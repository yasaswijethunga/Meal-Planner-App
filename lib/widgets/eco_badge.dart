import 'package:flutter/material.dart';

class EcoBadge extends StatelessWidget {
  final int score;

  const EcoBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.eco, size: 14, color: _color),
        const SizedBox(width: 4),
        Text(
          _label,
          style: TextStyle(
            color: _color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Row(
          children: List.generate(
            5,
            (i) => Icon(
              Icons.circle,
              size: 8,
              color: i < score ? _color : Colors.grey.shade300,
            ),
          ),
        ),
      ],
    );
  }

  Color get _color {
    if (score >= 5) return Colors.green.shade700;
    if (score >= 4) return Colors.green;
    if (score >= 3) return Colors.lightGreen;
    if (score >= 2) return Colors.orange;
    return Colors.red;
  }

  String get _label {
    switch (score) {
      case 5:
        return 'Excellent';
      case 4:
        return 'Great';
      case 3:
        return 'Good';
      case 2:
        return 'Fair';
      default:
        return 'Low';
    }
  }
}
