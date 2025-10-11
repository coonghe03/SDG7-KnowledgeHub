// Backend/src/routes/chatbot.js
import { Router } from 'express';

const r = Router();

/** Small knowledge base */
const KB = [
  {
    intent: 'what_is_sdg7',
    keys: ['sdg 7', 'sdg7', 'affordable and clean energy', 'what is sdg'],
    answer:
      'SDG 7 means “Affordable and Clean Energy.” It targets universal access to modern energy, higher renewable energy share, and better energy efficiency.',
  },
  {
    intent: 'renewable_sources',
    keys: ['renewable', 'types', 'sources', 'solar', 'wind', 'hydro'],
    answer:
      'Common renewable sources: Solar (sunlight→electricity), Wind (turbines), Hydro (water flow). They reduce emissions and support sustainability.',
  },
  {
    intent: 'solar_basics',
    keys: ['solar panel', 'photovoltaic', 'pv', 'sunlight', 'net metering'],
    answer:
      'Solar PV panels convert sunlight to electricity. With net metering, extra power goes to the grid and reduces your bill.',
  },
  {
    intent: 'wind_basics',
    keys: ['wind', 'turbine', 'blade', 'aerodynamics'],
    answer:
      'Wind turbines capture kinetic energy from moving air and convert it to electricity. Sites with steady wind—coasts/open plains—work best.',
  },
  {
    intent: 'hydro_basics',
    keys: ['hydro', 'dam', 'water', 'turbine water'],
    answer:
      'Hydropower uses flowing water to spin a turbine and generate electricity. It is clean but needs careful environmental planning.',
  },
  {
    intent: 'conservation_tips',
    keys: ['save energy', 'tips', 'conserve', 'reduce bill', 'efficiency'],
    answer:
      'Quick tips: use LED bulbs, switch off idle devices, set AC 24–26°C, use natural light, fix leaks in doors/windows, and unplug chargers.',
  },
  {
    intent: 'rewards_rule',
    keys: ['coins', 'reward', 'bill', 'rs 50', 'offset'],
    answer:
      'You earn +5 coins whenever your quiz score ≥ 80%. When you reach 50 coins, you become eligible for Rs. 50 bill offset (upload your bill in Billing).',
  },
  {
    intent: 'app_navigation',
    keys: ['where', 'find', 'videos', 'articles', 'quiz', 'billing', 'rewards', 'chatbot'],
    answer:
      'Open the Home page: • Videos → learn basics • Articles → daily news • Quizzes → test & earn coins • Rewards → see coins • Billing → upload your bill.',
  },
];

/** Fuzzy match by counting keyword hits */
function matchIntent(text) {
  const q = text.toLowerCase();
  let best = { score: 0, item: null };
  for (const item of KB) {
    let score = 0;
    for (const k of item.keys) {
      if (q.includes(k)) score += 2;
      // split words for looser matches
      for (const w of k.split(/\s+/)) {
        if (w && q.includes(w)) score += 1;
      }
    }
    if (score > best.score) best = { score, item };
  }
  return best.item;
}

r.post('/ask', (req, res) => {
  const question = (req.body?.question || '').toString().trim();
  if (!question) return res.status(400).json({ error: 'question is required' });

  const intent = matchIntent(question);
  const fallback =
    "I didn’t fully catch that. Try asking about: “SDG 7”, “solar basics”, “wind energy”, “conservation tips”, “rewards rule”, or “where to find quizzes”.";
  const answer = intent?.answer || fallback;

  // optional: tiny guidance links (client may use to navigate)
  const suggestions = [
    { label: 'Videos', route: '/videos' },
    { label: 'Articles', route: '/articles' },
    { label: 'Quizzes', route: '/quizzes' },
    { label: 'Rewards', route: '/rewards' },
    { label: 'Bill Upload', route: '/billing' },
  ];

  res.json({ answer, intent: intent?.intent || 'fallback', suggestions });
});

export default r;
