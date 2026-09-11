# Yalla Mobile — Phase 0: Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give the Flutter app a real backend data layer — persisted Server URL + token, a typed API client, auth/bootstrap state, and a connectivity/auth gate — so it boots against the Spring Boot API (or the local Node stub) and can log in, replacing the hard-coded mock user.

**Architecture:** A synchronous-getter `AppConfig` (backed by `shared_preferences`) holds the Server URL + token. `ApiClient` wraps `package:http` with bearer auth and a uniform `ApiException`. `AuthState` (ChangeNotifier) owns bootstrap/login/logout/user and a `BootStatus`. The existing `AppState` is slimmed to app-prefs and **delegates** `user`/`isPro`/`isLocked` to `AuthState` (via `bind`), so the ~10 existing screens keep compiling untouched. `go_router` gains a `redirect` driven by `BootStatus` (splash / offline+retry / login / app). A dependency-free **Node stub** serves the same DTOs for local verification (env A), because the Java server can't bind on this machine.

**Tech Stack:** Flutter (Material 3), Dart; `provider`, `go_router` (already present); **new:** `http`, `shared_preferences`. Tests: `flutter_test` + `package:http/testing.dart` `MockClient` + `SharedPreferences.setMockInitialValues`. No code generation — manual `fromJson`/`toJson`.

## Global Constraints

- **Repo/branch:** `D:\personal\fluenta-mobile`, branch `feat/yalla-english-hub-parity` (already checked out).
- **No codegen:** hand-write `fromJson`/`toJson`. Match the backend DTO field names **verbatim** (from `fluenta-web/backend`): user JSON = `id, name, email, initials, avatarUrl, plan("free"|"pro"), planLabel, renewsInDays, targetBand, examDate(ISO date or null), saveHistory, track, examType, purpose, level, onboarded, streak{current,best,last30}`; login response = `{token, user}`; `PATCH /me` accepts a partial patch where `examDate:""` clears the date, `null` leaves unchanged.
- **API base default:** `http://localhost:8080/api` (emulator: `http://10.0.2.2:8080/api`). Persisted keys: `yalla.serverUrl`, `yalla.token`.
- **Rebrand is OUT of P0** — brand strings stay "Fluenta" until Phase 1. P0 is plumbing only.
- **Every task ends green:** `flutter analyze` reports no issues and `flutter test` passes before committing.
- **graphify:** build the baseline in Task 1 and refresh it in Task 10 (standing rule: update graphify whenever code changes).
- **Verify against env A** (the Node stub) — the Java backend cannot bind on this machine.

---

### Task 1: Add dependencies + graphify baseline

**Files:**
- Modify: `pubspec.yaml` (dependencies)

- [ ] **Step 1: Add the two runtime dependencies**

Run:
```bash
cd /d/personal/fluenta-mobile && flutter pub add http shared_preferences
```
Expected: `pubspec.yaml` gains `http:` and `shared_preferences:` under `dependencies`; `flutter pub get` runs automatically.

- [ ] **Step 2: Verify the project still analyzes and tests pass**

Run:
```bash
cd /d/personal/fluenta-mobile && flutter analyze && flutter test
```
Expected: analyze reports "No issues found!"; the existing `test/widget_test.dart` passes.

- [ ] **Step 3: Build the graphify baseline**

Invoke the graphify skill on this repo (`/graphify`) to create/refresh `graphify-out/` for `fluenta-mobile`. This is the baseline every later phase re-indexes against.

- [ ] **Step 4: Commit**

```bash
cd /d/personal/fluenta-mobile && git add pubspec.yaml pubspec.lock graphify-out && git commit -m "chore: add http + shared_preferences; graphify baseline

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 2: AppConfig — persisted Server URL + token

**Files:**
- Create: `lib/config/app_config.dart`
- Test: `test/config/app_config_test.dart`

**Interfaces:**
- Produces: `class AppConfig` with `static Future<AppConfig> load()`, `String get serverUrl`, `Future<void> setServerUrl(String)`, `String? get token`, `Future<void> setToken(String?)`, and `static const String defaultServerUrl`.

- [ ] **Step 1: Write the failing test**

```dart
// test/config/app_config_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluenta_mobile/config/app_config.dart';

