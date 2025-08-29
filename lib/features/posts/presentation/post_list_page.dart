import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/post_provider.dart';
import 'new_post_page.dart';
import 'edit_post_page.dart';
import 'my_posts_page.dart';
import 'package:go_router/go_router.dart';

class PostListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(filteredPostsProvider);
    final searchQuery = ref.watch(searchQueryProvider);

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search posts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: postsAsync.when(
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/new');
        },
        child: Icon(Icons.add),
        tooltip: 'New Post',
      ),
    );
  }
}