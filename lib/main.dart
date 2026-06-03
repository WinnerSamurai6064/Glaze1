import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'screens/feed_screen.dart';
import 'theme/glaze_theme.dart';

void main() {
  runApp(const GlazeApp());
}

class GlazeApp extends StatelessWidget {
  const GlazeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      theme: GlazeTheme.dark(),
      home: const FeedScreen(),
    );
  }
}
