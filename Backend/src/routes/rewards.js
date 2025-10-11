import { Router } from 'express';
const r = Router();

// Later: use DB per user; for now a demo response
r.get('/balance/:userId', (req, res) => {
  const { userId } = req.params;
  res.json({ userId, coins: 15, eligibleForBillOffset: 15 >= 50, pendingOffsetRs: 0 });
});

export default r;

