const express = require('express');
const bodyParser = require('body-parser');
const { sendOtp, verifyOtp, logoutUser, deleteUser, } = require('./controllers/authController');
const app = express();

// Middleware untuk parsing JSON request body
app.use(bodyParser.json());

// Endpoint untuk mengirim OTP
app.post('/send-otp', sendOtp);

// Endpoint untuk verifikasi OTP
app.post('/verify-otp', verifyOtp);


// Endpoint untuk logout pengguna
app.post('/logout', logoutUser);

// Endpoint untuk menghapus pengguna
app.delete('/delete-user', deleteUser);

// Menjalankan server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
