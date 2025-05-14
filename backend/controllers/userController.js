const db = require('../config/firebaseConfig'); // Firebase config

// Fungsi untuk mendapatkan profil pengguna berdasarkan NIK
const getUserProfile = async (req, res) => {
  const { nik } = req.user;  // Mengambil NIK dari token JWT yang sudah terverifikasi
  
  try {
    const userRef = db.collection('users').doc(nik);  // Mengambil dokumen pengguna berdasarkan NIK
    const doc = await userRef.get();

    if (!doc.exists) {
      return res.status(404).json({ message: 'Pengguna tidak ditemukan' });
    }

    // Mengambil data profil pengguna dari Firestore
    const userData = doc.data();

    res.status(200).json({
      message: 'Profil pengguna berhasil ditemukan',
      profile: {
        nik: userData.nik,
        nama: userData.nama,
        telepon: userData.telepon,
        email: userData.email,
        golongan: userData.golongan,
        instansi: userData.instansi,
        masaKerja: userData.masaKerja,
        createdAt: userData.createdAt,
      }
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

module.exports = { getUserProfile };
