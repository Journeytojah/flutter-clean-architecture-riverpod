import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final int timeJoined;
  final String tenantId;
  final String email;
  final bool isEmailVerified;
  final String? phoneNumber;
  final bool isPhoneNumberVerified;
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String token;

  const User({
    this.id = '',
    this.timeJoined = 0,
    this.tenantId = '',
    this.email = '',
    this.isEmailVerified = false,
    this.phoneNumber,
    this.isPhoneNumberVerified = false,
    this.username = '',
    this.password = '',
    this.firstName = '',
    this.lastName = '',
    this.gender = '',
    this.image = '',
    this.token = '',
  });

  @override
  List<Object?> get props => [
        id,
        timeJoined,
        tenantId,
        email,
        isEmailVerified,
        phoneNumber,
        isPhoneNumberVerified,
        username,
        password,
        firstName,
        lastName,
        gender,
        image,
        token,
      ];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'timeJoined': timeJoined,
      'tenantId': tenantId,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'phoneNumber': phoneNumber,
      'isPhoneNumberVerified': isPhoneNumberVerified,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'token': token,
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    final userMap = map['user'] ?? map;

    return User(
      id: userMap['id'] ?? '',
      timeJoined: userMap['timeJoined'] ?? 0,
      tenantId:
          (userMap['tenantIds'] != null && userMap['tenantIds'].isNotEmpty)
              ? userMap['tenantIds'][0]
              : '',
      email: userMap['email'] ?? '',
      isEmailVerified: userMap['isEmailVerified'] ?? false,
      phoneNumber: userMap['phoneNumber'],
      isPhoneNumberVerified: userMap['isPhoneNumberVerified'] ?? false,
      username: userMap['username'] ?? '',
      password: userMap['password'] ?? '',
      firstName: userMap['firstName'] ?? '',
      lastName: userMap['lastName'] ?? '',
      gender: userMap['gender'] ?? '',
      image: userMap['image'] ?? '',
      token: map['st-access-token'] ??
          '', // Ensure you extract the token if it's part of headers or response
    );
  }

  User copyWith({
    String? id,
    int? timeJoined,
    String? tenantId,
    String? email,
    bool? isEmailVerified,
    String? phoneNumber,
    bool? isPhoneNumberVerified,
    String? username,
    String? password,
    String? firstName,
    String? lastName,
    String? gender,
    String? image,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      timeJoined: timeJoined ?? this.timeJoined,
      tenantId: tenantId ?? this.tenantId,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPhoneNumberVerified:
          isPhoneNumberVerified ?? this.isPhoneNumberVerified,
      username: username ?? this.username,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      token: token ?? this.token,
    );
  }
}
