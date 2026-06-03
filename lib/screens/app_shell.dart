import 'package:flutter/material.dart';

import '../services/glaze_api.dart';
import '../theme/glaze_theme.dart';
import 'feed_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

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
    ProfileScreen(user: demoUser, showBackButton: false),
    const _SettingsScreen(),
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
      extendBody: true,
      body: IndexedStack(index: _index, children: _screens),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          onPressed: _openComposer,
          backgroundColor: GlazeTheme.orange,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 40),
        ),
      ),
      bottomNavigationBar: Container(
        height: 88,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.94),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.075))),
          boxShadow: [
            BoxShadow(
              color: GlazeTheme.orange.withOpacity(0.08),
              blurRadius: 38,
              offset: const Offset(0, -14),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavButton(icon: Icons.home_outlined, active: _index == 0, onTap: () => setState(() => _index = 0)),
              _NavButton(icon: Icons.explore_outlined, active: _index == 1, onTap: () => setState(() => _index = 1)),
              _NavButton(icon: Icons.notifications_none_rounded, active: _index == 2, onTap: () => setState(() => _index = 2)),
              const SizedBox(width: 78),
              _NavButton(icon: Icons.mail_outline_rounded, active: _index == 3, onTap: () => setState(() => _index = 3)),
              _NavButton(icon: Icons.person_outline_rounded, active: _index == 4, onTap: () => setState(() => _index = 4)),
              _NavButton(icon: Icons.settings_outlined, active: _index == 5, onTap: () => setState(() => _index = 5)),
            ],
          ),
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
      icon: Icon(icon, size: 31),
      color: active ? GlazeTheme.orange : Colors.white.withOpacity(0.42),
      splashRadius: 28,
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
    return const _QuietScreen(title: 'Explore');
  }
}

class _MessagesScreen extends StatelessWidget {
  const _MessagesScreen();

  void _openChat(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _ChatScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 112),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Direct Messages', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 0.2)),
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.055),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: const Icon(Icons.add_rounded, color: GlazeTheme.orange, size: 31),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => _openChat(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF030303),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withOpacity(0.075)),
              ),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const CircleAvatar(radius: 34, backgroundColor: Color(0xFF1B1B1D), child: Text('J', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900))),
                      Positioned(
                        right: -2,
                        top: -7,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: GlazeTheme.orange, shape: BoxShape.circle),
                          child: const Text('1', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Flexible(child: Text('Jeanie Ross', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900))),
                            const SizedBox(width: 6),
                            Icon(Icons.verified, color: const Color(0xFF1DA1F2), size: 22, shadows: [Shadow(color: const Color(0xAA1DA1F2), blurRadius: 12)]),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text('hi diamond', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Text('18:10', style: TextStyle(color: Colors.white.withOpacity(0.42), fontSize: 14, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatScreen extends StatelessWidget {
  const _ChatScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 16, 12),
              child: Row(
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded, size: 30)),
                  const CircleAvatar(radius: 22, backgroundColor: Color(0xFF1B1B1D), child: Text('J')),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Jeanie Ross', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
                  Icon(Icons.verified, color: const Color(0xFF1DA1F2), size: 22, shadows: [Shadow(color: const Color(0xAA1DA1F2), blurRadius: 12)]),
                ],
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.08), height: 1),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(14),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Write message...',
                  suffixIcon: const Icon(Icons.send_rounded, color: GlazeTheme.orange),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(999)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 112),
        children: [
          const Text('Settings', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF030303),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.075)),
            ),
            child: Row(
              children: [
                const CircleAvatar(radius: 34, backgroundColor: Color(0xFF5428B8), child: Text('D', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900))),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Diamond Dee', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      Text('@diamond', style: TextStyle(color: Colors.white.withOpacity(0.38), fontSize: 14, fontWeight: FontWeight.w700)),
                      Text('gradedmaloka@gmail.com', style: TextStyle(color: Colors.white.withOpacity(0.38), fontSize: 13, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuietScreen extends StatelessWidget {
  const _QuietScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 112),
        child: Text(title, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
      ),
    );
  }
}
