// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';
import 'product_detail_screen.dart';
import 'create_product_screen.dart';  // Pastikan sudah mengimpor CreateProductScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  bool _isLoading = true;
  int _selectedCategoryIndex = 0;
  int _currentIndex = 0;

  final List<String> categories = ["All", "Men", "Women", "Kids", "Others"];

  // Fungsi untuk mengambil data produk dari API
  Future<void> fetchProducts() async {
    const String apiUrl = 'http://192.168.95.151:5000/api/products';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _products = data.map((json) => Product.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching products: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
  }

  void onTabTapped(int index) {
    if (index == 2) {
      // Jika yang diklik adalah tombol "+" (Add), langsung arahkan ke CreateProductScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateProductScreen(),
        ),
      );
    } else {
      // Jika bukan tombol "+" (Add), cukup ganti tab biasa
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(Icons.grid_view, color: Colors.black),
            Icon(Icons.search, color: Colors.black),
          ],
        ),
      ),
      body: _currentIndex == 0
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Explore",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Best trendy collection!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Kategori
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return categoryButton(
                          categories[index],
                          index == _selectedCategoryIndex,
                          () => onCategorySelected(index),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Produk
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              final product = _products[index];
                              return buildProductCard(product);
                            },
                          ),
                  ),
                ],
              ),
            )
          : Center(child: Text("Page ${_currentIndex + 1}")),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add', // Tombol + untuk menambahkan produk
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  Widget categoryButton(String title, bool isSelected, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.orange : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail produk
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: product.imagePath != null && product.imagePath!.isNotEmpty
                    ? Image.network(
                        'http://192.168.95.151:5000/${product.imagePath}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.error)),
                      )
                    : const Center(child: Icon(Icons.image_not_supported, size: 50)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
