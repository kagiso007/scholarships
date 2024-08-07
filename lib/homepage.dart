import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> notes = [];
  int _loadedItemsCount = 5;
  static const int _itemsPerPage = 5;
  double _minAverageMark = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    setState(() {
      _loadedItemsCount += _itemsPerPage;
    });
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _setMinAverageMark(double mark) {
    setState(() {
      _minAverageMark = mark;
    });
  }

  Stream<List<Map<String, dynamic>>> _getFilteredNotes() {
    return _supabaseClient
        .from('scholarships')
        .stream(primaryKey: ['id']).gte('average', 100 - _minAverageMark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Scholarships and Bursaries"),
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
                  child: Slider(
                    value: _minAverageMark,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: _minAverageMark.round().toString(),
                    onChanged: (double value) {
                      _setMinAverageMark(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _getFilteredNotes(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                notes = snapshot.data!;
                final visibleNotes = notes.take(_loadedItemsCount).toList();
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: visibleNotes.length + 1,
                  itemBuilder: (context, index) {
                    if (index == visibleNotes.length) {
                      return Visibility(
                        visible: _loadedItemsCount < notes.length,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: _loadMoreItems,
                              child: const Text("View More"),
                            ),
                          ),
                        ),
                      );
                    }
                    return Card(
                      elevation: 2.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        title: Text(
                          visibleNotes[index]['scholarships']!,
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
                          _launchURL(visibleNotes[index]['scholarship_url']!);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
                    decoration:
                        const InputDecoration(hintText: "Name of Scholarship"),
                    onFieldSubmitted: (value) async {
                      await Supabase.instance.client
                          .from('scholarships')
                          .insert({'scholarships': value});
                      Navigator.of(context).pop();
                    },
                  ),
                  TextFormField(
                    controller: urlController,
                    decoration: const InputDecoration(
                        hintText: "Scholarship Website Link"),
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
                        'scholarship_url': urlController.text,
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
