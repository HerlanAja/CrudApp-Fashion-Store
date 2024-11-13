// screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'order_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Product Detail",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Gambar Produk
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: product.imagePath != null && product.imagePath!.isNotEmpty
                  ? Image.network(
                      'http://192.168.95.151:5000/${product.imagePath}',
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.error)),
                    )
                  : const Center(child: Icon(Icons.image_not_supported, size: 50)),
            ),
            const SizedBox(height: 16),
            // Nama Produk
            Text(
              product.productName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Deskripsi Produk
            Text(
              product.description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Harga Produk
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Stok Produk
            Text(
              'Stock: ${product.stock}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Rating Produk (Bintang)
            if (product.rating != null)
              Row(
                children: [
                  for (int i = 1; i <= 5; i++)
                    Icon(
                      i <= product.rating!
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.orange,
                      size: 20,
                    ),
                  const SizedBox(width: 4),
                  Text(
                    product.rating!.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            if (product.rating == null)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  "No Rating",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 16),
            // Tombol Add to Cart
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderScreen(
                      product: product,
                      onOrderCompleted: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Order added to Cart")),
                        );
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Add to Cart",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
