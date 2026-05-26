import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/about_screen.dart';
import '../screens/home_screen.dart';
import '../screens/recipe_detail_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page not found')),
    body: Center(child: Text('No route for: ${state.uri}')),
  ),
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/recipe/:id',
      name: 'recipe-detail',
      builder: (context, state) => RecipeDetailScreen(
        id: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);
