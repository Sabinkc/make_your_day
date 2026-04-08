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

class _CategoryContentScreenState extends State<CategoryContentScreen> {
  final ScrollController _scrollController = ScrollController();
  List<QueryDocumentSnapshot> _contents = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  double _scrollOffset = 0;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _loadContents();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients && _contents.isNotEmpty) {
      final double offset = _scrollController.offset;
      final double itemHeight = MediaQuery.of(context).size.height * 0.65;

      // Calculate which item is currently visible
      int newIndex = ((offset + itemHeight / 2) / itemHeight).floor();
      newIndex = newIndex.clamp(0, _contents.length - 1);

      if (newIndex != _currentIndex && !_isScrolling) {
        setState(() {
          _currentIndex = newIndex;
          _scrollOffset = offset;
        });
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
    final itemHeight = screenHeight * 0.65;

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
                  colors: [themeColor.withOpacity(0.1), Colors.white],
                ),
              ),
              child: Column(
                children: [
                  // Category Info Card
                  _buildInfoCard(themeColor),

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
                        padding: EdgeInsets.symmetric(vertical: 10),
                        physics: const BouncingScrollPhysics(),
                        itemExtent: itemHeight,
                        itemBuilder: (context, index) {
                          final isCurrent = index == _currentIndex;
                          return _buildContentCard(
                            index,
                            isCurrent,
                            themeColor,
                          );
                        },
                      ),
                    ),
                  ),

                  // Navigation Buttons Below
                  _buildNavigationRow(themeColor),
                  const SizedBox(height: 8),
                ],
              ),
            ),
      bottomNavigationBar: _contents.isEmpty
          ? null
          : _buildBottomBar(themeColor),
    );
  }

  Widget _buildInfoCard(Color themeColor) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getSubcategoryIcon(), color: themeColor, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.subcategoryDescription,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_contents.length} items',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
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

  Widget _buildNavigationRow(Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _previous,
              icon: const Icon(Icons.arrow_upward, size: 18),
              label: Text(
                _currentIndex > 0 ? 'Previous' : 'Start',
                style: const TextStyle(fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: themeColor,
                side: BorderSide(color: themeColor),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Current Position Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              '${_currentIndex + 1} / ${_contents.length}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Next Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _next,
              icon: const Icon(Icons.arrow_downward, size: 18),
              label: Text(
                _currentIndex + 1 < _contents.length ? 'Next' : 'End',
                style: const TextStyle(fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(int index, bool isCurrent, Color themeColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isCurrent ? themeColor.withOpacity(0.3) : Colors.black12,
            blurRadius: isCurrent ? 20 : 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isCurrent ? themeColor : themeColor.withOpacity(0.2),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 400),
        scale: isCurrent ? 1.0 : 0.95,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Number Badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: isCurrent ? themeColor : themeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isCurrent ? Colors.white : themeColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Main Icon with Animation
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: Icon(
                  _getMainIcon(),
                  key: ValueKey(index),
                  size: 60,
                  color: themeColor,
                ),
              ),
              const SizedBox(height: 32),

              // Content Text with Slide Transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.2),
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
                child: Text(
                  _getContentValue(index),
                  key: ValueKey(index),
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                    height: 1.4,
                    color: isCurrent ? Colors.black87 : Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 28),

              // Action Text (only for current item)
              if (isCurrent)
                AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  scale: 1.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      _getActionText(),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: themeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              // Scroll Hint
              if (isCurrent && _contents.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.swipe_vertical,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Scroll up/down to navigate',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.swipe_vertical, color: themeColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Scroll vertically • View All to browse',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _showAllContent,
                icon: const Icon(Icons.list, size: 16),
                label: const Text('View All', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(foregroundColor: themeColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Methods ---

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
