import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true;

  Future<void> handleAuth() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final supabase = Supabase.instance.client;

    try {
      if (isLogin) {
        // User is logging in — no changes here
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } else {
        // User is signing up — insert user profile after sign-up
        final result = await supabase.auth.signUp(
          email: email,
          password: password,
        );

        final userId = result.user?.id;

        if (userId != null) {
          await supabase.from('profiles').insert({
            'id': userId,
            'username': email.split('@')[0], // Use part before @ as a username
            'bio': '',
            'avatar_url': '',
          });
        }
      }

      // No need to call setState — AuthGate listens to auth state changes
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Signup')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Password')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleAuth,
              child: Text(isLogin ? 'Login' : 'Signup'),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? "Don't have an account? Sign up" : "Already have an account? Log in"),
            ),
          ],
        ),
      ),
    );
  }
}
