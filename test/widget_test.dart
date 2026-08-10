import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app1/components/default_button.dart';
import 'package:my_flutter_app1/components/input_field.dart';

void main() {
  testWidgets('DefaultButton calls onPressed when tapped',
      (WidgetTester tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DefaultButton(
            text: 'Save',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Save'), findsOneWidget);
    expect(tapped, isFalse);

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('AppInputField shows the error text when provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppInputField(
            label: 'Model Number',
            errorText: 'Model number is required',
          ),
        ),
      ),
    );

    expect(find.text('Model Number'), findsOneWidget);
    expect(find.text('Model number is required'), findsOneWidget);
  });
}
