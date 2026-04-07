import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryContentScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  final String subcategoryId;
  final String subcategoryName;
  final String subcategoryDescription;

  const CategoryContentScreen({
    Key? key,
    required this.serviceId,
    required this.serviceName,
    required this.subcategoryId,
    required this.subcategoryName,
    required this.subcategoryDescription,
  }) : super(key: key);

  @override
  _CategoryContentScreenState createState() => _CategoryContentScreenState();
}

class _CategoryContentScreenState extends State<CategoryContentScreen> {
  int _currentIndex = 0;
  List<QueryDocumentSnapshot> _contents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  Future<void> _loadContents() async {
    setState(() => _isLoading = true);

    final snapshot = await FirebaseFirestore.instance
        .collection('all_services')
        .doc(widget.serviceId)
        .collection('service_subcategories')
        .doc(widget.subcategoryId)
        .collection('data')
        .get();

    _contents = snapshot.docs;
    setState(() => _isLoading = false);
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
              widget.subcategoryName,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              widget.serviceName,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        backgroundColor: _getColor(),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () => _showSaveMessage(),
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => _showShareMessage(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: _getColor()))
          : _contents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No content found',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_getColor().withOpacity(0.1), Colors.white],
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
                          color: _getColor().withOpacity(0.1),
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
                            color: _getColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getSubcategoryIcon(),
                            color: _getColor(),
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.subcategoryDescription,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${_contents.length} items',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: _getColor(),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main Content Card
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
                                    color: _getColor().withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                                border: Border.all(
                                  color: _getColor().withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    _getMainIcon(),
                                    size: 50,
                                    color: _getColor(),
                                  ),
                                  SizedBox(height: 25),
                                  Text(
                                    _contents[_currentIndex]['value'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                      color: _getColor(),
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
                                      color: _getColor().withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _getActionText(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: _getColor(),
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
                                    onPressed: _previous,
                                    icon: Icon(Icons.arrow_back),
                                    label: Text('Previous'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: _getColor(),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      side: BorderSide(color: _getColor()),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _next,
                                    icon: Icon(Icons.arrow_forward),
                                    label: Text('Next'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _getColor(),
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
                                  '${_currentIndex + 1} of ${_contents.length}',
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
                                    value: _contents.isEmpty
                                        ? 0
                                        : (_currentIndex + 1) /
                                              _contents.length,
                                    backgroundColor: _getColor().withOpacity(
                                      0.2,
                                    ),
                                    valueColor: AlwaysStoppedAnimation(
                                      _getColor(),
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
      bottomNavigationBar: _contents.isEmpty
          ? null
          : Container(
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
                        color: _getColor(),
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
                        onPressed: _showAllContent,
                        icon: Icon(Icons.list, size: 18),
                        label: Text('View All'),
                        style: TextButton.styleFrom(
                          foregroundColor: _getColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _next() {
    if (_contents.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _contents.length;
    });
  }

  void _previous() {
    if (_contents.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex - 1 + _contents.length) % _contents.length;
    });
  }

  void _showAllContent() {
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
                'All ${widget.subcategoryName}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _getColor(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _contents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getColor().withOpacity(0.1),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(color: _getColor()),
                      ),
                    ),
                    title: Text(
                      _contents[index]['value'],
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.chevron_right, color: _getColor()),
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

  Color _getColor() {
    switch (widget.serviceId) {
      case 'affirmations':
        return Colors.purple;
      case 'motivations':
        return Colors.orange;
      case 'quotes':
        return Colors.teal;
      case 'jokes':
        return Colors.amber;
      case 'compliments':
        return Colors.pink;
      default:
        return Colors.blue;
    }
  }

  IconData _getSubcategoryIcon() {
    switch (widget.subcategoryId) {
      case 'all':
        return Icons.apps;
      case 'self_love_confidence':
        return Icons.favorite;
      case 'morning_motivation':
        return Icons.wb_sunny;
      case 'overcoming_anxiety':
        return Icons.psychology;
      case 'success_abundance':
        return Icons.emoji_events;
      case 'gratitude_peace':
        return Icons.waving_hand;
      default:
        return Icons.folder;
    }
  }

  IconData _getMainIcon() {
    switch (widget.serviceId) {
      case 'affirmations':
        return Icons.format_quote;
      case 'motivations':
        return Icons.format_quote;
      case 'quotes':
        return Icons.format_quote;
      case 'jokes':
        return Icons.emoji_emotions;
      case 'compliments':
        return Icons.favorite;
      default:
        return Icons.star;
    }
  }

  String _getActionText() {
    switch (widget.serviceId) {
      case 'affirmations':
        return "✨ Speak this aloud ✨";
      case 'motivations':
        return "🔥 Let this motivate you 🔥";
      case 'quotes':
        return "📚 Let this inspire you 📚";
      case 'jokes':
        return "😂 Share this laugh 😂";
      case 'compliments':
        return "💝 You deserve this! 💝";
      default:
        return "✨ Enjoy this content ✨";
    }
  }

  void _showSaveMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved to favorites!'),
        backgroundColor: _getColor(),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showShareMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share feature coming soon!'),
        backgroundColor: _getColor(),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
