import 'package:flats/Models/user_model.dart';
import 'package:flats/Screens/Host/Host_Home/host_home_vertical.dart';
import 'package:flats/Screens/Host/host_map.dart';
import 'package:flats/Screens/Host/profile_pic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

var usr = User("fCq5oCKGqZgKVFEZ7y2zqITC9SG2", "alessandro@gmail.com");
AsyncSnapshot<User?> snapshot = AsyncSnapshot.withData(ConnectionState.active, usr);

void main() {
  testWidgets('There is only one "check my flats" text', (WidgetTester tester) async {

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(HostHomeVertical(snapshot: snapshot));
    final emailFinder = find.text('check my flats');
    expect(emailFinder, findsOneWidget);
  });

  testWidgets('There is only one "add new flat" text', (WidgetTester tester) async {

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(HostHomeVertical(snapshot: snapshot));
    final emailFinder = find.text('add new flat');
    expect(emailFinder, findsOneWidget);
  });

  testWidgets('There is only one "User email" text', (WidgetTester tester) async {

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(HostHomeVertical(snapshot: snapshot));
    final emailFinder = find.text('User email: alessandro@gmail.com');
    expect(emailFinder, findsOneWidget);
  });

  testWidgets('There is only one ProfilePic widget', (WidgetTester tester) async {

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(HostHomeVertical(snapshot: snapshot));

    expect(find.byType(ProfilePic), findsOneWidget);
  });


}