class Post {
  final String id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? username;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.username,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      username: map['profiles']?['username'],
    );
  }
}
