import 'package:flats/Models/user_model.dart';
import 'package:flats/Screens/Host/Host_Home/host_home_horizontal.dart';

import 'package:flats/Screens/Host/profile_pic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

var usr = User("fCq5oCKGqZgKVFEZ7y2zqITC9SG2", "alessandro@gmail.com");
AsyncSnapshot<User?> snapshot = AsyncSnapshot.withData(ConnectionState.active, usr);

void main() {

  testWidgets('There is only one "check my flats" text', (WidgetTester tester) async {

    tester.binding.window.physicalSizeTestValue = Size(3000, 2000);

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: HostHomeHorizontal(snapshot: snapshot)));
    final textFinder = find.text('check my flats');
    expect(textFinder, findsOneWidget);

    // resets the screen to its original size after the test end
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });

  testWidgets('There is only one "add new flat" text', (WidgetTester tester) async {

    tester.binding.window.physicalSizeTestValue = Size(3000, 2000);

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: HostHomeHorizontal(snapshot: snapshot)));
    final textFinder = find.text('add new flat');
    expect(textFinder, findsOneWidget);

    // resets the screen to its original size after the test end
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });

  testWidgets('There is only one "User email" text', (WidgetTester tester) async {

    tester.binding.window.physicalSizeTestValue = Size(3000, 2000);

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: HostHomeHorizontal(snapshot: snapshot)));
    final emailFinder = find.textContaining('email');
    expect(emailFinder, findsOneWidget);

    // resets the screen to its original size after the test end
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });

  testWidgets('There is only one ProfilePic widget', (WidgetTester tester) async {

    tester.binding.window.physicalSizeTestValue = Size(3000, 2000);

    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: HostHomeHorizontal(snapshot: snapshot)));

    expect(find.byType(ProfilePic), findsOneWidget);

    // resets the screen to its original size after the test end
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });


}