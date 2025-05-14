const db = require('../config/firebaseConfig');  // Firebase config
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const admin = require('firebase-admin');

// Register: Fungsi untuk mendaftarkan pengguna baru
const registerUser = async (req, res) => {
  const { nik, telepon, email, password } = req.body;
  try {
    const userRef = db.collection('users').doc(nik);
    const doc = await userRef.get();

    // Cek apakah pengguna sudah terdaftar
    if (doc.exists) {
      return res.status(400).json({ message: 'NIK sudah terdaftar' });
    }

    // Hash password sebelum menyimpannya
    const hash = await bcrypt.hash(password, 10);

    // Simpan data pengguna di Firestore
    await userRef.set({
      nik, telepon, email, password: hash, createdAt: new Date(), step: 'registered'
    });

    // Buat token JWT untuk login
    const token = jwt.sign({ nik }, process.env.JWT_SECRET, { expiresIn: '1d' });

    res.status(201).json({
      message: 'Registrasi berhasil',
      userId: nik,
      createdAt: new Date(),
      token: `Bearer ${token}`
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Login: Fungsi untuk login pengguna
const loginUser = async (req, res) => {
  const { nik, email, password } = req.body;
  try {
    const userRef = db.collection('users').doc(nik);
    const doc = await userRef.get();

    // Cek apakah NIK dan email cocok
    if (!doc.exists || doc.data().email !== email) {
      return res.status(401).json({ message: 'Email atau NIK salah' });
    }

    // Bandingkan password yang dimasukkan dengan yang ada di Firestore
    const match = await bcrypt.compare(password, doc.data().password);
    if (!match) return res.status(401).json({ message: 'Password salah' });

    // Buat token JWT untuk login
    const token = jwt.sign({ nik }, process.env.JWT_SECRET, { expiresIn: '1d' });

    res.status(200).json({
      message: 'Login berhasil',
      userId: nik,
      createdAt: doc.data().createdAt,
      token: `Bearer ${token}`
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Logout: Fungsi untuk logout pengguna (Hanya client-side yang dapat melakukan logout pada Firebase)
const logoutUser = async (req, res) => {
  // Logout dilakukan di sisi client dengan menghapus token atau sesi yang ada
  res.status(200).json({ message: 'Logout berhasil, hapus token di client-side' });
};

module.exports = { registerUser, loginUser, logoutUser };
