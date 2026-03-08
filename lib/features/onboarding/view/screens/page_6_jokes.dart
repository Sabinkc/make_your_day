import 'package:flutter/material.dart';
import 'package:make_your_day/features/onboarding/model/onboarding_options.dart';
import 'package:make_your_day/features/onboarding/model/user_data_model.dart';
import 'package:make_your_day/features/onboarding/view/widgets/info_container.dart';

class JokesPage extends StatelessWidget {
  final UserData userData;
  final Function(UserData) onUpdate;

  const JokesPage({Key? key, required this.userData, required this.onUpdate})
    : super(key: key);

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
              Icon(Icons.emoji_emotions, size: 30, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                'Jokes & Humor',
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
            'Laughter is the best medicine - enjoy clean, positive humor',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          SizedBox(height: 20),

          InfoContainer(
            title: '😊 Why laughter matters:',
            icon: Icons.emoji_emotions,
            color: Colors.amber,
            points: [
              'Reduces stress hormones',
              'Releases endorphins (feel-good chemicals)',
              'Boosts immune system',
              'Strengthens social connections',
              'Makes tough days easier',
            ],
          ),

          SizedBox(height: 30),

          Text(
            'What makes you laugh?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: OnboardingOptions.jokeCategories.map((category) {
              final isSelected = userData.preferences['jokes']!.contains(
                category['category'],
              );
              return ChoiceChip(
                label: Text(category['category']),
                selected: isSelected,
                onSelected: (selected) {
                  final updated = List<String>.from(
                    userData.preferences['jokes']!,
                  );
                  if (selected) {
                    updated.add(category['category']);
                  } else {
                    updated.remove(category['category']);
                  }
                  userData.preferences['jokes'] = updated;
                  onUpdate(userData);
                },
                avatar: Icon(category['icon'], size: 16, color: Colors.amber),
                selectedColor: Colors.amber.shade100,
              );
            }).toList(),
          ),

          SizedBox(height: 20),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '😂 Sample Joke:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Why don\'t eggs tell jokes?\nThey\'d crack each other up!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
