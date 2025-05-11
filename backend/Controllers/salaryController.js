// controllers/salaryController.js
const { db } = require('../config/database');
const mockDataService = require('../services/mockDataService');
const salaryRulesService = require('../services/salaryRulesService');

exports.getSalarySimulation = async (req, res) => {
  try {
    const { golongan, jabatan, masaKerja, lokasiKerja, instansiId } = req.body;
    
    // Validasi input
    if (!golongan || !jabatan || !masaKerja || !lokasiKerja || !instansiId) {
      return res.status(400).json({ 
        success: false, 
        message: 'Semua data harus diisi' 
      });
    }
    
    // Jika pengguna sudah login, gunakan data dari profil
    let nip = null;
    if (req.user) {
      nip = req.user.nip;
    }
    
    // Buat data ASN untuk perhitungan
    const asnData = {
      golongan,
      jabatan,
      masaKerja: parseInt(masaKerja),
      lokasiKerja,
      instansiId,
      nip
    };
    
    // Hitung gaji baru
    const salaryData = await salaryRulesService.calculateNewSalary(asnData);
    
    return res.status(200).json({
      success: true,
      data: salaryData
    });
  } catch (error) {
    console.error('Error in salary simulation:', error);
    return res.status(500).json({
      success: false,
      message: 'Terjadi kesalahan saat menghitung simulasi gaji',
      error: error.message
    });
  }
};

exports.getUserSalaryHistory = async (req, res) => {
  try {
    const { nip } = req.params;
    
    // Verifikasi akses (hanya user itu sendiri atau admin)
    if (req.user.nip !== nip && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Tidak memiliki akses'
      });
    }
    
    // Dapatkan riwayat gaji
    const salaryHistory = await mockDataService.getSalaryHistory(nip);
    
    return res.status(200).json({
      success: true,
      data: salaryHistory
    });
  } catch (error) {
    console.error('Error fetching salary history:', error);
    return res.status(500).json({
      success: false,
      message: 'Gagal mendapatkan riwayat gaji',
      error: error.message
    });
  }
};

// Endpoint untuk admin menambahkan formula gaji baru
exports.addSalaryFormula = async (req, res) => {
  try {
    // Verifikasi role admin
    if (req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Hanya admin yang dapat menambahkan formula gaji'
      });
    }
    
    const { 
      golongan, 
      masaKerjaMin, 
      masaKerjaMax, 
      nominal 
    } = req.body;
    
    // Validasi input
    if (!golongan || masaKerjaMin === undefined || masaKerjaMax === undefined || !nominal) {
      return res.status(400).json({
        success: false,
        message: 'Semua data harus diisi'
      });
    }
    
    // Buat ID dokumen
    const id = `gp-${golongan.replace('/', '')}-${masaKerjaMin}-${masaKerjaMax}`;
    
    // Simpan ke Firestore
    await db.collection('gajiPokok').doc(id).set({
      golongan,
      masaKerjaMin: parseInt(masaKerjaMin),
      masaKerjaMax: parseInt(masaKerjaMax),
      nominal: parseInt(nominal),
      createdAt: new Date(),
      createdBy: req.user.nip
    });
    
    return res.status(201).json({
      success: true,
      message: 'Formula gaji berhasil ditambahkan',
      data: { id }
    });
  } catch (error) {
    console.error('Error adding salary formula:', error);
    return res.status(500).json({
      success: false,
      message: 'Gagal menambahkan formula gaji',
      error: error.message
    });
  }
};