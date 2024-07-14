import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final note_stream =
      Supabase.instance.client.from("scholarships").stream(primaryKey: ['id']);
  List<String> urls = [];

  @override
  void initState() {
    super.initState();
    fetchUrls();
  }

  Future<void> fetchUrls() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/urls'));
    if (response.statusCode == 200) {
      setState(() {
        urls = List<String>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load URLs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("scholarships"),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: note_stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data!;
          return ListView.builder(
            /*itemCount: urls.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(urls[index]),
                onTap: () => print('Tapped on ${urls[index]}'),
              );
            },*/
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notes[index]['scholarships']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final TextEditingController controller = TextEditingController();
              return SimpleDialog(
                title: const Text("Add Scholarship"),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  TextFormField(
                    controller: controller,
                    onFieldSubmitted: (value) async {
                      await Supabase.instance.client
                          .from('scholarships')
                          .insert({'scholarships': value});
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      await Supabase.instance.client
                          .from('scholarships')
                          .insert({'scholarships': controller.text});
                      print("hello");
                      Navigator.of(context).pop();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
