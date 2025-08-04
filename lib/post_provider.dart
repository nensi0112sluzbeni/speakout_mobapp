import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'post.dart';

final postsProvider = FutureProvider<List<Post>>((ref) async {
  final response = await Supabase.instance.client
      .from('posts')
      .select('id, title, content, created_at, user_id, profiles(username)')
      .order('created_at', ascending: false);

  return (response as List).map((row) => Post.fromMap(row)).toList();
});