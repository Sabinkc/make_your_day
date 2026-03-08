import 'package:flutter/material.dart';

class OnboardingProgress extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingProgress({
    Key? key,
    required this.currentPage,
    required this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: (currentPage + 1) / totalPages,
      backgroundColor: Colors.grey.shade200,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}
