# Smoke Test

Quick confidence checks after merge/deploy.

## Local run

```bash
cd /home/b/.openclaw/workspace/tmp_tenacitos
./scripts/smoke-test.sh
```

## What it verifies

1. Production build succeeds (`npm run build`)
2. App boots (`npm start`)
3. `/login` returns `200`
4. `/api/health` returns `200`
5. Protected route `/api/system` returns `401` when unauthenticated

## Optional full manual pass (UI)

1. Login from `/login`
2. Run one safe terminal command
3. Upload and download one file in File Browser
4. Trigger quick action: `usage-stats`
5. Logout and confirm protected pages redirect back to login
