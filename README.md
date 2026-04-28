# Swifty Companion

Production-ready Flutter app for the 42 Intra API. Search a login and view the user profile, skills, and projects.

## Architecture

Feature-based clean structure with MVVM, Riverpod, and Dio.

```
lib/
	core/
		error/
		network/
		utils/
	features/
		auth/
		user/
	main.dart
```

## Setup

1. Install dependencies:

```
flutter pub get
```

2. Configure environment variables:

Copy `.env.example` to `.env` and add your 42 credentials.

```
FORTY_TWO_CLIENT_ID=your_client_id_here
FORTY_TWO_CLIENT_SECRET=your_client_secret_here
FORTY_TWO_REDIRECT_URI=swifty://oauth
```

3. Run the app:

```
flutter run
```

## Notes

- OAuth2 uses the client credentials flow by default and auto-refreshes when expired.
- The token is cached in memory to avoid unnecessary calls.
- Errors are surfaced in the UI for common API and network failures.
