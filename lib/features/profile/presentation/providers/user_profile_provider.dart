import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) return null;

  final response = await Supabase.instance.client
      .from('profiles')
      .select()
      .eq('id', user.id)
      .maybeSingle(); // ✅ changed from .single() to .maybeSingle()

  if (response == null) return null; // No profile yet

  return UserProfile.fromMap(response);
});