import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_app/login_form.dart';

void main() {
  testWidgets('Login form should show all fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LoginForm()),
    );

    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('INICIAR SESIÓN'), findsOneWidget);
  });

  testWidgets('Login form validation should work', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LoginForm()),
    );

    // Intentar login sin datos
    await tester.tap(find.text('INICIAR SESIÓN'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa tu correo electrónico'), findsOneWidget);
    expect(find.text('Ingresa tu contraseña'), findsOneWidget);
  });

  testWidgets('Email validation should work', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LoginForm()),
    );

    // Ingresar email inválido
    await tester.enterText(find.byType(TextFormField).first, 'email-malo');
    await tester.tap(find.text('INICIAR SESIÓN'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa un correo válido'), findsOneWidget);
  });
}