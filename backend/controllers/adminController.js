const db = require('../config/firebaseConfig');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Register Admin
const registerAdmin = async (req, res) => {
  const { nik, password } = req.body;

  try {
    // Cek apakah admin sudah terdaftar
    const adminRef = db.collection('admins').doc(nik);  // Koleksi untuk admin
    const doc = await adminRef.get();

    if (doc.exists) {
      return res.status(400).json({ message: 'NIK sudah terdaftar' });
    }

    // Hash password sebelum menyimpannya
    const hashedPassword = await bcrypt.hash(password, 10);

    // Simpan data admin ke Firestore
    await adminRef.set({
      nik,
      password: hashedPassword,
      createdAt: new Date(),
      updatedAt: new Date()
    });

    res.status(201).json({
      message: 'Admin berhasil terdaftar',
      userId: nik
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};


// Login Admin
const loginAdmin = async (req, res) => {
  const { nik, password } = req.body;

  try {
    // Cek apakah admin ada di Firestore
    const adminRef = db.collection('admins').doc(nik);  // Koleksi untuk admin
    const doc = await adminRef.get();

    if (!doc.exists) {
      return res.status(404).json({ message: 'Admin tidak ditemukan' });
    }

    // Bandingkan password yang dimasukkan dengan yang ada di Firestore
    const match = await bcrypt.compare(password, doc.data().password);
    if (!match) return res.status(401).json({ message: 'Password salah' });

    // Buat token JWT untuk admin
    const token = jwt.sign({ nik }, process.env.JWT_SECRET, { expiresIn: '1d' });

    res.status(200).json({
      message: 'Login berhasil',
      userId: nik,
      token: `Bearer ${token}`  // Mengembalikan token JWT
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Fungsi untuk menginput data statistik dashboard
const inputDashboardData = async (req, res) => {
  const { totalASN, persenKenaikan, grafikProgres } = req.body;  // Ambil data dari body request

  try {
    // Referensi ke koleksi statistik di Firestore
    const dashboardRef = db.collection('dashboard').doc('statistik'); // Anda bisa ganti nama koleksi sesuai kebutuhan

    // Cek apakah dokumen statistik sudah ada
    const doc = await dashboardRef.get();
    if (doc.exists) {
      // Update data jika sudah ada
      await dashboardRef.update({
        totalASN,
        persenKenaikan,
        grafikProgres,
        updatedAt: new Date()
      });
    } else {
      // Jika belum ada, buat dokumen baru
      await dashboardRef.set({
        totalASN,
        persenKenaikan,
        grafikProgres,
        createdAt: new Date(),
        updatedAt: new Date()
      });
    }

    res.status(200).json({ message: 'Data berhasil diperbarui' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports = { registerAdmin, inputDashboardData, loginAdmin };
