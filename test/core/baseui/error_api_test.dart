import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/core/baseui/error_api.dart';

void main() {
  group('ErrorApiWidget Tests', () {
    testWidgets('should display error message and retry button', (
      WidgetTester tester,
    ) async {
      var retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorApiWidget(
              errorMessage: 'Network connection failed',
              onRetry: () {
                retryPressed = true;
              },
            ),
          ),
        ),
      );

      // Verify error message is displayed
      expect(find.text('Error: Network connection failed'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      // Verify retry button is present
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Test retry functionality
      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryPressed, isTrue);
    });

    testWidgets('should be centered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorApiWidget(errorMessage: 'Test error', onRetry: () {}),
        ),
      );

      // Verify the widget structure - should find at least one Center widget
      expect(find.byType(Center), findsWidgets);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should display different error messages', (
      WidgetTester tester,
    ) async {
      // Test first error message
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorApiWidget(
              errorMessage: 'Server error 500',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text('Error: Server error 500'), findsOneWidget);

      // Test second error message
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorApiWidget(
              errorMessage: 'Timeout occurred',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text('Error: Timeout occurred'), findsOneWidget);
      expect(find.text('Error: Server error 500'), findsNothing);
    });

    testWidgets('should handle empty error message gracefully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorApiWidget(errorMessage: '', onRetry: () {}),
          ),
        ),
      );

      // Should still display the empty string (though not ideal UX)
      expect(find.text('Error: '), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should handle multiple retry button taps', (
      WidgetTester tester,
    ) async {
      var retryCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorApiWidget(
              errorMessage: 'Test error',
              onRetry: () {
                retryCount++;
              },
            ),
          ),
        ),
      );

      // Tap retry button multiple times
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryCount, equals(3));
    });
  });
}
