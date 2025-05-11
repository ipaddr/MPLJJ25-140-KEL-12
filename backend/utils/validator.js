/**
 * Validate email format
 * @param {String} email - Email to validate
 * @returns {Boolean} - Whether email is valid
 */
exports.isValidEmail = (email) => {
  const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  return emailRegex.test(email);
};

/**
 * Validate Indonesian mobile phone number
 * @param {String} phoneNumber - Phone number to validate
 * @returns {Boolean} - Whether phone number is valid
 */
exports.isValidPhoneNumber = (phoneNumber) => {
  // Remove all non-digit characters
  const cleaned = phoneNumber.replace(/\D/g, '');
  
  // Check if it starts with 0 or 62
  const startsWithValidPrefix = cleaned.startsWith('0') || cleaned.startsWith('62');
  
  // Check total length (10-13 digits after removing prefix)
  const validLength = (cleaned.startsWith('0') && cleaned.length >= 10 && cleaned.length <= 13) ||
                     (cleaned.startsWith('62') && cleaned.length >= 11 && cleaned.length <= 14);
  
  return startsWithValidPrefix && validLength;
};

/**
 * Validate Indonesian NIP (Nomor Induk Pegawai)
 * @param {String} nip - NIP to validate
 * @returns {Boolean} - Whether NIP is valid
 */
exports.isValidNIP = (nip) => {
  // Remove all non-digit characters
  const cleaned = nip.replace(/\D/g, '');
  
  // NIP should be 18 digits
  return cleaned.length === 18;
};

/**
 * Validate Indonesian NIK (Nomor Induk Kependudukan)
 * @param {String} nik - NIK to validate
 * @returns {Boolean} - Whether NIK is valid
 */
exports.isValidNIK = (nik) => {
  // Remove all non-digit characters
  const cleaned = nik.replace(/\D/g, '');
  
  // NIK should be 16 digits
  return cleaned.length === 16;
};

/**
 * Validate password strength
 * @param {String} password - Password to validate
 * @param {Object} options - Validation options
 * @returns {Object} - Validation result
 */
exports.validatePassword = (password, options = {}) => {
  const defaults = {
    minLength: 8,
    requireUppercase: true,
    requireLowercase: true,
    requireNumbers: true,
    requireSpecialChars: true
  };
  
  const config = { ...defaults, ...options };
  
  const result = {
    isValid: true,
    errors: []
  };
  
  // Check length
  if (password.length < config.minLength) {
    result.isValid = false;
    result.errors.push(`Password harus minimal ${config.minLength} karakter`);
  }
  
  // Check uppercase
  if (config.requireUppercase && !/[A-Z]/.test(password)) {
    result.isValid = false;
    result.errors.push('Password harus mengandung minimal 1 huruf kapital');
  }
  
  // Check lowercase
  if (config.requireLowercase && !/[a-z]/.test(password)) {
    result.isValid = false;
    result.errors.push('Password harus mengandung minimal 1 huruf kecil');
  }
  
  // Check numbers
  if (config.requireNumbers && !/[0-9]/.test(password)) {
    result.isValid = false;
    result.errors.push('Password harus mengandung minimal 1 angka');
  }
  
  // Check special characters
  if (config.requireSpecialChars && !/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
    result.isValid = false;
    result.errors.push('Password harus mengandung minimal 1 karakter khusus (!@#$%^&*()_+-=[]{};\':"\\|,.<>/?)');
  }
  
  return result;
};

/**
 * Validate date format (DD-MM-YYYY)
 * @param {String} dateString - Date string to validate
 * @returns {Boolean} - Whether date is valid
 */
exports.isValidDate = (dateString) => {
  // Check format
  const regex = /^(\d{2})-(\d{2})-(\d{4})$/;
  const match = dateString.match(regex);
  
  if (!match) {
    return false;
  }
  
  // Extract parts
  const day = parseInt(match[1], 10);
  const month = parseInt(match[2], 10);
  const year = parseInt(match[3], 10);
  
  // Check month
  if (month < 1 || month > 12) {
    return false;
  }
  
  // Check day based on month
  const daysInMonth = new Date(year, month, 0).getDate();
  if (day < 1 || day > daysInMonth) {
    return false;
  }
  
  return true;
};

/**
 * Validate file type
 * @param {String} filename - File name
 * @param {Array} allowedExtensions - Array of allowed extensions
 * @returns {Boolean} - Whether file type is allowed
 */
exports.isAllowedFileType = (filename, allowedExtensions = ['.jpg', '.jpeg', '.png', '.pdf', '.doc', '.docx']) => {
  const extension = filename.substring(filename.lastIndexOf('.')).toLowerCase();
  return allowedExtensions.includes(extension);
};

/**
 * Validate file size
 * @param {Number} sizeInBytes - File size in bytes
 * @param {Number} maxSizeInMB - Maximum allowed size in MB
 * @returns {Boolean} - Whether file size is valid
 */
exports.isValidFileSize = (sizeInBytes, maxSizeInMB = 5) => {
  const maxSizeInBytes = maxSizeInMB * 1024 * 1024;
  return sizeInBytes <= maxSizeInBytes;
};

/**
 * Validate URL format
 * @param {String} url - URL to validate
 * @returns {Boolean} - Whether URL is valid
 */
exports.isValidURL = (url) => {
  try {
    new URL(url);
    return true;
  } catch (error) {
    return false;
  }
};

/**
 * Validate Indonesian postal code
 * @param {String} postalCode - Postal code to validate
 * @returns {Boolean} - Whether postal code is valid
 */
exports.isValidPostalCode = (postalCode) => {
  // Remove all non-digit characters
  const cleaned = postalCode.replace(/\D/g, '');
  
  // Indonesian postal code is 5 digits
  return cleaned.length === 5;
};

/**
 * Validate NPWP (Nomor Pokok Wajib Pajak)
 * @param {String} npwp - NPWP to validate
 * @returns {Boolean} - Whether NPWP is valid
 */
exports.isValidNPWP = (npwp) => {
  // Remove all non-digit characters
  const cleaned = npwp.replace(/\D/g, '');
  
  // NPWP should be 15 digits
  return cleaned.length === 15;
};

/**
 * Validate Indonesian Bank Account Number
 * @param {String} accountNumber - Account number to validate
 * @returns {Boolean} - Whether account number is valid
 */
exports.isValidBankAccount = (accountNumber) => {
  // Remove all non-digit characters
  const cleaned = accountNumber.replace(/\D/g, '');
  
  // Bank account numbers are typically between 10-15 digits
  return cleaned.length >= 10 && cleaned.length <= 15;
};

/**
 * Sanitize input to prevent XSS
 * @param {String} input - Input to sanitize
 * @returns {String} - Sanitized input
 */
exports.sanitizeInput = (input) => {
  if (typeof input !== 'string') {
    return input;
  }
  
  // Replace HTML special characters
  return input
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
};