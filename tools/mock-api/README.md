# Yalla mock API (env A)

A dependency-free Node stub of the Spring Boot API, for **local verification only**
(the real Java server can't bind on this machine). It grows one route group per phase.

## Run
```bash
node tools/mock-api/server.mjs        # http://localhost:8080/api
PORT=9090 node tools/mock-api/server.mjs
```

Point the app's **Server URL** at `http://localhost:8080/api` (Flutter web) or your
laptop LAN IP for a device. The real backend on the owner's laptop (env B) is the
source of truth; keep this stub's DTO shapes identical to `fluenta-web/backend`.

## Routes
- Phase 0: `POST /api/auth/login`, `POST /api/auth/logout`, `GET/PATCH /api/me`, `/api/ai/*` → 501.
- (later phases add: `/api/overview`, `/api/exams`, `/api/attempts`, `/api/certificates`,
  `/api/lessons`, `/api/achievements`, `/api/plans`, `/api/progress`, `/api/tracks`, `/api/feedback`.)
