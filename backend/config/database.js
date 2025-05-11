const { initializeApp } = require('firebase/app');
const { getFirestore } = require('firebase/firestore');
const config = require('./env');

// Firebase configuration
const firebaseConfig = {
  apiKey: config.FIREBASE_API_KEY,
  authDomain: config.FIREBASE_AUTH_DOMAIN,
  projectId: config.FIREBASE_PROJECT_ID,
  storageBucket: config.FIREBASE_STORAGE_BUCKET,
  messagingSenderId: config.FIREBASE_MESSAGING_SENDER_ID,
  appId: config.FIREBASE_APP_ID,
};

// Initialize Firebase client app
const firebaseApp = initializeApp(firebaseConfig);
const db = getFirestore(firebaseApp);

module.exports = {
  firebaseApp,
  db,
};