import 'package:flutter/material.dart';

void main() {
  runApp(const CoreWidgetsDemo());
}

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 1 - Core Widgets')),

      body: Column(
        children: [
          const Text(
            'Welcome to Flutter UI',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const Icon(Icons.movie, size: 50, color: Colors.blue),

          Image.network(
            'https://images.unsplash.com/photo-1500534623283-312aade485b7',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Movie Item'),
              subtitle: const Text('This is a simple ListTile inside a Card.'),
            ),
          ),
        ],
      ),
    );
  }
}
