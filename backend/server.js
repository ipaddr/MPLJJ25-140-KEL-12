const express = require('express');
const bodyParser = require('body-parser');
const { sendOtp, verifyOtp, updateUserProfile, logoutUser, deleteUser, getUserProfile, } = require('./controllers/authController');
const profileRoute = require('./routes/profileRoute');
const app = express();

// Middleware untuk parsing JSON request body
app.use(bodyParser.json());

// Menggunakan routing untuk profil pengguna
app.use('/api', profileRoute);

// Endpoint untuk mengirim OTP
app.post('/send-otp', sendOtp);

// Endpoint untuk verifikasi OTP
app.post('/verify-otp', verifyOtp);

// Endpoint untuk update profil pengguna
app.post('/updateUserProfile', updateUserProfile);

// Endpoint untuk logout pengguna
app.post('/logout', logoutUser);

// Endpoint untuk menghapus pengguna
app.delete('/delete-user', deleteUser);

// Endpoint untuk mengambil profil pengguna
app.get('/user-profile/:uid', getUserProfile);



// Menjalankan server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
