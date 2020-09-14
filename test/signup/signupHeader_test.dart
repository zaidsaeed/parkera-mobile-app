import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/signup/signupHeader.dart';

void main() {
  testWidgets('expect header text to be present on screen',
      (WidgetTester tester) async {
    var app = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: SignUpHeader()));
    await tester.pumpWidget(app);
    var textField = find.byType(Text);
    expect(textField, findsOneWidget);
  });
}
