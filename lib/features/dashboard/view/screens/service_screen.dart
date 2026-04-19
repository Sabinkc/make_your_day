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
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isSmallPhone = screenWidth < 360;
    
    // Responsive values
    final horizontalPadding = isSmallPhone ? 12.0 : (isTablet ? 24.0 : 20.0);
    final verticalPadding = isSmallPhone ? 12.0 : (isTablet ? 24.0 : 20.0);
    final cardSpacing = isSmallPhone ? 10.0 : (isTablet ? 20.0 : 15.0);
    final titleFontSize = isSmallPhone ? 16.0 : (isTablet ? 20.0 : 18.0);
    final categoryTitleFontSize = isSmallPhone ? 16.0 : (isTablet ? 20.0 : 18.0);
    final iconSize = isSmallPhone ? 32.0 : (isTablet ? 48.0 : 40.0);
    final childAspectRatio = isTablet ? 0.8 : 0.85;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.serviceName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: isSmallPhone ? 18 : 20,
          ),
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
              margin: EdgeInsets.all(horizontalPadding),
              padding: EdgeInsets.all(isSmallPhone ? 12 : 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [_getColor(), _getColor()]),
                borderRadius: BorderRadius.circular(isSmallPhone ? 15 : 20),
                boxShadow: [
                  BoxShadow(
                    color: _getColor().withOpacity(0.3),
                    blurRadius: isSmallPhone ? 10 : 15,
                    offset: Offset(0, isSmallPhone ? 3 : 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.white, size: isSmallPhone ? 20 : 24),
                      SizedBox(width: 8),
                      Text(
                        '${widget.serviceName} of the Day',
                        style: GoogleFonts.poppins(
                          fontSize: isSmallPhone ? 14 : 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallPhone ? 10 : 15),
                  Text(
                    _contentOfTheDay,
                    style: GoogleFonts.poppins(
                      fontSize: isSmallPhone ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: isSmallPhone ? 10 : 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: _refreshContentOfTheDay,
                        icon: Icon(
                          Icons.refresh,
                          size: isSmallPhone ? 16 : 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          'New ${widget.serviceName.substring(0, widget.serviceName.length - 1)}',
                          style: TextStyle(
                            fontSize: isSmallPhone ? 11 : 14,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(isSmallPhone ? 15 : 20),
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
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  Text(
                    'Choose Category',
                    style: GoogleFonts.poppins(
                      fontSize: categoryTitleFontSize,
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
                          fontSize: isSmallPhone ? 10 : 12,
                          color: Colors.grey.shade600,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: isSmallPhone ? 10 : 15),

            // Subcategories Grid - Stream for real-time updates
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('all_services')
                      .doc(widget.serviceId)
                      .collection('service_subcategories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: GoogleFonts.poppins(
                            fontSize: isSmallPhone ? 12 : 14,
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: isSmallPhone ? 2 : 3,
                        ),
                      );
                    }

                    final subcategories = snapshot.data!.docs;

                    if (subcategories.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder,
                              size: isSmallPhone ? 48 : 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: isSmallPhone ? 12 : 16),
                            Text(
                              'No categories found',
                              style: GoogleFonts.poppins(
                                fontSize: isSmallPhone ? 14 : 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isTablet ? 3 : 2,
                        crossAxisSpacing: cardSpacing,
                        mainAxisSpacing: cardSpacing,
                        childAspectRatio: childAspectRatio,
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
                          iconSize: iconSize,
                          isSmallPhone: isSmallPhone,
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
    required double iconSize,
    required bool isSmallPhone,
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
          borderRadius: BorderRadius.circular(isSmallPhone ? 15 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: isSmallPhone ? 8 : 10,
              offset: Offset(0, isSmallPhone ? 1 : 2),
            ),
          ],
          border: Border.all(
            color: _getColor().withOpacity(0.3),
            width: isSmallPhone ? 0.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isSmallPhone ? 10 : 15),
              decoration: BoxDecoration(
                color: _getColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getSubcategoryIcon(subId),
                size: iconSize,
                color: _getColor(),
              ),
            ),
            SizedBox(height: isSmallPhone ? 10 : 15),
            Text(
              subName,
              style: GoogleFonts.poppins(
                fontSize: isSmallPhone ? 14 : 18,
                fontWeight: FontWeight.bold,
                color: _getColor(),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isSmallPhone ? 4 : 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isSmallPhone ? 6 : 10),
              child: Text(
                _getSubcategoryDescription(subId),
                style: GoogleFonts.poppins(
                  fontSize: isSmallPhone ? 9 : 11,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: isSmallPhone ? 6 : 10),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallPhone ? 8 : 12,
                vertical: isSmallPhone ? 2 : 4,
              ),
              decoration: BoxDecoration(
                color: _getColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(isSmallPhone ? 10 : 15),
              ),
              child: FutureBuilder<QuerySnapshot>(
                future: subDoc.reference.collection('data').get(),
                builder: (context, snapshot) {
                  final count = snapshot.data?.docs.length ?? 0;
                  return Text(
                    '$count items',
                    style: GoogleFonts.poppins(
                      fontSize: isSmallPhone ? 8 : 10,
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