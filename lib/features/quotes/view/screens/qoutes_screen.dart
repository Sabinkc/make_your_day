import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:make_your_day/features/quotes/view/screens/category_quotes_screen.dart';

class QuotesScreen extends StatefulWidget {
  @override
  _QuotesScreenState createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  String _quoteOfTheDay =
      "The purpose of our lives is to be happy. - Dalai Lama";

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'All',
      'icon': Icons.apps,
      'color': Colors.teal,
      'description': 'All quotes combined',
      'quotes': [
        {
          'quote': "The purpose of our lives is to be happy.",
          'author': "Dalai Lama",
        },
        {
          'quote': "Life is what happens when you're busy making other plans.",
          'author': "John Lennon",
        },
        {
          'quote': "Get busy living or get busy dying.",
          'author': "Stephen King",
        },
        {
          'quote':
              "You only live once, but if you do it right, once is enough.",
          'author': "Mae West",
        },
        {
          'quote':
              "In the end, it's not the years in your life that count. It's the life in your years.",
          'author': "Abraham Lincoln",
        },
        {
          'quote': "The way to get started is to quit talking and begin doing.",
          'author': "Walt Disney",
        },
        {
          'quote': "Life is either a daring adventure or nothing at all.",
          'author': "Helen Keller",
        },
        {
          'quote': "The only impossible journey is the one you never begin.",
          'author': "Tony Robbins",
        },
        {
          'quote':
              "Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment.",
          'author': "Buddha",
        },
        {
          'quote':
              "Happiness is not something ready made. It comes from your own actions.",
          'author': "Dalai Lama",
        },
      ],
    },
    {
      'name': 'Inspirational',
      'icon': Icons.emoji_objects,
      'color': Colors.blue,
      'description': 'Quotes to inspire greatness',
      'quotes': [
        {
          'quote': "The only way to do great work is to love what you do.",
          'author': "Steve Jobs",
        },
        {
          'quote': "Believe you can and you're halfway there.",
          'author': "Theodore Roosevelt",
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
              "Success is not final, failure is not fatal: it is the courage to continue that counts.",
          'author': "Winston Churchill",
        },
        {
          'quote':
              "The only limit to our realization of tomorrow is our doubts of today.",
          'author': "Franklin D. Roosevelt",
        },
      ],
    },
    {
      'name': 'Life Lessons',
      'icon': Icons.menu_book,
      'color': Colors.green,
      'description': 'Wisdom for everyday living',
      'quotes': [
        {
          'quote': "Life is what happens when you're busy making other plans.",
          'author': "John Lennon",
        },
        {
          'quote':
              "In the end, it's not the years in your life that count. It's the life in your years.",
          'author': "Abraham Lincoln",
        },
        {
          'quote': "Life is either a daring adventure or nothing at all.",
          'author': "Helen Keller",
        },
        {
          'quote': "The purpose of our lives is to be happy.",
          'author': "Dalai Lama",
        },
        {
          'quote': "Get busy living or get busy dying.",
          'author': "Stephen King",
        },
        {
          'quote':
              "Life is really simple, but we insist on making it complicated.",
          'author': "Confucius",
        },
      ],
    },
    {
      'name': 'Happiness',
      'icon': Icons.sentiment_very_satisfied,
      'color': Colors.amber,
      'description': 'Quotes about joy and happiness',
      'quotes': [
        {
          'quote':
              "Happiness is not something ready made. It comes from your own actions.",
          'author': "Dalai Lama",
        },
        {
          'quote':
              "For every minute you are angry you lose sixty seconds of happiness.",
          'author': "Ralph Waldo Emerson",
        },
        {
          'quote':
              "Happiness is when what you think, what you say, and what you do are in harmony.",
          'author': "Mahatma Gandhi",
        },
        {
          'quote':
              "The happiness of your life depends upon the quality of your thoughts.",
          'author': "Marcus Aurelius",
        },
        {
          'quote': "Happiness is a journey, not a destination.",
          'author': "Buddha",
        },
        {
          'quote':
              "The secret of happiness is freedom, the secret of freedom is courage.",
          'author': "Thucydides",
        },
      ],
    },
    {
      'name': 'Success',
      'icon': Icons.emoji_events,
      'color': Colors.orange,
      'description': 'Quotes for achieving greatness',
      'quotes': [
        {
          'quote':
              "Success is not the key to happiness. Happiness is the key to success.",
          'author': "Albert Schweitzer",
        },
        {
          'quote':
              "The road to success and the road to failure are almost exactly the same.",
          'author': "Colin R. Davis",
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
          'quote': "The way to get started is to quit talking and begin doing.",
          'author': "Walt Disney",
        },
        {
          'quote':
              "Success is walking from failure to failure with no loss of enthusiasm.",
          'author': "Winston Churchill",
        },
      ],
    },
    {
      'name': 'Wisdom',
      'icon': Icons.psychology,
      'color': Colors.purple,
      'description': 'Timeless wisdom from great minds',
      'quotes': [
        {
          'quote': "The only true wisdom is in knowing you know nothing.",
          'author': "Socrates",
        },
        {'quote': "Wisdom begins in wonder.", 'author': "Socrates"},
        {
          'quote': "Knowing yourself is the beginning of all wisdom.",
          'author': "Aristotle",
        },
        {
          'quote':
              "The fool doth think he is wise, but the wise man knows himself to be a fool.",
          'author': "William Shakespeare",
        },
        {'quote': "Turn your wounds into wisdom.", 'author': "Oprah Winfrey"},
        {
          'quote':
              "The art of being wise is the art of knowing what to overlook.",
          'author': "William James",
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshQuoteOfTheDay();
  }

  void _refreshQuoteOfTheDay() {
    List<Map<String, String>> allQuotes = [];
    for (var category in _categories) {
      allQuotes.addAll(List<Map<String, String>>.from(category['quotes']));
    }
    final randomIndex =
        DateTime.now().millisecondsSinceEpoch % allQuotes.length;
    final randomQuote = allQuotes[randomIndex];
    setState(() {
      _quoteOfTheDay = "${randomQuote['quote']} - ${randomQuote['author']}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Inspiring Quotes',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Quote of the Day Card
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade600, Colors.teal.shade400],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
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
                        'Quote of the Day',
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
                    _quoteOfTheDay,
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
                        onPressed: _refreshQuoteOfTheDay,
                        icon: Icon(
                          Icons.refresh,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          'New Quote',
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
                      color: Colors.teal.shade800,
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
            builder: (context) => CategoryQuotesScreen(
              categoryName: category['name'],
              categoryIcon: category['icon'],
              categoryColor: category['color'],
              categoryDescription: category['description'],
              quotes: category['quotes'],
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
                '${category['quotes'].length} quotes',
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
