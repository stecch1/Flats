import 'package:flats/Models/user_model.dart';
import 'package:flats/Screens/Social/PostDetails/post_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

User usr = User("fCq5oCKGqZgKVFEZ7y2zqITC9SG2", "alessandro@gmail.com");
var map = { "title":"Title", "userMail":"userMail","content":"content","flatId":"flatId","uid":"777" };
var map_same_usr = { "title":"Title", "userMail":"userMail","content":"content","flatId":"flatId","uid":"fCq5oCKGqZgKVFEZ7y2zqITC9SG2" };
void main() {

  testWidgets('Content text check', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
        home: PostDetailsView(data: map,user: usr,docId: "123")));
    final textFinder = find.textContaining('content');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Right email check', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
        home: PostDetailsView(data: map,user: usr,docId: "123")));
    final textFinder = find.textContaining('userMail');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Title check', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
        home: PostDetailsView(data: map,user: usr,docId: "123")));
    final textFinder = find.textContaining('Title');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Only chat Icon is showed', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
        home: PostDetailsView(data: map,user: usr,docId: "123")));
    final iconFinder = find.byType(Icon);
    expect(iconFinder, findsOneWidget);
  });

  //only if data['uid'] == user!.uid you can see the delete icon

  testWidgets('Two icons showing', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(
        home: PostDetailsView(data: map_same_usr,user: usr,docId: "123")));
    final iconFinder = find.byType(Icon);
    expect(iconFinder, findsNWidgets(2));
  });



}