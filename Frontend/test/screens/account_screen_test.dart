import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uhe/screens/account_screen.dart';

void main() {
  group('AccountScreen', () {
    testWidgets('Menampilkan teks pada layar akun', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: AccountScreen(),
        ),
      );

      // Act & Assert
      expect(find.text('Your Account'), findsOneWidget); // Ubah teks sesuai dengan yang ada di AccountScreen
    });
  });
}
