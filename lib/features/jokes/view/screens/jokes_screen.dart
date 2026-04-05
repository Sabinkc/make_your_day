import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JokesScreen extends StatefulWidget {
  @override
  _JokesScreenState createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  int _currentIndex = 0;
  final List<Map<String, String>> _jokes = [
    {
      'setup': "Why don't scientists trust atoms?",
      'punchline': "Because they make up everything!",
    },
    {'setup': "What do you call a fake noodle?", 'punchline': "An impasta!"},
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
  ];

  bool _showPunchline = false;

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
                              color: Colors.amber.withOpacity(0.2),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.emoji_emotions,
                              size: 50,
                              color: Colors.amber,
                            ),
                            SizedBox(height: 20),
                            Text(
                              _jokes[_currentIndex]['setup']!,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                color: Colors.amber.shade800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            if (_showPunchline)
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  _jokes[_currentIndex]['punchline']!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.amber.shade900,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showPunchline = !_showPunchline;
                          });
                        },
                        icon: Icon(
                          _showPunchline
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        label: Text(
                          _showPunchline ? 'Hide Punchline' : 'Show Punchline',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _previous,
                            icon: Icon(Icons.arrow_back),
                            label: Text('Previous'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade300,
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
                              backgroundColor: Colors.amber,
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
                        '${_currentIndex + 1} of ${_jokes.length}',
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
      _currentIndex = (_currentIndex + 1) % _jokes.length;
      _showPunchline = false;
    });
  }

  void _previous() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _jokes.length) % _jokes.length;
      _showPunchline = false;
    });
  }
}
