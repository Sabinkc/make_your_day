import 'package:flutter/material.dart';
import 'package:make_your_day/features/onboarding/model/onboarding_options.dart';
import 'package:make_your_day/features/onboarding/model/user_data_model.dart';
import 'package:make_your_day/features/onboarding/view/widgets/info_container.dart';

class MotivationPage extends StatelessWidget {
  final UserData userData;
  final Function(UserData) onUpdate;

  const MotivationPage({
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
          Row(
            children: [
              Icon(Icons.trending_up, size: 30, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                'Motivation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Fuel for your goals - stay driven and inspired',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          SizedBox(height: 20),

          InfoContainer(
            title: '🔥 How motivation helps:',
            icon: Icons.trending_up,
            color: Colors.orange,
            points: [
              'Push through challenges and obstacles',
              'Stay focused on your goals',
              'Build momentum and consistency',
              'Overcome procrastination',
              'Celebrate small wins',
            ],
          ),

          SizedBox(height: 30),

          Text(
            'What motivates you?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15),

          ...OnboardingOptions.motivationCategories.map((category) {
            final isSelected = userData.preferences['motivations']!.contains(
              category['category'],
            );
            return CheckboxListTile(
              title: Text(category['category']),
              subtitle: Text(category['examples'][0]),
              value: isSelected,
              onChanged: (selected) {
                final updated = List<String>.from(
                  userData.preferences['motivations']!,
                );
                if (selected!) {
                  updated.add(category['category']);
                } else {
                  updated.remove(category['category']);
                }
                userData.preferences['motivations'] = updated;
                onUpdate(userData);
              },
              activeColor: Colors.orange,
              secondary: Icon(category['icon'], color: Colors.orange),
            );
          }).toList(),
        ],
      ),
    );
  }
}
