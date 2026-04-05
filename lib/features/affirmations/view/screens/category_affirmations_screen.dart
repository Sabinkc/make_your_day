import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryAffirmationsScreen extends StatefulWidget {
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;
  final String categoryDescription;
  final List<String> affirmations;

  const CategoryAffirmationsScreen({
    Key? key,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.categoryDescription,
    required this.affirmations,
  }) : super(key: key);

  @override
  _CategoryAffirmationsScreenState createState() =>
      _CategoryAffirmationsScreenState();
}

class _CategoryAffirmationsScreenState
    extends State<CategoryAffirmationsScreen> {
  int _currentIndex = 0;
  late List<String> _affirmations;

  @override
  void initState() {
    super.initState();
    _affirmations = widget.affirmations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.categoryName,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Affirmations',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        backgroundColor: widget.categoryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              _showSaveMessage();
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _showShareMessage();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [widget.categoryColor.withOpacity(0.1), Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Category Info Card
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: widget.categoryColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.categoryIcon,
                      color: widget.categoryColor,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.categoryDescription,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${_affirmations.length} positive affirmations',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: widget.categoryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Affirmation Card
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
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: widget.categoryColor.withOpacity(0.2),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: widget.categoryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.format_quote,
                              size: 50,
                              color: widget.categoryColor,
                            ),
                            SizedBox(height: 25),
                            Text(
                              _affirmations[_currentIndex],
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                color: widget.categoryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 25),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: widget.categoryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "✨ Speak this aloud ✨",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: widget.categoryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),

                      // Navigation Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _previousAffirmation,
                              icon: Icon(Icons.arrow_back),
                              label: Text('Previous'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: widget.categoryColor,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                side: BorderSide(color: widget.categoryColor),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _nextAffirmation,
                              icon: Icon(Icons.arrow_forward),
                              label: Text('Next'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.categoryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Progress Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_currentIndex + 1} of ${_affirmations.length}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                            width: 100,
                            child: LinearProgressIndicator(
                              value: (_currentIndex + 1) / _affirmations.length,
                              backgroundColor: widget.categoryColor.withOpacity(
                                0.2,
                              ),
                              valueColor: AlwaysStoppedAnimation(
                                widget.categoryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Sheet for Quick Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.format_list_numbered,
                  color: widget.categoryColor,
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Swipe or use buttons to navigate',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _showAllAffirmations,
                  icon: Icon(Icons.list, size: 18),
                  label: Text('View All'),
                  style: TextButton.styleFrom(
                    foregroundColor: widget.categoryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _nextAffirmation() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _affirmations.length;
    });
  }

  void _previousAffirmation() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _affirmations.length) % _affirmations.length;
    });
  }

  void _showAllAffirmations() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'All ${widget.categoryName} Affirmations',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.categoryColor,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _affirmations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: widget.categoryColor.withOpacity(0.1),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(color: widget.categoryColor),
                      ),
                    ),
                    title: Text(
                      _affirmations[index],
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        color: widget.categoryColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSaveMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved to favorites!'),
        backgroundColor: widget.categoryColor,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showShareMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share feature coming soon!'),
        backgroundColor: widget.categoryColor,
        duration: Duration(seconds: 1),
      ),
    );
  }
}
