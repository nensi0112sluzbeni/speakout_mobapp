import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'post.dart';
import 'post_provider.dart';

class EditPostPage extends ConsumerStatefulWidget {
  final Post post;

  EditPostPage({required this.post});

  @override
  ConsumerState<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends ConsumerState<EditPostPage> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.post.title);
    contentController = TextEditingController(text: widget.post.content);
  }

  Future<void> updatePost() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) return;

    setState(() => isLoading = true);

    try {
      await Supabase.instance.client
          .from('posts')
          .update({
            'title': title,
            'content': content,
          })
          .eq('id', widget.post.id);

      ref.invalidate(postsProvider);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> deletePost() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Post?'),
        content: Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await Supabase.instance.client
          .from('posts')
          .delete()
          .eq('id', widget.post.id);

      ref.invalidate(postsProvider);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Post')),
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
            Row(
              children: [
                ElevatedButton(
                  onPressed: isLoading ? null : updatePost,
                  child: isLoading ? CircularProgressIndicator() : Text('Save'),
                ),
                Spacer(),
                TextButton(
                  onPressed: isLoading ? null : deletePost,
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
