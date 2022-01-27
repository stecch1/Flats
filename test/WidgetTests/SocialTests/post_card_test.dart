import 'package:flats/Models/user_model.dart';
import 'package:flats/Screens/Social/PostDetails/post_details_view.dart';
import 'package:flats/Screens/Social/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

var map = { "title":"Title", "content":"content"};
void main() {

  testWidgets('Content text check', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
        home: PostCard(data: map,docId: "123",)));
    final textFinder = find.textContaining('content');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Title check', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
        home: PostCard(data: map,docId: "123")));
    final textFinder = find.textContaining('Title');
    expect(textFinder, findsOneWidget);
  });







}