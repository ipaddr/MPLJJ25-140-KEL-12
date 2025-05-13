const express = require('express');
const { updateUserProfile, getUserProfile } = require('../controllers/profileController');
const router = express.Router();

// Endpoint untuk update profil pengguna
router.put('/update-profile', updateUserProfile);

// Endpoint untuk mengambil data profil pengguna
router.get('/user-profile/:uid', getUserProfile);

module.exports = router;
