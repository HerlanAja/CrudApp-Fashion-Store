const db = require('./db');

// Model untuk Profile
const Profile = {
  // Ambil semua profile
  getAllProfiles: (callback) => {
    const query = 'SELECT * FROM profile';
    db.query(query, callback);
  },

  // Ambil profile berdasarkan ID
  getProfileById: (id, callback) => {
    const query = 'SELECT * FROM profile WHERE id = ?';
    db.query(query, [id], callback);
  },

  // Buat profile baru
  createProfile: (profileData, callback) => {
    const query = `
      INSERT INTO profile (name, email, password, profile_image, phone_number, address) 
      VALUES (?, ?, ?, ?, ?, ?)
    `;
    const { name, email, password, profile_image, phone_number, address } = profileData;
    db.query(query, [name, email, password, profile_image, phone_number, address], callback);
  },

  // Update profile
  updateProfile: (id, profileData, callback) => {
    const query = `
      UPDATE profile SET 
      name = ?, email = ?, password = ?, profile_image = ?, phone_number = ?, address = ? 
      WHERE id = ?
    `;
    const { name, email, password, profile_image, phone_number, address } = profileData;
    db.query(query, [name, email, password, profile_image, phone_number, address, id], callback);
  },

  // Hapus profile
  deleteProfile: (id, callback) => {
    const query = 'DELETE FROM profile WHERE id = ?';
    db.query(query, [id], callback);
  },
};

module.exports = Profile;
