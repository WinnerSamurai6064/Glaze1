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
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xFF030303),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white.withOpacity(0.075)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onOpenProfile,
            child: _Avatar(user: post.user),
          ),
          const SizedBox(width: 18),
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
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    GlazeBadge(badge: post.user.badge, size: 18),
                    Text(
                      '•  $_date',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.30),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  post.content,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
                if (post.imageUrl != null) ...[
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(post.imageUrl!),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Action(icon: Icons.chat_bubble_outline_rounded, count: post.comments),
                    _Action(icon: Icons.repeat_rounded, count: post.reGlazes, active: post.reglazed),
                    _Action(icon: post.liked ? Icons.favorite_rounded : Icons.favorite_border_rounded, count: post.likes, active: post.liked),
                    const _Action(icon: Icons.ios_share_rounded),
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

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user});

  final GlazeUser user;

  Color get _fallbackColor {
    if (user.id.contains('young')) return const Color(0xFF005C9E);
    if (user.id.contains('diamond')) return const Color(0xFF5428B8);
    return const Color(0xFF1B1B1D);
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 31,
      backgroundColor: _fallbackColor,
      backgroundImage: user.avatarUrl == null ? null : NetworkImage(user.avatarUrl!),
      child: user.avatarUrl == null
          ? Text(
              user.displayName.characters.first.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            )
          : null,
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, this.count, this.active = false});

  final IconData icon;
  final int? count;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? GlazeTheme.orange : Colors.white.withOpacity(0.34);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        if (count != null) ...[
          const SizedBox(width: 7),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ],
    );
  }
}
