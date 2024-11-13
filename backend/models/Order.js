const db = require('./db');

// Fungsi untuk membuat pesanan baru
exports.createOrder = (userId, totalAmount, callback) => {
  const sql = 'INSERT INTO orders (user_id, total_amount) VALUES (?, ?)';
  db.query(sql, [userId, totalAmount], callback);
};

// Fungsi untuk mengambil semua pesanan milik user tertentu
exports.getUserOrders = (userId, callback) => {
  const sql = 'SELECT * FROM orders WHERE user_id = ?';
  db.query(sql, [userId], callback);
};

// Fungsi untuk mengambil semua pesanan (untuk admin)
exports.getAllOrders = (callback) => {
  const sql = 'SELECT * FROM orders';
  db.query(sql, callback);
};

// Fungsi untuk memperbarui status pesanan
exports.updateOrderStatus = (orderId, status, callback) => {
  const sql = 'UPDATE orders SET order_status = ? WHERE order_id = ?';
  db.query(sql, [status, orderId], callback);
};

// Fungsi untuk menghapus pesanan
exports.deleteOrder = (orderId, callback) => {
  const sql = 'DELETE FROM orders WHERE order_id = ?';
  db.query(sql, [orderId], callback);
};
