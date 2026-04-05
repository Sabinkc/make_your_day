import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:make_your_day/features/jokes/view/screens/category_jokes_screen.dart';

class JokesScreen extends StatefulWidget {
  @override
  _JokesScreenState createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  String _jokeOfTheDay =
      "Why don't scientists trust atoms? Because they make up everything!";

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'All',
      'icon': Icons.apps,
      'color': Colors.amber,
      'description': 'All jokes combined',
      'jokes': [
        {
          'setup': "Why don't scientists trust atoms?",
          'punchline': "Because they make up everything!",
        },
        {
          'setup': "What do you call a fake noodle?",
          'punchline': "An impasta!",
        },
        {
          'setup': "Why did the scarecrow win an award?",
          'punchline': "Because he was outstanding in his field!",
        },
        {
          'setup': "What do you call a bear with no teeth?",
          'punchline': "A gummy bear!",
        },
        {
          'setup': "Why don't eggs tell jokes?",
          'punchline': "They'd crack each other up!",
        },
        {
          'setup': "What's the best thing about Switzerland?",
          'punchline': "I don't know, but the flag is a big plus!",
        },
        {
          'setup': "Why did the math book look so sad?",
          'punchline': "Because it had too many problems!",
        },
        {
          'setup': "What do you call a fish wearing a bowtie?",
          'punchline': "So-fish-ticated!",
        },
        {
          'setup': "Why did the bicycle fall over?",
          'punchline': "Because it was two-tired!",
        },
        {
          'setup': "What do you call a sleeping bull?",
          'punchline': "A bulldozer!",
        },
      ],
    },
    {
      'name': 'Dad Jokes',
      'icon': Icons.person,
      'color': Colors.blue,
      'description': 'Classic, corny dad humor',
      'jokes': [
        {
          'setup': "Why don't eggs tell jokes?",
          'punchline': "They'd crack each other up!",
        },
        {
          'setup': "What do you call a fake noodle?",
          'punchline': "An impasta!",
        },
        {
          'setup': "Why did the bicycle fall over?",
          'punchline': "Because it was two-tired!",
        },
        {
          'setup': "What do you call a sleeping bull?",
          'punchline': "A bulldozer!",
        },
        {
          'setup': "I'm reading a book about anti-gravity.",
          'punchline': "It's impossible to put down!",
        },
        {
          'setup': "What do you call a can opener that doesn't work?",
          'punchline': "A can't opener!",
        },
      ],
    },
    {
      'name': 'Puns & Wordplay',
      'icon': Icons.abc,
      'color': Colors.green,
      'description': 'Clever plays on words',
      'jokes': [
        {
          'setup': "What do you call a fish wearing a bowtie?",
          'punchline': "So-fish-ticated!",
        },
        {
          'setup': "I used to be a baker.",
          'punchline': "But I couldn't make enough dough!",
        },
        {
          'setup': "What do you call a bear with no teeth?",
          'punchline': "A gummy bear!",
        },
        {
          'setup': "I'm friends with all the letters.",
          'punchline': "But I don't know Y!",
        },
        {
          'setup': "What do you call a pig that does karate?",
          'punchline': "A pork chop!",
        },
        {
          'setup': "I stayed up all night wondering where the sun went.",
          'punchline': "Then it dawned on me!",
        },
      ],
    },
    {
      'name': 'Work Friendly',
      'icon': Icons.business_center,
      'color': Colors.purple,
      'description': 'Office-appropriate humor',
      'jokes': [
        {
          'setup': "Why did the scarecrow win an award?",
          'punchline': "Because he was outstanding in his field!",
        },
        {
          'setup': "Why don't scientists trust atoms?",
          'punchline': "Because they make up everything!",
        },
        {
          'setup': "What's the best thing about Switzerland?",
          'punchline': "I don't know, but the flag is a big plus!",
        },
        {
          'setup': "Why did the math book look so sad?",
          'punchline': "Because it had too many problems!",
        },
        {
          'setup': "What do you call a computer that sings?",
          'punchline': "A Dell!",
        },
        {
          'setup': "Why do programmers prefer dark mode?",
          'punchline': "Because light attracts bugs!",
        },
      ],
    },
    {
      'name': 'Short & Sweet',
      'icon': Icons.timer,
      'color': Colors.orange,
      'description': 'Quick laughs for busy moments',
      'jokes': [
        {
          'setup': "What do you call a fake noodle?",
          'punchline': "An impasta!",
        },
        {
          'setup': "Why don't scientists trust atoms?",
          'punchline': "Because they make up everything!",
        },
        {
          'setup': "What do you call a bear with no teeth?",
          'punchline': "A gummy bear!",
        },
        {
          'setup': "Why did the bicycle fall over?",
          'punchline': "Because it was two-tired!",
        },
        {
          'setup': "What do you call a sleeping bull?",
          'punchline': "A bulldozer!",
        },
        {
          'setup': "I'm reading a book about anti-gravity.",
          'punchline': "It's impossible to put down!",
        },
      ],
    },
    {
      'name': 'Feel Good',
      'icon': Icons.sentiment_satisfied,
      'color': Colors.pink,
      'description': 'Wholesome heartwarming humor',
      'jokes': [
        {
          'setup': "Why did the cookie go to the doctor?",
          'punchline': "Because it felt crumbly!",
        },
        {
          'setup': "What do you call a happy cowboy?",
          'punchline': "A jolly rancher!",
        },
        {
          'setup': "Why are elephants so wrinkled?",
          'punchline': "Because they take too long to iron!",
        },
        {
          'setup': "What did the baby corn say to the mama corn?",
          'punchline': "Where's popcorn?",
        },
        {
          'setup': "What do you call a bear that's caught in the rain?",
          'punchline': "A drizzly bear!",
        },
        {
          'setup': "Why did the golfer bring two pairs of pants?",
          'punchline': "In case he got a hole in one!",
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshJokeOfTheDay();
  }

  void _refreshJokeOfTheDay() {
    List<Map<String, String>> allJokes = [];
    for (var category in _categories) {
      allJokes.addAll(List<Map<String, String>>.from(category['jokes']));
    }
    final randomIndex = DateTime.now().millisecondsSinceEpoch % allJokes.length;
    final randomJoke = allJokes[randomIndex];
    setState(() {
      _jokeOfTheDay = "${randomJoke['setup']} ${randomJoke['punchline']}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Daily Jokes',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amber.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Joke of the Day Card
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade600, Colors.orange.shade400],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
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
                      Icon(Icons.emoji_emotions, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Joke of the Day',
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
                    _jokeOfTheDay,
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
                        onPressed: _refreshJokeOfTheDay,
                        icon: Icon(
                          Icons.refresh,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          'New Joke',
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
                      color: Colors.amber.shade800,
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
            builder: (context) => CategoryJokesScreen(
              categoryName: category['name'],
              categoryIcon: category['icon'],
              categoryColor: category['color'],
              categoryDescription: category['description'],
              jokes: category['jokes'],
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
                '${category['jokes'].length} jokes',
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
