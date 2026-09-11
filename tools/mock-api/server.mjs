// tools/mock-api/server.mjs
// Dependency-free stand-in for the Spring Boot API, for LOCAL testing without Java
// (the real backend can't always bind on the dev machine). Mirrors the student
// endpoints the app uses. Run: node tools/mock-api/server.mjs
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

const series = (a, b, c, d, e, f) =>
  ['2026-08-18','2026-08-24','2026-08-30','2026-09-04'].map((date, i) => ({ date, band: [a,b,c,d,e,f][i] }));

const overview = {
  targetBand: 7, currentAverage: 6, gapToTarget: 1, testsCompleted: 37,
  skills: [
    { key: 'listening', label: 'Listening', band: 6.5, tests: 8 },
    { key: 'reading', label: 'Reading', band: 6, tests: 9 },
    { key: 'writing', label: 'Writing', band: 5.5, tests: 5 },
    { key: 'speaking', label: 'Speaking', band: 6, tests: 4 },
    { key: 'vocabulary', label: 'Vocabulary', band: 6.5, tests: 6 },
    { key: 'grammar', label: 'Grammar', band: 5.5, tests: 5 },
  ],
  strongest: { key: 'listening', label: 'Listening', band: 6.5 },
  weakest: { key: 'writing', label: 'Writing', band: 5.5 },
  series: {
    listening: series(4.5, 5, 5.5, 6.5), reading: series(4.5, 5, 5.5, 6),
    writing: series(4, 4.5, 5, 5.5), speaking: series(5, 5.5, 5.5, 6),
    vocabulary: series(5, 5.5, 6, 6.5), grammar: series(4.5, 5, 5, 5.5),
    overall: series(4.5, 5, 5.5, 6),
  },
  recentActivity: [
    { id: 'ra1', type: 'completed', skill: 'reading', title: 'Completed Reading Practice', date: '2026-09-04', band: 6 },
    { id: 'ra2', type: 'submitted', skill: 'writing', title: 'Submitted Writing Task', date: '2026-09-04' },
    { id: 'ra3', type: 'feedback', skill: 'speaking', title: 'Received Speaking Feedback', date: '2026-09-03', band: 6 },
    { id: 'ra4', type: 'unfinished', skill: 'grammar', title: 'Continue Grammar Practice', date: '2026-09-03' },
  ],
};

const tracks = [
  { key: 'ielts', name: 'IELTS Preparation', short: 'IELTS', status: 'active', icon: 'GraduationCap', description: 'Academic & General Training' },
  { key: 'general-english', name: 'General English', short: 'General', status: 'coming-soon', icon: 'MessageCircle', description: 'Everyday speaking, listening & grammar' },
  { key: 'business-english', name: 'Business English', short: 'Business', status: 'coming-soon', icon: 'Briefcase', description: 'Meetings, email & presentations' },
  { key: 'toefl', name: 'TOEFL Preparation', short: 'TOEFL', status: 'coming-soon', icon: 'Globe', description: 'iBT reading, listening, speaking, writing' },
  { key: 'kids', name: 'English for Kids', short: 'Kids', status: 'coming-soon', icon: 'Baby', description: 'Playful lessons for young learners' },
];

const achievements = [
  { id: 'first-steps', title: 'First Steps', description: 'Complete your first exam', category: 'exams', tier: 'bronze', points: 10, icon: 'Footprints', status: 'unlocked', progress: 100, unlockedOn: '2026-09-01' },
  { id: 'dedicated-learner', title: 'Dedicated Learner', description: 'Complete 5 exams', category: 'exams', tier: 'silver', points: 50, icon: 'BookOpen', status: 'unlocked', progress: 100, unlockedOn: '2026-09-03' },
  { id: 'streak-3', title: 'Warm-Up Streak', description: 'Practise 3 days in a row', category: 'consistency', tier: 'bronze', points: 15, icon: 'Flame', status: 'unlocked', progress: 100, unlockedOn: '2026-08-31' },
  { id: 'band-climber', title: 'Band Climber', description: 'Improve any skill by 0.5', category: 'progress', tier: 'silver', points: 40, icon: 'Target', status: 'locked', progress: 60 },
  { id: 'all-rounder', title: 'All-Rounder', description: 'Attempt all four skills', category: 'progress', tier: 'gold', points: 100, icon: 'Trophy', status: 'locked', progress: 75 },
];

