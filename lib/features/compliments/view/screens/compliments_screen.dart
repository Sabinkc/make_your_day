import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComplimentsScreen extends StatefulWidget {
  @override
  _ComplimentsScreenState createState() => _ComplimentsScreenState();
}

class _ComplimentsScreenState extends State<ComplimentsScreen> {
  int _currentIndex = 0;
  final List<String> _compliments = [
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
  ];

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
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.2),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.favorite, size: 50, color: Colors.pink),
                            SizedBox(height: 20),
                            Text(
                              _compliments[_currentIndex],
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                color: Colors.pink.shade800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "💝 You deserve this! 💝",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
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
                              backgroundColor: Colors.pink.shade300,
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
                              backgroundColor: Colors.pink,
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
                        '${_currentIndex + 1} of ${_compliments.length}',
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
      _currentIndex = (_currentIndex + 1) % _compliments.length;
    });
  }

  void _previous() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _compliments.length) % _compliments.length;
    });
  }
}
