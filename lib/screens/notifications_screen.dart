import 'package:flutter/material.dart';

import '../theme/glaze_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Notifications', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                TextButton(onPressed: () {}, child: const Text('Clear')),
              ],
            ),
            const SizedBox(height: 18),
            const _NotificationTile(
              icon: Icons.favorite_rounded,
              title: 'Liked',
              body: 'Someone liked your post.',
            ),
            const _NotificationTile(
              icon: Icons.repeat_rounded,
              title: 'Reglazed',
              body: 'Someone reglazed your post.',
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: GlazeTheme.cardBlack.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: GlazeTheme.orange.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, color: GlazeTheme.orange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15.5)),
                const SizedBox(height: 4),
                Text(body, style: TextStyle(color: Colors.white.withOpacity(0.48), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
