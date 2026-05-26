import 'package:ecoplate/models/recipe.dart';
import 'package:ecoplate/widgets/eco_badge.dart';
import 'package:ecoplate/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testRecipe = RecipeSummary(
    id: '1',
    name: 'Avocado Toast',
    thumbnailUrl: 'https://example.com/avocado.jpg',
  );

  Widget buildCard({int? ecoScore}) {
    return MaterialApp(
      home: Scaffold(
        body: RecipeCard(
          recipe: testRecipe,
          ecoScore: ecoScore,
          onTap: () {},
        ),
      ),
    );
  }

  testWidgets('renders recipe name', (WidgetTester tester) async {
    await tester.pumpWidget(buildCard());
    expect(find.text('Avocado Toast'), findsOneWidget);
  });

  testWidgets('renders EcoBadge when ecoScore is provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildCard(ecoScore: 4));
    await tester.pump();
    expect(find.byType(EcoBadge), findsOneWidget);
  });

  testWidgets('does not render EcoBadge when ecoScore is null',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildCard());
    expect(find.byType(EcoBadge), findsNothing);
  });

  testWidgets('calls onTap when tapped', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: RecipeCard(
          recipe: testRecipe,
          onTap: () => tapped = true,
        ),
      ),
    ));
    await tester.tap(find.byType(InkWell));
    expect(tapped, isTrue);
  });

  group('EcoBadge', () {
    testWidgets('shows Excellent for score 5', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EcoBadge(score: 5))),
      );
      expect(find.text('Excellent'), findsOneWidget);
    });

    testWidgets('shows Great for score 4', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EcoBadge(score: 4))),
      );
      expect(find.text('Great'), findsOneWidget);
    });

    testWidgets('shows Low for score 1', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EcoBadge(score: 1))),
      );
      expect(find.text('Low'), findsOneWidget);
    });
  });
}
