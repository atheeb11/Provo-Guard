const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

const serviceAccountPath = path.join(__dirname, '../service-account.json');

if (fs.existsSync(serviceAccountPath)) {
  const serviceAccount = JSON.parse(fs.readFileSync(serviceAccountPath, 'utf8'));
  if (!admin.apps.length) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });
  }
  console.log('[Firebase Admin] Connected to Firestore project:', serviceAccount.project_id);
} else {
  console.error('Service account file not found');
  process.exit(1);
}

const db = admin.firestore();

const COLLECTIONS_TO_PURGE = [
  'users',
  'threat_logs',
  'evidence_items',
  'emergency_incidents',
  'learning_progress'
];

async function purgeCollection(collectionName) {
  try {
    const snapshot = await db.collection(collectionName).get();
    console.log(`[Purge] Found ${snapshot.docs.length} document(s) in "${collectionName}"...`);
    
    if (snapshot.docs.length === 0) {
      console.log(`[Purge] Collection "${collectionName}" is already empty.`);
      return;
    }

    const batchSize = 500;
    let count = 0;
    
    for (const doc of snapshot.docs) {
      await doc.ref.delete();
      count++;
    }
    
    console.log(`[Purge] Successfully deleted ${count} document(s) from "${collectionName}".`);
  } catch (error) {
    console.error(`[Purge Error] Failed to purge collection "${collectionName}":`, error.message);
  }
}

async function purgeAllData() {
  console.log('\n===================================================');
  console.log(' PURGING ALL USERS & DATA FROM FIRESTORE DATABASE   ');
  console.log('===================================================\n');

  for (const collectionName of COLLECTIONS_TO_PURGE) {
    await purgeCollection(collectionName);
  }

  console.log('\n===================================================');
  console.log(' DATABASE PURGE COMPLETED SUCCESSFULLY             ');
  console.log('===================================================\n');
  process.exit(0);
}

purgeAllData();
