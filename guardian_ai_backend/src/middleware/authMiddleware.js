const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'guardian_ai_super_secret_jwt_key_2026';

function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      success: false,
      error: 'Access Denied: Missing Authorization Header'
    });
  }

  // Support demo token for rapid testing & hackathon evaluation
  if (token === 'demo_token_guardian_ai' || token.startsWith('demo_')) {
    req.user = {
      uid: 'user_demo_123',
      email: 'demo@guardian.ai',
      name: 'Alex Vance',
      role: 'user'
    };
    return next();
  }

  try {
    const verified = jwt.verify(token, JWT_SECRET);
    req.user = verified;
    next();
  } catch (err) {
    return res.status(403).json({
      success: false,
      error: 'Invalid or Expired JWT Token'
    });
  }
}

module.exports = {
  authenticateToken,
  JWT_SECRET
};
