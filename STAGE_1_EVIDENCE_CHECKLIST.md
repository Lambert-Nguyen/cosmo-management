# Stage 1 Exit Evidence Checklist

## Overview

This document tracks the evidence required to exit Stage 1 (Alpha) and proceed to Stage 2 (Beta).
All items must be completed and verified before advancing.

**Stage 1 Goal:** Validate new architecture with working mobile app
**Deliverable:** Authentication + Staff Task Management on mobile with offline support

---

## 1. Test Coverage Requirements

### 1.1 Service Layer Coverage (Target: >= 80%)

| Component | Coverage | Status |
|-----------|----------|--------|
| `auth_service.dart` | __%  | [ ] |
| `task_service.dart` | __%  | [ ] |
| `offline_mutation_repository.dart` | __%  | [ ] |
| `offline_sync_notifier.dart` | __%  | [ ] |
| `connectivity_service.dart` | __%  | [ ] |
| `api_service.dart` | __%  | [ ] |
| **Overall Service Layer** | __%  | [ ] |

**Evidence Location:** `cosmo_app/coverage/lcov.info`

**Commands to generate:**
```bash
cd cosmo_app
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### 1.2 Widget Tests

| Screen | Tests Exist | Tests Pass | Status |
|--------|-------------|------------|--------|
| Login Screen | [ ] | [ ] | |
| Registration Screen | [ ] | [ ] | |
| Forgot Password Screen | [ ] | [ ] | |
| Staff Task List Screen | [ ] | [ ] | |
| Staff Task Detail Screen | [ ] | [ ] | |
| Task Checklist Screen | [ ] | [ ] | |
| Offline Sync Status Widget | [ ] | [ ] | |

**Evidence Location:** `cosmo_app/test/` directory

---

## 2. Offline Test Suite

### 2.1 Task Operations (Zero Duplicates)

| Test Case | Expected | Actual | Pass |
|-----------|----------|--------|------|
| Task list loads when offline | Cached tasks display | | [ ] |
| Create task offline, sync online | Single task created | | [ ] |
| Edit task offline, sync online | Single update applied | | [ ] |
| Complete task offline, sync online | Single status change | | [ ] |
| Delete task offline, sync online | Single deletion | | [ ] |

### 2.2 Idempotency Replay Tests

| Test Case | Expected | Actual | Pass |
|-----------|----------|--------|------|
| Replay create mutation 3x | 1 task created (deduped) | | [ ] |
| Replay update mutation 3x | 1 update applied (deduped) | | [ ] |
| Replay status change 3x | 1 status change (deduped) | | [ ] |
| Verify `X-Idempotency-Key` header sent | Header present in requests | | [ ] |
| Verify server returns cached response | 200 with same body | | [ ] |

### 2.3 Photo Queue Replay

| Test Case | Expected | Actual | Pass |
|-----------|----------|--------|------|
| Queue photo upload offline | Photo stored in queue | | [ ] |
| Sync photos when online | Photos uploaded once | | [ ] |
| Retry failed upload | No duplicate uploads | | [ ] |
| Checksum validation | Duplicates skipped | | [ ] |

### 2.4 Sync Conflict Resolution

| Test Case | Expected | Actual | Pass |
|-----------|----------|--------|------|
| Server data newer than local | Server wins | | [ ] |
| Local data newer than server | Merge applied | | [ ] |
| Concurrent edits to same task | Conflict UI shown | | [ ] |
| User chooses "Keep Local" | Local changes applied | | [ ] |
| User chooses "Discard" | Server version kept | | [ ] |

**Evidence:** Screenshots or test logs showing zero duplicate mutations

---

## 3. Staging Smoke Checklist

### 3.1 Authentication Flow

| Step | Verified | Tester | Date |
|------|----------|--------|------|
| User registration with invite code | [ ] | | |
| User login with valid credentials | [ ] | | |
| User login with invalid credentials (error shown) | [ ] | | |
| JWT token refresh on expiry | [ ] | | |
| Logout clears tokens | [ ] | | |
| Password reset email sent | [ ] | | |

### 3.2 Task Management Flow

| Step | Verified | Tester | Date |
|------|----------|--------|------|
| View task list (assigned tasks) | [ ] | | |
| View task detail | [ ] | | |
| Update task status | [ ] | | |
| Complete checklist items | [ ] | | |
| Upload task photo | [ ] | | |
| Assign task to self | [ ] | | |

### 3.3 Offline-Online Cycle Test

**Test Procedure:**
1. [ ] Start app online, load task list
2. [ ] Enable airplane mode (offline)
3. [ ] Perform offline actions:
   - [ ] View cached tasks
   - [ ] Update task status
   - [ ] Complete checklist item
   - [ ] Queue photo upload
4. [ ] Verify offline indicator shown
5. [ ] Disable airplane mode (online)
6. [ ] Verify sync progress indicator
7. [ ] Verify all changes synced
8. [ ] Verify no duplicate data on server
9. [ ] Verify no duplicate data in app

**Tester:** _______________
**Date:** _______________
**Result:** [ ] PASS  [ ] FAIL

---

## 4. Backend Verification

### 4.1 Idempotency Middleware

| Check | Verified | Status |
|-------|----------|--------|
| `IdempotencyKey` model exists | [ ] | |
| Migration `0080_idempotencykey.py` applied | [ ] | |
| Middleware registered in settings | [ ] | |
| Keys stored on successful mutation | [ ] | |
| Duplicate requests return cached response | [ ] | |

### 4.2 API Endpoints

| Endpoint | Tested | Works |
|----------|--------|-------|
| `POST /api/tasks/` | [ ] | [ ] |
| `PATCH /api/tasks/{id}/` | [ ] | [ ] |
| `POST /api/tasks/{id}/set-status/` | [ ] | [ ] |
| `POST /api/tasks/{id}/assign-to-me/` | [ ] | [ ] |
| `POST /api/tasks/{id}/checklist/respond/` | [ ] | [ ] |

---

## 5. Sign-Off

### Stage 1 Gate Approval

| Criterion | Met | Evidence |
|-----------|-----|----------|
| Services smoke-tested (auth, tasks, sync) | [ ] | Section 3 |
| Offline suite: zero duplicate mutations | [ ] | Section 2 |
| Core workflow verified online/offline | [ ] | Section 3.3 |
| Test coverage >= 80% service layer | [ ] | Section 1.1 |
| Widget tests for Auth & Staff | [ ] | Section 1.2 |

**Approved By:** _______________
**Date:** _______________

---

## Appendix: Commands Reference

### Run Flutter Tests with Coverage
```bash
cd cosmo_app
flutter test --coverage
```

### Run Django Migrations
```bash
cd cosmo_backend
python manage.py migrate
```

### Verify Idempotency Keys in Database
```bash
cd cosmo_backend
python manage.py shell -c "from api.models import IdempotencyKey; print(IdempotencyKey.objects.count())"
```

### Clean Old Idempotency Keys
```bash
cd cosmo_backend
python manage.py shell -c "from api.models import IdempotencyKey; print(IdempotencyKey.cleanup_old_keys(days=7))"
```
