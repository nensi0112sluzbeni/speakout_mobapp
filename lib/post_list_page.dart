import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'post_provider.dart';
import 'new_post_page.dart';
import 'edit_post_page.dart';
import 'my_posts_page.dart';

class PostListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(realtimePostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('All Posts'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            tooltip: 'My Posts',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MyPostsPage()),
              );
            },
          ),
        ],
      ),
      body: postsAsync.when(
        data: (posts) => ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return ListTile(
              title: Text(post.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.username != null)
                    Text('@${post.username}', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  SizedBox(height: 4),
                  Text(
                    post.content.length > 60
                        ? '${post.content.substring(0, 60)}...'
                        : post.content,
                  ),
                ],
              ),
              trailing: Text(
                '${post.createdAt.day}/${post.createdAt.month}',
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditPostPage(post: post)),
                );
              },
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NewPostPage()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'New Post',
      ),
    );
  }
}
