# Security Requirements

## Token & Credential Storage
- Store JWT tokens and sensitive credentials in `flutter_secure_storage` — NEVER in SharedPreferences or in-memory only
- Users lose auth on restart if tokens aren't persisted to secure storage

## Dio Interceptors
- `WalletAuthInterceptor` auto-injects JWT from secure storage into request headers
- `CexAuthInterceptor` handles CEX-specific auth headers
- Error interceptor maps HTTP errors to typed `AppException` subclasses
- On 401 response: clear stored credentials and redirect to `/connect`

## Data Handling
- Use BigInt for all token amount arithmetic — no floating-point
- No KYC images persisted locally after upload
- No sensitive data in logs or print statements
- HTTPS for all API calls

## Environment
- `.env` files never committed to version control
- API keys, RPC URLs, and project IDs configured via `.env`
- No hardcoded development URLs (localhost, 127.0.0.1) in committed code
