const db = require('../models/db');

exports.createUser = (username, email, password, callback) => {
    const sql = 'INSERT INTO users (username, email, password) VALUES (?, ?, ?)';
    db.query(sql, [username, email, password], callback);
} 

exports.findUserByEmail = (email, callback) => {
    const sql = 'SELECT * FROM users WHERE email = ?';
    db.query(sql, [email], callback);
}

exports.getUser = (callback) => {
    const sql = 'SELECT * FROM users';
    db.query(sql, callback);
}