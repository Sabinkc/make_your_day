import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> points;
  final Color color;

  const InfoContainer({
    Key? key,
    required this.title,
    required this.icon,
    required this.points,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ...points.map(
            (point) => Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: color)),
                  Expanded(child: Text(point)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
