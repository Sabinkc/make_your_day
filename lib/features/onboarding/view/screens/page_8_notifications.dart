import 'package:flutter/material.dart';
import 'package:make_your_day/features/onboarding/model/onboarding_options.dart';
import 'package:make_your_day/features/onboarding/model/user_data_model.dart';

class NotificationsPage extends StatelessWidget {
  final UserData userData;
  final Function(UserData) onUpdate;
  final Function(BuildContext) onTimePicker;

  const NotificationsPage({
    Key? key,
    required this.userData,
    required this.onUpdate,
    required this.onTimePicker,
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
              Icon(Icons.notifications_active, size: 30, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                'Cheerful Notifications',
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
            'Choose how you want to be surprised throughout the day',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          SizedBox(height: 20),

          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(Icons.notifications_on, color: Colors.blue, size: 40),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enable Daily Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Get positive surprises throughout your day',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: userData.notificationsEnabled,
                  onChanged: (value) {
                    onUpdate(userData..notificationsEnabled = value);
                    if (value) onTimePicker(context);
                  },
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),

          if (userData.notificationsEnabled) ...[
            SizedBox(height: 25),

            GestureDetector(
              onTap: () => onTimePicker(context),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.blue),
                    SizedBox(width: 12),
                    Text('Preferred time: ', style: TextStyle(fontSize: 16)),
                    Text(
                      userData.notificationTime != null
                          ? '${userData.notificationTime!.format(context)}'
                          : '8:00 AM (default)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 25),

            Text(
              'What would you like to receive?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15),

            ...OnboardingOptions.notificationTypes.map((type) {
              final isSelected = userData.preferences['notifications']!
                  .contains(type['type']);
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.pink.shade50 : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.pink : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      type['icon'],
                      color: isSelected ? Colors.pink : Colors.grey,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type['type'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.pink.shade800
                                  : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            type['description'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '"${type['examples'][0]}"',
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: isSelected,
                      onChanged: (selected) {
                        final updated = List<String>.from(
                          userData.preferences['notifications']!,
                        );
                        if (selected!) {
                          updated.add(type['type']);
                        } else {
                          updated.remove(type['type']);
                        }
                        userData.preferences['notifications'] = updated;
                        onUpdate(userData);
                      },
                      activeColor: Colors.pink,
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
}
