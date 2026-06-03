# Glaze1

Clean rebuild of **Glaze** as a Flutter/Dart web frontend.

## Product direction

Glaze1 inherits the successful product decisions from the previous prototype, not the broken implementation:

- **Glaze Feed** instead of Timeline/Trace language
- Composer copy: **What’s on your mind?**
- Notifications header: **Notifications** with **Clear** action
- Profile action: **Edit Profile**
- Profile post tab: **My Posts**
- Post success copy: **Your post is live** / **Posted to Glaze**
- Actions: **Liked**, **Reglazed**, **Share post**
- Feed cards show **Display Name + Verified Badge + Date**
- Feed cards do **not** show @username
- Profile header keeps @username underneath the name
- Frontend is separate from backend and data

## Architecture

```txt
Glaze1 Flutter Web frontend
  ↓ calls
Separate Glaze API backend
  ↓ owns
/opt/glaze-data/db.json
/opt/glaze-data/.verified
/opt/glaze-data/content.json
/opt/glaze-data/uploads
```

## Development

```bash
flutter pub get
flutter run -d chrome
```

## Build web

```bash
flutter build web --release
```

The static build is generated in:

```txt
build/web
```

That folder can be deployed to GitHub Pages or copied to the VM behind Caddy.

## API URL

Set the API URL at build time:

```bash
flutter build web --release --dart-define=API_BASE_URL=https://your-domain.com/api
```

No backend secrets belong in Flutter Web. Any API URL used by the browser is public. Security must live on the backend through authentication, ownership checks, rate limiting, validation, and HTTPS.
