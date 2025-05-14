const jwt = require('jsonwebtoken');

const jwtVerify = (req, res, next) => {
  // Ambil token dari header Authorization
  const token = req.headers['authorization'] && req.headers['authorization'].split(' ')[1];

  if (!token) {
    return res.status(403).json({ message: 'Token tidak ditemukan, Anda harus login terlebih dahulu' });
  }

  // Verifikasi token menggunakan JWT_SECRET
  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: 'Token tidak valid atau telah kedaluwarsa' });
    }

    // Simpan data pengguna (nik) di request, bisa diakses di controller
    req.user = decoded;
    next();
  });
};

module.exports = jwtVerify;
