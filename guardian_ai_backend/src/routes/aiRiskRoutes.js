const express = require('express');
const router = express.Router();
const aiRiskController = require('../controllers/aiRiskController');
const { authenticateToken } = require('../middleware/authMiddleware');

router.post('/analyze', authenticateToken, aiRiskController.analyzeInteraction);
router.post('/coach-chat', authenticateToken, aiRiskController.chatSafetyCoach);
router.post('/chat', authenticateToken, aiRiskController.chatSafetyCoach);
router.get('/threat-logs', authenticateToken, aiRiskController.getThreatLogs);

module.exports = router;
