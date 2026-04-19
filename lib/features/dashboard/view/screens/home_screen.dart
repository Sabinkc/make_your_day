import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_your_day/features/dashboard/view/screens/service_screen.dart';
import 'package:make_your_day/features/dashboard/view/widgets/service_card.dart';
import 'package:make_your_day/features/menu/view/screens/menu_screen.dart';
import 'package:make_your_day/features/notifications/view/screens/notification_setup_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [HomeContent(), MenuScreen()],
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 400;
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: isSmallScreen ? 10 : 12,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 10 : 12,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: isSmallScreen ? 20 : 24),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu, size: isSmallScreen ? 20 : 24),
                label: 'Menu',
              ),
            ],
          );
        },
      ),
    );
  }
}

// Home Content Widget - Fetches services from Firebase
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Determine responsive values
    final isTablet = screenWidth > 600;
    final isSmallPhone = screenWidth < 360;
    final isMediumPhone = screenWidth >= 360 && screenWidth <= 600;
    
    // Grid configuration
    int crossAxisCount = 2;
    double childAspectRatio = 0.9;
    double crossAxisSpacing = 15;
    double mainAxisSpacing = 15;
    double horizontalPadding = 20;
    double verticalPadding = 20;
    
    if (isTablet) {
      crossAxisCount = 3;
      childAspectRatio = 0.85;
      crossAxisSpacing = 20;
      mainAxisSpacing = 20;
      horizontalPadding = 24;
      verticalPadding = 24;
    } else if (isSmallPhone) {
      crossAxisCount = 2;
      childAspectRatio = 0.85;
      crossAxisSpacing = 10;
      mainAxisSpacing = 10;
      horizontalPadding = 12;
      verticalPadding = 12;
    }
    
    // Font sizes
    final titleSize = isSmallPhone ? 20.0 : (isTablet ? 28.0 : 24.0);
    final bannerTextSize = isSmallPhone ? 12.0 : (isTablet ? 16.0 : 14.0);
    final bannerHeadingSize = isSmallPhone ? 16.0 : (isTablet ? 22.0 : 20.0);
    final iconSize = isSmallPhone ? 40.0 : (isTablet ? 60.0 : 50.0);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isSmallPhone ? 50 : kToolbarHeight),
        child: AppBar(
          title: Text(
            'Make Your Day',
            style: GoogleFonts.poppins(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications,
                size: isSmallPhone ? 20 : 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationSetupScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Responsive Welcome Banner
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding / 2,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: isSmallPhone ? 12 : 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.purple.shade600],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: GoogleFonts.poppins(
                            fontSize: bannerTextSize,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Ready for positivity?',
                          style: GoogleFonts.poppins(
                            fontSize: bannerHeadingSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.wb_sunny,
                    size: iconSize,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ],
              ),
            ),

            // Services Grid - Fetch from Firebase
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('all_services')
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

                    final services = snapshot.data!.docs;

                    if (services.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category,
                              size: isSmallPhone ? 48 : 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No services found',
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
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: crossAxisSpacing,
                        mainAxisSpacing: mainAxisSpacing,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final serviceDoc = services[index];
                        final serviceId = serviceDoc.id;
                        final serviceName =
                            serviceDoc['service_name'] ?? serviceId;

                        return ServiceCard(
                          serviceId: serviceId,
                          serviceName: serviceName,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceScreen(
                                  serviceId: serviceId,
                                  serviceName: serviceName,
                                ),
                              ),
                            );
                          },
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

  // Helper method to get dynamic greeting based on time of day
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning! 🌅';
    if (hour < 17) return 'Good Afternoon! ☀️';
    return 'Good Evening! 🌙';
  }
}