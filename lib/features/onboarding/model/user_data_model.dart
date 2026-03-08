// import 'package:flutter/material.dart';

// class UserData {
//   String? name;
//   String? age;
//   String? gender;
//   String? howKnow;
//   String? employment;
//   String? religion;
//   String? frequency;
//   TimeOfDay? notificationTime;
//   bool notificationsEnabled;
//   List<String> selectedFeatures;
//   Map<String, List<String>> preferences;

//   UserData({
//     this.name,
//     this.age,
//     this.gender,
//     this.howKnow,
//     this.employment,
//     this.religion,
//     this.frequency,
//     this.notificationTime,
//     this.notificationsEnabled = false,
//     List<String>? selectedFeatures,
//     Map<String, List<String>>? preferences,
//   })  : selectedFeatures = selectedFeatures ?? [],
//         preferences = preferences ?? {
//           'affirmations': [],
//           'motivations': [],
//           'jokes': [],
//           'quotes': [],
//           'notifications': [],
//         };

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'age': age,
//       'gender': gender,
//       'howKnow': howKnow,
//       'employment': employment,
//       'religion': religion,
//       'frequency': frequency,
//       'notificationTime': notificationTime?.format(context),
//       'notificationsEnabled': notificationsEnabled,
//       'selectedFeatures': selectedFeatures,
//       'preferences': preferences,
//     };
//   }
// }

import 'package:flutter/material.dart';

class UserData {
  String? name;
  String? age;
  String? gender;
  String? howKnow;
  String? employment;
  String? religion;
  String? frequency;
  TimeOfDay? notificationTime;
  bool notificationsEnabled;
  List<String> selectedFeatures;
  Map<String, List<String>> preferences;

  UserData({
    this.name,
    this.age,
    this.gender,
    this.howKnow,
    this.employment,
    this.religion,
    this.frequency,
    this.notificationTime,
    this.notificationsEnabled = false,
    List<String>? selectedFeatures,
    Map<String, List<String>>? preferences,
  }) : selectedFeatures = selectedFeatures ?? [],
       preferences =
           preferences ??
           {
             'affirmations': [],
             'motivations': [],
             'jokes': [],
             'quotes': [],
             'notifications': [],
           };

  // Method 1: Store time as string without context
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'howKnow': howKnow,
      'employment': employment,
      'religion': religion,
      'frequency': frequency,
      'notificationTime': notificationTime != null
          ? '${notificationTime!.hour}:${notificationTime!.minute}'
          : null,
      'notificationsEnabled': notificationsEnabled,
      'selectedFeatures': selectedFeatures,
      'preferences': preferences,
    };
  }

  // Method 2: If you need formatted time with context, create a separate method
  String? getFormattedNotificationTime(BuildContext context) {
    if (notificationTime == null) return null;
    return notificationTime!.format(context);
  }

  // Method 3: Create a copyWith method for easy updates
  UserData copyWith({
    String? name,
    String? age,
    String? gender,
    String? howKnow,
    String? employment,
    String? religion,
    String? frequency,
    TimeOfDay? notificationTime,
    bool? notificationsEnabled,
    List<String>? selectedFeatures,
    Map<String, List<String>>? preferences,
  }) {
    return UserData(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      howKnow: howKnow ?? this.howKnow,
      employment: employment ?? this.employment,
      religion: religion ?? this.religion,
      frequency: frequency ?? this.frequency,
      notificationTime: notificationTime ?? this.notificationTime,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      selectedFeatures: selectedFeatures ?? this.selectedFeatures,
      preferences: preferences ?? this.preferences,
    );
  }

  // Method 4: Create from JSON (for when you load saved data)
  factory UserData.fromJson(Map<String, dynamic> json) {
    // Parse time string back to TimeOfDay if needed
    TimeOfDay? parseTime(String? timeString) {
      if (timeString == null) return null;
      final parts = timeString.split(':');
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
      return null;
    }

    return UserData(
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      howKnow: json['howKnow'],
      employment: json['employment'],
      religion: json['religion'],
      frequency: json['frequency'],
      notificationTime: parseTime(json['notificationTime']),
      notificationsEnabled: json['notificationsEnabled'] ?? false,
      selectedFeatures: List<String>.from(json['selectedFeatures'] ?? []),
      preferences: Map<String, List<String>>.from(json['preferences'] ?? {}),
    );
  }
}
