import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final Map<String, dynamic> category;
  final bool isSelected;
  final Function(bool) onSelected;
  final Color? selectedColor;

  const CategoryChip({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onSelected,
    this.selectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category['icon'], size: 16, color: selectedColor ?? Colors.blue),
          SizedBox(width: 4),
          Text(category['category']),
        ],
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.grey.shade100,
      selectedColor: (selectedColor ?? Colors.blue).withOpacity(0.2),
      checkmarkColor: selectedColor ?? Colors.blue,
      labelStyle: TextStyle(
        color: isSelected ? (selectedColor ?? Colors.blue) : Colors.black87,
        fontSize: 13,
      ),
    );
  }
}
