import 'package:flutter/material.dart';
import 'package:scholarships/inputpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://tgwwlkjsfmcgvavoegmw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRnd3dsa2pzZm1jZ3Zhdm9lZ213Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjA3Nzc1ODgsImV4cCI6MjAzNjM1MzU4OH0.v6awRcg8F2IZP6qeXN7e9YIShxjbx708MRBa_Ff0IwM',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'scholarships',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EnterMarksPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
