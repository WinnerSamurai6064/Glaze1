import 'package:flutter/material.dart';

import '../models/glaze_models.dart';
import '../services/glaze_api.dart';
import '../theme/glaze_theme.dart';
import '../widgets/post_card.dart';
import 'profile_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _api = GlazeApi();
  late Future<_FeedData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_FeedData> _load() async {
    final content = await _api.fetchContent();
    final posts = await _api.fetchPosts();
    return _FeedData(content: content, posts: posts);
  }

  void _openProfile(GlazeUser user) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_FeedData>(
      future: _future,
      builder: (context, snapshot) {
        final data = snapshot.data ?? _FeedData(content: const GlazeContent(), posts: demoPosts);

        return SafeArea(
          child: RefreshIndicator(
            color: GlazeTheme.orange,
            onRefresh: () async {
              setState(() => _future = _load());
              await _future;
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
              children: [
                _Header(title: data.content.feedTitle),
                const SizedBox(height: 18),
                _Composer(placeholder: data.content.composerPlaceholder),
                const SizedBox(height: 18),
                if (data.posts.isEmpty)
                  _EmptyState(text: data.content.emptyPosts)
                else
                  for (final post in data.posts)
                    PostCard(
                      post: post,
                      onOpenProfile: () => _openProfile(post.user),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FeedData {
  const _FeedData({required this.content, required this.posts});

  final GlazeContent content;
  final List<GlazePost> posts;
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GLAZE',
              style: TextStyle(
                color: GlazeTheme.orange,
                fontWeight: FontWeight.w900,
                letterSpacing: 5,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: const Icon(Icons.add_rounded, color: GlazeTheme.orange, size: 31),
        ),
      ],
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.placeholder});

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.045),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 22, backgroundColor: GlazeTheme.orange, child: Text('G')),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              placeholder,
              style: TextStyle(
                color: Colors.white.withOpacity(0.50),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.045),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white.withOpacity(0.55), fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
