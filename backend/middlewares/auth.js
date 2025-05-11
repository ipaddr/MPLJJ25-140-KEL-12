const { adminAuth } = require('../config/auth');
const { logger } = require('../utils/logger');

/**
 * Middleware to verify Firebase ID token
 */
exports.verifyToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        status: 'error',
        message: 'Unauthorized: No token provided'
      });
    }
    
    const token = authHeader.split(' ')[1];
    
    // Verify the token using Firebase Admin SDK
    const decodedToken = await adminAuth.verifyIdToken(token);
    
    // Add user info to request object
    req.user = {
      uid: decodedToken.uid,
      email: decodedToken.email,
      emailVerified: decodedToken.email_verified,
      role: decodedToken.role || 'user'
    };
    
    next();
  } catch (error) {
    logger.error('Auth middleware error:', error);
    return res.status(403).json({
      status: 'error',
      message: 'Forbidden: Invalid or expired token'
    });
  }
};

/**
 * Check if user email is verified
 */
exports.requireEmailVerified = (req, res, next) => {
  if (!req.user || !req.user.emailVerified) {
    return res.status(403).json({
      status: 'error',
      message: 'Forbidden: Email not verified'
    });
  }
  next();
};