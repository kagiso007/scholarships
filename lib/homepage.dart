import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  title: Text(
                    notes[index]['scholarships']!,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.open_in_new,
                    color: Colors.teal,
                  ),
                  onTap: () {
                    _launchURL(notes[index]['scholarship_url']!);
                  },
                ),
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
              final TextEditingController nameController =
                  TextEditingController();
              final TextEditingController urlController =
                  TextEditingController();

              return SimpleDialog(
                title: const Text("Add Scholarship"),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  TextFormField(
                    controller: nameController,
                    onFieldSubmitted: (value) async {
                      await Supabase.instance.client
                          .from('scholarships')
                          .insert({'scholarships': value});
                      Navigator.of(context).pop();
                    },
                  ),
                  TextFormField(
                    controller: urlController,
                    onFieldSubmitted: (value) async {
                      await Supabase.instance.client
                          .from('scholarships')
                          .insert({'scholarship_url': value});
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      await Supabase.instance.client
                          .from('scholarships')
                          .insert({
                        'scholarships': nameController.text,
                        'scholarship_url': urlController.text
                      });
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


//fetch url via python scrapping
/*itemCount: urls.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(urls[index]),
                onTap: () => print('Tapped on ${urls[index]}'),
              );
            },*/