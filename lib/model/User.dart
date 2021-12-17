import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email = '';
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  Timestamp lastOnlineTimestamp = Timestamp.now();
  String userID;
  bool active = false;
  String profilePictureURL = '';
  String appIdentifier = '${Platform.operatingSystem}';

  User(
      {this.email,
      this.firstName,
      this.phoneNumber,
      this.lastName,
      this.active,
      this.lastOnlineTimestamp,
      this.userID,
      this.profilePictureURL});


  String fullName() {
    return '$firstName $lastName';
  }

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
        email: parsedJson['email'] ?? '',
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        active: parsedJson['active'] ?? false,
        lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
        phoneNumber: parsedJson['phoneNumber'] ?? '',
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        profilePictureURL: parsedJson['profilePictureURL'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'phoneNumber': this.phoneNumber,
      'id': this.userID,
      'active': this.active,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      'profilePictureURL': this.profilePictureURL,
      'appIdentifier': this.appIdentifier
    };
  }
}