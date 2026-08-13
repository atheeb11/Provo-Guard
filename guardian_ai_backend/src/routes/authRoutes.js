const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { authenticateToken } = require('../middleware/authMiddleware');

router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/verify-otp', authController.verifyOtp);
router.get('/profile', authenticateToken, authController.getProfile);
router.put('/emergency-contacts', authenticateToken, authController.updateEmergencyContacts);

module.exports = router;
