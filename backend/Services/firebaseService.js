const { firebaseApp } = require('../config/database');
const admin = require('firebase-admin');
const config = require('../config/env');
const { logger } = require('../utils/logger');

/**
 * Initialize Firebase and Firebase Admin
 */
exports.initializeFirebase = async () => {
  try {
    // Check if Firebase app was initialized
    if (!firebaseApp) {
      throw new Error('Firebase app not initialized');
    }

    // Check if Firebase Admin was initialized
    try {
      admin.app();
      logger.info('Firebase Admin already initialized');
    } catch (error) {
      // Initialize Firebase Admin
      const serviceAccount = require(config.FIREBASE_ADMIN_CREDENTIAL_PATH);
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
        storageBucket: config.FIREBASE_STORAGE_BUCKET
      });
      logger.info('Firebase Admin initialized successfully');
    }

    return { status: 'success' };
  } catch (error) {
    logger.error('Error initializing Firebase:', error);
    throw error;
  }
};

/**
 * Get Firestore instance
 */
exports.getFirestore = () => {
  return admin.firestore();
};

/**
 * Get Firebase Storage instance
 */
exports.getStorage = () => {
  return admin.storage();
};

/**
 * Get Firebase Auth instance
 */
exports.getAuth = () => {
  return admin.auth();
};

/**
 * Create a Firestore document with auto-generated ID
 */
exports.createDocument = async (collection, data) => {
  try {
    const db = this.getFirestore();
    const docRef = await db.collection(collection).add({
      ...data,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
    return { id: docRef.id };
  } catch (error) {
    logger.error(`Error creating document in ${collection}:`, error);
    throw error;
  }
};

/**
 * Create or update a Firestore document with specific ID
 */
exports.setDocument = async (collection, id, data, merge = true) => {
  try {
    const db = this.getFirestore();
    await db.collection(collection).doc(id).set({
      ...data,
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    }, { merge });
    return { id };
  } catch (error) {
    logger.error(`Error setting document ${id} in ${collection}:`, error);
    throw error;
  }
};

/**
 * Get a document by ID
 */
exports.getDocument = async (collection, id) => {
  try {
    const db = this.getFirestore();
    const doc = await db.collection(collection).doc(id).get();
    if (!doc.exists) {
      return null;
    }
    return { id: doc.id, ...doc.data() };
  } catch (error) {
    logger.error(`Error getting document ${id} from ${collection}:`, error);
    throw error;
  }
};

/**
 * Update a document
 */
exports.updateDocument = async (collection, id, data) => {
  try {
    const db = this.getFirestore();
    await db.collection(collection).doc(id).update({
      ...data,
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
    return { id };
  } catch (error) {
    logger.error(`Error updating document ${id} in ${collection}:`, error);
    throw error;
  }
};

/**
 * Delete a document
 */
exports.deleteDocument = async (collection, id) => {
  try {
    const db = this.getFirestore();
    await db.collection(collection).doc(id).delete();
    return { id };
  } catch (error) {
    logger.error(`Error deleting document ${id} from ${collection}:`, error);
    throw error;
  }
};

/**
 * Query documents with filters
 */
exports.queryDocuments = async (collection, filters = [], orderBy = null, limit = 100) => {
  try {
    const db = this.getFirestore();
    let query = db.collection(collection);
    
    // Apply filters
    filters.forEach(filter => {
      query = query.where(filter.field, filter.operator, filter.value);
    });
    
    // Apply ordering
    if (orderBy) {
      query = query.orderBy(orderBy.field, orderBy.direction || 'asc');
    }
    
    // Apply limit
    query = query.limit(limit);
    
    const snapshot = await query.get();
    
    const results = [];
    snapshot.forEach(doc => {
      results.push({ id: doc.id, ...doc.data() });
    });
    
    return results;
  } catch (error) {
    logger.error(`Error querying documents from ${collection}:`, error);
    throw error;
  }
};