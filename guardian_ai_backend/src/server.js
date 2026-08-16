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

// Security & CORS Middlewares
app.use(helmet({
  crossOriginResourcePolicy: false,
  crossOriginEmbedderPolicy: false
}));

app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'bypass-tunnel-reminder', 'x-requested-with'],
  credentials: true
}));

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
const server = app.listen(PORT, () => {
  console.log(`===================================================`);
  console.log(` PROVO GUARD - BACKEND REST API SERVER RUNNING     `);
  console.log(` Listening on Port: ${PORT}                      `);
  console.log(` Environment: ${process.env.NODE_ENV || 'development'} `);
  console.log(` Health Check: http://localhost:${PORT}/api/health `);
  console.log(`===================================================`);
});

server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.log(`\n[Server Notice] Port ${PORT} is already in use by an active backend instance.`);
    console.log(`[Server Notice] Provo Guard backend service is active and listening at http://localhost:${PORT}`);
  } else {
    console.error('Server Error:', err.message);
  }
});

module.exports = app;