void main() {
  test('defaults to localhost when unset', () async {
    SharedPreferences.setMockInitialValues({});
    final config = await AppConfig.load();
    expect(config.serverUrl, 'http://localhost:8080/api');
  });

  test('persists and trims a trailing slash on the server URL', () async {
    SharedPreferences.setMockInitialValues({});
    final config = await AppConfig.load();
    await config.setServerUrl('http://192.168.1.50:8080/api/');
    expect(config.serverUrl, 'http://192.168.1.50:8080/api');
  });

  test('stores and clears the token', () async {
    SharedPreferences.setMockInitialValues({});
    final config = await AppConfig.load();
    expect(config.token, isNull);
    await config.setToken('abc123');
    expect(config.token, 'abc123');
    await config.setToken(null);
    expect(config.token, isNull);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd /d/personal/fluenta-mobile && flutter test test/config/app_config_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:fluenta_mobile/config/app_config.dart'`.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/config/app_config.dart
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted app configuration: the backend base URL and the auth token.
/// Loaded once at startup; getters are synchronous, setters persist immediately.
class AppConfig {
  static const String serverUrlKey = 'yalla.serverUrl';
  static const String tokenKey = 'yalla.token';
  static const String defaultServerUrl = 'http://localhost:8080/api';

  final SharedPreferences _prefs;
  AppConfig(this._prefs);

  static Future<AppConfig> load() async =>
      AppConfig(await SharedPreferences.getInstance());

  String get serverUrl =>
      _normalize(_prefs.getString(serverUrlKey) ?? defaultServerUrl);

  Future<void> setServerUrl(String url) =>
      _prefs.setString(serverUrlKey, _normalize(url));

  String? get token => _prefs.getString(tokenKey);

  Future<void> setToken(String? value) => value == null
      ? _prefs.remove(tokenKey)
      : _prefs.setString(tokenKey, value);

  static String _normalize(String url) =>
      url.trim().replaceAll(RegExp(r'/+$'), '');
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd /d/personal/fluenta-mobile && flutter test test/config/app_config_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

```bash
cd /d/personal/fluenta-mobile && git add lib/config/app_config.dart test/config/app_config_test.dart && git commit -m "feat: AppConfig with persisted server URL + token

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 3: FluentaUser + Streak JSON (de)serialization

**Files:**
- Modify: `lib/models/models.dart` (`Streak` lines 48-53; `FluentaUser` lines 55-99)
- Test: `test/models/fluenta_user_test.dart`

**Interfaces:**
- Consumes: nothing new.
- Produces: `FluentaUser.fromJson(Map<String,dynamic>)`, `FluentaUser.toJson()`, extended `FluentaUser.copyWith({name, targetBand, examDate, clearExamDate, saveHistory, track, examType, purpose, level, onboarded})`, new fields `id, avatarUrl, track?, examType?, purpose?, level?, onboarded`; `Streak.fromJson`, `Streak.toJson`. Existing `const currentUser` (mock/data.dart) must still compile (new fields are defaulted).

- [ ] **Step 1: Write the failing test**

```dart
// test/models/fluenta_user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/models/models.dart';

const _userJson = {
  'id': 'u1', 'name': 'Sara Hamzeh', 'email': 'sara@example.com',
  'initials': 'SH', 'avatarUrl': '', 'plan': 'pro', 'planLabel': 'Pro Monthly',
  'renewsInDays': 7, 'targetBand': 7.0, 'examDate': '2026-12-01',
  'saveHistory': true, 'track': 'ielts', 'examType': 'IELTS (Academic)',
  'purpose': 'Study Abroad', 'level': 'upper-intermediate', 'onboarded': true,
  'streak': {'current': 4, 'best': 11, 'last30': [0, 1, 2, 3]},
};

void main() {
  test('fromJson parses the full backend user shape', () {
    final u = FluentaUser.fromJson(Map<String, dynamic>.from(_userJson));
    expect(u.id, 'u1');
    expect(u.plan, PlanTier.pro);
    expect(u.targetBand, 7.0);
    expect(u.examDate, DateTime(2026, 12, 1));
    expect(u.onboarded, isTrue);
    expect(u.track, 'ielts');
    expect(u.streak.best, 11);
    expect(u.streak.last30, [0, 1, 2, 3]);
  });

  test('fromJson tolerates a null examDate and missing initials', () {
    final json = Map<String, dynamic>.from(_userJson)
      ..['examDate'] = null
      ..remove('initials')
      ..['plan'] = 'free';
    final u = FluentaUser.fromJson(json);
    expect(u.examDate, isNull);
    expect(u.plan, PlanTier.free);
    expect(u.initials, 'SH'); // derived from "Sara Hamzeh"
  });

  test('toJson round-trips examDate as a plain ISO date and plan as a string', () {
    final u = FluentaUser.fromJson(Map<String, dynamic>.from(_userJson));
    final json = u.toJson();
    expect(json['plan'], 'pro');
    expect(json['examDate'], '2026-12-01');
    expect(json['onboarded'], true);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd /d/personal/fluenta-mobile && flutter test test/models/fluenta_user_test.dart`
Expected: FAIL — `The method 'fromJson' isn't defined for the type 'FluentaUser'`.

- [ ] **Step 3: Write minimal implementation**

In `lib/models/models.dart`, replace the `Streak` class (lines 48-53) with:

```dart
class Streak {
  final int current;
  final int best;
  final List<int> last30; // intensity 0..3
  const Streak({required this.current, required this.best, required this.last30});

  factory Streak.fromJson(Map<String, dynamic> json) => Streak(
        current: (json['current'] as num?)?.toInt() ?? 0,
        best: (json['best'] as num?)?.toInt() ?? 0,
        last30: (json['last30'] as List?)
                ?.map((e) => (e as num).toInt())
                .toList() ??
            const [],
      );

  Map<String, dynamic> toJson() =>
      {'current': current, 'best': best, 'last30': last30};
}
```

Replace the `FluentaUser` class (lines 55-99) with:

```dart
class FluentaUser {
  final String id;
  final String name;
  final String email;
  final String initials;
  final String avatarUrl;
  final PlanTier plan;
  final String planLabel;
  final int renewsInDays;
  final double targetBand;
  final DateTime? examDate;
  final bool saveHistory;
  final String? track;
  final String? examType;
  final String? purpose;
  final String? level;
  final bool onboarded;
  final Streak streak;

  const FluentaUser({
    this.id = '',
    required this.name,
    required this.email,
    required this.initials,
    this.avatarUrl = '',
    required this.plan,
    required this.planLabel,
    required this.renewsInDays,
    required this.targetBand,
    required this.examDate,
    required this.saveHistory,
    this.track,
    this.examType,
    this.purpose,
    this.level,
    this.onboarded = false,
    required this.streak,
  });

  factory FluentaUser.fromJson(Map<String, dynamic> json) {
    final examDateRaw = json['examDate'];
    final initialsRaw = json['initials'] as String?;
    return FluentaUser(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      initials: (initialsRaw != null && initialsRaw.isNotEmpty)
          ? initialsRaw
          : _initialsFrom((json['name'] as String?) ?? ''),
      avatarUrl: (json['avatarUrl'] as String?) ?? '',
      plan: _planFrom(json['plan'] as String?),
      planLabel: (json['planLabel'] as String?) ?? 'Free',
      renewsInDays: (json['renewsInDays'] as num?)?.toInt() ?? 0,
      targetBand: (json['targetBand'] as num?)?.toDouble() ?? 6.5,
      examDate: (examDateRaw is String && examDateRaw.isNotEmpty)
          ? DateTime.tryParse(examDateRaw)
          : null,
      saveHistory: (json['saveHistory'] as bool?) ?? true,
      track: json['track'] as String?,
      examType: json['examType'] as String?,
      purpose: json['purpose'] as String?,
      level: json['level'] as String?,
      onboarded: (json['onboarded'] as bool?) ?? false,
      streak: json['streak'] is Map
          ? Streak.fromJson(Map<String, dynamic>.from(json['streak'] as Map))
          : const Streak(current: 0, best: 0, last30: []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'initials': initials,
        'avatarUrl': avatarUrl,
        'plan': plan.name,
        'planLabel': planLabel,
        'renewsInDays': renewsInDays,
        'targetBand': targetBand,
        'examDate': examDate == null
            ? null
            : examDate!.toIso8601String().split('T').first,
        'saveHistory': saveHistory,
        'track': track,
        'examType': examType,
        'purpose': purpose,
        'level': level,
        'onboarded': onboarded,
        'streak': streak.toJson(),
      };

  FluentaUser copyWith({
    String? name,
    double? targetBand,
    DateTime? examDate,
    bool clearExamDate = false,
    bool? saveHistory,
    String? track,
    String? examType,
    String? purpose,
    String? level,
    bool? onboarded,
  }) {
    return FluentaUser(
      id: id,
      name: name ?? this.name,
      email: email,
      initials: initials,
      avatarUrl: avatarUrl,
      plan: plan,
      planLabel: planLabel,
      renewsInDays: renewsInDays,
      targetBand: targetBand ?? this.targetBand,
      examDate: clearExamDate ? null : (examDate ?? this.examDate),
      saveHistory: saveHistory ?? this.saveHistory,
      track: track ?? this.track,
      examType: examType ?? this.examType,
      purpose: purpose ?? this.purpose,
      level: level ?? this.level,
      onboarded: onboarded ?? this.onboarded,
      streak: streak,
    );
  }

  static PlanTier _planFrom(String? s) =>
      s == 'pro' ? PlanTier.pro : PlanTier.free;

  static String _initialsFrom(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
```

- [ ] **Step 4: Run tests to verify they pass (and nothing regressed)**

Run: `cd /d/personal/fluenta-mobile && flutter test test/models/fluenta_user_test.dart && flutter analyze`
Expected: 3 tests PASS; analyze clean (the const `currentUser` still compiles because new fields are defaulted).

- [ ] **Step 5: Commit**

```bash
cd /d/personal/fluenta-mobile && git add lib/models/models.dart test/models/fluenta_user_test.dart && git commit -m "feat: FluentaUser/Streak JSON (de)serialization + new profile fields

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 4: ApiException + ApiClient (core request + auth/me)

**Files:**
- Create: `lib/services/api_client.dart`
- Test: `test/services/api_client_test.dart`

**Interfaces:**
- Consumes: `AppConfig` (Task 2), `FluentaUser` (Task 3).
- Produces:
  - `class ApiException implements Exception { final int status; final String message; }`
  - `class ApiClient` with `ApiClient(AppConfig config, {http.Client? client})`, `Future<({String token, FluentaUser user})> login(String email)`, `Future<void> logout()`, `Future<FluentaUser> getMe()`, `Future<FluentaUser> patchMe(Map<String,dynamic> patch)`.

- [ ] **Step 1: Write the failing test**

```dart
// test/services/api_client_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluenta_mobile/config/app_config.dart';
import 'package:fluenta_mobile/services/api_client.dart';

const _userJson = {
  'id': 'u1', 'name': 'Sara Hamzeh', 'email': 'sara@example.com',
  'initials': 'SH', 'avatarUrl': '', 'plan': 'pro', 'planLabel': 'Pro Monthly',
  'renewsInDays': 7, 'targetBand': 7.0, 'examDate': '2026-12-01',
  'saveHistory': true, 'track': 'ielts', 'examType': 'IELTS (Academic)',
  'purpose': 'Study Abroad', 'level': 'upper-intermediate', 'onboarded': true,
  'streak': {'current': 4, 'best': 11, 'last30': [0, 1, 2, 3]},
};

Future<AppConfig> _config({String? token}) async {
  SharedPreferences.setMockInitialValues(
      token == null ? {} : {AppConfig.tokenKey: token});
  return AppConfig.load();
}

void main() {
  test('login parses token + user and hits /api/auth/login', () async {
    final config = await _config();
    final api = ApiClient(config, client: MockClient((req) async {
      expect(req.url.path, '/api/auth/login');
      expect(jsonDecode(req.body)['email'], 'sara@example.com');
      return http.Response(jsonEncode({'token': 't1', 'user': _userJson}), 200,
          headers: {'content-type': 'application/json'});
    }));
    final result = await api.login('sara@example.com');
    expect(result.token, 't1');
    expect(result.user.name, 'Sara Hamzeh');
    expect(result.user.onboarded, isTrue);
  });

  test('getMe attaches the bearer token', () async {
    final config = await _config(token: 't1');
    late String authHeader;
    final api = ApiClient(config, client: MockClient((req) async {
      authHeader = req.headers['Authorization'] ?? '';
      return http.Response(jsonEncode(_userJson), 200);
    }));
    await api.getMe();
    expect(authHeader, 'Bearer t1');
  });

  test('401 clears the token and throws ApiException(401)', () async {
    final config = await _config(token: 't1');
    final api = ApiClient(config, client: MockClient((req) async => http.Response('', 401)));
    await expectLater(
      api.getMe(),
      throwsA(isA<ApiException>().having((e) => e.status, 'status', 401)),
    );
    expect(config.token, isNull);
  });

  test('network failure surfaces ApiException(0)', () async {
    final config = await _config();
    final api = ApiClient(config, client: MockClient((req) async => throw Exception('down')));
    await expectLater(
      api.login('x@y.com'),
      throwsA(isA<ApiException>().having((e) => e.status, 'status', 0)),
    );
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd /d/personal/fluenta-mobile && flutter test test/services/api_client_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '.../services/api_client.dart'`.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/services/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/models.dart';

/// Thrown for every API failure. `status == 0` means the network/host was
/// unreachable; `status == 401` means the session expired (token cleared).
class ApiException implements Exception {
  final int status;
  final String message;
  ApiException(this.status, this.message);
  @override
  String toString() => 'ApiException($status): $message';
}

class ApiClient {
  final AppConfig config;
  final http.Client _http;
  ApiClient(this.config, {http.Client? client}) : _http = client ?? http.Client();

  Future<T> _request<T>(
    String method,
    String path, {
    Object? body,
    required T Function(dynamic json) decode,
  }) async {
    final uri = Uri.parse('${config.serverUrl}$path');
    http.Response res;
    try {
      final request = http.Request(method, uri);
      final token = config.token;
      if (token != null) request.headers['Authorization'] = 'Bearer $token';
      if (body != null) {
        request.headers['Content-Type'] = 'application/json';
        request.body = jsonEncode(body);
      }
      res = await http.Response.fromStream(await _http.send(request));
    } catch (_) {
      throw ApiException(0,
          "Can't reach the Yalla English Hub API at ${config.serverUrl}. Is the backend running?");
    }

    if (res.statusCode == 401) {
      await config.setToken(null);
      throw ApiException(401, 'Your session has expired. Please sign in again.');
    }
    if (res.statusCode >= 400) {
      var msg = 'Request failed (${res.statusCode})';
      try {
        final data = jsonDecode(res.body);
        if (data is Map && data['error'] is String) msg = data['error'] as String;
      } catch (_) {/* keep default */}
      throw ApiException(res.statusCode, msg);
    }
    if (res.statusCode == 204 || res.body.isEmpty) return decode(null);
    return decode(jsonDecode(res.body));
  }

  Future<({String token, FluentaUser user})> login(String email) =>
      _request('POST', '/auth/login', body: {'email': email}, decode: (json) {
        final map = json as Map<String, dynamic>;
        return (
          token: map['token'] as String,
          user: FluentaUser.fromJson(map['user'] as Map<String, dynamic>),
        );
      });

  Future<void> logout() => _request('POST', '/auth/logout', decode: (_) {});

  Future<FluentaUser> getMe() => _request('GET', '/me',
      decode: (json) => FluentaUser.fromJson(json as Map<String, dynamic>));

  Future<FluentaUser> patchMe(Map<String, dynamic> patch) => _request('PATCH', '/me',
      body: patch,
      decode: (json) => FluentaUser.fromJson(json as Map<String, dynamic>));
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd /d/personal/fluenta-mobile && flutter test test/services/api_client_test.dart`
Expected: PASS (4 tests).

- [ ] **Step 5: Commit**

```bash
cd /d/personal/fluenta-mobile && git add lib/services/api_client.dart test/services/api_client_test.dart && git commit -m "feat: ApiClient (auth/me) + ApiException with 401/offline handling

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 5: AuthState (bootstrap / login / logout)

**Files:**
- Create: `lib/state/auth_state.dart`
- Test: `test/state/auth_state_test.dart`

**Interfaces:**
- Consumes: `AppConfig` (T2), `ApiClient` (T4), `FluentaUser` (T3).
- Produces:
  - `enum BootStatus { booting, offline, unauthed, ready }`
  - `class AuthState extends ChangeNotifier` with ctor `AuthState({required AppConfig config, required ApiClient api})`; getters `BootStatus get status`, `FluentaUser? get user`, `String? get error`, `bool get isAuthed`; methods `Future<void> bootstrap()`, `Future<void> login(String email)`, `Future<void> logout()`, `Future<void> updateMe(Map<String,dynamic> patch)`, `Future<void> retry()`.

- [ ] **Step 1: Write the failing test**

```dart
// test/state/auth_state_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluenta_mobile/config/app_config.dart';
import 'package:fluenta_mobile/services/api_client.dart';
import 'package:fluenta_mobile/state/auth_state.dart';

const _userJson = {
  'id': 'u1', 'name': 'Sara Hamzeh', 'email': 'sara@example.com',
  'initials': 'SH', 'plan': 'pro', 'planLabel': 'Pro Monthly', 'renewsInDays': 7,
  'targetBand': 7.0, 'examDate': null, 'saveHistory': true, 'track': 'ielts',
  'onboarded': true, 'streak': {'current': 1, 'best': 2, 'last30': []},
};

Future<AuthState> _auth({String? token, required MockClient client}) async {
  SharedPreferences.setMockInitialValues(
      token == null ? {} : {AppConfig.tokenKey: token});
  final config = await AppConfig.load();
  return AuthState(config: config, api: ApiClient(config, client: client));
}

void main() {
  test('bootstrap with no token -> unauthed', () async {
    final auth = await _auth(client: MockClient((_) async => http.Response('', 500)));
    await auth.bootstrap();
    expect(auth.status, BootStatus.unauthed);
    expect(auth.user, isNull);
  });

  test('bootstrap with a valid token -> ready + user', () async {
    final auth = await _auth(
        token: 't1',
        client: MockClient((_) async => http.Response(jsonEncode(_userJson), 200)));
    await auth.bootstrap();
    expect(auth.status, BootStatus.ready);
    expect(auth.user?.name, 'Sara Hamzeh');
  });

  test('bootstrap when the host is unreachable -> offline', () async {
    final auth = await _auth(
        token: 't1', client: MockClient((_) async => throw Exception('down')));
    await auth.bootstrap();
    expect(auth.status, BootStatus.offline);
    expect(auth.error, isNotNull);
  });

  test('login stores the token and becomes ready', () async {
    final auth = await _auth(
        client: MockClient((_) async =>
            http.Response(jsonEncode({'token': 't2', 'user': _userJson}), 200)));
    await auth.login('sara@example.com');
    expect(auth.status, BootStatus.ready);
    expect(auth.config.token, 't2');
  });

  test('logout clears the token -> unauthed', () async {
    final auth = await _auth(
        token: 't1',
        client: MockClient((_) async => http.Response('{"ok":true}', 200)));
    await auth.logout();
    expect(auth.status, BootStatus.unauthed);
    expect(auth.config.token, isNull);
    expect(auth.user, isNull);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd /d/personal/fluenta-mobile && flutter test test/state/auth_state_test.dart`
Expected: FAIL — `Target of URI doesn't exist: '.../state/auth_state.dart'`.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/state/auth_state.dart
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../models/models.dart';
import '../services/api_client.dart';

enum BootStatus { booting, offline, unauthed, ready }

/// Source of truth for authentication + the current user + app bootstrap.
class AuthState extends ChangeNotifier {
  final AppConfig config;
  final ApiClient api;
  AuthState({required this.config, required this.api});

  BootStatus _status = BootStatus.booting;
  FluentaUser? _user;
  String? _error;

  BootStatus get status => _status;
  FluentaUser? get user => _user;
  String? get error => _error;
  bool get isAuthed => _user != null;

  Future<void> bootstrap() async {
    _status = BootStatus.booting;
    _error = null;
    notifyListeners();
    if (config.token == null) {
      _status = BootStatus.unauthed;
      notifyListeners();
      return;
    }
    try {
      _user = await api.getMe();
      _status = BootStatus.ready;
    } on ApiException catch (e) {
      if (e.status == 0) {
        _status = BootStatus.offline;
        _error = e.message;
      } else {
        _user = null;
        _status = BootStatus.unauthed;
      }
    }
    notifyListeners();
  }

  Future<void> login(String email) async {
    final result = await api.login(email);
    await config.setToken(result.token);
    _user = result.user;
    _error = null;
    _status = BootStatus.ready;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await api.logout();
    } catch (_) {/* ignore network errors on logout */}
    await config.setToken(null);
    _user = null;
    _status = BootStatus.unauthed;
    notifyListeners();
  }

  Future<void> updateMe(Map<String, dynamic> patch) async {
    _user = await api.patchMe(patch);
    notifyListeners();
  }

  Future<void> retry() => bootstrap();
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd /d/personal/fluenta-mobile && flutter test test/state/auth_state_test.dart`
Expected: PASS (5 tests).

- [ ] **Step 5: Commit**

```bash
cd /d/personal/fluenta-mobile && git add lib/state/auth_state.dart test/state/auth_state_test.dart && git commit -m "feat: AuthState bootstrap/login/logout with BootStatus

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 6: Slim AppState to delegate to AuthState

**Files:**
- Modify: `lib/state/app_state.dart` (whole file)
- Test: existing `test/widget_test.dart` must still pass unchanged.

**Interfaces:**
- Consumes: `AuthState` (T5), `currentUser` (mock/data.dart).
- Produces: `AppState` keeps its public surface (`user`, `previewFree`, `effectivePlan`, `isPro`, `isLocked`, `setPreviewFree`, `setExamDate`, `clearExamDate`, `setSaveHistory`) plus new `void bind(AuthState)` and `String track`. `user` now delegates to the bound `AuthState` (falls back to `currentUser` when unbound, so bare `AppState()` in tests still works).

- [ ] **Step 1: Write the failing test**

```dart
// test/state/app_state_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluenta_mobile/config/app_config.dart';
import 'package:fluenta_mobile/services/api_client.dart';
import 'package:fluenta_mobile/state/auth_state.dart';
import 'package:fluenta_mobile/state/app_state.dart';
import 'package:fluenta_mobile/models/models.dart';

void main() {
  test('unbound AppState falls back to the seed user', () {
    final app = AppState();
    expect(app.user.name, 'Sara Hamzeh'); // from mock/data currentUser
  });

  test('bound AppState reflects the AuthState user and rebuilds on change', () async {
    SharedPreferences.setMockInitialValues({});
    final config = await AppConfig.load();
    const userJson = {
      'id': 'u9', 'name': 'Test Learner', 'email': 't@e.com', 'plan': 'free',
      'planLabel': 'Free', 'renewsInDays': 0, 'targetBand': 6.0, 'examDate': null,
      'saveHistory': true, 'onboarded': true,
      'streak': {'current': 0, 'best': 0, 'last30': []},
    };
    final auth = AuthState(
      config: config,
      api: ApiClient(config,
          client: MockClient((_) async =>
              http.Response(jsonEncode({'token': 't', 'user': userJson}), 200))),
    );
    final app = AppState()..bind(auth);
    var rebuilds = 0;
    app.addListener(() => rebuilds++);
    await auth.login('t@e.com');
    expect(app.user.name, 'Test Learner');
    expect(app.effectivePlan, PlanTier.free);
    expect(rebuilds, greaterThan(0));
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd /d/personal/fluenta-mobile && flutter test test/state/app_state_test.dart`
Expected: FAIL — `The method 'bind' isn't defined for the type 'AppState'`.

- [ ] **Step 3: Write minimal implementation** (replace the whole file)

```dart
// lib/state/app_state.dart
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../mock/data.dart';
import 'auth_state.dart';

/// App-level preferences. The current user + auth live in [AuthState];
/// AppState delegates `user`/plan lookups to it once [bind] is called.
class AppState extends ChangeNotifier {
  AuthState? _auth;
  bool _previewFree = false;
  String track = 'ielts';

  /// Wire this AppState to the AuthState so `user` reflects the signed-in
  /// account and consumers rebuild when auth changes.
  void bind(AuthState auth) {
    _auth = auth;
    auth.addListener(notifyListeners);
  }

  FluentaUser get user => _auth?.user ?? currentUser;
  bool get previewFree => _previewFree;

  PlanTier get effectivePlan => _previewFree ? PlanTier.free : user.plan;
  bool get isPro => effectivePlan == PlanTier.pro;

  /// listening / speaking / full-exam are locked on the free tier.
  bool isLocked(String key) {
    if (effectivePlan == PlanTier.pro) return false;
    return key == 'listening' || key == 'speaking' || key == 'full-exam';
  }

  void setPreviewFree(bool v) {
    _previewFree = v;
    notifyListeners();
  }

  // These now persist through the API (PATCH /me) via AuthState.
  void setExamDate(DateTime date, double targetBand) {
    _auth?.updateMe({
      'examDate': date.toIso8601String().split('T').first,
      'targetBand': targetBand,
    });
  }

  void clearExamDate() => _auth?.updateMe({'examDate': ''});

  void setSaveHistory(bool v) => _auth?.updateMe({'saveHistory': v});
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd /d/personal/fluenta-mobile && flutter test test/state/app_state_test.dart test/widget_test.dart && flutter analyze`
Expected: new app_state tests PASS; the existing `widget_test.dart` (bare `AppState()` → dashboard) still PASSES; analyze clean.

- [ ] **Step 5: Commit**

```bash
cd /d/personal/fluenta-mobile && git add lib/state/app_state.dart test/state/app_state_test.dart && git commit -m "refactor: AppState delegates user/plan to AuthState (keeps screen API)

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 7: Node stub API (env A — local verification)

**Files:**
- Create: `tools/mock-api/server.mjs`
- Create: `tools/mock-api/README.md`

**Interfaces:**
- Produces: an HTTP server on `:8080` serving `POST /api/auth/login` → `{token, user}`, `POST /api/auth/logout` → `{ok:true}`, `GET /api/me` → user, `PATCH /api/me` → merged user (`examDate:""` clears), `/api/ai/*` → 501, everything else → 404. User JSON matches the backend `UserDto` verbatim.

- [ ] **Step 1: Write the stub server**

```js
// tools/mock-api/server.mjs
// Dependency-free stand-in for the Spring Boot API, used for LOCAL verification
// only (the real Java server can't bind on this machine). Run: node tools/mock-api/server.mjs
import { createServer } from 'node:http';

const PORT = process.env.PORT || 8080;

const seedUser = {
  id: 'u1', name: 'Sara Hamzeh', email: 'sara.hamzeh@example.com', initials: 'SH',
  avatarUrl: '', plan: 'pro', planLabel: 'Pro Monthly', renewsInDays: 7,
  targetBand: 7, examDate: '2026-12-01', saveHistory: true, track: 'ielts',
  examType: 'IELTS (Academic)', purpose: 'Study Abroad', level: 'upper-intermediate',
  onboarded: true,
  streak: { current: 4, best: 11, last30: [0,1,0,2,1,3,2,0,0,1,2,3,3,1,0,2,1,0,3,2,1,1,0,2,3,1,2,3,2,3] },
};
let me = { ...seedUser };

function send(res, status, body) {
  res.writeHead(status, {
    'content-type': 'application/json',
    'access-control-allow-origin': '*',
    'access-control-allow-headers': 'authorization,content-type',
    'access-control-allow-methods': 'GET,POST,PATCH,PUT,DELETE,OPTIONS',
  });
  res.end(body == null ? '' : JSON.stringify(body));
}

async function readBody(req) {
  let data = '';
  for await (const chunk of req) data += chunk;
  return data ? JSON.parse(data) : {};
}

createServer(async (req, res) => {
  if (req.method === 'OPTIONS') return send(res, 204, null);
  const { pathname } = new URL(req.url, 'http://localhost');
  try {
    if (pathname === '/api/auth/login' && req.method === 'POST') {
      const b = await readBody(req);
      me = { ...seedUser, email: b.email || seedUser.email };
      return send(res, 200, { token: 'demo-token', user: me });
    }
    if (pathname === '/api/auth/logout') return send(res, 200, { ok: true });
    if (pathname === '/api/me' && req.method === 'GET') return send(res, 200, me);
    if (pathname === '/api/me' && req.method === 'PATCH') {
      const b = await readBody(req);
      if (b.examDate === '') b.examDate = null;
      me = { ...me, ...b };
      return send(res, 200, me);
    }
    if (pathname.startsWith('/api/ai/')) return send(res, 501, { error: 'AI features are coming soon.' });
    return send(res, 404, { error: `No stub for ${req.method} ${pathname}` });
  } catch (e) {
    return send(res, 500, { error: String(e) });
  }
}).listen(PORT, () => console.log(`Yalla stub API on http://localhost:${PORT}/api`));
```

- [ ] **Step 2: Write the README**

```markdown
<!-- tools/mock-api/README.md -->
# Yalla mock API (env A)

A dependency-free Node stub of the Spring Boot API, for **local verification only**
(the real Java server can't bind on this machine). It grows one route per phase.

## Run
```bash
node tools/mock-api/server.mjs        # http://localhost:8080/api
PORT=9090 node tools/mock-api/server.mjs
```

Point the app's **Server URL** at `http://localhost:8080/api` (Flutter web) or your
laptop LAN IP for a device. The real backend on the owner's laptop (env B) is the
source of truth; keep this stub's DTO shapes identical to `fluenta-web/backend`.
```

- [ ] **Step 3: Verify the stub responds**

Run (in a second shell, leave it running):
```bash
cd /d/personal/fluenta-mobile && node tools/mock-api/server.mjs
```
Then:
```bash
curl -s -X POST http://localhost:8080/api/auth/login -H "content-type: application/json" -d '{"email":"a@b.com"}'
curl -s http://localhost:8080/api/me -H "authorization: Bearer demo-token"
```
Expected: login returns `{"token":"demo-token","user":{...}}`; `/me` returns the user JSON.

- [ ] **Step 4: Commit**

```bash
cd /d/personal/fluenta-mobile && git add tools/mock-api && git commit -m "chore: Node stub API for local verification (env A)

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 8: Bootstrap gate (splash/offline) + router redirect + providers

**Files:**
- Create: `lib/features/bootstrap/splash_screen.dart`
- Create: `lib/features/bootstrap/offline_screen.dart`
- Modify: `lib/router.dart` (add `auth` param, `refreshListenable`, `redirect`, `/splash` + `/offline` routes)
- Modify: `lib/main.dart` (async init, providers, `bind`, `bootstrap()`)
- Test: `test/bootstrap_gate_test.dart`

**Interfaces:**
- Consumes: `AuthState`/`BootStatus` (T5), `AppState` (T6), `AppConfig`/`ApiClient` (T2/T4).
- Produces: `GoRouter buildRouter(AuthState auth)`; `SplashScreen`; `OfflineScreen`.

- [ ] **Step 1: Write the failing test**

```dart
// test/bootstrap_gate_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:fluenta_mobile/config/app_config.dart';
import 'package:fluenta_mobile/services/api_client.dart';
import 'package:fluenta_mobile/state/auth_state.dart';
import 'package:fluenta_mobile/state/app_state.dart';
import 'package:fluenta_mobile/router.dart';

Widget _app(AuthState auth, AppState app) => MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider.value(value: app),
      ],
      child: MaterialApp.router(routerConfig: buildRouter(auth)),
    );

void main() {
  testWidgets('offline bootstrap shows the retry screen', (tester) async {
    SharedPreferences.setMockInitialValues({AppConfig.tokenKey: 't1'});
    final config = await AppConfig.load();
    final auth = AuthState(
        config: config,
        api: ApiClient(config, client: MockClient((_) async => throw Exception('down'))));
    final app = AppState()..bind(auth);
    await tester.pumpWidget(_app(auth, app));
    await auth.bootstrap();
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('no token routes to the login screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final config = await AppConfig.load();
    final auth = AuthState(
        config: config,
        api: ApiClient(config, client: MockClient((_) async => http.Response('', 500))));
    final app = AppState()..bind(auth);
    await tester.pumpWidget(_app(auth, app));
    await auth.bootstrap();
    await tester.pumpAndSettle();
    expect(find.textContaining('Welcome back'), findsOneWidget); // login hero copy
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd /d/personal/fluenta-mobile && flutter test test/bootstrap_gate_test.dart`
Expected: FAIL — `buildRouter` expects 0 args / `SplashScreen` undefined.

- [ ] **Step 3: Write the splash + offline screens**

```dart
// lib/features/bootstrap/splash_screen.dart
import 'package:flutter/material.dart';
import '../../config/brand.dart';
import '../../theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: AppColors.warmGradient),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(Brand.name,
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
          ]),
        ),
      ),
    );
  }
}
```

```dart
// lib/features/bootstrap/offline_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth_state.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthState>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off_rounded, size: 56),
            const SizedBox(height: 16),
            const Text("Can't reach the server",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              context.select<AuthState, String?>((a) => a.error) ??
                  'Check the Server URL and that the backend is running on the same network.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: auth.retry, child: const Text('Retry')),
          ]),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Update the router** (replace `lib/router.dart`)

Keep every existing route; add the `auth` parameter, `/splash` + `/offline`, and a `redirect`. Replace the file with:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'state/auth_state.dart';
import 'features/bootstrap/splash_screen.dart';
import 'features/bootstrap/offline_screen.dart';
import 'features/shell/app_shell.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/practice/practice_hub_screen.dart';
import 'features/progress/progress_screen.dart';
import 'features/coach/coach_screen.dart';
import 'features/more/more_screen.dart';
import 'features/reading/reading_hub_screen.dart';
import 'features/reading/reading_runner_screen.dart';
import 'features/reading/reading_results_screen.dart';
import 'features/writing/writing_hub_screen.dart';
import 'features/writing/writing_editor_screen.dart';
import 'features/writing/writing_results_screen.dart';
import 'features/listening/listening_screen.dart';
import 'features/speaking/speaking_screen.dart';
import 'features/full_exam/full_exam_screen.dart';
import 'features/mock_exams/mock_exams_screen.dart';
import 'features/lessons/lessons_screen.dart';
import 'features/achievements/achievements_screen.dart';
import 'features/certificates/certificates_screen.dart';
import 'features/checkout/checkout_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/help/help_screen.dart';
import 'features/auth/login_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

GoRouter buildRouter(AuthState auth) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    refreshListenable: auth,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      switch (auth.status) {
        case BootStatus.booting:
          return loc == '/splash' ? null : '/splash';
        case BootStatus.offline:
          return loc == '/offline' ? null : '/offline';
        case BootStatus.unauthed:
          return loc == '/login' ? null : '/login';
        case BootStatus.ready:
          if (loc == '/splash' || loc == '/offline' || loc == '/login') return '/';
          return null;
      }
    },
    errorBuilder: (context, state) => const _NotFoundRedirect(),
    routes: [
      GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/offline', builder: (c, s) => const OfflineScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/', builder: (c, s) => const DashboardScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/practice', builder: (c, s) => const PracticeHubScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/progress', builder: (c, s) => const ProgressScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/coach', builder: (c, s) => const CoachScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/more', builder: (c, s) => const MoreScreen())]),
        ],
      ),
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/reading', builder: (c, s) => const ReadingHubScreen()),
      GoRoute(path: '/writing', builder: (c, s) => const WritingHubScreen()),
      GoRoute(path: '/listening', builder: (c, s) => const ListeningScreen()),
      GoRoute(path: '/speaking', builder: (c, s) => const SpeakingScreen()),
      GoRoute(path: '/full-exam', builder: (c, s) => const FullExamScreen()),
      GoRoute(path: '/mock-exams', builder: (c, s) => const MockExamsScreen()),
      GoRoute(path: '/lessons', builder: (c, s) => const LessonsScreen()),
      GoRoute(path: '/achievements', builder: (c, s) => const AchievementsScreen()),
      GoRoute(path: '/certificates', builder: (c, s) => const CertificatesScreen()),
      GoRoute(path: '/checkout', builder: (c, s) => const CheckoutScreen()),
      GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
      GoRoute(path: '/help', builder: (c, s) => const HelpScreen()),
      GoRoute(path: '/exam/reading', builder: (c, s) => const ReadingRunnerScreen()),
      GoRoute(path: '/results/reading', builder: (c, s) => const ReadingResultsScreen()),
      GoRoute(path: '/exam/writing/:id', builder: (c, s) => WritingEditorScreen(taskId: s.pathParameters['id']!)),
      GoRoute(path: '/results/writing/:id', builder: (c, s) => const WritingResultsScreen()),
    ],
  );
}

class _NotFoundRedirect extends StatefulWidget {
  const _NotFoundRedirect();
  @override
  State<_NotFoundRedirect> createState() => _NotFoundRedirectState();
}

class _NotFoundRedirectState extends State<_NotFoundRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
```

- [ ] **Step 5: Update main.dart** (replace `lib/main.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_config.dart';
import 'config/brand.dart';
import 'router.dart';
import 'services/api_client.dart';
import 'state/app_state.dart';
import 'state/auth_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await AppConfig.load();
  final auth = AuthState(config: config, api: ApiClient(config));
  final app = AppState()..bind(auth);
  auth.bootstrap(); // fire-and-forget; the gate reacts to status
  runApp(FluentaApp(auth: auth, app: app));
}

class FluentaApp extends StatelessWidget {
  final AuthState auth;
  final AppState app;
  const FluentaApp({super.key, required this.auth, required this.app});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider.value(value: app),
      ],
      child: MaterialApp.router(
        title: Brand.name,
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        routerConfig: buildRouter(auth),
      ),
    );
  }
}
```

- [ ] **Step 6: Run tests to verify they pass**

Run: `cd /d/personal/fluenta-mobile && flutter test test/bootstrap_gate_test.dart && flutter analyze`
Expected: both widget tests PASS; analyze clean.

> Note: the login screen still shows its current placeholder "Continue with Google" copy (it contains "Welcome back", satisfying the test). Real login wiring is Task 9.

- [ ] **Step 7: Commit**

```bash
cd /d/personal/fluenta-mobile && git add lib/features/bootstrap lib/router.dart lib/main.dart test/bootstrap_gate_test.dart && git commit -m "feat: bootstrap gate (splash/offline) + status-driven router redirect

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 9: Wire the login screen to the API (email + Server URL)

**Files:**
- Modify: `lib/features/auth/login_screen.dart` (convert to `StatefulWidget`; replace the Google button with the real form)
- Test: `test/login_screen_test.dart`

**Interfaces:**
- Consumes: `AuthState.login` (T5), `AppConfig` (via `AuthState.config`, T2), `Brand`/`AppColors` (existing).
- Produces: a login form with an email `TextField`, an editable **Server URL** `TextField` (pre-filled from `config.serverUrl`, saved on sign-in), and a **Sign in** button that calls `auth.login(email)` and shows a SnackBar on `ApiException`.

- [ ] **Step 1: Write the failing test**

```dart
// test/login_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fluenta_mobile/config/app_config.dart';
import 'package:fluenta_mobile/services/api_client.dart';
import 'package:fluenta_mobile/state/auth_state.dart';
import 'package:fluenta_mobile/features/auth/login_screen.dart';

const _userJson = {
  'id': 'u1', 'name': 'Sara Hamzeh', 'email': 's@e.com', 'plan': 'pro',
  'planLabel': 'Pro', 'renewsInDays': 7, 'targetBand': 7.0, 'examDate': null,
  'saveHistory': true, 'onboarded': true, 'streak': {'current': 0, 'best': 0, 'last30': []},
};

void main() {
  testWidgets('signing in calls the API and stores the token', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final config = await AppConfig.load();
    final auth = AuthState(
      config: config,
      api: ApiClient(config, client: MockClient((_) async =>
          http.Response(jsonEncode({'token': 'tk', 'user': _userJson}), 200))),
    );
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: auth,
      child: const MaterialApp(home: LoginScreen()),
    ));
    await tester.enterText(find.byKey(const Key('login-email')), 's@e.com');
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    expect(config.token, 'tk');
    expect(auth.status, BootStatus.ready);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd /d/personal/fluenta-mobile && flutter test test/login_screen_test.dart`
Expected: FAIL — no widget with key `login-email`.

- [ ] **Step 3: Rewrite the login screen** (replace `lib/features/auth/login_screen.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/brand.dart';
import '../../services/api_client.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _serverUrl;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthState>();
    _email = TextEditingController(text: 'sara.hamzeh@example.com');
    _serverUrl = TextEditingController(text: auth.config.serverUrl);
  }

  @override
  void dispose() {
    _email.dispose();
    _serverUrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final auth = context.read<AuthState>();
    setState(() => _busy = true);
    try {
      await auth.config.setServerUrl(_serverUrl.text);
      await auth.login(_email.text.trim());
      // The router redirect moves us to '/' once status == ready.
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 36),
              decoration: const BoxDecoration(
                gradient: AppColors.warmGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: const Text('F',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
                  ),
                  const SizedBox(width: 10),
                  const Text(Brand.name,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 24),
                const Text(Brand.tagline,
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, height: 1.2)),
                const SizedBox(height: 8),
                const Text(Brand.shortPitch, style: TextStyle(color: Colors.white70, height: 1.4)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Welcome back',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const Text('Sign in to continue your IELTS journey.',
                    style: TextStyle(color: AppColors.mutedForeground)),
                const SizedBox(height: 20),
                TextField(
                  key: const Key('login-email'),
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('login-server-url'),
                  controller: _serverUrl,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Server URL',
                    helperText: 'e.g. http://192.168.1.50:8080/api',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('login-submit'),
                    style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
                    onPressed: _busy ? null : _signIn,
                    child: _busy
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Sign in'),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text('Prototype — any email signs you in against the configured server.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11.5, color: AppColors.mutedForeground)),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd /d/personal/fluenta-mobile && flutter test test/login_screen_test.dart test/bootstrap_gate_test.dart && flutter analyze`
Expected: login test PASS; the gate test still PASS ("Welcome back" copy retained); analyze clean.

- [ ] **Step 5: Commit**

```bash
cd /d/personal/fluenta-mobile && git add lib/features/auth/login_screen.dart test/login_screen_test.dart && git commit -m "feat: real login form (email + editable Server URL) wired to the API

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

### Task 10: Phase wrap — end-to-end verification against the stub + graphify refresh

**Files:** none (verification + graphify).

- [ ] **Step 1: Full test suite + analyze**

Run: `cd /d/personal/fluenta-mobile && flutter analyze && flutter test`
Expected: analyze "No issues found!"; all test files pass (config, models, api_client, auth_state, app_state, bootstrap_gate, login_screen, widget_test).

- [ ] **Step 2: End-to-end run against the Node stub (env A)**

In shell A: `cd /d/personal/fluenta-mobile && node tools/mock-api/server.mjs`
In shell B: `cd /d/personal/fluenta-mobile && flutter run -d chrome` (size the window to a phone).

Verify manually:
- App opens on the branded **splash**, then lands on **login** (no token yet).
- Sign in with the pre-filled email and Server URL `http://localhost:8080/api` → the app navigates to the home dashboard.
- Stop the Node stub, then hot-restart the app → after the splash it shows the **offline + Retry** screen; start the stub and tap **Retry** → it recovers to the app.

Capture a screenshot of the login screen and the dashboard for the owner-facing progress note.

- [ ] **Step 3: Refresh graphify**

Invoke the graphify skill (`/graphify`) to re-index the new/changed files (config, services, state, router, bootstrap, login). Confirm `graphify-out/` updates.

- [ ] **Step 4: Commit any graphify output + push the branch**

```bash
cd /d/personal/fluenta-mobile && git add graphify-out && git commit -m "chore: graphify refresh after P0 foundation

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>" && git push -u origin feat/yalla-english-hub-parity
```

> Push only if the user has asked to push. Otherwise stop after the commit.

---

## Self-Review

**1. Spec coverage (P0 items from `2026-09-11-yalla-mobile-parity-design.md` §7 P0):**
- `http` + `shared_preferences` → Task 1. ✅
- `app_config` + persisted Server URL → Task 2. ✅
- `api_client` (auth/me core + error model) → Task 4. Remaining endpoint groups (exams/attempts/content/overview/feedback) are added in the phases that consume them, per the spec's "added per phase" note — noted here so P1+ plans extend `ApiClient`. ✅ (scoped)
- Split `AuthState`/`AppState` → Tasks 5-6. ✅
- Bootstrap gate (splash / offline+Retry) → Task 8. ✅
- Token persistence → Task 2 (storage) + Task 5 (lifecycle). ✅
- Node stub API (env A) → Task 7. ✅

**2. Placeholder scan:** No "TBD"/"add error handling"/"similar to Task N". Every code and test step carries real, complete content. The one forward-reference (login copy in Task 8 note) is explicitly resolved in Task 9. ✅

**3. Type consistency:** `AppConfig` (`serverUrl`, `token`, `setServerUrl`, `setToken`, `tokenKey`, `defaultServerUrl`) used identically across Tasks 2/4/5/8/9. `ApiClient.login` returns `({String token, FluentaUser user})` — consumed with `.token`/`.user` in Task 5. `BootStatus{booting,offline,unauthed,ready}` used the same in Tasks 5/8. `AuthState` ctor `{required config, required api}` and methods `bootstrap/login/logout/updateMe/retry` consistent in Tasks 5/6/8/9. `buildRouter(AuthState)` signature matches Tasks 8 (def) and 8/main + gate test (callers). ✅

**Out of P0 (later phases, by design):** rebrand strings, onboarding, Overview home, 6-skill grid, exam runners→attempts, speaking modes, achievements/certificates/feedback/tracks, 4-tab restructure (P0 keeps the current 5-branch shell to stay plumbing-only; the `/progress` branch is dropped in P2).
