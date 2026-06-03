class AppConfig {
  static const appName = 'Glaze';
  static const tagline = 'Your voice. Glazed.';

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000/api',
  );
}
