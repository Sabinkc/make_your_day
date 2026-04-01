import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuotesScreen extends StatefulWidget {
  @override
  _QuotesScreenState createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  int _currentIndex = 0;
  final List<Map<String, String>> _quotes = [
    {
      'quote': "The purpose of our lives is to be happy.",
      'author': "Dalai Lama",
    },
    {
      'quote': "Life is what happens when you're busy making other plans.",
      'author': "John Lennon",
    },
    {'quote': "Get busy living or get busy dying.", 'author': "Stephen King"},
    {
      'quote': "You only live once, but if you do it right, once is enough.",
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
  ];

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
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.2),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.format_quote,
                              size: 40,
                              color: Colors.teal,
                            ),
                            SizedBox(height: 20),
                            Text(
                              _quotes[_currentIndex]['quote']!,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                color: Colors.teal.shade800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "- ${_quotes[_currentIndex]['author']}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _previous,
                            icon: Icon(Icons.arrow_back),
                            label: Text('Previous'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade300,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _next,
                            icon: Icon(Icons.arrow_forward),
                            label: Text('Next'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${_currentIndex + 1} of ${_quotes.length}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _next() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _quotes.length;
    });
  }

  void _previous() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _quotes.length) % _quotes.length;
    });
  }
}
