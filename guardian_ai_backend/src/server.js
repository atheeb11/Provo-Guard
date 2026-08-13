require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');

const authRoutes = require('./routes/authRoutes');
const aiRiskRoutes = require('./routes/aiRiskRoutes');
const evidenceRoutes = require('./routes/evidenceRoutes');
const emergencyRoutes = require('./routes/emergencyRoutes');
const learningRoutes = require('./routes/learningRoutes');
const errorHandler = require('./middleware/errorHandler');

const app = express();
app.set('trust proxy', 1);
const PORT = process.env.PORT || 8080;

// Security Middlewares
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(morgan('dev'));

// Rate Limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 200, // max 200 requests per IP
  message: { success: false, error: 'Too many requests from this IP, please try again later.' }
});
app.use('/api/', limiter);

// Health Check Endpoint
app.get('/api/health', (req, res) => {
  res.json({
    status: 'HEALTHY',
    service: 'Provo Guard Production REST API',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
    aiEngine: process.env.GEMINI_API_KEY ? 'Gemini 1.5 Flash (Active)' : 'Heuristic Safety Engine (Fallback Active)'
  });
});

// API Routes
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/ai-risk', aiRiskRoutes);
app.use('/api/v1/evidence', evidenceRoutes);
app.use('/api/v1/emergency', emergencyRoutes);
app.use('/api/v1/learning', learningRoutes);

// Global Error Handler
app.use(errorHandler);

// Start Server
app.listen(PORT, () => {
  console.log(`===================================================`);
  console.log(` PROVO GUARD - BACKEND REST API SERVER RUNNING     `);
  console.log(` Listening on Port: ${PORT}                      `);
  console.log(` Environment: ${process.env.NODE_ENV || 'development'} `);
  console.log(` Health Check: http://localhost:${PORT}/api/health `);
  console.log(`===================================================`);
});

module.exports = app;
