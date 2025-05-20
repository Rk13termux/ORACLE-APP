import 'package:flutter/material.dart';
import 'package:vida_organizada/config/themes.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final String trend;
  final bool trendUp;
  final VoidCallback? onTap;

  const MetricCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.trend,
    required this.trendUp,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black38,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: iconColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (trendUp ? Colors.green : Colors.red).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          trendUp ? Icons.trending_up : Icons.trending_down,
                          color: trendUp ? Colors.green : Colors.red,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          trend,
                          style: TextStyle(
                            fontSize: 12,
                            color: trendUp ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}