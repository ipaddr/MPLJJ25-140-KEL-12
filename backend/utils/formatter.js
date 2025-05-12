// utils/formatter.js

/**
 * Format angka ke mata uang Rupiah.
 * Contoh: 5000000 => "Rp 5.000.000"
 */
exports.toRupiah = (value) => {
  if (typeof value !== 'number') return value;
  return 'Rp ' + value.toLocaleString('id-ID');
};

/**
 * Format angka desimal ke persen.
 * Contoh: 0.2 => "20%"
 */
exports.toPercent = (value) => {
  if (typeof value !== 'number') return value;
  return (value * 100).toFixed(0) + '%';
};
