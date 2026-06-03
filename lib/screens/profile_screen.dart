import 'package:flutter/material.dart';

import '../models/glaze_models.dart';
import '../services/glaze_api.dart';
import '../theme/glaze_theme.dart';
import '../widgets/glaze_badge.dart';
import '../widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user, this.showBackButton = true});

  final GlazeUser user;
  final bool showBackButton;

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
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 112),
        children: [
          _ProfileTopBar(user: widget.user, showBackButton: widget.showBackButton),
          _CoverPanel(user: widget.user),
          _ProfileDetails(user: widget.user),
          Divider(color: Colors.white.withOpacity(0.08), height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 14),
            child: Text(
              'My Posts',
              style: const TextStyle(
                color: GlazeTheme.orange,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
          ),
          FutureBuilder<List<GlazePost>>(
            future: _posts,
            builder: (context, snapshot) {
              final posts = snapshot.data ?? demoPosts.where((post) => post.user.id == widget.user.id).toList();

              if (posts.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.035),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Text(
                      'No posts yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(0.55), fontWeight: FontWeight.w700),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(children: [for (final post in posts) PostCard(post: post)]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar({required this.user, required this.showBackButton});

  final GlazeUser user;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.fromLTRB(8, 8, 18, 8),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.075))),
      ),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.close_rounded, size: 34, color: Colors.white54),
            )
          else
            const SizedBox(width: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 0.4),
                      ),
                    ),
                    GlazeBadge(badge: user.badge, size: 21),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '4 posts on post',
                  style: TextStyle(color: Colors.white.withOpacity(0.38), fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 2.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverPanel extends StatelessWidget {
  const _CoverPanel({required this.user});

  final GlazeUser user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              color: const Color(0xFF060606),
              child: user.bannerUrl == null
                  ? Center(
                      child: Text(
                        'Add cover photo',
                        style: TextStyle(color: Colors.white.withOpacity(0.18), fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                    )
                  : Image.network(user.bannerUrl!, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            right: 18,
            top: 18,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.58),
                border: Border.all(color: Colors.white.withOpacity(0.18)),
              ),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 23),
            ),
          ),
          Positioned(
            left: 42,
            bottom: -52,
            child: CircleAvatar(
              radius: 64,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 57,
                backgroundColor: const Color(0xFF1B1B1D),
                backgroundImage: user.avatarUrl == null ? null : NetworkImage(user.avatarUrl!),
                child: user.avatarUrl == null
                    ? Text(user.displayName.characters.first.toUpperCase(), style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900))
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({required this.user});

  final GlazeUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 70, 18, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.14)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                ),
                child: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Flexible(
                child: Text(
                  user.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 0.2),
                ),
              ),
              GlazeBadge(badge: user.badge, size: 23),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '@${user.username}',
            style: TextStyle(color: Colors.white.withOpacity(0.36), fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.8),
          ),
          const SizedBox(height: 22),
          Text(
            user.bio.isEmpty ? 'Connect, explore and discover your voice' : user.bio,
            style: const TextStyle(fontSize: 18, height: 1.45, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Text('${user.following}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
              Text(' Following', style: TextStyle(color: Colors.white.withOpacity(0.42), fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(width: 28),
              Text('${user.followers}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
              Text(' Followers', style: TextStyle(color: Colors.white.withOpacity(0.42), fontSize: 16, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}
