const express = require('express');
const bodyParser = require('body-parser');
const { registerUser, loginUser, logoutUser } = require('./controllers/authController');  // Sesuaikan import dengan controller Anda
const app = express();
const jwtVerify = require('./middlewares/jwtVerify'); 
const { registerAdmin, loginAdmin, inputDashboardData } = require('./controllers/adminController'); 
const profileRoute = require('./routes/profileRoute');
require('dotenv').config(); 

// Endpoint yang dilindungi, hanya bisa diakses jika user sudah login
app.get('/protected', jwtVerify, (req, res) => {
  res.status(200).json({
    message: 'Akses berhasil, Anda telah login',
    userId: req.user.nik
  });
});

// Middleware untuk parsing JSON request body
app.use(bodyParser.json());

// Endpoint untuk register pengguna
app.post('/register', registerUser);

// Endpoint untuk login pengguna
app.post('/login', loginUser);

// Endpoint untuk logout pengguna
app.post('/logout', logoutUser);

// Endpoint untuk input data dashboard (hanya bisa diakses admin)
app.post('/admin/dashboard', jwtVerify, inputDashboardData);

// Endpoint untuk login admin
app.post('/admin/login', loginAdmin);

// Endpoint untuk register admin
app.post('/admin/register', registerAdmin);

// Gunakan routing untuk profile
app.use('/api', profileRoute);

// Menjalankan server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
