
import 'package:flats/Screens/Chat/chat_message_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';



void main() {

  testWidgets('There is only one "check my flats" text', (WidgetTester tester) async {


    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: ChatMessageTile(message: "messaggio di prova", sendByMe: true)));
    final textFinder = find.textContaining('messaggio di prova');
    expect(textFinder, findsOneWidget);


  });

}