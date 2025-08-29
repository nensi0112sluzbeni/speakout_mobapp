import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/presentation/auth_page.dart';
import 'home_page.dart';
import '../features/posts/presentation/new_post_page.dart';
import '../features/posts/presentation/edit_post_page.dart';
import '../features/posts/data/post.dart';
import '../features/profile/presentation/edit_profile_page.dart';
import '../features/posts/presentation/post_list_page.dart';

import 'dart:async';

final router = GoRouter(
  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange,
  ),
  redirect: (context, state) {
    final user = Supabase.instance.client.auth.currentUser;
    final isAuthPage = state.fullPath == '/auth';

    if (user == null && !isAuthPage) return '/auth';
    if (user != null && isAuthPage) return '/';
    return null;
  },

  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => AuthPage(),
    ),
    GoRoute(
      path: '/new',
      name: 'newPost',
      builder: (context, state) => NewPostPage(),
    ),
    GoRoute(
      path: '/edit',
      name: 'editPost',
      builder: (context, state) {
        final post = state.extra as Post;
        return EditPostPage(post: post);
      },
    ),
    GoRoute(
      path: '/edit-profile',
      name: 'editProfile',
      builder: (context, state) => EditProfilePage(),
    ),
    GoRoute(
      path: '/posts',
      name: 'posts',
      builder: (context, state) => PostListPage(),
    ),
  ],
);

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners(); // Force initial check
    _subscription = stream.asBroadcastStream().listen((event) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
