import { Router } from 'express';
const r = Router();

// Later: integrate a news API; for now static
r.get('/', (_req, res) => {
  res.json([
    { id: 'a1', title: 'Clean Energy 101', summary: 'Basics of renewable energy.' },
    { id: 'a2', title: 'Saving Energy at Home', summary: 'Quick conservation tips.' },
  ]);
});

export default r;
