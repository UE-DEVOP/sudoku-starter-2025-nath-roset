import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sudoku_starter/game.dart';

void main() {
  runApp(const MyApp());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sudoku")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () => context.go("/game"),
                child: const Text("Start a new game")),
          )
        ],
      ),
    );
  }
}

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sudoku")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You solved it !'),
          Center(
            child: ElevatedButton(
                onPressed: () => context.go("/"),
                child: const Text("Go to Main menu")),
          )
        ],
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'game',
          builder: (context, state) => const Game(
            title: "Sudoku",
          ),
        ),
        GoRoute(
          path: 'end',
          builder: (context, state) => const VictoryScreen(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
