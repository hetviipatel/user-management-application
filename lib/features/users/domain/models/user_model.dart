import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String username;
  final String phone;
  final Address address;
  final Company company;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.username,
    required this.phone,
    required this.address,
    required this.company,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      image: json['image'],
      username: json['username'],
      phone: json['phone'],
      address: Address.fromJson(json['address']),
      company: Company.fromJson(json['company']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        image,
        username,
        phone,
        address,
        company,
      ];
}

class Address extends Equatable {
  final String address;
  final String city;
  final String state;
  final String postalCode;

  const Address({
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
    );
  }

  @override
  List<Object?> get props => [address, city, state, postalCode];
}

class Company extends Equatable {
  final String name;
  final String title;
  final String department;

  const Company({
    required this.name,
    required this.title,
    required this.department,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      title: json['title'],
      department: json['department'],
    );
  }

  @override
  List<Object?> get props => [name, title, department];
} 