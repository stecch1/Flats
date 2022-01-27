import 'package:flats/Screens/Chat/chatroom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';



void main() {

  testWidgets('Last message is right', (WidgetTester tester) async {

    mockNetworkImagesFor(() async{

      await tester.pumpWidget(MaterialApp(home: ChatRoomListTile("ultimo messaggio","123","miaEmail@gmail.com")));
      final textFinder = find.textContaining('ultimo messaggio');
      expect(textFinder, findsOneWidget);

    });

  });

  testWidgets('Chatter name is right', (WidgetTester tester) async {

    mockNetworkImagesFor(() async{

      await tester.pumpWidget(MaterialApp(home: ChatRoomListTile("ultimo messaggio","123","test@email.com")));
      final textFinder = find.byType(Text);
      final textWidget = tester.firstWidget<Text>(textFinder);
      expect(textWidget.data, "test");

    });

  });

}