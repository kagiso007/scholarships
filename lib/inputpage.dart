import 'package:flutter/material.dart';
import 'package:scholarships/homepage.dart';

class EnterMarksPage extends StatefulWidget {
  const EnterMarksPage({super.key});

  @override
  State<EnterMarksPage> createState() => _EnterMarksPageState();
}

class _EnterMarksPageState extends State<EnterMarksPage> {
  final TextEditingController _minAverageMarkController =
      TextEditingController(text: '0.0');
  final TextEditingController _minMathMarkController =
      TextEditingController(text: '0.0');
  final TextEditingController _minPhysicsMarkController =
      TextEditingController(text: '0.0');
  final TextEditingController _minAccountingMarkController =
      TextEditingController(text: '0.0');
  final TextEditingController _minEnglishMarkController =
      TextEditingController(text: '0.0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("please Enter your Marks"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Minimum Average Mark:'),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _minAverageMarkController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "0.0"),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Mathematics:'),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _minMathMarkController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "0.0"),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Physical Science:'),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _minPhysicsMarkController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "0.0"),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Accounting:'),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _minAccountingMarkController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "0.0"),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('English:'),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _minEnglishMarkController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "0.0"),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the View Scholarships Page with the entered marks
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Homepage(
                    minAverageMark:
                        double.tryParse(_minAverageMarkController.text) ?? 0.0,
                    minMathMark:
                        double.tryParse(_minMathMarkController.text) ?? 0.0,
                    minPhysicsMark:
                        double.tryParse(_minPhysicsMarkController.text) ?? 0.0,
                    minAccountingMark:
                        double.tryParse(_minAccountingMarkController.text) ??
                            0.0,
                    minEnglishMark:
                        double.tryParse(_minEnglishMarkController.text) ?? 0.0,
                  ),
                ),
              );
            },
            child: const Text("View Scholarships"),
          ),
        ],
      ),
    );
  }
}
