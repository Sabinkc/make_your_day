import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_your_day/features/dashboard/view/screens/category_content_screen.dart';

class ServiceScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;

  const ServiceScreen({
    Key? key,
    required this.serviceId,
    required this.serviceName,
  }) : super(key: key);

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  String _contentOfTheDay = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadContentOfTheDay();
  }

  Future<void> _loadContentOfTheDay() async {
    try {
      // Get random content from all subcategories
      final subcategoriesSnapshot = await FirebaseFirestore.instance
          .collection('all_services')
          .doc(widget.serviceId)
          .collection('service_subcategories')
          .get();

      if (subcategoriesSnapshot.docs.isEmpty) {
        setState(() => _contentOfTheDay = "No content available");
        return;
      }

      // Pick random subcategory
      final randomSub =
          subcategoriesSnapshot.docs[DateTime.now().millisecondsSinceEpoch %
              subcategoriesSnapshot.docs.length];

      // Get content from that subcategory
      final contentSnapshot = await randomSub.reference
          .collection('data')
          .get();

      if (contentSnapshot.docs.isEmpty) {
        setState(() => _contentOfTheDay = "No content available");
        return;
      }

      // Pick random content
      final randomContent =
          contentSnapshot.docs[DateTime.now().millisecondsSinceEpoch %
              contentSnapshot.docs.length];

      setState(() => _contentOfTheDay = randomContent['value']);
    } catch (e) {
      setState(() => _contentOfTheDay = "Stay positive and keep going!");
    }
  }

  Future<void> _refreshContentOfTheDay() async {
    await _loadContentOfTheDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.serviceName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _getColor(),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_getColor().withOpacity(0.1), Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Content of the Day Card
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [_getColor(), _getColor()]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _getColor().withOpacity(0.3),
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
                        '${widget.serviceName} of the Day',
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
                    _contentOfTheDay,
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
                        onPressed: _refreshContentOfTheDay,
                        icon: Icon(
                          Icons.refresh,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          'New ${widget.serviceName.substring(0, widget.serviceName.length - 1)}',
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

            // Subcategories Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Choose Category',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getColor(),
                    ),
                  ),
                  Spacer(),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('all_services')
                        .doc(widget.serviceId)
                        .collection('service_subcategories')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return SizedBox();
                      final count = snapshot.data!.docs.length;
                      return Text(
                        '$count categories',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),

            // Subcategories Grid - Stream for real-time updates
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('all_services')
                      .doc(widget.serviceId)
                      .collection('service_subcategories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final subcategories = snapshot.data!.docs;

                    if (subcategories.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No categories found',
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: subcategories.length,
                      itemBuilder: (context, index) {
                        final subDoc = subcategories[index];
                        final subId = subDoc.id;
                        final subName = subDoc['subcategory_name'] ?? subId;

                        return _buildSubcategoryCard(
                          subId: subId,
                          subName: subName,
                          subDoc: subDoc,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryCard({
    required String subId,
    required String subName,
    required QueryDocumentSnapshot subDoc,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryContentScreen(
              serviceId: widget.serviceId,
              serviceName: widget.serviceName,
              subcategoryId: subId,
              subcategoryName: subName,
              subcategoryDescription: _getSubcategoryDescription(subId),
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
          border: Border.all(color: _getColor().withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _getColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getSubcategoryIcon(subId),
                size: 40,
                color: _getColor(),
              ),
            ),
            SizedBox(height: 15),
            Text(
              subName,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getColor(),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                _getSubcategoryDescription(subId),
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
                color: _getColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: FutureBuilder<QuerySnapshot>(
                future: subDoc.reference.collection('data').get(),
                builder: (context, snapshot) {
                  final count = snapshot.data?.docs.length ?? 0;
                  return Text(
                    '$count items',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: _getColor(),
                      fontWeight: FontWeight.w500,
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

  IconData _getSubcategoryIcon(String subId) {
    switch (subId) {
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
      case 'career_success':
        return Icons.work;
      case 'personal_growth':
        return Icons.trending_up;
      case 'overcoming_challenges':
        return Icons.fitness_center;
      case 'daily_drive':
        return Icons.alarm;
      case 'perseverance_grit':
        return Icons.bolt;
      default:
        return Icons.folder;
    }
  }

  String _getSubcategoryDescription(String subId) {
    switch (subId) {
      case 'all':
        return 'All content combined';
      case 'self_love_confidence':
        return 'Boost your self-worth and confidence';
      case 'morning_motivation':
        return 'Start your day with purpose';
      case 'overcoming_anxiety':
        return 'Find peace and calm';
      case 'success_abundance':
        return 'Achieve your goals and dreams';
      case 'gratitude_peace':
        return 'Appreciate life\'s blessings';
      case 'career_success':
        return 'Professional growth and success';
      case 'personal_growth':
        return 'Become the best version of yourself';
      case 'overcoming_challenges':
        return 'Strength through difficult times';
      case 'daily_drive':
        return 'Daily inspiration and energy';
      case 'perseverance_grit':
        return 'Keep going, never give up';
      default:
        return 'Positive content for your day';
    }
  }
}
