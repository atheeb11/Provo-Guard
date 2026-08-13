const jwt = require('jsonwebtoken');
const { getDb } = require('../config/firebase');
const { JWT_SECRET } = require('../middleware/authMiddleware');
const { sendVerificationEmail } = require('../services/emailService');

async function register(req, res) {
  try {
    const { email, password, fullName, age, country } = req.body;
    if (!email || !password || !fullName) {
      return res.status(400).json({ success: false, error: 'Email, Password, and Full Name are required.' });
    }

    const db = getDb();

    // Check if email already registered
    const existingUser = await db.collection('users').where('email', '==', email).get();
    if (existingUser.docs.length > 0) {
      return res.status(400).json({ success: false, error: 'Email already registered.' });
    }

    const uid = 'usr_' + Date.now();
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
    const otpExpiry = new Date(Date.now() + 15 * 60000).toISOString(); // 15 mins validity

    const userDoc = {
      uid,
      email,
      fullName,
      age: age || 20,
      country: country || 'United States',
      emergencyContacts: [],
      privacyPreferences: {
        visibleMonitoringConsent: true,
        localOCRAnalysis: true,
        cloudAnalysisConsent: true,
        biometricLockEnabled: true
      },
      isVerified: false,
      otpCode,
      otpExpiry,
      createdAt: new Date().toISOString()
    };

    await db.collection('users').doc(uid).set(userDoc);

    // Send Brevo OTP email
    await sendVerificationEmail(email, fullName, otpCode);

    res.status(201).json({
      success: true,
      message: 'Signup successful. A 6-digit verification code has been sent to your email.',
      requiresVerification: true,
      email
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}

async function login(req, res) {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ success: false, error: 'Email and password required' });
    }

    const db = getDb();

    // Check if user exists in database
    const snapshot = await db.collection('users').where('email', '==', email).get();

    if (snapshot.docs.length > 0) {
      const userDoc = snapshot.docs[0];
      const user = userDoc.data();

      // Check verification status
      if (user.isVerified === false) {
        // Generate new OTP and send via Brevo
        const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
        const otpExpiry = new Date(Date.now() + 15 * 60000).toISOString();

        await db.collection('users').doc(user.uid).set({
          otpCode,
          otpExpiry
        }, { merge: true });

        await sendVerificationEmail(email, user.fullName, otpCode);

        return res.status(200).json({
          success: false,
          requiresVerification: true,
          message: 'Account not verified. A new 6-digit OTP code has been sent to your email.',
          email
        });
      }

      const token = jwt.sign({ uid: user.uid, email: user.email, name: user.fullName }, JWT_SECRET, { expiresIn: '7d' });
      return res.json({
        success: true,
        message: 'Login successful',
        token,
        user
      });
    }



    return res.status(404).json({ success: false, error: 'User profile not found.' });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}

async function getProfile(req, res) {
  try {
    const db = getDb();
    const userDoc = await db.collection('users').doc(req.user.uid).get();

    if (userDoc.exists) {
      return res.json({ success: true, user: userDoc.data() });
    }

    // Return default active session user
    res.json({
      success: true,
      user: {
        uid: req.user.uid,
        email: req.user.email || 'alex@guardian.ai',
        fullName: req.user.name || 'Alex Vance',
        age: 21,
        country: 'United States',
        emergencyContacts: [
          { name: 'Sarah Vance (Mother)', phone: '+1-555-0199', relationship: 'Family' }
        ],
        privacyPreferences: {
          visibleMonitoringConsent: true,
          localOCRAnalysis: true,
          cloudAnalysisConsent: true,
          biometricLockEnabled: true
        }
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}

async function updateEmergencyContacts(req, res) {
  try {
    const { contacts } = req.body;
    if (!Array.isArray(contacts)) {
      return res.status(400).json({ success: false, error: 'Contacts must be an array' });
    }

    const db = getDb();
    await db.collection('users').doc(req.user.uid).set({ emergencyContacts: contacts }, { merge: true });

    res.json({
      success: true,
      message: 'Emergency contacts updated successfully',
      contacts
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}

async function verifyOtp(req, res) {
  try {
    const { email, otp } = req.body;
    if (!email || !otp) {
      return res.status(400).json({ success: false, error: 'Email and OTP code are required.' });
    }

    const db = getDb();
    const snapshot = await db.collection('users').where('email', '==', email).get();

    if (snapshot.docs.length === 0) {
      return res.status(404).json({ success: false, error: 'User profile not found.' });
    }

    const userDoc = snapshot.docs[0];
    const user = userDoc.data();

    // Verify OTP code
    if (user.otpCode === otp && new Date(user.otpExpiry) > new Date()) {
      // OTP is valid
      const updatedUser = {
        ...user,
        isVerified: true
      };
      delete updatedUser.otpCode;
      delete updatedUser.otpExpiry;

      await db.collection('users').doc(user.uid).set(updatedUser);

      const token = jwt.sign({ uid: user.uid, email: user.email, name: user.fullName }, JWT_SECRET, { expiresIn: '7d' });

      return res.json({
        success: true,
        message: 'OTP verified successfully. Account activated.',
        token,
        user: updatedUser
      });
    } else {
      return res.status(400).json({ success: false, error: 'Invalid or expired OTP code.' });
    }
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}

module.exports = {
  register,
  login,
  verifyOtp,
  getProfile,
  updateEmergencyContacts
};
