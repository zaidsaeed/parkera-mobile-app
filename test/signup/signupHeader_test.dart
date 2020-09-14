import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/signup/signupHeader.dart';
import '../globals.dart';

void main() {
  testWidgets('expect header text to be present on screen',
      (WidgetTester tester) async {
    var signUoHeader = makeTestableWidget(child: SignUpHeader());
    await tester.pumpWidget(signUoHeader);
    var textField = find.byType(Text);
    expect(textField, findsOneWidget);
  });
}
