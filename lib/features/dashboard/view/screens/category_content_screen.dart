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
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.subcategoryId,
    required this.subcategoryName,
    required this.subcategoryDescription,
  });

  @override
  State<CategoryContentScreen> createState() => _CategoryContentScreenState();
}

class _CategoryContentScreenState extends State<CategoryContentScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  List<QueryDocumentSnapshot> _contents = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  double _scrollOffset = 0;
  bool _isScrolling = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadContents();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients && _contents.isNotEmpty) {
      final double offset = _scrollController.offset;
      final double itemHeight = MediaQuery.of(context).size.height * 0.65;

      int newIndex = ((offset + itemHeight / 2) / itemHeight).floor();
      newIndex = newIndex.clamp(0, _contents.length - 1);

      if (newIndex != _currentIndex && !_isScrolling) {
        setState(() {
          _currentIndex = newIndex;
          _scrollOffset = offset;
        });
        _animationController.reset();
        _animationController.forward();
      }
    }
  }

  Future<void> _loadContents() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('all_services')
          .doc(widget.serviceId)
          .collection('service_subcategories')
          .doc(widget.subcategoryId)
          .collection('data')
          .get();

      if (mounted) {
        setState(() {
          _contents = snapshot.docs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    }
  }

  void _scrollToIndex(int index) {
    if (_scrollController.hasClients) {
      _isScrolling = true;
      final double itemHeight = MediaQuery.of(context).size.height * 0.65;
      _scrollController
          .animateTo(
            index * itemHeight,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          )
          .then((_) {
            _isScrolling = false;
            setState(() {
              _currentIndex = index;
            });
            _animationController.reset();
            _animationController.forward();
          });
    }
  }

  void _next() {
    if (_currentIndex + 1 < _contents.length) {
      _scrollToIndex(_currentIndex + 1);
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      _scrollToIndex(_currentIndex - 1);
    }
  }

  String _getContentValue(int index) {
    try {
      final data = _contents[index].data() as Map<String, dynamic>;
      return data['value']?.toString() ?? 'No content available';
    } catch (e) {
      return 'Error parsing content';
    }
  }

  void _showAllContent() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
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
                  final isCurrent = index == _currentIndex;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getColor().withOpacity(
                        isCurrent ? 0.3 : 0.1,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isCurrent
                              ? _getColor()
                              : _getColor().withOpacity(0.7),
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    title: Text(
                      _getContentValue(index),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: isCurrent
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isCurrent ? _getColor() : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: isCurrent
                        ? Icon(Icons.check_circle, color: _getColor())
                        : IconButton(
                            icon: Icon(Icons.chevron_right, color: _getColor()),
                            onPressed: () {
                              Navigator.pop(context);
                              _scrollToIndex(index);
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

  @override
  Widget build(BuildContext context) {
    final themeColor = _getColor();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemHeight = screenHeight * 0.65;
    
    // Responsive values - all as double
    final isTablet = screenWidth > 600;
    final isSmallPhone = screenWidth < 360;
    
    final double horizontalPadding = isSmallPhone ? 12.0 : (isTablet ? 24.0 : 20.0);
    final double verticalPadding = isSmallPhone ? 8.0 : (isTablet ? 16.0 : 12.0);
    final double titleFontSize = isSmallPhone ? 16.0 : 20.0;
    final double subtitleFontSize = isSmallPhone ? 10.0 : 12.0;
    final double contentFontSize = isSmallPhone ? 18.0 : 22.0;
    final double actionTextFontSize = isSmallPhone ? 11.0 : 13.0;
    final double iconSize = isSmallPhone ? 48.0 : 60.0;
    final double badgeSize = isSmallPhone ? 28.0 : 36.0;
    final double badgeFontSize = isSmallPhone ? 14.0 : 18.0;

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
                fontSize: titleFontSize,
              ),
            ),
            Text(
              widget.serviceName,
              style: GoogleFonts.poppins(
                fontSize: subtitleFontSize,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: _showSaveMessage,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _showShareMessage,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: themeColor))
          : _contents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No content found',
                    style: GoogleFonts.poppins(
                      fontSize: isSmallPhone ? 14.0 : 18.0,
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
                  colors: [themeColor.withOpacity(0.1), Colors.white],
                ),
              ),
              child: Column(
                children: [
                  // Category Info Card
                  _buildInfoCard(themeColor, isSmallPhone, isTablet),

                  // Scrollable Content
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollUpdateNotification) {
                          _onScroll();
                        }
                        return true;
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _contents.length,
                        padding: EdgeInsets.symmetric(vertical: verticalPadding),
                        physics: const BouncingScrollPhysics(),
                        itemExtent: itemHeight,
                        itemBuilder: (context, index) {
                          final isCurrent = index == _currentIndex;
                          return _buildContentCard(
                            index,
                            isCurrent,
                            themeColor,
                            isSmallPhone,
                            isTablet,
                            contentFontSize,
                            actionTextFontSize,
                            iconSize,
                            badgeSize,
                            badgeFontSize,
                          );
                        },
                      ),
                    ),
                  ),

                  // Navigation Buttons Below
                  _buildNavigationRow(themeColor, isSmallPhone, isTablet),
                  const SizedBox(height: 8),
                ],
              ),
            ),
      bottomNavigationBar: _contents.isEmpty
          ? null
          : _buildBottomBar(themeColor, isSmallPhone, isTablet),
    );
  }

  Widget _buildInfoCard(Color themeColor, bool isSmallPhone, bool isTablet) {
    final double padding = isSmallPhone ? 8.0 : (isTablet ? 16.0 : 12.0);
    final double iconSize = isSmallPhone ? 24.0 : (isTablet ? 32.0 : 28.0);
    final double fontSize = isSmallPhone ? 10.0 : (isTablet ? 14.0 : 12.0);
    final double countFontSize = isSmallPhone ? 9.0 : (isTablet ? 12.0 : 10.0);
    final double borderRadius = isSmallPhone ? 12.0 : 15.0;
    final double iconBorderRadius = isSmallPhone ? 10.0 : 12.0;
    
    return Container(
      margin: EdgeInsets.all(isSmallPhone ? 12.0 : 16.0),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.1),
            blurRadius: isSmallPhone ? 6.0 : 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallPhone ? 8.0 : 10.0),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(iconBorderRadius),
            ),
            child: Icon(_getSubcategoryIcon(), color: themeColor, size: iconSize),
          ),
          SizedBox(width: isSmallPhone ? 8.0 : 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.subcategoryDescription,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: isSmallPhone ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallPhone ? 2.0 : 4.0),
                Text(
                  '${_contents.length} items',
                  style: GoogleFonts.poppins(
                    fontSize: countFontSize,
                    color: themeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRow(Color themeColor, bool isSmallPhone, bool isTablet) {
    final double buttonPadding = isSmallPhone ? 6.0 : 10.0;
    final double fontSize = isSmallPhone ? 11.0 : (isTablet ? 14.0 : 13.0);
    final double spacing = isSmallPhone ? 8.0 : 12.0;
    final double borderRadius = isSmallPhone ? 20.0 : 25.0;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallPhone ? 12.0 : 20.0, vertical: isSmallPhone ? 4.0 : 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _previous,
              icon: Icon(Icons.arrow_upward, size: isSmallPhone ? 14.0 : 18.0),
              label: Text(
                _currentIndex > 0 ? 'Previous' : 'Start',
                style: TextStyle(fontSize: fontSize),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: themeColor,
                side: BorderSide(color: themeColor),
                padding: EdgeInsets.symmetric(vertical: buttonPadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
          ),
          SizedBox(width: spacing),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallPhone ? 12.0 : 16.0,
              vertical: isSmallPhone ? 6.0 : 8.0,
            ),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Text(
              '${_currentIndex + 1} / ${_contents.length}',
              style: GoogleFonts.poppins(
                fontSize: isSmallPhone ? 12.0 : (isTablet ? 16.0 : 14.0),
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _next,
              icon: Icon(Icons.arrow_downward, size: isSmallPhone ? 14.0 : 18.0),
              label: Text(
                _currentIndex + 1 < _contents.length ? 'Next' : 'End',
                style: TextStyle(fontSize: fontSize),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: buttonPadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(
    int index,
    bool isCurrent,
    Color themeColor,
    bool isSmallPhone,
    bool isTablet,
    double contentFontSize,
    double actionTextFontSize,
    double iconSize,
    double badgeSize,
    double badgeFontSize,
  ) {
    final double marginHorizontal = isSmallPhone ? 12.0 : 20.0;
    final double marginVertical = isSmallPhone ? 6.0 : 10.0;
    final double padding = isSmallPhone ? 16.0 : 24.0;
    final double borderRadius = isSmallPhone ? 20.0 : 25.0;
    final double blurRadius = isCurrent ? (isSmallPhone ? 15.0 : 20.0) : (isSmallPhone ? 6.0 : 8.0);
    final double borderWidth = isCurrent ? (isSmallPhone ? 1.5 : 2.0) : (isSmallPhone ? 0.5 : 1.0);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.symmetric(horizontal: marginHorizontal, vertical: marginVertical),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: isCurrent ? themeColor.withOpacity(0.3) : Colors.black12,
            blurRadius: blurRadius,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isCurrent ? themeColor : themeColor.withOpacity(0.2),
          width: borderWidth,
        ),
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 400),
        scale: isCurrent ? 1.0 : 0.95,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Number Badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: badgeSize,
                height: badgeSize,
                decoration: BoxDecoration(
                  color: isCurrent ? themeColor : themeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: badgeFontSize,
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? Colors.white : themeColor,
                    ),
                    child: Text('${index + 1}'),
                  ),
                ),
              ),
              SizedBox(height: isSmallPhone ? 16.0 : 24.0),
              
              // Main Icon with smooth scale transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  _getMainIcon(),
                  key: ValueKey(index),
                  size: iconSize,
                  color: themeColor,
                ),
              ),
              SizedBox(height: isSmallPhone ? 20.0 : 32.0),
              
              // Content Text with smooth fade and slide transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  key: ValueKey(index),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: GoogleFonts.poppins(
                      fontSize: contentFontSize,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                      height: 1.4,
                      color: isCurrent ? Colors.black87 : Colors.grey.shade600,
                    ),
                    child: Text(
                      _getContentValue(index),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isSmallPhone ? 16.0 : 28.0),
              
              // Action Text (only for current item)
              if (isCurrent)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: 1.0,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 400),
                    scale: 1.0,
                    curve: Curves.elasticOut,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallPhone ? 12.0 : 18.0,
                        vertical: isSmallPhone ? 6.0 : 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(isSmallPhone ? 20.0 : 30.0),
                      ),
                      child: Text(
                        _getActionText(),
                        style: GoogleFonts.poppins(
                          fontSize: actionTextFontSize,
                          color: themeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              
              // Scroll Hint
              if (isCurrent && _contents.length > 1 && !isSmallPhone)
                FadeTransition(
                  opacity: _animationController.drive(
                    Tween<double>(begin: 0.3, end: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.swipe_vertical, size: 16.0, color: Colors.grey.shade400),
                        const SizedBox(width: 6.0),
                        Text(
                          'Scroll up/down to navigate',
                          style: GoogleFonts.poppins(
                            fontSize: 11.0,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(Color themeColor, bool isSmallPhone, bool isTablet) {
    final double fontSize = isSmallPhone ? 10.0 : (isTablet ? 12.0 : 11.0);
    final double iconSize = isSmallPhone ? 16.0 : (isTablet ? 20.0 : 18.0);
    final double padding = isSmallPhone ? 12.0 : 20.0;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10.0)],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: isSmallPhone ? 4.0 : 8.0),
          child: Row(
            children: [
              Icon(Icons.swipe_vertical, color: themeColor, size: iconSize),
              SizedBox(width: isSmallPhone ? 6.0 : 8.0),
              Expanded(
                child: Text(
                  isSmallPhone ? 'Scroll • View All' : 'Scroll vertically • View All to browse',
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _showAllContent,
                icon: Icon(Icons.list, size: isSmallPhone ? 14.0 : 16.0),
                label: Text('View All', style: TextStyle(fontSize: isSmallPhone ? 10.0 : 12.0)),
                style: TextButton.styleFrom(foregroundColor: themeColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Methods (unchanged) ---

  Color _getColor() {
    final Map<String, Color> colors = {
      'affirmations': Colors.purple,
      'motivations': Colors.orange,
      'quotes': Colors.teal,
      'jokes': Colors.amber,
      'compliments': Colors.pink,
    };
    return colors[widget.serviceId] ?? Colors.blue;
  }

  IconData _getSubcategoryIcon() {
    final Map<String, IconData> icons = {
      'all': Icons.apps,
      'self_love_confidence': Icons.favorite,
      'morning_motivation': Icons.wb_sunny,
      'overcoming_anxiety': Icons.psychology,
      'success_abundance': Icons.emoji_events,
      'gratitude_peace': Icons.waving_hand,
    };
    return icons[widget.subcategoryId] ?? Icons.folder;
  }

  IconData _getMainIcon() {
    if (widget.serviceId == 'jokes') return Icons.emoji_emotions;
    if (widget.serviceId == 'compliments') return Icons.favorite;
    return Icons.format_quote;
  }

  String _getActionText() {
    final Map<String, String> actions = {
      'affirmations': "✨ Speak this aloud ✨",
      'motivations': "🔥 Let this motivate you 🔥",
      'quotes': "📚 Let this inspire you 📚",
      'jokes': "😂 Share this laugh 😂",
      'compliments': "💝 You deserve this! 💝",
    };
    return actions[widget.serviceId] ?? "✨ Enjoy this content ✨";
  }

  void _showSaveMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Saved to favorites!'),
        backgroundColor: _getColor(),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showShareMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Share feature coming soon!'),
        backgroundColor: _getColor(),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}