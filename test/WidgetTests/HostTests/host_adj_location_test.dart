import 'package:flats/Screens/Host/host_add.dart';
import 'package:flats/Screens/Host/host_adj_loc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  property p = property("name", "description", 450, LatLng(11, 22), "hostMail");

  testWidgets('Confirm button check', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: locationScreen("123", p)));
    final textFinder = find.textContaining("Confirm");

    expect(textFinder, findsOneWidget);
  });

  //presenza mappa
  testWidgets('One map showing', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: locationScreen("123", p)));
    final mapFinder = find.byType(GoogleMap);

    expect(mapFinder, findsOneWidget);
  });

  testWidgets('Right starting map camera position',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(MaterialApp(home: locationScreen("123", p)));
    final mapFinder = find.byType(GoogleMap);
    final containerWidget = tester.firstWidget<GoogleMap>(mapFinder);

    expect(containerWidget.initialCameraPosition,
        CameraPosition(target: p.coordinate, zoom: 17));
  });
}
