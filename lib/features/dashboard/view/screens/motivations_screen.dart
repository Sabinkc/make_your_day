import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MotivationsScreen extends StatefulWidget {
  @override
  _MotivationsScreenState createState() => _MotivationsScreenState();
}

class _MotivationsScreenState extends State<MotivationsScreen> {
  int _currentIndex = 0;
  final List<Map<String, String>> _motivations = [
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
      'quote': "Everything you've ever wanted is on the other side of fear.",
      'author': "George Addair",
    },
    {
      'quote':
          "The future belongs to those who believe in the beauty of their dreams.",
      'author': "Eleanor Roosevelt",
    },
  ];

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
                              color: Colors.orange.withOpacity(0.2),
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
                              color: Colors.orange,
                            ),
                            SizedBox(height: 20),
                            Text(
                              _motivations[_currentIndex]['quote']!,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                color: Colors.orange.shade800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "- ${_motivations[_currentIndex]['author']}",
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
                              backgroundColor: Colors.orange.shade300,
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
                              backgroundColor: Colors.orange,
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
                        '${_currentIndex + 1} of ${_motivations.length}',
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
      _currentIndex = (_currentIndex + 1) % _motivations.length;
    });
  }

  void _previous() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _motivations.length) % _motivations.length;
    });
  }
}
