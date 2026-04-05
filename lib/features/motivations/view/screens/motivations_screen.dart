import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:make_your_day/features/motivations/view/screens/category_motivations_screen.dart';

class MotivationsScreen extends StatefulWidget {
  @override
  _MotivationsScreenState createState() => _MotivationsScreenState();
}

class _MotivationsScreenState extends State<MotivationsScreen> {
  String _motivationOfTheDay =
      "The only way to do great work is to love what you do. - Steve Jobs";

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'All',
      'icon': Icons.apps,
      'color': Colors.orange,
      'description': 'All motivations combined',
      'motivations': [
        {
          'quote': "The only way to do great work is to love what you do.",
          'author': "Steve Jobs",
        },
        {
          'quote':
              "Success is not final, failure is not fatal: it is the courage to continue that counts.",
          'author': "Winston Churchill",
        },
        {
          'quote': "Believe you can and you're halfway there.",
          'author': "Theodore Roosevelt",
        },
        {'quote': "Your only limit is your mind.", 'author': "Unknown"},
        {'quote': "Small progress is still progress.", 'author': "Unknown"},
        {
          'quote': "Don't watch the clock; do what it does. Keep going.",
          'author': "Sam Levenson",
        },
        {
          'quote':
              "Everything you've ever wanted is on the other side of fear.",
          'author': "George Addair",
        },
        {
          'quote':
              "The future belongs to those who believe in the beauty of their dreams.",
          'author': "Eleanor Roosevelt",
        },
        {
          'quote':
              "It does not matter how slowly you go as long as you do not stop.",
          'author': "Confucius",
        },
        {
          'quote':
              "The only limit to our realization of tomorrow is our doubts of today.",
          'author': "Franklin D. Roosevelt",
        },
      ],
    },
    {
      'name': 'Career',
      'icon': Icons.work,
      'color': Colors.blue,
      'description': 'Professional growth and success',
      'motivations': [
        {
          'quote':
              "Choose a job you love, and you will never have to work a day in your life.",
          'author': "Confucius",
        },
        {
          'quote':
              "Success usually comes to those who are too busy to be looking for it.",
          'author': "Henry David Thoreau",
        },
        {
          'quote': "Don't be afraid to give up the good to go for the great.",
          'author': "John D. Rockefeller",
        },
        {
          'quote':
              "The only way to achieve the impossible is to believe it is possible.",
          'author': "Charles Kingsleigh",
        },
        {
          'quote':
              "Your work is to discover your work and then with all your heart to give yourself to it.",
          'author': "Buddha",
        },
        {
          'quote': "The future depends on what you do today.",
          'author': "Mahatma Gandhi",
        },
      ],
    },
    {
      'name': 'Personal Growth',
      'icon': Icons.trending_up,
      'color': Colors.green,
      'description': 'Self-improvement and development',
      'motivations': [
        {
          'quote': "Be the change that you wish to see in the world.",
          'author': "Mahatma Gandhi",
        },
        {
          'quote':
              "The only person you are destined to become is the person you decide to be.",
          'author': "Ralph Waldo Emerson",
        },
        {
          'quote':
              "What lies behind us and what lies before us are tiny matters compared to what lies within us.",
          'author': "Ralph Waldo Emerson",
        },
        {
          'quote': "The secret of getting ahead is getting started.",
          'author': "Mark Twain",
        },
        {
          'quote':
              "You learn more from failure than from success. Don't let it stop you. Failure builds character.",
          'author': "Unknown",
        },
        {
          'quote':
              "The only limit to our realization of tomorrow is our doubts of today.",
          'author': "Franklin D. Roosevelt",
        },
      ],
    },
    {
      'name': 'Overcoming Fear',
      'icon': Icons.psychology,
      'color': Colors.purple,
      'description': 'Courage and facing challenges',
      'motivations': [
        {
          'quote':
              "Everything you've ever wanted is on the other side of fear.",
          'author': "George Addair",
        },
        {
          'quote': "Fear is only as deep as the mind allows.",
          'author': "Japanese Proverb",
        },
        {
          'quote': "Do one thing every day that scares you.",
          'author': "Eleanor Roosevelt",
        },
        {
          'quote':
              "Courage is resistance to fear, mastery of fear, not absence of fear.",
          'author': "Mark Twain",
        },
        {
          'quote':
              "You gain strength, courage, and confidence by every experience in which you really stop to look fear in the face.",
          'author': "Eleanor Roosevelt",
        },
        {
          'quote': "Fear doesn't shut you down; it wakes you up.",
          'author': "Veronica Roth",
        },
      ],
    },
    {
      'name': 'Perseverance',
      'icon': Icons.fitness_center,
      'color': Colors.red,
      'description': 'Keep going despite obstacles',
      'motivations': [
        {
          'quote':
              "It does not matter how slowly you go as long as you do not stop.",
          'author': "Confucius",
        },
        {
          'quote':
              "Our greatest glory is not in never falling, but in rising every time we fall.",
          'author': "Confucius",
        },
        {
          'quote': "Fall seven times, stand up eight.",
          'author': "Japanese Proverb",
        },
        {
          'quote':
              "Perseverance is not a long race; it is many short races one after the other.",
          'author': "Walter Elliot",
        },
        {
          'quote':
              "The difference between a successful person and others is not a lack of strength, not a lack of knowledge, but rather a lack of will.",
          'author': "Vince Lombardi",
        },
        {
          'quote':
              "It's not that I'm so smart, it's just that I stay with problems longer.",
          'author': "Albert Einstein",
        },
      ],
    },
    {
      'name': 'Positive Mindset',
      'icon': Icons.wb_sunny,
      'color': Colors.amber,
      'description': 'Optimism and positive thinking',
      'motivations': [
        {
          'quote': "Believe you can and you're halfway there.",
          'author': "Theodore Roosevelt",
        },
        {
          'quote':
              "Keep your face always toward the sunshine—and shadows will fall behind you.",
          'author': "Walt Whitman",
        },
        {
          'quote': "Positive anything is better than negative nothing.",
          'author': "Elbert Hubbard",
        },
        {
          'quote':
              "The only limit to our realization of tomorrow is our doubts of today.",
          'author': "Franklin D. Roosevelt",
        },
        {
          'quote':
              "Optimism is the faith that leads to achievement. Nothing can be done without hope and confidence.",
          'author': "Helen Keller",
        },
        {
          'quote':
              "A positive attitude causes a chain reaction of positive thoughts, events, and outcomes.",
          'author': "Wade Boggs",
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshMotivationOfTheDay();
  }

  void _refreshMotivationOfTheDay() {
    List<Map<String, String>> allMotivations = [];
    for (var category in _categories) {
      allMotivations.addAll(
        List<Map<String, String>>.from(category['motivations']),
      );
    }
    final randomIndex =
        DateTime.now().millisecondsSinceEpoch % allMotivations.length;
    final randomMotivation = allMotivations[randomIndex];
    setState(() {
      _motivationOfTheDay =
          "${randomMotivation['quote']} - ${randomMotivation['author']}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Motivations',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Motivation of the Day Card
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade600, Colors.deepOrange.shade400],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
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
                        'Motivation of the Day',
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
                    _motivationOfTheDay,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
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
                        onPressed: _refreshMotivationOfTheDay,
                        icon: Icon(
                          Icons.refresh,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          'New Motivation',
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

            // Categories Section Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Choose Category',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
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
            builder: (context) => CategoryMotivationsScreen(
              categoryName: category['name'],
              categoryIcon: category['icon'],
              categoryColor: category['color'],
              categoryDescription: category['description'],
              motivations: category['motivations'],
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
                '${category['motivations'].length} motivations',
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
}
