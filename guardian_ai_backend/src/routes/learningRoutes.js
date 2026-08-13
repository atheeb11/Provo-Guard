const express = require('express');
const router = express.Router();
const learningController = require('../controllers/learningController');
const { authenticateToken } = require('../middleware/authMiddleware');

router.get('/modules', authenticateToken, learningController.getLearningModules);
router.get('/simulators', authenticateToken, learningController.getSimulators);

module.exports = router;
