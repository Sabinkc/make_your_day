import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceCard extends StatelessWidget {
  final String serviceId;
  final String serviceName;
  final VoidCallback onTap;

  const ServiceCard({
    Key? key,
    required this.serviceId,
    required this.serviceName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              child: Icon(_getIcon(), size: 40, color: _getColor()),
            ),
            SizedBox(height: 15),
            Text(
              serviceName,
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
                _getDescription(),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor() {
    switch (serviceId) {
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

  IconData _getIcon() {
    switch (serviceId) {
      case 'affirmations':
        return Icons.auto_awesome;
      case 'motivations':
        return Icons.trending_up;
      case 'quotes':
        return Icons.format_quote;
      case 'jokes':
        return Icons.emoji_emotions;
      case 'compliments':
        return Icons.favorite;
      default:
        return Icons.category;
    }
  }

  String _getDescription() {
    switch (serviceId) {
      case 'affirmations':
        return 'Positive statements to boost your mindset';
      case 'motivations':
        return 'Fuel for your goals and dreams';
      case 'quotes':
        return 'Wisdom from great minds';
      case 'jokes':
        return 'Light-hearted humor to brighten your day';
      case 'compliments':
        return 'Sweet words to make you smile';
      default:
        return 'Positive content for your day';
    }
  }
}
