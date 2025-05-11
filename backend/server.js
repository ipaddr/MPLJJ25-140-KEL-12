const app = require('./app');
const { logger } = require('./utils/logger');
const { initializeFirebase } = require('./services/firebaseService');

const PORT = process.env.PORT || 3000;

// Initialize services
const initializeServer = async () => {
  try {
    // Initialize Firebase
    await initializeFirebase();
    logger.info('Firebase initialized successfully');
    
    // Start server
    app.listen(PORT, () => {
      logger.info(`Server running on port ${PORT}`);
    });
  } catch (error) {
    logger.error('Failed to initialize server:', error);
    process.exit(1);
  }
};

// Handle uncaught exceptions
process.on('uncaughtException', (err) => {
  logger.error('UNCAUGHT EXCEPTION! Shutting down...', err);
  process.exit(1);
});

// Handle unhandled rejections
process.on('unhandledRejection', (err) => {
  logger.error('UNHANDLED REJECTION! Shutting down...', err);
  process.exit(1);
});

// Initialize the server
initializeServer();