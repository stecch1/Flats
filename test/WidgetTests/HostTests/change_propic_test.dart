import 'package:flats/Screens/Host/change_propic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';



void main() {

  testWidgets('If no image selected, text is empty', (WidgetTester tester) async {

      //here i used a key to find the widget i'm interested in
      await tester.pumpWidget(MaterialApp(home: ChangeProPic(uid:"uid")));
      final textFinder = find.byKey(ValueKey("test_key"));
      final widget = tester.firstWidget<Text>(textFinder);
      expect(widget.data, "");

  });



}