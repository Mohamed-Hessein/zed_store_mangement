# Production Implementation Guide

## 1. Update pubspec.yaml

Ensure these dependencies are present:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.0.0
  injectable: ^2.3.0
  get_it: ^7.6.0
  dartz: ^0.10.1
  flutter_screenutil: ^5.9.0
  url_launcher: ^6.2.0
  dio: ^5.3.0              # ADD THIS
```

Run: `flutter pub get`

---

## 2. Configure Dio in DI (di.dart)

Add this to your `di.dart` or dependency injection file:

```dart
import 'package:dio/dio.dart';

// ... existing imports ...

@module
abstract class NetworkModule {
  @singleton
  Dio provideDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.zid.sa/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Content-Type'] = 'application/json';
          // Add your auth token here if needed
          // options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  @lazySingleton
  StoreProfileRemoteDataSource provideStoreProfileRemoteDataSource(Dio dio) {
    return StoreProfileRemoteDataSourceImpl(dio);
  }
}
```

Register in `configureDependencies()`:

```dart
// In your configureDependencies() method or where you call getIt.registerModule
getIt.registerModule(NetworkModule());
```

---

## 3. API Endpoint Configuration

The implementation uses these endpoints:

```
GET /stores/profile?include=stats,verification

Response Format:
{
  "store": {
    "id": "store_123",
    "name": "Store Name",
    "logo": {
      "url": "https://..."
    },
    "rating": 4.9,
    "verified": true,
    "productsCount": 1284,
    "createdAt": "2023-10-15T00:00:00Z"
  }
}
```

---

## 4. Authentication (Optional)

If your API requires authentication, update the Dio interceptor:

```dart
onRequest: (options, handler) {
  options.headers['Content-Type'] = 'application/json';
  
  // Add auth token
  final authToken = getIt<AuthService>().getToken();
  if (authToken != null) {
    options.headers['Authorization'] = 'Bearer $authToken';
  }
  
  return handler.next(options);
},
```

---

## 5. Error Handling

The implementation catches:
- DioException (network errors, timeouts, etc.)
- Generic exceptions (JSON parsing errors)
- HTTP error status codes

All errors are wrapped in Failure objects via the repository.

---

## 6. Usage

Navigate to the page:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const StoreProfilePage()),
);

// Or with named route
Navigator.pushNamed(context, '/store-profile');
```

---

## 7. Architecture Summary

```
StoreProfilePage (StatelessWidget)
  ├─ BlocProvider
  │   └─ ProfileBloc
  │       └─ GetStoreProfileUseCase
  │           └─ StoreProfileRepository
  │               └─ StoreProfileRemoteDataSource
  │                   └─ Dio (HTTP Client)
  │
  └─ BlocBuilder
      ├─ Loading State → Spinner
      ├─ Error State → Error UI + Retry
      └─ Success State → Content
          ├─ StoreHeaderCard
          ├─ QuickStatsRow
          └─ SettingsListTile
```

---

## 8. Key Features

✅ **Pure Stateless UI** - No StatefulWidget, no setState
✅ **Bloc State Management** - All state via BlocBuilder
✅ **Real API Integration** - Dio for HTTP requests
✅ **Error Handling** - Comprehensive error states
✅ **Retry Logic** - Users can retry on error
✅ **URL Launcher** - External dashboard links
✅ **Responsive Design** - ScreenUtil scaling
✅ **Production Ready** - Proper error handling, logging support

---

## 9. Testing Checklist

- [ ] App builds without errors
- [ ] Dio is properly configured
- [ ] Navigate to Store Profile page
- [ ] Loading spinner shows
- [ ] Store data loads from API
- [ ] UI renders correctly
- [ ] Settings tiles open URLs
- [ ] Error state works (test by offline mode)
- [ ] Retry button works
- [ ] All responsive sizes work

---

## 10. Troubleshooting

**Issue: "Dio not found"**
- Solution: `flutter pub add dio` and run `flutter pub get`

**Issue: "API returns 401 Unauthorized"**
- Solution: Add auth token in Dio interceptor

**Issue: "CORS errors on web"**
- Solution: Configure CORS on backend API

**Issue: "JSON parsing error"**
- Solution: Check API response matches expected format

---

**Implementation Complete!** 🚀

