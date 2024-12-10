import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:uhe/screens/home_screen.dart';
import 'package:uhe/models/product_model.dart';

// Membuat kelas Mock untuk http.Client
class MockClient extends Mock implements http.Client {}

void main() {
  group('HomeScreen', () {
    testWidgets('Menampilkan indikator loading saat mengambil produk', (WidgetTester tester) async {
      // Arrange
      final mockClient = MockClient();
      when(mockClient.get(Uri.parse('http://192.168.95.151:5000/api/products')))
          .thenAnswer((_) async => http.Response('[]', 200));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(client: mockClient),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Menampilkan daftar produk setelah berhasil mengambil data', (WidgetTester tester) async {
      // Arrange
      final mockClient = MockClient();
      final mockResponse = [
        {
          'product_id': 1,
          'product_name': 'Test Product 1',
          'description': 'Description 1',
          'price': 10.0,
          'stock': 100,
          'image_path': 'path/to/image',
          'rating': 4.5,
        },
        {
          'product_id': 2,
          'product_name': 'Test Product 2',
          'description': 'Description 2',
          'price': 20.0,
          'stock': 50,
          'image_path': 'path/to/image2',
          'rating': 5.0,
        },
      ];
      when(mockClient.get(Uri.parse('http://192.168.95.151:5000/api/products')))
          .thenAnswer((_) async => http.Response(mockResponse.toString(), 200));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(client: mockClient),
        ),
      );
      await tester.pumpAndSettle(); // Menunggu hingga animasi selesai

      // Assert
      expect(find.text('Test Product 1'), findsOneWidget);
      expect(find.text('Test Product 2'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('Menampilkan pesan kesalahan saat gagal mengambil produk', (WidgetTester tester) async {
      // Arrange
      final mockClient = MockClient();
      when(mockClient.get(Uri.parse('http://192.168.95.151:5000/api/products')))
          .thenThrow(Exception('Error fetching products'));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(client: mockClient),
        ),
      );
      await tester.pumpAndSettle(); // Menunggu hingga animasi selesai

      // Assert
      expect(find.text('Error fetching products'), findsOneWidget);
    });
  });
}
