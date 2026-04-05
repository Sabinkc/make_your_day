import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:make_your_day/features/compliments/view/screens/category_compliments_screen.dart';

class ComplimentsScreen extends StatefulWidget {
  @override
  _ComplimentsScreenState createState() => _ComplimentsScreenState();
}

class _ComplimentsScreenState extends State<ComplimentsScreen> {
  String _complimentOfTheDay = "You have a beautiful smile! 😊";

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'All',
      'icon': Icons.apps,
      'color': Colors.pink,
      'description': 'All compliments combined',
      'compliments': [
        "You have a beautiful smile! 😊",
        "Your kindness inspires others! ✨",
        "You're incredibly talented! 🌟",
        "Your positive energy is contagious! 💫",
        "You make the world a better place! 🌍",
        "Your creativity knows no bounds! 🎨",
        "You're a great listener! 👂",
        "Your strength is admirable! 💪",
        "You have a heart of gold! 💛",
        "You're doing amazing things! 🚀",
        "Your presence lights up any room! 💡",
        "You have a beautiful soul! 🌸",
      ],
    },
    {
      'name': 'Personality',
      'icon': Icons.person,
      'color': Colors.purple,
      'description': 'Compliments about who you are',
      'compliments': [
        "You have a beautiful soul! 🌸",
        "Your kindness inspires others! ✨",
        "You're incredibly genuine and authentic! 💯",
        "Your positive energy is contagious! 💫",
        "You have a heart of gold! 💛",
        "You're a great listener! 👂",
        "Your honesty is refreshing! 🌟",
        "You have such a warm personality! 🔥",
      ],
    },
    {
      'name': 'Appearance',
      'icon': Icons.face,
      'color': Colors.orange,
      'description': 'Compliments about looks',
      'compliments': [
        "You have a beautiful smile! 😊",
        "Your eyes sparkle with joy! ✨",
        "You have a radiant glow today! 💫",
        "You look absolutely wonderful! 🌟",
        "Your style is so unique and cool! 👗",
        "You have a lovely presence! 💝",
        "Your smile lights up the room! 😄",
        "You look great today! 👍",
      ],
    },
    {
      'name': 'Talents',
      'icon': Icons.star,
      'color': Colors.blue,
      'description': 'Compliments about abilities',
      'compliments': [
        "You're incredibly talented! 🌟",
        "Your creativity knows no bounds! 🎨",
        "You're so good at what you do! 💪",
        "Your skills are impressive! 🎯",
        "You have a natural gift! 🌈",
        "You make everything look easy! ✨",
        "Your talent is inspiring! 💫",
        "You're a true artist! 🎭",
      ],
    },
    {
      'name': 'Strength',
      'icon': Icons.fitness_center,
      'color': Colors.green,
      'description': 'Compliments about inner strength',
      'compliments': [
        "Your strength is admirable! 💪",
        "You're so resilient and strong! 🦁",
        "You handle challenges with grace! 🌟",
        "Your courage inspires me! 🦸‍♀️",
        "You never give up! 🎯",
        "You're a warrior! ⚔️",
        "Your determination is inspiring! 🔥",
        "You're stronger than you know! 💫",
      ],
    },
    {
      'name': 'Impact',
      'icon': Icons.people,
      'color': Colors.teal,
      'description': 'Compliments about your effect on others',
      'compliments': [
        "You make the world a better place! 🌍",
        "You're doing amazing things! 🚀",
        "You make everyone around you better! ✨",
        "Your presence is a gift! 🎁",
        "You've changed lives for the better! 💫",
        "You're a blessing to those who know you! 🌸",
        "Your impact is immeasurable! 🌟",
        "You bring joy wherever you go! 😊",
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshComplimentOfTheDay();
  }

  void _refreshComplimentOfTheDay() {
    List<String> allCompliments = [];
    for (var category in _categories) {
      allCompliments.addAll(List<String>.from(category['compliments']));
    }
    final randomIndex =
        DateTime.now().millisecondsSinceEpoch % allCompliments.length;
    setState(() {
      _complimentOfTheDay = allCompliments[randomIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Sweet Compliments',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Compliment of the Day Card
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade600, Colors.purple.shade400],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.3),
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
                      Icon(Icons.favorite, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Compliment of the Day',
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
                    _complimentOfTheDay,
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
                        onPressed: _refreshComplimentOfTheDay,
                        icon: Icon(
                          Icons.refresh,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          'New Compliment',
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
                      color: Colors.pink.shade800,
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
            builder: (context) => CategoryComplimentsScreen(
              categoryName: category['name'],
              categoryIcon: category['icon'],
              categoryColor: category['color'],
              categoryDescription: category['description'],
              compliments: category['compliments'],
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
                '${category['compliments'].length} compliments',
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
