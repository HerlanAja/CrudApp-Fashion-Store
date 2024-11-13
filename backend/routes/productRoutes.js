const express = require('express');
const { getProducts, createProduct, deleteProduct, upload } = require('../controllers/productController');
const { authMiddleware } = require('../middleware/authMiddleware');
const router = express.Router();

router.get('/', getProducts);
router.post('/create', authMiddleware, upload, createProduct);
router.delete('/delete/:id', authMiddleware, deleteProduct);

module.exports = router;
