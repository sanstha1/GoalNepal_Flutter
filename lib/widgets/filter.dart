import 'package:flutter/material.dart';

class Filter extends StatelessWidget {
  final VoidCallback onTap;

  const Filter({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(19),
      ),
      child: const Icon(Icons.filter_list),
    );
  }
}
