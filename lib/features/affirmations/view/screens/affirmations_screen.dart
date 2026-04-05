import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:make_your_day/features/affirmations/view/screens/category_affirmations_screen.dart';

class AffirmationsScreen extends StatefulWidget {
  @override
  _AffirmationsScreenState createState() => _AffirmationsScreenState();
}

class _AffirmationsScreenState extends State<AffirmationsScreen> {
  String _affirmationOfTheDay =
      "I am capable of achieving amazing things today";

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'All',
      'icon': Icons.apps,
      'color': Colors.purple,
      'description': 'All affirmations combined',
      'affirmations': [
        "I am worthy of love and respect",
        "I believe in myself and my abilities",
        "I am capable of achieving great things",
        "I attract positivity into my life",
        "I am grateful for everything I have",
        "I am strong, resilient, and brave",
        "I deserve happiness and success",
        "I am enough, just as I am",
        "I choose to be confident and fearless",
        "Today, I will embrace new opportunities",
      ],
    },
    {
      'name': 'Self-Love',
      'icon': Icons.favorite,
      'color': Colors.pink,
      'description': 'Boost your self-worth and confidence',
      'affirmations': [
        "I am worthy of love and respect",
        "I love and accept myself completely",
        "I am enough, just as I am",
        "I deserve happiness and success",
        "I am proud of who I'm becoming",
        "I radiate confidence and self-assurance",
        "I am beautiful inside and out",
        "I honor the person I am becoming",
      ],
    },
    {
      'name': 'Success',
      'icon': Icons.emoji_events,
      'color': Colors.orange,
      'description': 'Achieve your goals and dreams',
      'affirmations': [
        "I attract success naturally",
        "I am capable of achieving great things",
        "Opportunities come to me easily",
        "I am focused, productive, and successful",
        "My work makes a positive impact",
        "I am worthy of career advancement",
        "Money flows to me abundantly",
        "I turn obstacles into opportunities",
      ],
    },
    {
      'name': 'Peace',
      'icon': Icons.self_improvement,
      'color': Colors.teal,
      'description': 'Find inner calm and tranquility',
      'affirmations': [
        "I am at peace with myself",
        "I breathe in calm and exhale stress",
        "I release all worries and anxiety",
        "Peace surrounds me at all times",
        "I am centered and grounded",
        "I choose peace over worry",
        "Everything is working out for me",
        "I trust the journey of life",
      ],
    },
    {
      'name': 'Gratitude',
      'icon': Icons.waving_hand,
      'color': Colors.green,
      'description': 'Appreciate life\'s blessings',
      'affirmations': [
        "I am grateful for everything I have",
        "Abundance flows freely in my life",
        "I appreciate the little things",
        "Life gives me everything I need",
        "I attract positive experiences",
        "I am thankful for this moment",
        "More good things are coming my way",
        "I celebrate my blessings daily",
      ],
    },
    {
      'name': 'Health',
      'icon': Icons.fitness_center,
      'color': Colors.blue,
      'description': 'Wellness for mind and body',
      'affirmations': [
        "My body is healthy and strong",
        "I choose to be active and energetic",
        "Every day I feel better and better",
        "I nourish my body with healthy choices",
        "My mind and body are in perfect harmony",
        "I am grateful for my health",
        "I sleep deeply and wake up refreshed",
        "Healing energy flows through me",
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Daily Affirmations',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Affirmation of the Day Card
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade600, Colors.pink.shade600],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Affirmation of the Day',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    _affirmationOfTheDay,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _refreshAffirmationOfTheDay();
                          });
                        },
                        icon: Icon(
                          Icons.refresh,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          'New Affirmation',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Categories Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Choose Category',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${_categories.length} categories',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),

            // Categories Grid
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return _buildCategoryCard(category);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryAffirmationsScreen(
              categoryName: category['name'],
              categoryIcon: category['icon'],
              categoryColor: category['color'],
              categoryDescription: category['description'],
              affirmations: category['affirmations'],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: category['color'].withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: category['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(category['icon'], size: 40, color: category['color']),
            ),
            SizedBox(height: 15),
            Text(
              category['name'],
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: category['color'],
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                category['description'],
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: category['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '${category['affirmations'].length} affirmations',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: category['color'],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _refreshAffirmationOfTheDay() {
    // Random affirmation from all categories combined
    List<String> allAffirmations = [];
    for (var category in _categories) {
      allAffirmations.addAll(category['affirmations']);
    }
    final randomIndex =
        DateTime.now().millisecondsSinceEpoch % allAffirmations.length;
    setState(() {
      _affirmationOfTheDay = allAffirmations[randomIndex];
    });
  }
}
