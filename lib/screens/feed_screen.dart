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
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileScreen(user: user)));
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
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 112),
              children: [
                _Header(title: data.content.feedTitle),
                const SizedBox(height: 28),
                _Composer(placeholder: data.content.composerPlaceholder),
                const SizedBox(height: 28),
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
                letterSpacing: 6,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.4,
              ),
            ),
          ],
        ),
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.055),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: const Icon(Icons.add_rounded, color: GlazeTheme.orange, size: 34),
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
      height: 188,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: const Color(0xFF030303),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.075)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 28, backgroundColor: GlazeTheme.orange, child: Text('G', style: TextStyle(fontWeight: FontWeight.w900))),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  placeholder,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.42),
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(height: 1, color: Colors.white.withOpacity(0.08)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Spacer(),
              const Icon(Icons.image_outlined, color: GlazeTheme.orange, size: 27),
              const Spacer(),
              Text('280', style: TextStyle(color: Colors.white.withOpacity(0.72), fontSize: 18, fontWeight: FontWeight.w900)),
              const Spacer(),
              Container(
                width: 142,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: GlazeTheme.orange.withOpacity(0.52),
                  boxShadow: [BoxShadow(color: GlazeTheme.orange.withOpacity(0.13), blurRadius: 24)],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Glaze', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
                    SizedBox(width: 8),
                    Icon(Icons.send_rounded, color: Colors.black, size: 21),
                  ],
                ),
              ),
            ],
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
