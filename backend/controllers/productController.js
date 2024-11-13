const { getAllProducts, createProduct, deleteProduct } = require('../models/Product');
const multer = require('multer');

const storage = multer.diskStorage({
  destination: './uploads',
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname);
  },
});
const upload = multer({ storage });

exports.upload = upload.single('image');

exports.getProducts = (req, res) => {
  getAllProducts((err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
};

exports.createProduct = (req, res) => {
  const { product_name, description, price, stock } = req.body;
  const image_path = req.file ? req.file.path : null;
  createProduct({ product_name, description, price, stock, image_path }, (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({ message: 'Product created' });
  });
};

// Fungsi untuk menghapus produk
exports.deleteProduct = (req, res) => {
  const productId = req.params.id;
  deleteProduct(productId, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    if (results.affectedRows === 0) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.json({ message: 'Product deleted successfully' });
  });
};
