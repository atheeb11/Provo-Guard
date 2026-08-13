const express = require('express');
const router = express.Router();
const emergencyController = require('../controllers/emergencyController');
const { authenticateToken } = require('../middleware/authMiddleware');

router.post('/trigger', authenticateToken, emergencyController.triggerEmergency);
router.get('/pdf-report/:incidentId', authenticateToken, emergencyController.exportIncidentPDF);
router.get('/safe-places', authenticateToken, emergencyController.getNearbySafePlaces);

module.exports = router;
