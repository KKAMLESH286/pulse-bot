# Security Requirements

## API Key & Token Security
- **NEVER** expose Anthropic API keys or OAuth tokens in Flutter client code
- All Claude API calls are proxied through Firebase Cloud Functions
- All Vertex AI calls happen server-side in Cloud Functions
- `ANTHROPIC_SETUP_TOKEN` is stored in Cloud Functions Secret Manager
- GCP credentials for Vertex AI are implicit in Cloud Functions runtime (no key needed)

## Firebase Auth
- Authentication via Google Sign-In with Firebase Auth
- Auth state checked in GoRouter redirect — unauthenticated users redirected to `/sign-in`
- Use `FirebaseAuth.instance.currentUser` for current user identity
- User ID from auth used as Firestore document path — never trust client-provided user IDs for writes

## Firestore Security Rules
- User-scoped isolation: users can only read/write their own data
- Messages: users can create with `role == "user"` only (prevents role spoofing)
- Workout logs & PRs: read-only for users — writes by Cloud Functions only (admin SDK)
- Agent config: read/write by authenticated user only

## Data Handling
- No sensitive data in logs or print statements
- No hardcoded development URLs (localhost, 127.0.0.1) in committed code
- HTTPS for all API calls

## Environment
- `.env` files never committed to version control
- Firebase config files (`google-services.json`, `GoogleService-Info.plist`) are platform-specific
- No API keys or secrets in Flutter client code — all secrets live in Cloud Functions
