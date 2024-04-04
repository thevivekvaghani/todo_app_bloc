class UserProfileModel {
  final String userId;
  final String name;
  final String email;
  final String address;
  final String city;
  final String password;
  final String pinCode;
  final DateTime dateOfBirth;

  UserProfileModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.address,
    required this.city,
    required this.password,
    required this.pinCode,
    required this.dateOfBirth,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
    userId: json["uid"],
    name: json['name'],
    email: json['email'],
    address: json['address'],
    city: json['city'],
    password: json['password'],
    pinCode: json['pin_code'],
    dateOfBirth:  json['date_of_birth'].toDate(),
  );

  Map<String, dynamic> toJson() => {
    "uid": userId,
    "name": name,
    "email": email,
    "address": address,
    "city": city,
    "password": password,
    "pinCode": pinCode,
    "date_of_birth": dateOfBirth,
  };
}
