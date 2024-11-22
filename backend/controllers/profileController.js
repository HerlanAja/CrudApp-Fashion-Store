const Profile = require('../models/Profile');

// Ambil semua profile
exports.getAllProfiles = (req, res) => {
  Profile.getAllProfiles((err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(200).json(results);
  });
};

// Ambil profile berdasarkan ID
exports.getProfileById = (req, res) => {
  const { id } = req.params;
  Profile.getProfileById(id, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.length === 0) return res.status(404).json({ message: 'Profile not found' });
    res.status(200).json(results[0]);
  });
};

// Buat profile baru
exports.createProfile = (req, res) => {
  const profileData = req.body;
  Profile.createProfile(profileData, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ message: 'Profile created', profileId: results.insertId });
  });
};

// Update profile
exports.updateProfile = (req, res) => {
  const { id } = req.params;
  const profileData = req.body;
  Profile.updateProfile(id, profileData, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.affectedRows === 0) return res.status(404).json({ message: 'Profile not found' });
    res.status(200).json({ message: 'Profile updated' });
  });
};

// Hapus profile
exports.deleteProfile = (req, res) => {
  const { id } = req.params;
  Profile.deleteProfile(id, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.affectedRows === 0) return res.status(404).json({ message: 'Profile not found' });
    res.status(200).json({ message: 'Profile deleted' });
  });
};
