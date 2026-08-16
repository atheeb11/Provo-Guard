const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Mock or Live Firebase Initialization
let db;
let auth;
let storage;

try {
  if (!admin.apps.length) {
    let serviceAccount = null;

    // Check if FIREBASE_SERVICE_ACCOUNT environment variable is set
    if (process.env.FIREBASE_SERVICE_ACCOUNT) {
      const val = process.env.FIREBASE_SERVICE_ACCOUNT.trim();
      if (val.startsWith('{')) {
        serviceAccount = JSON.parse(val);
      } else {
        // Assume it is a file path
        const resolvedPath = path.resolve(val);
        if (fs.existsSync(resolvedPath)) {
          serviceAccount = JSON.parse(fs.readFileSync(resolvedPath, 'utf8'));
        }
      }
    } else {
      // Check if service-account.json exists in root directory of backend
      const defaultPath = path.join(__dirname, '../../service-account.json');
      if (fs.existsSync(defaultPath)) {
        serviceAccount = JSON.parse(fs.readFileSync(defaultPath, 'utf8'));
      }
    }

    if (serviceAccount) {
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
        storageBucket: process.env.FIREBASE_STORAGE_BUCKET || 'guardian-ai-prod.appspot.com'
      });
      console.log('[Firebase] Initialized production Firebase Admin SDK using Service Account');
    } else {
      console.log('[Firebase] No Service Account provided - Running in local mock DB mode');
    }
  }
} catch (error) {
  console.warn('[Firebase] Warning initializing Firebase Admin:', error.message);
}

// In-Memory Database fallback for local testing without cloud credentials
class MockFirestore {
  constructor() {
    this.collections = {
      users: new Map(),
      threat_logs: new Map(),
      evidence_items: new Map(),
      emergency_incidents: new Map(),
      learning_progress: new Map()
    };

    // Pre-seed default user profile in fallback database
    const defaultUser = {
      uid: 'usr_default_demo',
      email: 'alex@example.com',
      fullName: 'Alex Johnson',
      age: 20,
      country: 'United States',
      emergencyContacts: [
        { name: 'Sarah Johnson (Mother)', phone: '+1-555-0199', relation: 'Mother' },
        { name: 'David Johnson (Father)', phone: '+1-555-0198', relation: 'Father' }
      ],
      isVerified: true,
      privacyPreferences: {
        visibleMonitoringConsent: true,
        localOCRAnalysis: true,
        cloudAnalysisConsent: true,
        biometricLockEnabled: true
      }
    };
    this.collections.users.set('usr_default_demo', defaultUser);
    this.collections.users.set('user_demo_123', defaultUser);
  }

  collection(name) {
    if (!this.collections[name]) {
      this.collections[name] = new Map();
    }
    const store = this.collections[name];
    return {
      doc: (id) => ({
        get: async () => ({
          exists: store.has(id),
          data: () => store.get(id),
          id
        }),
        set: async (data, options = {}) => {
          const current = store.get(id) || {};
          const updated = options.merge ? { ...current, ...data } : data;
          store.set(id, updated);
          return { id };
        },
        update: async (data) => {
          const current = store.get(id) || {};
          store.set(id, { ...current, ...data });
          return { id };
        },
        delete: async () => store.delete(id)
      }),
      add: async (data) => {
        const id = 'doc_' + Date.now() + '_' + Math.random().toString(36).substring(2, 7);
        store.set(id, { ...data, id });
        return { id, get: async () => ({ exists: true, data: () => store.get(id) }) };
      },
      get: async () => ({
        docs: Array.from(store.entries()).map(([id, data]) => ({
          id,
          data: () => data
        }))
      }),
      where: function(field, op, val) {
        return {
          get: async () => {
            const matches = Array.from(store.entries())
              .filter(([_, d]) => d[field] === val)
              .map(([id, d]) => ({ id, data: () => d }));
            return { docs: matches };
          }
        };
      }
    };
  }
}

const mockDb = new MockFirestore();

class ResilientDb {
  collection(name) {
    const isLive = admin.apps.length > 0;
    if (!isLive) {
      return mockDb.collection(name);
    }

    const liveCol = admin.firestore().collection(name);
    const fallbackCol = mockDb.collection(name);

    return {
      doc: (id) => {
        const liveDoc = liveCol.doc(id);
        const fallbackDoc = fallbackCol.doc(id);
        return {
          get: async () => {
            try {
              return await Promise.race([
                liveDoc.get(),
                new Promise((_, r) => setTimeout(() => r(new Error('Firestore Timeout')), 2500))
              ]);
            } catch (e) {
              console.warn(`[Database] Live query for doc "${id}" timed out/failed. Using database fallback.`);
              return await fallbackDoc.get();
            }
          },
          set: async (data, options = {}) => {
            await fallbackDoc.set(data, options);
            try {
              return await Promise.race([
                liveDoc.set(data, options),
                new Promise((_, r) => setTimeout(() => r(new Error('Firestore Timeout')), 2500))
              ]);
            } catch (e) {
              console.warn(`[Database] Live write for doc "${id}" timed out/failed. Saved to database fallback.`);
              return { id };
            }
          },
          update: async (data) => {
            await fallbackDoc.update(data);
            try {
              return await Promise.race([
                liveDoc.update(data),
                new Promise((_, r) => setTimeout(() => r(new Error('Firestore Timeout')), 2500))
              ]);
            } catch (e) {
              console.warn(`[Database] Live update for doc "${id}" timed out/failed. Updated in database fallback.`);
              return { id };
            }
          },
          delete: async () => {
            await fallbackDoc.delete();
            try { return await liveDoc.delete(); } catch (e) { return true; }
          }
        };
      },
      where: (field, op, val) => {
        return {
          get: async () => {
            try {
              return await Promise.race([
                liveCol.where(field, op, val).get(),
                new Promise((_, r) => setTimeout(() => r(new Error('Firestore Timeout')), 2500))
              ]);
            } catch (e) {
              console.warn(`[Database] Live query where(${field} ${op} ${val}) timed out/failed. Querying database fallback.`);
              return await fallbackCol.where(field, op, val).get();
            }
          }
        };
      },
      get: async () => {
        try {
          return await Promise.race([
            liveCol.get(),
            new Promise((_, r) => setTimeout(() => r(new Error('Firestore Timeout')), 2500))
          ]);
        } catch (e) {
          console.warn(`[Database] Live collection fetch for "${name}" timed out/failed. Fetching from database fallback.`);
          return await fallbackCol.get();
        }
      },
      add: async (data) => {
        const mockRes = await fallbackCol.add(data);
        try {
          return await Promise.race([
            liveCol.add(data),
            new Promise((_, r) => setTimeout(() => r(new Error('Firestore Timeout')), 2500))
          ]);
        } catch (e) {
          return mockRes;
        }
      }
    };
  }
}

const resilientDb = new ResilientDb();

module.exports = {
  admin,
  getDb: () => resilientDb,
  getAuth: () => (admin.apps.length ? admin.auth() : null)
};

