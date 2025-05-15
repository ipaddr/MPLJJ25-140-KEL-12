const express = require('express');
const router = express.Router();
const authenticateJWT = require('../middlewares/jwtVerify');
const { getUserProfile } = require('../controllers/userController');

// Route untuk mendapatkan profil pengguna, menggunakan middleware autentikasi JWT
router.get('/profile', authenticateJWT, getUserProfile);

module.exports = router;
