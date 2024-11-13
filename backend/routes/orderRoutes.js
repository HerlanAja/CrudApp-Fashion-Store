const express = require('express');
const {
  createOrder,
  getUserOrders,
  getAllOrders,
  updateOrderStatus,
  deleteOrder
} = require('../controllers/orderController');
const { authMiddleware } = require('../middleware/authMiddleware');
const router = express.Router();

// Membuat pesanan baru
router.post('/', authMiddleware, createOrder);

// Mendapatkan semua pesanan milik user yang sedang login
router.get('/', authMiddleware, getUserOrders);

// Mendapatkan semua pesanan (hanya admin)
router.get('/all', authMiddleware, getAllOrders);

// Memperbarui status pesanan (hanya admin)
router.put('/:orderId', authMiddleware, updateOrderStatus);

// Menghapus pesanan (hanya admin)
router.delete('/:orderId', authMiddleware, deleteOrder);

module.exports = router;
