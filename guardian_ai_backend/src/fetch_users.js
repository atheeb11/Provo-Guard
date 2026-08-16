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

async function run() {
  try {
    console.log('[Query] Fetching docs from "users" collection...');
    const snapshot = await Promise.race([
      db.collection('users').get(),
      new Promise((_, reject) => setTimeout(() => reject(new Error('Firestore timeout (10s)')), 10000))
    ]);

    console.log(`\n===================================================`);
    console.log(` TOTAL USERS FOUND IN DATABASE: ${snapshot.docs.length}`);
    console.log(`===================================================\n`);

    if (snapshot.docs.length === 0) {
      console.log('No registered user records in the live "users" collection yet.');
    } else {
      snapshot.docs.forEach((doc, idx) => {
        console.log(`User #${idx + 1} | Document ID: ${doc.id}`);
        console.log(JSON.stringify(doc.data(), null, 2));
        console.log('---------------------------------------------------');
      });
    }
  } catch (err) {
    console.log('Firestore Live Error / Timeout:', err.message);
  } finally {
    process.exit(0);
  }
}

run();