const certificates = [
  { id: 'cert1', title: 'Full Practice Test — Academic', candidate: 'Sara Hamzeh', type: 'ielts-report', verificationNumber: 'EIELTS-2026-478091', module: 'academic', centre: 'Online Practice', issuedOn: '2026-09-01', dateOfBirth: '', sex: '', countryOfOrigin: '', nationality: '', firstLanguage: '', schemeCode: 'Online Practice Test', scores: { listening: 6.5, reading: 6.5, writing: 6, speaking: 6.5 }, overall: 6.5, cefr: 'B2', comments: 'Practice examination on Yalla English Hub.', status: 'issued' },
];

const lessons = [
  { title: 'True/False/Not Given, decoded', skill: 'reading', level: 'Foundation', minutes: 8, kind: 'Video', summary: 'A reliable 4-step method.', progress: 100 },
  { title: 'Task 2: building a clear position', skill: 'writing', level: 'Intermediate', minutes: 12, kind: 'Article', summary: 'Turn a prompt into a thesis fast.', progress: 40 },
];
const plans = {
  plans: [
    { id: 'starter', name: 'Starter Plan', price: 'Free', cadence: '', detail: 'Reading & Writing with limits.', highlight: false },
    { id: 'monthly', name: 'Monthly', badge: 'STANDARD', price: '$19.99', cadence: '/month', detail: '$19.99/month.', highlight: true },
  ],
  planIncludes: ['All 4 IELTS sections', 'Unlimited practice', 'Progress tracking'],
};
const progress = { sectionSummaries: overview.skills.slice(0, 4).map(s => ({ skill: s.key, band: s.band, tests: s.tests })), recentExams: [] };

// One small runner-format reading exam so the reading runner + scoring work.
const readingExam = {
  id: 'read-demo', skill: 'reading', title: 'Reading Demo — Language & Trade', module: 'academic',
  status: 'published', scope: 'global', timeLimit: 20, updatedAt: '2026-09-11T00:00:00Z', format: 'runner',
  content: {
    id: 'read-demo', title: 'Reading Demo — Language & Trade', durationSec: 1200,
    questionTypes: ['true-false-notgiven', 'sentence-completion'],
    passages: [{
      id: 'p1', headline: 'The Spread of Writing Systems', label: 'Academic', passageNumber: 1, totalPassages: 1,
      paragraphs: [
        'Writing emerged independently in several ancient societies. The earliest systems recorded trade and taxation before they were used for literature.',
        'As trade routes expanded, scripts travelled with merchants, and borrowing between cultures accelerated the evolution of alphabets.',
      ],
      groups: [
        { id: 'p1g1', type: 'true-false-notgiven', rangeLabel: 'Questions 1–3', instructions: 'Do the statements agree with the passage?',
          sharedOptions: [{ key: 'True', text: 'True' }, { key: 'False', text: 'False' }, { key: 'Not Given', text: 'Not Given' }],
          questions: [
            { id: 'q1', number: 1, prompt: 'Writing was first used for literature.', correct: 'False' },
            { id: 'q2', number: 2, prompt: 'Trade helped writing systems spread.', correct: 'True' },
            { id: 'q3', number: 3, prompt: 'All alphabets come from a single origin.', correct: 'Not Given' },
          ] },
        { id: 'p1g2', type: 'sentence-completion', rangeLabel: 'Questions 4–5', instructions: 'Complete with ONE WORD from the passage.',
          questions: [
            { id: 'q4', number: 4, prompt: 'Early writing recorded trade and __________.', correct: 'taxation', wordLimit: 'ONE WORD' },
            { id: 'q5', number: 5, prompt: 'Scripts travelled with __________.', correct: 'merchants', wordLimit: 'ONE WORD' },
          ] },
      ],
    }],
  },
};
const exams = [readingExam];

const feedback = [];
let fbSeq = 1;

