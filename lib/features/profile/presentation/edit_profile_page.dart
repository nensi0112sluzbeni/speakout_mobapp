import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/user_profile_provider.dart';
import 'package:file_picker/file_picker.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final usernameController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider).value;
    if (profile != null) {
      usernameController.text = profile.username;
      bioController.text = profile.bio;
    }
  }

  Future<void> saveProfile() async {
    final username = usernameController.text.trim();
    final bio = bioController.text.trim();
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    try {
      await Supabase.instance.client
          .from('profiles')
          .update({
            'username': username,
            'bio': bio,
          })
          .eq('id', user.id);

      // Invalidate the profile so it refetches the latest
      ref.invalidate(userProfileProvider);

      if (mounted) {
        Navigator.pop(context); // go back to HomePage
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  Future<void> uploadAvatar() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    // Let user pick an image file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // necessary for web
    );

    if (result == null || result.files.first.bytes == null) return;

    final fileBytes = result.files.first.bytes!;
    final fileName = '${user.id}.png';

    try {
      // Upload to Supabase Storage
      await Supabase.instance.client.storage
          .from('avatars')
          .uploadBinary('public/$fileName', fileBytes, fileOptions: const FileOptions(
            upsert: true, // overwrite if already exists
          ));

      // Get public URL
      final imageUrl = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl('public/$fileName');

      // Save avatar URL to user's profile
      await Supabase.instance.client
          .from('profiles')
          .update({'avatar_url': imageUrl})
          .eq('id', user.id);

      // Refresh Riverpod profile
      ref.invalidate(userProfileProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Avatar uploaded!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Bio'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProfile,
              child: Text('Save Changes'),
            ),
            ElevatedButton.icon(
              onPressed: uploadAvatar,
              icon: Icon(Icons.upload),
              label: Text("Upload Avatar"),
            ),
          ],
        ),
      ),
    );
  }
}
