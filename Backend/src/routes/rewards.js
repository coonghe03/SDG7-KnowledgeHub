import { Router } from 'express';
import { getCoins } from '../store/memory.js';

const r = Router();
const TARGET = 50;
const OFFSET_RS = 50;

// GET /api/rewards/balance/:userId
r.get('/balance/:userId', (req, res) => {
  const { userId } = req.params;
  const coins = getCoins(userId);
  const eligible = coins >= TARGET;
  res.json({
    userId,
    coins,
    eligibleForBillOffset: eligible,
    targetCoins: TARGET,
    rewardOffsetRs: OFFSET_RS
  });
});

export default r;
