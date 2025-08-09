import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_app/register_form.dart';

void main() {
  testWidgets('Register form should show all fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: RegisterForm()),
    );

    expect(find.text('Crear Cuenta'), findsOneWidget);
    expect(find.text('Nombre completo'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Confirmar contraseña'), findsOneWidget);
  });



  testWidgets('Form validation should work', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: RegisterForm()),
    );

    await tester.tap(find.text('CREAR CUENTA'));
    await tester.pumpAndSettle();

    expect(find.text('El nombre es obligatorio'), findsOneWidget);
    expect(find.text('Ingresa tu correo electrónico'), findsOneWidget);
  });

  testWidgets('Password confirmation should work', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: RegisterForm()),
    );

    // Llenar campos
    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(find.byType(TextFormField).at(1), 'test@test.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'different');

    await tester.tap(find.text('CREAR CUENTA'));
    await tester.pumpAndSettle();

    expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
  });
}