import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_profile_provider.dart';
import 'edit_profile_page.dart';
import 'post_list_page.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
          )
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return Center(child: Text("No profile found."));
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("👋 Welcome, ${profile.username}", style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),

                if (profile.avatarUrl.isNotEmpty)
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('${profile.avatarUrl}?v=${DateTime.now().millisecondsSinceEpoch}'),
                  )
                else
                  CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person),
                  ),
                SizedBox(height: 20),
        
                Text("📝 Bio: ${profile.bio.isEmpty ? 'No bio yet.' : profile.bio}"),
                SizedBox(height: 10),
                Text("🆔 ID: ${profile.id}"),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditProfilePage()),
                    );
                  },
                  icon: Icon(Icons.edit),
                  label: Text("Edit Profile"), 
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PostListPage()),
                    );
                  },
                  icon: Icon(Icons.article),
                  label: Text("View All Posts"),
                ),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}