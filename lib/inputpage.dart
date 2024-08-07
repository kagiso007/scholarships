import 'package:flutter/material.dart';
import 'package:scholarships/homepage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController mathematicsController = TextEditingController();
  final TextEditingController physicsController = TextEditingController();
  final TextEditingController EnglishController = TextEditingController();
  final TextEditingController accountingController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController averagemarkController = TextEditingController();

  void _navigateToHomePage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const MyHomePage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: mathematicsController,
              decoration: const InputDecoration(labelText: 'mathematics'),
            ),
            TextField(
              controller: physicsController,
              decoration: const InputDecoration(labelText: 'physical sciences'),
            ),
            TextField(
              controller: EnglishController,
              decoration: const InputDecoration(labelText: 'English'),
            ),
            TextField(
              controller: accountingController,
              decoration: const InputDecoration(labelText: 'accounting'),
            ),
            TextField(
              controller: nationalityController,
              decoration: const InputDecoration(labelText: 'nationality'),
            ),
            TextField(
              controller: averagemarkController,
              decoration: const InputDecoration(labelText: 'average mark'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // You can process the inputs here if needed
                _navigateToHomePage();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
