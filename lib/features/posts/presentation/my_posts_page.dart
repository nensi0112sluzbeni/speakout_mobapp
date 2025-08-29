import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/post_provider.dart';
import 'edit_post_page.dart';
import 'package:go_router/go_router.dart';

class MyPostsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(myPostsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('My Posts')),
      body: postsAsync.when(
        data: (posts) => posts.isEmpty
            ? Center(child: Text('You haven’t posted anything yet.'))
            : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (_, index) {
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
                      context.push('/edit', extra: post);
                    },
                  );
                },
              ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}