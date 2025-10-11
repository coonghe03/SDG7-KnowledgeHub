import { Router } from 'express';
import Parser from 'rss-parser';

const r = Router();
const parser = new Parser();

// .env: NEWS_FEED_URLS = url1,url2,url3
const urls = (process.env.NEWS_FEED_URLS || '').split(',').map(s => s.trim()).filter(Boolean);

// GET /api/news/live?q=solar
r.get('/live', async (req, res) => {
  try {
    if (urls.length === 0) return res.json([]);
    const q = (req.query.q || '').toString().toLowerCase();

    const results = [];
    for (const u of urls) {
      try {
        const feed = await parser.parseURL(u);
        for (const item of feed.items || []) {
          const title = item.title || '';
          const summary = (item.contentSnippet || item.content || item.summary || '').toString();
          const source = feed.title || 'Feed';
          const url = item.link || '';
          const publishedAt = (item.isoDate || item.pubDate || '').toString();

          const row = { title, summary, url, source, publishedAt };
          if (!q) results.push(row);
          else {
            const text = `${title} ${summary} ${source}`.toLowerCase();
            if (text.includes(q)) results.push(row);
          }
        }
      } catch (e) {
        // skip bad feed, continue
        console.error('Feed error', u, e.message);
      }
    }
    // sort newest first if possible
    results.sort((a, b) => (b.publishedAt || '').localeCompare(a.publishedAt || ''));
    res.json(results.slice(0, 50));
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

export default r;
