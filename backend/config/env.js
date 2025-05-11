// Load environment variables from .env file
require('dotenv').config();

module.exports = {
  // Server configuration
  NODE_ENV: process.env.NODE_ENV || 'development',
  PORT: process.env.PORT || 3000,
  
  // Firebase configuration
  FIREBASE_API_KEY: process.env.FIREBASE_API_KEY,
  FIREBASE_AUTH_DOMAIN: process.env.FIREBASE_AUTH_DOMAIN,
  FIREBASE_PROJECT_ID: process.env.FIREBASE_PROJECT_ID,
  FIREBASE_STORAGE_BUCKET: process.env.FIREBASE_STORAGE_BUCKET,
  FIREBASE_MESSAGING_SENDER_ID: process.env.FIREBASE_MESSAGING_SENDER_ID,
  FIREBASE_APP_ID: process.env.FIREBASE_APP_ID,
  
  // Firebase Admin SDK
  FIREBASE_ADMIN_CREDENTIAL_PATH: process.env.FIREBASE_ADMIN_CREDENTIAL_PATH,
  
  // JWT Settings
  JWT_SECRET: process.env.JWT_SECRET || 'gaji-naik-secret-key',
  JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN || '24h',
  
  // External API configuration
  BKN_API_URL: process.env.BKN_API_URL,
  BKN_API_KEY: process.env.BKN_API_KEY,
  KEMENKEU_API_URL: process.env.KEMENKEU_API_URL,
  KEMENKEU_API_KEY: process.env.KEMENKEU_API_KEY,
  
  // Rate limiting
  RATE_LIMIT_WINDOW_MS: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  RATE_LIMIT_MAX: parseInt(process.env.RATE_LIMIT_MAX) || 100, // 100 requests per window
  
  // Logging
  LOG_LEVEL: process.env.LOG_LEVEL || 'info',
  
  // Mock data toggle for development
  USE_MOCK_DATA: process.env.USE_MOCK_DATA === 'true' || false
};