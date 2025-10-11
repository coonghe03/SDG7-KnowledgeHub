import { Router } from 'express';
import { addCoins } from '../store/memory.js';

const r = Router();

// Simple bank of quizzes by topic
const QUIZZES = {
  solar: [
    { q: 'Solar panels primarily convert sunlight into…', options: ['Heat', 'Electricity', 'Fuel'], answer: 1 },
    { q: 'Unit used to measure solar irradiance?', options: ['W/m²', 'kWh/kg', 'Pa'], answer: 0 },
    { q: 'Main material in most PV cells?', options: ['Silicon', 'Copper', 'Gold'], answer: 0 },
    { q: 'Best direction for panels in Sri Lanka (NHem)?', options: ['South', 'North', 'West'], answer: 0 },
    { q: 'Net metering lets you…', options: ['Store fuel', 'Export excess power to grid', 'Run without sun'], answer: 1 },
  ],
  wind: [
    { q: 'Wind turbines capture energy from…', options: ['Ocean tides', 'Moving air', 'Earth’s heat'], answer: 1 },
    { q: 'Blade efficiency depends MOST on…', options: ['Color', 'Aerodynamics', 'Weight only'], answer: 1 },
    { q: 'Typical location for utility wind?', options: ['Open plains/coasts', 'Dense forests', 'Deep caves'], answer: 0 },
    { q: 'Output is measured in…', options: ['Lumens', 'Watts', 'Decibels'], answer: 1 },
    { q: 'Intermittency means…', options: ['Always on', 'Variable over time', 'Nuclear fusion'], answer: 1 },
  ],
};

const PASS_THRESHOLD = 80;
const COIN_REWARD = 5;

// GET /api/quizzes/:topic
r.get('/:topic', (req, res) => {
  const topic = req.params.topic?.toLowerCase();
  const questions = QUIZZES[topic];
  if (!questions) return res.status(404).json({ error: 'Unknown topic' });
  // Don’t send correct answers to the client
  res.json({ topic, questions: questions.map(({ q, options }) => ({ q, options })) });
});

// POST /api/quizzes/submit  { userId, topic, answers:[index,...] }
r.post('/submit', (req, res) => {
  const { userId = 'demoUser', topic, answers = [] } = req.body || {};
  const bank = QUIZZES[topic?.toLowerCase()];
  if (!bank) return res.status(400).json({ error: 'Invalid topic' });

  const total = bank.length;
  let correct = 0;
  bank.forEach((q, i) => {
    if (answers[i] === q.answer) correct++;
  });

  const scorePct = Math.round((correct / total) * 100);
  const passed = scorePct >= PASS_THRESHOLD;

  let coinsEarned = 0;
  if (passed) {
    coinsEarned = COIN_REWARD;
    addCoins(userId, coinsEarned);
  }

  res.json({ topic, total, correct, scorePct, passed, coinsEarned });
});

export default r;
