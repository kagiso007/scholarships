import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  final double minAverageMark;
  final double minMathMark;
  final double minPhysicsMark;
  final double minAccountingMark;
  final double minEnglishMark;

  const Homepage({
    super.key,
    required this.minAverageMark,
    required this.minMathMark,
    required this.minPhysicsMark,
    required this.minAccountingMark,
    required this.minEnglishMark,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> notes = [];
  int _loadedItemsCount = 5;
  static const int _itemsPerPage = 5;

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

  Stream<List<Map<String, dynamic>>> _getFilteredNotes() {
    return _supabaseClient
        .from('scholarships')
        .select()
        .gte('average', 100 - widget.minAverageMark)
        .gte('mathematics', 100 - widget.minMathMark)
        .gte('physics', 100 - widget.minPhysicsMark)
        .gte('accounting', 100 - widget.minAccountingMark)
        .gte('english', 100 - widget.minEnglishMark)
        .asStream()
        .map((response) => response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scholarships and Bursaries"),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
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
          if (visibleNotes.isEmpty) {
            return const Center(
              child: Text(
                "you do not qualify for any scholarship or bursary at the moment.",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }
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
    );
  }
}
