class Product {
  final int productId;
  final String productName;
  final String description;
  final double price;
  final int stock;
  final String? imagePath;
  final double? rating;

  Product({
    required this.productId,
    required this.productName,
    required this.description,
    required this.price,
    required this.stock,
    this.imagePath,
    this.rating,
  });

  //muncul di json

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      productName: json['product_name'],
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stock: json['stock'] ?? 0,
      imagePath: json['image_path']?.replaceAll('\\', '/'),
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
    );
  }
}
