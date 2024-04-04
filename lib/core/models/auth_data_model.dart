class AuthDataModel {
  final String userId;
  final String name;
  final String email;

  AuthDataModel({
    required this.userId,
    required this.name,
    required this.email,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) => AuthDataModel(
        name: json["name"],
        userId: json['id'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        "id": userId,
        "name": name,
        "email": email,
      };
}
