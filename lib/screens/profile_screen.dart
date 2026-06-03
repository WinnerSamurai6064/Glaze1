import 'package:flutter/material.dart';

import '../models/glaze_models.dart';
import '../services/glaze_api.dart';
import '../theme/glaze_theme.dart';
import '../widgets/glaze_badge.dart';
import '../widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final GlazeUser user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _api = GlazeApi();
  late Future<List<GlazePost>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = _api.fetchUserPosts(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: 4),
                const Text('Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 14),
            _ProfileHeader(user: widget.user),
            const SizedBox(height: 24),
            const Text(
              'My Posts',
              style: TextStyle(
                color: GlazeTheme.orange,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 3.2,
              ),
            ),
            const SizedBox(height: 14),
            FutureBuilder<List<GlazePost>>(
              future: _posts,
              builder: (context, snapshot) {
                final posts = snapshot.data ?? demoPosts.where((post) => post.user.id == widget.user.id).toList();

                if (posts.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.045),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Text(
                      'No posts yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(0.55), fontWeight: FontWeight.w700),
                    ),
                  );
                }

                return Column(children: [for (final post in posts) PostCard(post: post)]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final GlazeUser user;

  @override
  Widget build(BuildContext context) {
    final handle = '@' + user.username;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: GlazeTheme.cardBlack.withOpacity(0.94),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: Colors.white.withOpacity(0.10),
                backgroundImage: user.avatarUrl == null ? null : NetworkImage(user.avatarUrl!),
                child: user.avatarUrl == null
                    ? Text(user.displayName.characters.first.toUpperCase(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900))
                    : null,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: GlazeTheme.orange,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: const Text('Edit Profile'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Flexible(
                child: Text(
                  user.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
              ),
              GlazeBadge(badge: user.badge, size: 21),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            handle,
            style: TextStyle(color: Colors.white.withOpacity(0.38), fontSize: 13, fontWeight: FontWeight.w700),
          ),
          if (user.bio.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(user.bio, style: const TextStyle(fontSize: 15.5, height: 1.45)),
          ],
        ],
      ),
    );
  }
}
