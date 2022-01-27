
import 'package:flats/Screens/Chat/chat_message_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';



void main() {

  testWidgets('Message text check', (WidgetTester tester) async {


    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: ChatMessageTile(message: "messaggio di prova", sendByMe: true)));
    final textFinder = find.textContaining('messaggio di prova');
    expect(textFinder, findsOneWidget);


  });

  testWidgets('Messages have white text', (WidgetTester tester) async {


    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: ChatMessageTile(message: "messaggio di prova", sendByMe: true)));
    final textFinder = find.textContaining("prova");
    final textWidget = tester.firstWidget<Text>(textFinder);

    expect(textWidget.style!.color, Colors.white );

  });

  testWidgets('Your message cloud is blue', (WidgetTester tester) async {


    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: ChatMessageTile(message: "messaggio di prova", sendByMe: true)));
    final containerFinder = find.byType(Container);
    final containerWidget = tester.firstWidget<Container>(containerFinder);

    expect(containerWidget.decoration.toString().contains("Color(0xff2196f3)"), true);

  });

  testWidgets('Other person message cloud is grey', (WidgetTester tester) async {


    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: ChatMessageTile(message: "messaggio di prova", sendByMe: false)));
    final containerFinder = find.byType(Container);
    final containerWidget = tester.firstWidget<Container>(containerFinder);

    expect(containerWidget.decoration.toString().contains('Color(0xff9e9e9e)'), true);

  });

  testWidgets('Border Shape is right', (WidgetTester tester) async {


    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: ChatMessageTile(message: "messaggio di prova", sendByMe: true)));
    final containerFinder = find.byType(Container);
    final containerWidget = tester.firstWidget<Container>(containerFinder);

    expect(containerWidget.decoration.toString().contains('BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), bottomLeft: Radius.circular(24.0)))'), true);

  });

}