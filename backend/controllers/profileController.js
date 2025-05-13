const { db } = require('../config/firebaseConfig');  // Mengimpor Firebase Admin SDK untuk Firestore

// Fungsi untuk mengupdate profil pengguna
const updateUserProfile = (req, res) => {
  const { uid, name, phoneNumber, instansi, golongan, masaKerja } = req.body;

  const userRef = db.collection('users').doc(uid);

  // Update data pengguna di Firestore
  userRef.update({
    name: name,
    phoneNumber: phoneNumber,
    instansi: instansi,
    golongan: golongan,
    masaKerja: masaKerja,
    updatedAt: new Date()
  })
  .then(() => {
    res.status(200).json({ success: true, message: 'User profile updated successfully.' });
  })
  .catch((error) => {
    console.error('Error updating user profile: ', error);
    res.status(500).json({ success: false, message: error.message });
  });
};

// Fungsi untuk mengambil data profil pengguna
const getUserProfile = (req, res) => {
  const { uid } = req.params; // Mengambil uid pengguna dari parameter

  const userRef = db.collection('users').doc(uid);

  // Ambil data pengguna dari Firestore
  userRef.get()
    .then((doc) => {
      if (doc.exists) {
        res.status(200).json({ success: true, user: doc.data() });
      } else {
        res.status(404).json({ success: false, message: 'User not found.' });
      }
    })
    .catch((error) => {
      console.error('Error getting user profile: ', error);
      res.status(500).json({ success: false, message: error.message });
    });
};

module.exports = { updateUserProfile, getUserProfile };
