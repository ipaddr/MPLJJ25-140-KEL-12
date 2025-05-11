const { getStorage } = require('firebase-admin/storage');
const { v4: uuidv4 } = require('uuid');
const path = require('path');
const { logger } = require('../utils/logger');

/**
 * Upload a file to Firebase Storage
 * @param {Buffer} fileBuffer - File buffer
 * @param {String} fileName - Original file name
 * @param {String} folder - Storage folder path
 * @returns {Promise<String>} - Download URL
 */
exports.uploadFile = async (fileBuffer, fileName, folder = 'uploads') => {
  try {
    const storage = getStorage();
    const bucket = storage.bucket();
    
    // Generate unique file name
    const fileExtension = path.extname(fileName);
    const uniqueFileName = `${folder}/${uuidv4()}${fileExtension}`;
    
    // Create a file reference
    const file = bucket.file(uniqueFileName);
    
    // Upload the file
    await file.save(fileBuffer, {
      metadata: {
        contentType: getContentType(fileExtension)
      }
    });
    
    // Make the file publicly accessible
    await file.makePublic();
    
    // Get download URL
    const downloadUrl = `https://storage.googleapis.com/${bucket.name}/${uniqueFileName}`;
    
    logger.info(`File uploaded successfully: ${uniqueFileName}`);
    return downloadUrl;
  } catch (error) {
    logger.error('Error uploading file:', error);
    throw error;
  }
};

/**
 * Delete a file from Firebase Storage
 * @param {String} fileUrl - File URL
 * @returns {Promise<Boolean>} - Success status
 */
exports.deleteFile = async (fileUrl) => {
  try {
    const storage = getStorage();
    const bucket = storage.bucket();
    
    // Extract file path from URL
    const filePathRegex = /https:\/\/storage\.googleapis\.com\/[^\/]+\/(.+)/;
    const match = fileUrl.match(filePathRegex);
    
    if (!match || !match[1]) {
      throw new Error('Invalid file URL format');
    }
    
    const filePath = match[1];
    
    // Delete the file
    await bucket.file(filePath).delete();
    
    logger.info(`File deleted successfully: ${filePath}`);
    return true;
  } catch (error) {
    logger.error('Error deleting file:', error);
    throw error;
  }
};

/**
 * Get the content type based on file extension
 * @param {String} extension - File extension
 * @returns {String} - Content type
 */
function getContentType(extension) {
  const contentTypes = {
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.png': 'image/png',
    '.gif': 'image/gif',
    '.pdf': 'application/pdf',
    '.doc': 'application/msword',
    '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    '.xls': 'application/vnd.ms-excel',
    '.xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    '.txt': 'text/plain'
  };
  
  return contentTypes[extension.toLowerCase()] || 'application/octet-stream';
}