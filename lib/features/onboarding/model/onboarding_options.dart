import 'package:flutter/material.dart';

class OnboardingOptions {
  static const List<String> howKnowOptions = [
    'Google Search',
    'Social Media (Instagram, Facebook)',
    'Friend/Family Recommendation',
    'App Store',
    'Advertisement',
    'Article/Blog',
    'Other',
  ];

  static const List<String> genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
  ];

  static const List<String> employmentOptions = [
    'Student',
    'Employed Full-time',
    'Employed Part-time',
    'Self-employed',
    'Unemployed',
    'Retired',
    'Homemaker',
  ];

  static const List<String> religionOptions = [
    'Christianity',
    'Islam',
    'Hinduism',
    'Buddhism',
    'Judaism',
    'Sikhism',
    'Spiritual but not religious',
    'Agnostic',
    'Atheist',
    'Prefer not to say',
  ];

  static const List<String> frequencyOptions = [
    'Morning only (8:00 AM)',
    'Evening only (7:00 PM)',
    'Morning & Evening',
    'Throughout the day (3-4 times)',
    'Custom schedule',
    'Only when I open the app',
  ];

  static const List<Map<String, dynamic>> appFeatures = [
    {
      'name': 'Daily Affirmations',
      'icon': Icons.auto_awesome,
      'description': 'Positive statements to boost your confidence and mindset',
      'benefits': [
        'Builds self-esteem',
        'Reduces negative thoughts',
        'Improves focus',
      ],
      'examples': [
        '"I am capable of achieving great things"',
        '"Today, I choose to be confident"',
      ],
    },
    {
      'name': 'Motivational Content',
      'icon': Icons.trending_up,
      'description': 'Inspiring messages to keep you going',
      'benefits': [
        'Increases productivity',
        'Helps overcome challenges',
        'Builds momentum',
      ],
      'examples': [
        '"Your only limit is your mind"',
        '"Small progress is still progress"',
      ],
    },
    {
      'name': 'Daily Quotes',
      'icon': Icons.format_quote,
      'description': 'Wisdom from great minds to start your day',
      'benefits': ['Gain perspective', 'Learn from others', 'Find inspiration'],
      'examples': ['Quote of the day from philosophers, leaders, and thinkers'],
    },
    {
      'name': 'Light-Hearted Jokes',
      'icon': Icons.emoji_emotions,
      'description': 'Clean, positive humor to brighten your mood',
      'benefits': ['Reduces stress', 'Brings smiles', 'Share with friends'],
      'examples': [
        'Why don\'t scientists trust atoms? Because they make up everything!',
      ],
    },
    {
      'name': 'Funny Notifications',
      'icon': Icons.notifications_active,
      'description': 'Playful reminders that make you laugh',
      'benefits': [
        'Start with a smile',
        'Break negative thought patterns',
        'Lighten your day',
      ],
      'examples': [
        '"Time to shine! 🌟 (Your daily reminder that you\'re awesome)"',
      ],
    },
    {
      'name': 'Compliment Notifications',
      'icon': Icons.favorite,
      'description': 'Sweet, personalized compliments throughout your day',
      'benefits': [
        'Boosts self-worth',
        'Makes you feel valued',
        'Spreads positivity',
      ],
      'examples': ['"You have a beautiful way of seeing the world"'],
    },
  ];

  static const List<Map<String, dynamic>> affirmationCategories = [
    {
      'category': 'Self-Love & Confidence',
      'icon': Icons.favorite,
      'examples': [
        '"I am worthy of love and respect"',
        '"I believe in myself"',
      ],
    },
    {
      'category': 'Success & Career',
      'icon': Icons.work,
      'examples': [
        '"I attract success naturally"',
        '"I am capable and skilled"',
      ],
    },
    {
      'category': 'Health & Wellness',
      'icon': Icons.health_and_safety,
      'examples': [
        '"My body is healthy and strong"',
        '"I choose to be active"',
      ],
    },
    {
      'category': 'Peace & Calm',
      'icon': Icons.self_improvement,
      'examples': ['"I am at peace with myself"', '"I breathe in calm"'],
    },
    {
      'category': 'Gratitude',
      'icon': Icons.waving_hand,
      'examples': [
        '"I am grateful for today"',
        '"I appreciate the little things"',
      ],
    },
    {
      'category': 'Overcoming Anxiety',
      'icon': Icons.psychology,
      'examples': ['"I release my worries"', '"I am stronger than my anxiety"'],
    },
  ];

  static const List<Map<String, dynamic>> motivationCategories = [
    {
      'category': 'Morning Motivation',
      'icon': Icons.wb_sunny,
      'examples': ['Start your day with purpose and energy'],
    },
    {
      'category': 'Career & Goals',
      'icon': Icons.emoji_objects,
      'examples': ['Push through challenges and achieve your dreams'],
    },
    {
      'category': 'Overcoming Challenges',
      'icon': Icons.fitness_center,
      'examples': ['Strength to face difficult times'],
    },
    {
      'category': 'Study & Learning',
      'icon': Icons.school,
      'examples': ['Stay focused and motivated to learn'],
    },
    {
      'category': 'Fitness & Health',
      'icon': Icons.directions_run,
      'examples': ['Keep going on your fitness journey'],
    },
  ];

  static const List<Map<String, dynamic>> jokeCategories = [
    {
      'category': 'Clean Dad Jokes',
      'icon': Icons.person,
      'examples': ['Corny but cute - perfect for all ages'],
    },
    {
      'category': 'Puns & Wordplay',
      'icon': Icons.abc,
      'examples': ['Clever plays on words that make you smile'],
    },
    {
      'category': 'Work-Friendly Humor',
      'icon': Icons.business_center,
      'examples': ['Funny but professional - safe for office'],
    },
    {
      'category': 'Feel-Good Jokes',
      'icon': Icons.sentiment_satisfied,
      'examples': ['Wholesome humor that warms the heart'],
    },
    {
      'category': 'Short & Sweet',
      'icon': Icons.timer,
      'examples': ['Quick laughs for busy moments'],
    },
  ];

  static const List<Map<String, dynamic>> quoteCategories = [
    {
      'category': 'Inspirational',
      'icon': Icons.emoji_objects,
      'examples': ['Quotes to inspire greatness'],
    },
    {
      'category': 'Wisdom & Life Lessons',
      'icon': Icons.menu_book,
      'examples': ['Timeless wisdom from philosophers'],
    },
    {
      'category': 'Happiness & Joy',
      'icon': Icons.sentiment_very_satisfied,
      'examples': ['Quotes that bring a smile'],
    },
    {
      'category': 'Success & Achievement',
      'icon': Icons.star,
      'examples': ['Words from successful people'],
    },
    {
      'category': 'Love & Kindness',
      'icon': Icons.favorite,
      'examples': ['Heartwarming quotes about love'],
    },
  ];

  static const List<Map<String, dynamic>> notificationTypes = [
    {
      'type': 'Funny Notifications',
      'icon': Icons.sentiment_very_satisfied,
      'description': 'Playful reminders to make you chuckle',
      'examples': ['"Psst... you\'re doing great! (No pressure, just facts)"'],
    },
    {
      'type': 'Compliment Notifications',
      'icon': Icons.emoji_emotions,
      'description': 'Sweet compliments delivered throughout the day',
      'examples': ['"Your smile is contagious 😊"'],
    },
    {
      'type': 'Quote of the Day',
      'icon': Icons.format_quote,
      'description': 'Daily wisdom delivered right to your lock screen',
      'examples': [
        '"The only way to do great work is to love what you do" - Steve Jobs',
      ],
    },
    {
      'type': 'Motivation Pings',
      'icon': Icons.bolt,
      'description': 'Quick motivation when you need it most',
      'examples': ['"You\'ve got this! 💪"'],
    },
    {
      'type': 'Affirmation Reminders',
      'icon': Icons.auto_awesome,
      'description': 'Gentle reminders of your daily affirmations',
      'examples': ['"Remember: You are enough"'],
    },
  ];
}
