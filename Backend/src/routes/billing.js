import { Router } from 'express';
import multer from 'multer';
import path from 'path';

const r = Router();

// Save with user + timestamp + original extension
const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => {
    const userId = (req.body?.userId || 'unknown').replace(/[^a-zA-Z0-9_-]/g, '');
    const ext = path.extname(file.originalname || '').toLowerCase() || '.jpg';
    cb(null, `${userId}_${Date.now()}${ext}`);
  }
});
const upload = multer({ storage });

r.post('/upload', upload.single('billPhoto'), (req, res) => {
  const userId = req.body?.userId || 'unknown';
  res.json({
    ok: true,
    userId,
    file: {
      filename: req.file?.filename,
      size: req.file?.size,
      path: req.file?.path
    },
    message: 'Bill uploaded. Verification pending.'
  });
});

export default r;
