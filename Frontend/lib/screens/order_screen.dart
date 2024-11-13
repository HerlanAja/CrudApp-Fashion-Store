// screens/order_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'dart:convert';

class OrderScreen extends StatelessWidget {
  final Product product;
  final VoidCallback onOrderCompleted;

  const OrderScreen({
    Key? key,
    required this.product,
    required this.onOrderCompleted,
  }) : super(key: key);

  Future<void> createOrder() async {
    final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjUsImlhdCI6MTczMTQ1NjQwN30.hws_G6b0sAwtih6yi5EA748XJoHWZYetZalKpZeXp-k'; // Your token
    final url = Uri.parse('http://192.168.95.151:5000/api/orders');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "productId": product.productId,
        "totalAmount": product.price * product.stock,
      }),
    );

    if (response.statusCode == 201) {
      onOrderCompleted();
    } else {
      print("Failed to create order: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Order",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product Added to Cart",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
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
            Text(
              product.productName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createOrder,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Proceed to Checkout",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
