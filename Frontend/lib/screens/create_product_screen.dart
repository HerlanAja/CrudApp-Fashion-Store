import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({Key? key}) : super(key: key);

  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  // Function to create product with the input fields
  Future<void> createProduct(BuildContext context) async {
    const String apiUrl = 'http://192.168.95.151:5000/api/products/create';

    // Validate inputs
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty || _priceController.cktext.isEmpty || _stockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Get data from controllers
    final String productName = _nameController.text;
    final String description = _descriptionController.text;
    final double price = double.tryParse(_priceController.text) ?? 0.0;
    final int stock = int.tryParse(_stockController.text) ?? 0;

    try {
      // Create multipart request for uploading product data
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add product data to request
      request.fields['product_name'] = productName;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();
      request.fields['stock'] = stock.toString();

      // Send request to server
      var response = await request.send();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product created successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create product')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error creating product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => createProduct(context),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
