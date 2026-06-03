import 'package:flutter/material.dart';

import '../theme/glaze_theme.dart';
import 'feed_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import '../services/glaze_api.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final _screens = <Widget>[
    const FeedScreen(),
    const _ExploreScreen(),
    const NotificationsScreen(),
    const _MessagesScreen(),
    ProfileScreen(user: demoUser),
  ];

  void _openComposer() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ComposerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: _openComposer,
          backgroundColor: GlazeTheme.orange,
          foregroundColor: Colors.black,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 38),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 82,
        color: Colors.black.withOpacity(0.96),
        elevation: 0,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavButton(icon: Icons.home_rounded, active: _index == 0, onTap: () => setState(() => _index = 0)),
            _NavButton(icon: Icons.search_rounded, active: _index == 1, onTap: () => setState(() => _index = 1)),
            _NavButton(icon: Icons.notifications_none_rounded, active: _index == 2, onTap: () => setState(() => _index = 2)),
            const SizedBox(width: 52),
            _NavButton(icon: Icons.mail_outline_rounded, active: _index == 3, onTap: () => setState(() => _index = 3)),
            _NavButton(icon: Icons.person_outline_rounded, active: _index == 4, onTap: () => setState(() => _index = 4)),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.active, required this.onTap});

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 29),
      color: active ? GlazeTheme.orange : Colors.white.withOpacity(0.42),
    );
  }
}

class _ComposerSheet extends StatelessWidget {
  const _ComposerSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
        decoration: const BoxDecoration(
          color: Color(0xFF050505),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('What’s on your mind?', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 5,
              minLines: 3,
              decoration: const InputDecoration(hintText: 'Write something for Glaze...'),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Your post is live')),
                  );
                },
                icon: const Icon(Icons.send_rounded),
                label: const Text('Glaze'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreScreen extends StatelessWidget {
  const _ExploreScreen();

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderScreen(title: 'Explore', body: 'Discover new Glazers and posts.');
  }
}

class _MessagesScreen extends StatelessWidget {
  const _MessagesScreen();

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderScreen(title: 'Messages', body: 'Direct messages will connect to the API next.');
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: GlazeTheme.cardBlack.withOpacity(0.92),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Text(body, style: TextStyle(color: Colors.white.withOpacity(0.62), fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
