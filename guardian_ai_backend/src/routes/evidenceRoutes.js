const express = require('express');
const router = express.Router();
const evidenceController = require('../controllers/evidenceController');
const { authenticateToken } = require('../middleware/authMiddleware');

router.post('/', authenticateToken, evidenceController.addEvidenceItem);
router.get('/', authenticateToken, evidenceController.getEvidenceItems);

module.exports = router;
