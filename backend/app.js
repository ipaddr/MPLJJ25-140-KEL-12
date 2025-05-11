require('dotenv').config();
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const { logger } = require('./utils/logger');

// Import routes
const authRoutes = require('./routes/authRoutes');
// Uncomment routes as they are implemented
// const userRoutes = require('./routes/userRoutes');
// const institutionRoutes = require('./routes/institutionRoutes');
// const salaryRoutes = require('./routes/salaryRoutes');
// const reportRoutes = require('./routes/reportRoutes');
// const newsRoutes = require('./routes/newsRoutes');
// const dashboardRoutes = require('./routes/dashboardRoutes');
// const educationRoutes = require('./routes/educationRoutes');
// const notificationRoutes = require('./routes/notificationRoutes');

// Initialize app
const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('combined', { stream: { write: message => logger.info(message.trim()) } }));

// Routes
app.use('/api/auth', authRoutes);
// Uncomment routes as they are implemented
// app.use('/api/users', userRoutes);
// app.use('/api/institutions', institutionRoutes);
// app.use('/api/salary', salaryRoutes);
// app.use('/api/reports', reportRoutes);
// app.use('/api/news', newsRoutes);
// app.use('/api/dashboard', dashboardRoutes);
// app.use('/api/education', educationRoutes);
// app.use('/api/notifications', notificationRoutes);

// Health check route
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', message: 'Server is running' });
});

// Error handling middleware
app.use((err, req, res, next) => {
  logger.error(err.stack);
  res.status(err.statusCode || 500).json({
    status: 'error',
    message: err.message || 'Internal Server Error'
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    status: 'error',
    message: 'Route not found'
  });
});

module.exports = app;