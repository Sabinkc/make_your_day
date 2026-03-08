import 'package:flutter/material.dart';
import 'package:make_your_day/features/onboarding/model/onboarding_options.dart';
import 'package:make_your_day/features/onboarding/model/user_data_model.dart';

class BasicInfoPage extends StatelessWidget {
  final UserData userData;
  final Function(UserData) onUpdate;

  const BasicInfoPage({
    Key? key,
    required this.userData,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Tell us about yourself',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'This helps us personalize your experience',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          SizedBox(height: 30),

          TextField(
            onChanged: (value) => onUpdate(userData..name = value),
            decoration: InputDecoration(
              labelText: 'Your Name',
              hintText: 'Enter your name',
              prefixIcon: Icon(Icons.person_outline, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
          SizedBox(height: 20),

          TextField(
            onChanged: (value) => onUpdate(userData..age = value),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Your Age',
              hintText: 'Enter your age',
              prefixIcon: Icon(Icons.cake_outlined, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
          SizedBox(height: 25),

          Text(
            'Gender',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          ...OnboardingOptions.genderOptions.map(
            (option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: userData.gender,
              onChanged: (value) => onUpdate(userData..gender = value),
              activeColor: Colors.blue,
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          SizedBox(height: 15),

          Text(
            'How did you find us?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          ...OnboardingOptions.howKnowOptions.map(
            (option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: userData.howKnow,
              onChanged: (value) => onUpdate(userData..howKnow = value),
              activeColor: Colors.blue,
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
