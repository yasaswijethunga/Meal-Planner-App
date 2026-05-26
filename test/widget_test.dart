import 'package:ecoplate/widgets/eco_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EcoBadge renders correctly for Vegan score', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: EcoBadge(score: 5)),
      ),
    );
    expect(find.byIcon(Icons.eco), findsOneWidget);
    expect(find.text('Excellent'), findsOneWidget);
  });
}
