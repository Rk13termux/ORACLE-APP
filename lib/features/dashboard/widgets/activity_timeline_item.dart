import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityTimelineItem extends StatelessWidget {
  final String title;
  final String type;
  final IconData icon;
  final Color color;
  final DateTime time;

  const ActivityTimelineItem({
    Key? key,
    required this.title,
    required this.type,
    required this.icon,
    required this.color,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 