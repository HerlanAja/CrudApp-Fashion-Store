import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uhe/models/product_model.dart';
import 'package:uhe/screens/product_detail_screen.dart';

void main() {
  group('ProductDetailScreen', () {
    testWidgets('Menampilkan detail produk', (WidgetTester tester) async {
      // Arrange
      final product = Product(
        productId: 1,
        productName: 'Test Product',
        description: 'Test Description',
        price: 10.0,
        stock: 100,
        imagePath: 'path/to/image',
        rating: 4.5,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ProductDetailScreen(product: product),
        ),
      );

      // Act & Assert
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('\$10.00'), findsOneWidget);
    });
  });
}
