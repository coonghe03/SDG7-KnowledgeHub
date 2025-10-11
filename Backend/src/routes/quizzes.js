import { Router } from 'express';
const r = Router();

// GET quiz by topic
r.get('/:topic', (req, res) => {
  const topic = req.params.topic;
  // Later: load from DB; now a tiny sample
  res.json({
    topic,
    questions: [
      { q: 'Solar panels convert sunlight into?', options: ['Heat', 'Electricity', 'Wind'], answer: 1 },
      { q: 'Wind energy uses?', options: ['Turbines', 'Dams', 'Batteries'], answer: 0 }
    ]
  });
});

// POST answers -> return score & coins
r.post('/submit', (req, res) => {
  const { topic, answers } = req.body;
  // placeholder scoring
  const scorePct = 100; // fake for now
  const coinsEarned = scorePct >= 80 ? 5 : 0;
  res.json({ topic, scorePct, coinsEarned });
});

export default r;
