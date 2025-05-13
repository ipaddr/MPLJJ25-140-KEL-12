const admin = require('firebase-admin'); // Menggunakan Firebase Admin SDK
const { db } = require('../config/firebaseConfig'); // Mengimpor Firebase Admin SDK untuk Firestore
require('firebase/auth');

// Inisialisasi Firebase Admin SDK jika belum diinisialisasi
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(require('../config/serviceAccountKey.json')), // File Service Account Key yang didapat dari Firebase Console
  });
}

// Fungsi untuk mengirim OTP (Note: ini hanya dapat dilakukan di frontend menggunakan Firebase SDK)
const sendOtp = (req, res) => {
  res.status(500).json({ message: "OTP must be handled on the frontend with Firebase SDK" });
};

// Fungsi untuk memverifikasi OTP yang dimasukkan oleh pengguna
const verifyOtp = (req, res) => {
  // Ambil verificationId dan OTP yang dikirim dari frontend
  const verificationId = req.body.verificationId; // verificationId dari proses kirim OTP di frontend
  const otp = req.body.otp;  // OTP yang dimasukkan pengguna
  
  // Pastikan verificationId dan OTP ada di request body
  if (!verificationId || !otp) {
    return res.status(400).json({ success: false, message: "Verification ID and OTP are required" });
  }

  // Membuat kredensial dengan menggunakan OTP yang dimasukkan
  const credential = admin.auth.PhoneAuthProvider.credential(verificationId, otp);

  // Verifikasi kredensial menggunakan Firebase Authentication
  admin.auth().signInWithCredential(credential)
    .then((userCredential) => {
      // Jika berhasil, dapatkan data pengguna
      const user = userCredential.user;

      // Menambahkan pengguna ke Firestore setelah berhasil login
      addUserToFirestore(user);

      // Mengirimkan respons sukses dengan data pengguna
      res.status(200).json({
        success: true,
        message: 'OTP Verified!',
        user: {
          uid: user.uid,
          phoneNumber: user.phoneNumber,
          email: user.email,
          displayName: user.displayName,
        }
      });
    })
    .catch((error) => {
      console.error('Error verifying OTP: ', error);

      // Menangani error jika OTP tidak valid
      if (error.code === 'auth/invalid-verification-code') {
        return res.status(400).json({ success: false, message: 'Invalid OTP code' });
      }

      // Menangani error lainnya
      res.status(500).json({ success: false, message: error.message });
    });
};

// Fungsi untuk menambahkan pengguna ke Firestore
const addUserToFirestore = (user) => {
  const userRef = db.collection('users').doc(user.uid);

  userRef.set({
    name: user.displayName || 'No Name',  // Jika nama tidak ada, set ke 'No Name'
    email: user.email || 'No Email',      // Jika email tidak ada, set ke 'No Email'
    phoneNumber: user.phoneNumber,        // Menyimpan nomor telepon pengguna
    createdAt: new Date(),                // Menyimpan waktu pembuatan pengguna
  })
  .then(() => {
    console.log('User added to Firestore!');
  })
  .catch((error) => {
    console.error('Error adding user to Firestore: ', error);
  });
};

// Fungsi untuk mengupdate profil pengguna
const updateUserProfile = (req, res) => {
  const uid = req.body.uid;
  const name = req.body.name;
  const phoneNumber = req.body.phoneNumber;

  const userRef = db.collection('users').doc(uid);

  userRef.update({
    name: name,
    phoneNumber: phoneNumber,
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

// Fungsi untuk logout pengguna
const logoutUser = (req, res) => {
  admin.auth().signOut()
    .then(() => {
      res.status(200).json({ success: true, message: 'User logged out successfully.' });
    })
    .catch((error) => {
      console.error('Error logging out user: ', error);
      res.status(500).json({ success: false, message: error.message });
    });
};

// Fungsi untuk menghapus pengguna dari Firestore
const deleteUser = (req, res) => {
  const uid = req.body.uid;

  // Hapus user dari Firestore
  const userRef = db.collection('users').doc(uid);
  userRef.delete()
    .then(() => {
      res.status(200).json({ success: true, message: 'User deleted from Firestore.' });
    })
    .catch((error) => {
      console.error('Error deleting user: ', error);
      res.status(500).json({ success: false, message: error.message });
    });
};

// Fungsi untuk mendapatkan data pengguna dari Firestore
const getUserProfile = (req, res) => {
  const uid = req.params.uid; // Ambil uid pengguna dari parameter

  const userRef = db.collection('users').doc(uid);

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

module.exports = { sendOtp, verifyOtp, updateUserProfile, logoutUser, deleteUser, getUserProfile };
