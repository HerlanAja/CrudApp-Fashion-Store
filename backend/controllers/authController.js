const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { createUser, findUserByEmail } = require('../models/User');

exports.register = async (req, res) => {
  const { username, email, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);
  createUser(username, email, hashedPassword, (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ message: 'User registered successfully' });
  });
};

exports.login = async (req, res) => {
  const { email, password } = req.body;
  findUserByEmail(email, async (err, results) => {
    if (err || results.length === 0) return res.status(404).json({ message: 'User not found' });
    const user = results[0];
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ message: 'Invalid credentials' });
    const token = jwt.sign({ userId: user.user_id }, process.env.JWT_SECRET);
    res.json({ token });
  });
};
