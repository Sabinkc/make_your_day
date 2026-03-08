import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final Map<String, dynamic> feature;
  final bool isSelected;
  final VoidCallback onTap;

  const FeatureCard({
    Key? key,
    required this.feature,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                feature['icon'],
                color: isSelected ? Colors.white : Colors.grey.shade700,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.blue.shade800 : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    feature['description'],
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
