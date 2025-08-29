import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/auth_gate.dart';
import 'app/router.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bwboyvgltvwcjouwjbnn.supabase.co', // replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ3Ym95dmdsdHZ3Y2pvdXdqYm5uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEyMzgwMjYsImV4cCI6MjA2NjgxNDAyNn0.KIOoyMx7EY5Jhthy1ndfcPEN1TiI5jat6ODniUr2Qx4', // replace with your Anon Key
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'SpeakOut',
      theme: ThemeData(primarySwatch: Colors.indigo),
    );
  }
}