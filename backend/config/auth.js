const { getAuth } = require('firebase/auth');
const { firebaseApp } = require('./database');
const admin = require('firebase-admin');
const config = require('./env');
const { logger } = require('../utils/logger');

// Initialize Firebase Auth for client-side operations
const auth = getAuth(firebaseApp);

// Initialize Firebase Admin for server-side operations
const serviceAccount = require(config.FIREBASE_ADMIN_CREDENTIAL_PATH);

// Determine if Firebase Admin has already been initialized
let adminApp;
try {
  adminApp = admin.app();
  logger.info('Firebase Admin SDK already initialized');
} catch (error) {
  adminApp = admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    storageBucket: config.FIREBASE_STORAGE_BUCKET
  });
  logger.info('Firebase Admin SDK initialized successfully');
}

const adminAuth = adminApp.auth();
const adminFirestore = adminApp.firestore();
const adminStorage = adminApp.storage();

module.exports = {
  auth,
  adminAuth,
  adminFirestore,
  adminStorage
};