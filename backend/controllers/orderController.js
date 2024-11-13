const { createOrder, getUserOrders, getAllOrders, updateOrderStatus, deleteOrder } = require('../models/Order');

// Membuat pesanan baru
exports.createOrder = (req, res) => {
  const userId = req.userId; // ID user didapatkan dari authMiddleware
  const { totalAmount } = req.body;

  if (!totalAmount) {
    return res.status(400).json({ message: 'Total amount is required' });
  }

  createOrder(userId, totalAmount, (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ message: 'Order created successfully', orderId: result.insertId });
  });
};

// Mendapatkan semua pesanan user yang sedang login
exports.getUserOrders = (req, res) => {
  const userId = req.userId;

  getUserOrders(userId, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
};

// Mendapatkan semua pesanan (untuk admin)
exports.getAllOrders = (req, res) => {
  getAllOrders((err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
};

// Mengubah status pesanan (untuk admin)
exports.updateOrderStatus = (req, res) => {
  const { orderId } = req.params;
  const { status } = req.body;

  if (!['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'].includes(status)) {
    return res.status(400).json({ message: 'Invalid status' });
  }

  updateOrderStatus(orderId, status, (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Order status updated successfully' });
  });
};

// Menghapus pesanan (untuk admin)
exports.deleteOrder = (req, res) => {
  const { orderId } = req.params;

  deleteOrder(orderId, (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: 'Order deleted successfully' });
  });
};
