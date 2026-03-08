import 'package:flutter/material.dart';
import 'package:make_your_day/features/onboarding/model/onboarding_options.dart';
import 'package:make_your_day/features/onboarding/model/user_data_model.dart';
import 'package:make_your_day/features/onboarding/view/widgets/info_container.dart';

class QuotesPage extends StatelessWidget {
  final UserData userData;
  final Function(UserData) onUpdate;

  const QuotesPage({Key? key, required this.userData, required this.onUpdate})
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
              Icon(Icons.format_quote, size: 30, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                'Quote of the Day',
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
            'Wisdom, inspiration, and perspective from great minds',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          SizedBox(height: 20),

          InfoContainer(
            title: '📚 Power of quotes:',
            icon: Icons.format_quote,
            color: Colors.teal,
            points: [
              'Gain new perspectives',
              'Learn from others\' experiences',
              'Find words for your feelings',
              'Daily dose of wisdom',
              'Share meaningful messages',
            ],
          ),

          SizedBox(height: 30),

          Text(
            'Quote categories you\'ll love:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15),

          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.5,
            children: OnboardingOptions.quoteCategories.map((category) {
              final isSelected = userData.preferences['quotes']!.contains(
                category['category'],
              );
              return GestureDetector(
                onTap: () {
                  final updated = List<String>.from(
                    userData.preferences['quotes']!,
                  );
                  if (isSelected) {
                    updated.remove(category['category']);
                  } else {
                    updated.add(category['category']);
                  }
                  userData.preferences['quotes'] = updated;
                  onUpdate(userData);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.teal.shade100
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.teal : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'],
                        color: isSelected
                            ? Colors.teal.shade700
                            : Colors.grey.shade700,
                      ),
                      SizedBox(height: 4),
                      Text(
                        category['category'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
