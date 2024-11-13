const db = require('../models/db');

exports.getAllProducts = (callback) => {
    db.query('SELECT * FROM products', callback);   
}
exports.createProduct = (product, callback) => {
    const { product_name, description, price, stock, image_path } = product;
    const sql = 'INSERT INTO products (product_name, description, price, stock, image_path) VALUES (?, ?, ?, ?, ?)';
    db.query(sql, [product_name, description, price, stock, image_path], callback);
};

exports.deleteProduct = (productId, callback) => {
    const sql = 'DELETE FROM products WHERE product_id = ?';
    db.query(sql, [productId], callback);
};