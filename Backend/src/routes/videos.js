import { Router } from 'express';
const r = Router();

// Later: fetch from DB or a JSON list
r.get('/', (_req, res) => {
  res.json([
    { id: 'v1', title: 'Intro to Solar Energy', url: 'https://example.com/solar.mp4' },
    { id: 'v2', title: 'How Wind Turbines Work', url: 'https://example.com/wind.mp4' },
  ]);
});

export default r;
