// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('App launches with home page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify that the home page loads with expected content.
    expect(find.text('Clean Architecture Demo'), findsOneWidget);
    expect(find.text('Users Demo'), findsOneWidget);
    expect(find.text('Posts Demo'), findsOneWidget);

    // Verify navigation cards are present
    expect(find.byIcon(Icons.people_outlined), findsOneWidget);
    expect(find.byIcon(Icons.article_outlined), findsOneWidget);
  });
}
