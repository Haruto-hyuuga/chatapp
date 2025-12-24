class UserEntity {
  final String id;
  final String email;
  final String username;
  final String token;
  final String profileUrl;

  UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.profileUrl,
    this.token = '',
  });
}
