import 'package:flutter/material.dart';
import 'package:make_your_day/features/onboarding/model/onboarding_options.dart';
import 'package:make_your_day/features/onboarding/model/user_data_model.dart';
import 'package:make_your_day/features/onboarding/view/widgets/category_chip.dart';
import 'package:make_your_day/features/onboarding/view/widgets/info_container.dart';

class AffirmationsPage extends StatelessWidget {
  final UserData userData;
  final Function(UserData) onUpdate;

  const AffirmationsPage({
    Key? key,
    required this.userData,
    required this.onUpdate,
  }) : super(key: key);

  void _toggleAffirmation(String category) {
    final updated = List<String>.from(userData.preferences['affirmations']!);
    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }
    userData.preferences['affirmations'] = updated;
    onUpdate(userData);
  }

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
              Icon(Icons.auto_awesome, size: 30, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                'Daily Affirmations',
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
            'Positive statements to reprogram your mind for success and happiness',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          SizedBox(height: 20),

          InfoContainer(
            title: '✨ How affirmations help:',
            icon: Icons.auto_awesome,
            color: Colors.purple,
            points: [
              'Rewire negative thought patterns',
              'Boost self-confidence and self-worth',
              'Reduce stress and anxiety',
              'Improve focus and manifestation',
              'Start your day with positive mindset',
            ],
          ),

          SizedBox(height: 30),

          Text(
            'Choose affirmation categories:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: OnboardingOptions.affirmationCategories.map((category) {
              return CategoryChip(
                category: category,
                isSelected: userData.preferences['affirmations']!.contains(
                  category['category'],
                ),
                onSelected: (_) => _toggleAffirmation(category['category']),
                selectedColor: Colors.purple,
              );
            }).toList(),
          ),

          SizedBox(height: 20),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Preview:', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 10),
                Text(
                  '"I am worthy of all the good things life has to offer"',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.purple.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
