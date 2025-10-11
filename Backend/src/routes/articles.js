// Backend/src/routes/articles.js
import { Router } from 'express';
const r = Router();

// simple in-memory list for now
const ARTICLES = [
  {
    id: 'a1',
    title: 'Clean Energy 101',
    summary: 'Basics of renewable energy (solar, wind, hydro).',
    url: 'https://www.un.org/sustainabledevelopment/energy/',
    source: 'UN SDGs',
    publishedAt: '2025-10-10'
  },
  {
    id: 'a2',
    title: 'Saving Energy at Home',
    summary: '10 quick tips to reduce electricity usage safely.',
    url: 'https://www.energy.gov/energysaver/energy-saver',
    source: 'Energy.gov',
    publishedAt: '2025-10-09'
  },
  {
    id: 'a3',
    title: 'What is Net Metering?',
    summary: 'How rooftop solar sends extra power back to the grid.',
    url: 'https://example.com/net-metering',
    source: 'SDG7 Hub',
    publishedAt: '2025-10-08'
  }
];

// GET /api/articles?q=solar
r.get('/', (req, res) => {
  const q = (req.query.q || '').toString().toLowerCase();
  const list = !q
    ? ARTICLES
    : ARTICLES.filter(a =>
        a.title.toLowerCase().includes(q) ||
        a.summary.toLowerCase().includes(q) ||
        a.source.toLowerCase().includes(q)
      );
  res.json(list);
});

export default r;
