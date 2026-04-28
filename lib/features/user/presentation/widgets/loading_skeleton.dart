import 'package:flutter/material.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(6, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 16,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.06),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
