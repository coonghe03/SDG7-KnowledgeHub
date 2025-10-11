import { Router } from 'express';
import videos from './videos.js';
import articles from './articles.js';
import quizzes from './quizzes.js';
import rewards from './rewards.js';
import billing from './billing.js';

const router = Router();

router.use('/videos', videos);
router.use('/articles', articles);
router.use('/quizzes', quizzes);
router.use('/rewards', rewards);
router.use('/billing', billing);

router.get('/health', (_req, res) => res.json({ ok: true, service: 'sdg7-backend' }));

export default router;
