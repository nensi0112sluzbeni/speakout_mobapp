import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'post.dart';

final realtimePostsProvider = StreamProvider<List<Post>>((ref) {
  final supabase = Supabase.instance.client;

  final stream = supabase
      .from('posts')
      .stream(primaryKey: ['id']) // needed to uniquely track rows
      .order('created_at', ascending: false);

  return stream.map((rows) =>
      rows.map((row) => Post.fromMap(row)).toList());
});