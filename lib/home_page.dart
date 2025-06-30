import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${user?.email}"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Text("You're logged in!"),
      ),
    );
  }
}
