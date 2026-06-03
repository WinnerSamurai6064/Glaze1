class GlazeUser {
  const GlazeUser({
    required this.id,
    required this.displayName,
    required this.username,
    this.avatarUrl,
    this.bannerUrl,
    this.email,
    this.bio = '',
    this.badge,
    this.following = 0,
    this.followers = 0,
  });

  final String id;
  final String displayName;
  final String username;
  final String? avatarUrl;
  final String? bannerUrl;
  final String? email;
  final String bio;
  final String? badge;
  final int following;
  final int followers;

  factory GlazeUser.fromJson(Map<String, dynamic> json) {
    return GlazeUser(
      id: '${json['id'] ?? ''}',
      displayName: '${json['displayName'] ?? 'Glazer'}',
      username: '${json['username'] ?? 'glazer'}',
      avatarUrl: json['profilePic'] as String? ?? json['avatarUrl'] as String?,
      bannerUrl: json['bannerPic'] as String? ?? json['bannerUrl'] as String?,
      email: json['email'] as String?,
      bio: '${json['bio'] ?? ''}',
      badge: json['badge'] as String?,
      following: json['following'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
    );
  }
}

class GlazePost {
  const GlazePost({
    required this.id,
    required this.user,
    required this.content,
    required this.createdAt,
    this.imageUrl,
    this.likes = 0,
    this.reGlazes = 0,
    this.comments = 0,
    this.liked = false,
    this.reglazed = false,
  });

  final String id;
  final GlazeUser user;
  final String content;
  final DateTime createdAt;
  final String? imageUrl;
  final int likes;
  final int reGlazes;
  final int comments;
  final bool liked;
  final bool reglazed;

  factory GlazePost.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return GlazePost(
      id: '${json['id'] ?? ''}',
      user: userJson is Map<String, dynamic>
          ? GlazeUser.fromJson(userJson)
          : const GlazeUser(id: 'unknown', displayName: 'Glazer', username: 'glazer'),
      content: '${json['content'] ?? json['text'] ?? ''}',
      createdAt: DateTime.tryParse('${json['createdAt'] ?? ''}') ?? DateTime.now(),
      imageUrl: json['image'] as String? ?? json['imageUrl'] as String?,
      likes: json['likesCount'] as int? ?? json['likes'] as int? ?? 0,
      reGlazes: json['repostsCount'] as int? ?? json['reGlazes'] as int? ?? 0,
      comments: json['commentsCount'] as int? ?? json['comments'] as int? ?? 0,
      liked: json['liked'] as bool? ?? false,
      reglazed: json['reglazed'] as bool? ?? false,
    );
  }
}

class GlazeContent {
  const GlazeContent({
    this.feedTitle = 'Glaze Feed',
    this.composerPlaceholder = 'What’s on your mind?',
    this.notificationsTitle = 'Notifications',
    this.clearNotifications = 'Clear',
    this.profilePostsTitle = 'My Posts',
    this.emptyPosts = 'No posts yet',
    this.postLive = 'Your post is live',
  });

  final String feedTitle;
  final String composerPlaceholder;
  final String notificationsTitle;
  final String clearNotifications;
  final String profilePostsTitle;
  final String emptyPosts;
  final String postLive;

  factory GlazeContent.fromJson(Map<String, dynamic> json) {
    final copy = json['copy'];
    if (copy is! Map<String, dynamic>) return const GlazeContent();

    return GlazeContent(
      feedTitle: '${copy['feedTitle'] ?? 'Glaze Feed'}',
      composerPlaceholder: '${copy['composerPlaceholder'] ?? 'What’s on your mind?'}',
      notificationsTitle: '${copy['notificationsTitle'] ?? 'Notifications'}',
      clearNotifications: '${copy['clearNotifications'] ?? 'Clear'}',
      profilePostsTitle: '${copy['profilePostsTitle'] ?? 'My Posts'}',
      emptyPosts: '${copy['emptyPosts'] ?? 'No posts yet'}',
      postLive: '${copy['postLive'] ?? 'Your post is live'}',
    );
  }
}
