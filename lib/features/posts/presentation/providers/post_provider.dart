import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/post.dart';

final realtimePostsProvider = StreamProvider<List<Post>>((ref) {
  final supabase = Supabase.instance.client;

  final stream = supabase
      .from('posts')
      .stream(primaryKey: ['id']) // needed to uniquely track rows
      .order('created_at', ascending: false);

  return stream.map((rows) =>
      rows.map((row) => Post.fromMap(row)).toList());
});


final myPostsProvider = StreamProvider<List<Post>>((ref) {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    // Return empty stream if not logged in
    return const Stream.empty();
  }

  final stream = Supabase.instance.client
      .from('posts')
      .stream(primaryKey: ['id'])
      .eq('user_id', user.id) // ✅ Filter by current user
      .order('created_at', ascending: false);

  return stream.map((rows) =>
      rows.map((row) => Post.fromMap(row)).toList());
});


final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredPostsProvider = StreamProvider<List<Post>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final supabase = Supabase.instance.client;

  final stream = supabase
      .from('posts')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);

  return stream.map((rows) {
    final posts = rows.map((row) => Post.fromMap(row)).toList();

    if (query.isEmpty) return posts;

    return posts.where((post) {
      return post.title.toLowerCase().contains(query) ||
             post.content.toLowerCase().contains(query);
    }).toList();
  });
});