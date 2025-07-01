class UserProfile {
  final String id;
  final String username;
  final String bio;
  final String avatarUrl;

  UserProfile({
    required this.id,
    required this.username,
    required this.bio,
    required this.avatarUrl,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      username: map['username'] ?? '',
      bio: map['bio'] ?? '',
      avatarUrl: map['avatar_url'] ?? '',
    );
  }
}