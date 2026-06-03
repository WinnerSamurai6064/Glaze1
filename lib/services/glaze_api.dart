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
        return data.whereType<Map<String, dynamic>>().map(GlazePost.fromJson).toList();
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
  email: 'halexbody@gmail.com',
  bio: 'Connect, explore and discover your voice',
  badge: 'blue',
  following: 1,
  followers: 2,
);

final demoYoungScottish = GlazeUser(
  id: 'demo-young-scottish',
  displayName: 'Young Scottish',
  username: 'youngscottish',
);

final demoDiamond = GlazeUser(
  id: 'demo-diamond',
  displayName: 'Diamond Dee',
  username: 'diamond',
  email: 'gradedmaloka@gmail.com',
  bio: 'Connect, explore and discover your voice',
  following: 1,
  followers: 2,
);

final demoPosts = <GlazePost>[
  GlazePost(
    id: 'post-young-1',
    user: demoYoungScottish,
    content: 'what a great day',
    createdAt: DateTime(2026, 6, 2),
    likes: 2,
  ),
  GlazePost(
    id: 'post-jeanie-1',
    user: demoUser,
    content: 'hang on , the ride is about to begin',
    createdAt: DateTime(2026, 6, 2),
    likes: 1,
    reGlazes: 1,
  ),
  GlazePost(
    id: 'post-lawrence-1',
    user: const GlazeUser(id: 'demo-lawrence', displayName: 'Lawrence', username: 'lawdarence'),
    content: 'I could have sworn I saw a rat',
    createdAt: DateTime(2026, 6, 2),
  ),
];
