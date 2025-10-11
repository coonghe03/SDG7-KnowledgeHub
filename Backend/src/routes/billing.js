import { Router } from 'express';
import multer from 'multer';

const r = Router();
const upload = multer({ dest: 'uploads/' });

r.post('/upload', upload.single('billPhoto'), (req, res) => {
  // Later: OCR/verification; for now echo file info
  res.json({ ok: true, file: req.file, message: 'Bill uploaded. Verification pending.' });
});

export default r;
