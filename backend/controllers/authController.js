const { admin, db } = require('../firebaseConfig'); // Mengimpor Firebase Admin SDK untuk Firestore
const firebase = require('firebase');
require('firebase/auth');

// Fungsi untuk mengirim OTP (One-Time Password)
const sendOtp = (req, res) => {
  const phoneNumber = req.body.phoneNumber; // Ambil nomor ponsel dari request
  const appVerifier = req.body.recaptchaVerifier; // Verifier reCAPTCHA (untuk keamanan)

  firebase.auth().signInWithPhoneNumber(phoneNumber, appVerifier)
    .then((confirmationResult) => {
      // Kirimkan verificationId ke pengguna
      res.status(200).json({
        success: true,
        verificationId: confirmationResult.verificationId
      });
    })
    .catch((error) => {
      console.error('Error sending OTP: ', error);
      res.status(500).json({ success: false, message: error.message });
    });
};

// Fungsi untuk memverifikasi OTP yang dimasukkan oleh pengguna
const verifyOtp = (req, res) => {
  const verificationId = req.body.verificationId; // verificationId dari proses kirim OTP
  const otp = req.body.otp;  // OTP yang dimasukkan pengguna

  // Buat credential dari OTP yang dimasukkan
  const credential = firebase.auth.PhoneAuthProvider.credential(verificationId, otp);

  // Verifikasi credential menggunakan Firebase Authentication
  firebase.auth().signInWithCredential(credential)
    .then((userCredential) => {
      // Jika berhasil, dapatkan data pengguna
      const user = userCredential.user;
      
      // Simpan data pengguna ke Firestore
      addUserToFirestore(user);

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
      res.status(500).json({ success: false, message: error.message });
    });
};

// Fungsi untuk menambahkan pengguna ke Firestore
const addUserToFirestore = (user) => {
  const userRef = db.collection('users').doc(user.uid);

  userRef.set({
    name: user.displayName || 'No Name',
    email: user.email || 'No Email',
    phoneNumber: user.phoneNumber,
    createdAt: new Date(),
    // Kamu bisa menambahkan lebih banyak data di sini sesuai kebutuhan
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
  firebase.auth().signOut()
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
