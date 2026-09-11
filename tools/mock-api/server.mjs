// tools/mock-api/server.mjs
// Dependency-free stand-in for the Spring Boot API, used for LOCAL verification
// only (the real Java server can't bind on this machine). Grows one route group
// per phase. Run: node tools/mock-api/server.mjs
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
    // ---- auth / me (Phase 0) ----
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
