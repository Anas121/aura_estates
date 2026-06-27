class UserData {
  final String? userName;
  final String? userEmail;
  final String? userPhone;
  final List<String> userFavorites;

  UserData({
    this.userName,
    this.userEmail,
    this.userPhone,
    this.userFavorites = const [],
  });
}
