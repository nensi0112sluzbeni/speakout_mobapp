import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'post_provider.dart';

class NewPostPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends ConsumerState<NewPostPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  bool isLoading = false;

  Future<void> submitPost() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    final user = Supabase.instance.client.auth.currentUser;

    if (title.isEmpty || content.isEmpty || user == null) return;

    setState(() => isLoading = true);

    try {
      await Supabase.instance.client.from('posts').insert({
        'user_id': user.id,
        'title': title,
        'content': content,
      });

      // Refresh post list
      ref.invalidate(postsProvider);

      if (mounted) Navigator.pop(context); // Go back to post list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Post')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 6,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : submitPost,
              child: isLoading ? CircularProgressIndicator() : Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
