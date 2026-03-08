import 'package:flutter/material.dart';
import 'package:make_your_day/features/onboarding/model/onboarding_options.dart';
import 'package:make_your_day/features/onboarding/model/user_data_model.dart';

class FinalPreferencesPage extends StatelessWidget {
  final UserData userData;
  final Function(UserData) onUpdate;

  const FinalPreferencesPage({
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
            'Almost done!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Final details to personalize your experience',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          SizedBox(height: 30),

          Text(
            'How often should we brighten your day?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          ...OnboardingOptions.frequencyOptions.map(
            (option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: userData.frequency,
              onChanged: (value) => onUpdate(userData..frequency = value),
              activeColor: Colors.blue,
              dense: true,
            ),
          ),
          SizedBox(height: 20),

          Text(
            'Employment Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          ...OnboardingOptions.employmentOptions.map(
            (option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: userData.employment,
              onChanged: (value) => onUpdate(userData..employment = value),
              activeColor: Colors.blue,
              dense: true,
            ),
          ),
          SizedBox(height: 20),

          Text(
            'Religion / Beliefs (Optional)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Text(
            'This helps us respect your beliefs in our content',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          SizedBox(height: 10),
          ...OnboardingOptions.religionOptions.map(
            (option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: userData.religion,
              onChanged: (value) => onUpdate(userData..religion = value),
              activeColor: Colors.blue,
              dense: true,
            ),
          ),

          SizedBox(height: 30),

          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.purple.shade50],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  '✨ You\'re all set!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'We\'ll send you daily ${userData.selectedFeatures.length} types of positive content tailored just for you.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
