import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/signup/signupTextField.dart';
import '../globals.dart';

void main() {
  testWidgets(
      'expect label text to be present on top of the input field string',
      (WidgetTester tester) async {
    const testLabelText = 'Test label';
    const emptyErrorText = 'Text field is empty';
    var signupTextField = makeTestableWidget(
        child: new Scaffold(
      body: SignUpTextField(
          labelText: testLabelText,
          onTextChange: (text) {},
          emptyErrorText: emptyErrorText,
          isEmpty: true),
    ));
    await tester.pumpWidget(signupTextField);
    var labelTextFound = find.text(testLabelText);
    expect(find.text(testLabelText), findsOneWidget);
  });
}
