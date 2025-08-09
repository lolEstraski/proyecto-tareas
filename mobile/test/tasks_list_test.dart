import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_app/tasks_list.dart';

void main() {
  testWidgets('TasksList should show loading initially', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TasksList(token: 'test-token'),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('TasksList should have search field', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TasksList(token: 'test-token'),
      ),
    );

    expect(find.text('Buscar tareas...'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('TasksList should have floating action button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TasksList(token: 'test-token'),
      ),
    );

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsAtLeastNWidgets(1));
  });

  testWidgets('Search field should accept text input', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TasksList(token: 'test-token'),
      ),
    );

    await tester.enterText(find.byType(TextField), 'test search');
    expect(find.text('test search'), findsOneWidget);
  });

  testWidgets('Stats cards should be present', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TasksList(token: 'test-token'),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Total'), findsOneWidget);
    expect(find.text('Pendientes'), findsOneWidget);
    expect(find.text('Completadas'), findsOneWidget);
  });
}