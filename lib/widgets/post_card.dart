import 'package:flutter/material.dart';

import '../models/glaze_models.dart';
import '../theme/glaze_theme.dart';
import 'glaze_badge.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onOpenProfile,
  });

  final GlazePost post;
  final VoidCallback? onOpenProfile;

  String get _date {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${post.createdAt.day} ${months[post.createdAt.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GlazeTheme.cardBlack.withOpacity(0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: GlazeTheme.orange.withOpacity(0.05),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onOpenProfile,
            child: CircleAvatar(
              radius: 27,
              backgroundColor: Colors.white.withOpacity(0.10),
              backgroundImage: post.user.avatarUrl == null ? null : NetworkImage(post.user.avatarUrl!),
              child: post.user.avatarUrl == null
                  ? Text(
                      post.user.displayName.characters.first.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: onOpenProfile,
                        child: Text(
                          post.user.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ),
                    GlazeBadge(badge: post.user.badge, size: 17),
                    Text(
                      _date,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.34),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  post.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (post.imageUrl != null) ...[
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.network(post.imageUrl!),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Action(icon: Icons.chat_bubble_outline_rounded, label: '${post.comments}'),
                    _Action(icon: Icons.repeat_rounded, label: 'Reglazed', active: post.reglazed),
                    _Action(icon: post.liked ? Icons.favorite_rounded : Icons.favorite_border_rounded, label: 'Liked', active: post.liked),
                    const _Action(icon: Icons.ios_share_rounded, label: 'Share post'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, this.active = false});

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? GlazeTheme.orange : Colors.white.withOpacity(0.42);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 21),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
