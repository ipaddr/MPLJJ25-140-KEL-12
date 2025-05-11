const { adminFirestore } = require('../config/auth');
const { logger } = require('../utils/logger');

/**
 * Middleware to verify if the user is an admin
 */
exports.isAdmin = async (req, res, next) => {
  try {
    if (!req.user || !req.user.uid) {
      return res.status(401).json({
        status: 'error',
        message: 'Unauthorized: Authentication required'
      });
    }
    
    // Check user role in Firestore
    const userDoc = await adminFirestore.collection('users').doc(req.user.uid).get();
    
    if (!userDoc.exists) {
      return res.status(403).json({
        status: 'error',
        message: 'Forbidden: User not found'
      });
    }
    
    const userData = userDoc.data();
    
    if (userData.role !== 'admin') {
      return res.status(403).json({
        status: 'error',
        message: 'Forbidden: Admin access required'
      });
    }
    
    // Add role to request object
    req.user.role = 'admin';
    next();
  } catch (error) {
    logger.error('Admin middleware error:', error);
    return res.status(500).json({
      status: 'error',
      message: 'Internal server error'
    });
  }
};

/**
 * Middleware to verify if the user is an institutional admin
 */
exports.isInstitutionAdmin = async (req, res, next) => {
  try {
    if (!req.user || !req.user.uid) {
      return res.status(401).json({
        status: 'error',
        message: 'Unauthorized: Authentication required'
      });
    }
    
    // Check user role in Firestore
    const userDoc = await adminFirestore.collection('users').doc(req.user.uid).get();
    
    if (!userDoc.exists) {
      return res.status(403).json({
        status: 'error',
        message: 'Forbidden: User not found'
      });
    }
    
    const userData = userDoc.data();
    
    if (userData.role !== 'admin' && userData.role !== 'institution_admin') {
      return res.status(403).json({
        status: 'error',
        message: 'Forbidden: Institution admin access required'
      });
    }
    
    // If institution ID is provided in the request, check if user is admin for that institution
    if (req.params.institutionId && userData.role === 'institution_admin') {
      if (userData.institutionId !== req.params.institutionId) {
        return res.status(403).json({
          status: 'error',
          message: 'Forbidden: You do not have access to this institution'
        });
      }
    }
    
    // Add role and institution ID to request object
    req.user.role = userData.role;
    req.user.institutionId = userData.institutionId;
    next();
  } catch (error) {
    logger.error('Institution admin middleware error:', error);
    return res.status(500).json({
      status: 'error',
      message: 'Internal server error'
    });
  }
};