function collectCorrect(content) {
  const map = {};
  for (const p of content.passages || []) for (const g of p.groups || []) for (const q of g.questions || []) map[q.id] = q.correct;
  return map;
}
function rawToBand(raw, total) {
  const pct = total ? raw / total : 0;
  if (pct >= 0.97) return 9; if (pct >= 0.87) return 8; if (pct >= 0.75) return 7;
  if (pct >= 0.6) return 6.5; if (pct >= 0.5) return 6; if (pct >= 0.4) return 5.5;
  if (pct >= 0.3) return 5; return 4;
}

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
  const { pathname, searchParams } = new URL(req.url, 'http://localhost');
  const m = req.method;
  try {
    // auth / me
    if (pathname === '/api/auth/login' && m === 'POST') {
      const b = await readBody(req);
      me = { ...seedUser, email: b.email || seedUser.email };
      return send(res, 200, { token: 'demo-token', user: me });
    }
    if (pathname === '/api/auth/logout') return send(res, 200, { ok: true });
    if (pathname === '/api/me' && m === 'GET') return send(res, 200, me);
    if (pathname === '/api/me' && m === 'PATCH') {
      const b = await readBody(req); if (b.examDate === '') b.examDate = null;
      me = { ...me, ...b }; return send(res, 200, me);
    }
    // content
    if (pathname === '/api/overview') return send(res, 200, overview);
    if (pathname === '/api/tracks') return send(res, 200, tracks);
    if (pathname === '/api/achievements') return send(res, 200, achievements);
    if (pathname === '/api/certificates') return send(res, 200, certificates);
    if (pathname === '/api/lessons') return send(res, 200, lessons);
    if (pathname === '/api/plans') return send(res, 200, plans);
    if (pathname === '/api/progress') return send(res, 200, progress);
    // exams
    if (pathname === '/api/exams' && m === 'GET') {
      const skill = searchParams.get('skill');
      return send(res, 200, exams.filter(e => !skill || e.skill === skill));
    }
    const exMatch = pathname.match(/^\/api\/exams\/([^/]+)$/);
    if (exMatch && m === 'GET') {
      const e = exams.find(x => x.id === exMatch[1]);
      return e ? send(res, 200, e) : send(res, 404, { error: 'Exam not found' });
    }
    // attempts (server-scored)
    if (pathname === '/api/attempts' && m === 'POST') {
      const b = await readBody(req);
      const exam = exams.find(x => x.id === b.examId);
      const correctMap = exam ? collectCorrect(exam.content) : {};
      const total = Object.keys(correctMap).length;
      let correct = 0;
      for (const [id, ans] of Object.entries(b.answers || {})) {
        if (correctMap[id] && `${ans}`.trim().toLowerCase() === `${correctMap[id]}`.trim().toLowerCase()) correct++;
      }
      return send(res, 200, {
        id: 'att-' + Math.random().toString(36).slice(2, 8), examId: b.examId,
        examTitle: exam ? exam.title : b.examId, skill: b.skill, answers: b.answers || {},
        correct, total, band: rawToBand(correct, total), durationUsedSec: b.durationUsedSec || 0,
        createdAt: new Date().toISOString(),
      });
    }
    // feedback
    if (pathname === '/api/feedback' && m === 'POST') {
      const b = await readBody(req);
      const f = { id: 'fb-' + (fbSeq++), userId: 'u1', userName: me.name, category: b.category || 'general',
        subject: b.subject || '', message: b.message || '', rating: b.rating ?? null, status: 'new',
        adminReply: null, createdAt: new Date().toISOString(), updatedAt: new Date().toISOString() };
      feedback.unshift(f); return send(res, 200, f);
    }
    if (pathname === '/api/feedback' && m === 'GET') return send(res, 200, feedback);
    if (pathname === '/api/feedback/summary') {
      return send(res, 200, { total: feedback.length, newCount: feedback.filter(f => f.status === 'new').length, underReview: 0, completed: 0, latest: feedback[0] || null });
    }

    if (pathname.startsWith('/api/ai/')) return send(res, 501, { error: 'AI features are coming soon.' });
    return send(res, 404, { error: `No stub for ${m} ${pathname}` });
  } catch (e) {
    return send(res, 500, { error: String(e) });
  }
}).listen(PORT, () => console.log(`Yalla stub API on http://localhost:${PORT}/api`));
