import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/glaze_models.dart';

class GlazeApi {
  GlazeApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _url(String path) {
    final base = AppConfig.apiBaseUrl.replaceAll(RegExp(r'/+$'), '');
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$cleanPath');
  }

  Future<GlazeContent> fetchContent() async {
    try {
      final response = await _client.get(_url('/content'));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return const GlazeContent();
      }

      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) return GlazeContent.fromJson(data);
      return const GlazeContent();
    } catch (_) {
      return const GlazeContent();
    }
  }

  Future<List<GlazePost>> fetchPosts() async {
    try {
      final response = await _client.get(_url('/posts'));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return demoPosts;
      }

      final data = jsonDecode(response.body);
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(GlazePost.fromJson)
            .toList();
      }

      return demoPosts;
    } catch (_) {
      return demoPosts;
    }
  }

  Future<List<GlazePost>> fetchUserPosts(String userId) async {
    try {
      final response = await _client.get(_url('/posts?userId=$userId'));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return demoPosts.where((post) => post.user.id == userId).toList();
      }

      final data = jsonDecode(response.body);
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(GlazePost.fromJson)
            .where((post) => post.user.id == userId)
            .toList();
      }

      return demoPosts.where((post) => post.user.id == userId).toList();
    } catch (_) {
      return demoPosts.where((post) => post.user.id == userId).toList();
    }
  }
}

final demoUser = GlazeUser(
  id: 'demo-jeanie',
  displayName: 'Jeanie Ross',
  username: 'heyjeanie',
  bio: 'Building something warm, fast and beautifully social.',
  badge: 'blue',
);

final demoBusinessUser = GlazeUser(
  id: 'demo-diamond',
  displayName: 'Diamond Studio',
  username: 'diamondstudio',
  bio: 'A creative studio testing Glaze.',
  badge: 'green',
);

final demoPosts = <GlazePost>[
  GlazePost(
    id: 'post-1',
    user: demoUser,
    content: 'Glaze feels cleaner when the feed focuses on names, badges and the actual post.',
    createdAt: DateTime(2026, 6, 2),
    likes: 23,
    reGlazes: 4,
    comments: 6,
    liked: true,
  ),
  GlazePost(
    id: 'post-2',
    user: demoBusinessUser,
    content: 'Separate frontend, backend, data and CMS. That is how the rebuild stays stable.',
    createdAt: DateTime(2026, 6, 1),
    likes: 11,
    reGlazes: 2,
    comments: 3,
  ),
];
