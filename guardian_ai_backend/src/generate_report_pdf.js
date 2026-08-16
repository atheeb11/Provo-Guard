const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');

const outputPath = path.join(__dirname, '../../Provo_Guard_UNESCO_Technical_Report_2026.pdf');
const doc = new PDFDocument({
  size: 'A4',
  margin: 40,
  info: {
    Title: 'Provo Guard — UNESCO Youth Hackathon 2026 Technical Audit Report',
    Author: 'Provo Guard Engineering Team',
    Subject: 'Digital Safety & AI Threat Prevention Platform Technical Report'
  }
});

const stream = fs.createWriteStream(outputPath);
doc.pipe(stream);

// Primary Colors
const PRIMARY = '#0A2540';
const ACCENT = '#0075FF';
const DARK_TEXT = '#1E293B';
const GRAY_TEXT = '#64748B';
const LIGHT_BG = '#F8FAFC';

// Helper for Header
function drawHeader(title) {
  doc.rect(40, 30, 515, 45).fill(PRIMARY);
  doc.fillColor('#FFFFFF').fontSize(16).font('Helvetica-Bold').text(title, 55, 45);
  doc.fillColor('#00A2FF').fontSize(10).font('Helvetica').text('UNESCO Youth Hackathon 2026 Official Submission', 320, 47, { align: 'right' });
  doc.moveDown(2);
}

// Draw Title Cover Section
drawHeader('PROVO GUARD — TECHNICAL REPORT');

doc.moveDown(0.5);
doc.fillColor(PRIMARY).fontSize(20).font('Helvetica-Bold').text('Provo Guard Technical Audit & System Report', { align: 'center' });
doc.fillColor(ACCENT).fontSize(11).font('Helvetica-Bold').text('Personal Digital Safety & AI Threat Prevention Ecosystem', { align: 'center' });
doc.fillColor(GRAY_TEXT).fontSize(9).font('Helvetica').text('Generated: August 2026 | Platform Version: V1.0 Production Candidate', { align: 'center' });
doc.moveDown(1.5);

function addSection(title) {
  doc.moveDown(0.8);
  doc.rect(40, doc.y, 515, 22).fill('#E2E8F0');
  doc.fillColor(PRIMARY).fontSize(12).font('Helvetica-Bold').text(title, 50, doc.y - 17);
  doc.moveDown(0.6);
  doc.fillColor(DARK_TEXT).fontSize(10).font('Helvetica');
}

function addParagraph(text) {
  doc.fillColor(DARK_TEXT).fontSize(9.5).font('Helvetica').text(text, { align: 'justify', lineGap: 3 });
  doc.moveDown(0.4);
}

function addBullet(label, text) {
  doc.fillColor(ACCENT).font('Helvetica-Bold').fontSize(9.5).text(`• ${label}: `, { continued: true });
  doc.fillColor(DARK_TEXT).font('Helvetica').text(text);
  doc.moveDown(0.2);
}

// 1. EXECUTIVE SUMMARY
addSection('1. EXECUTIVE SUMMARY');
addParagraph('Provo Guard is an end-to-end digital safety mobile ecosystem designed specifically for teenagers, youth, and young adults to identify, understand, and defend against online threats including Cyber Extortion, Sextortion, Phishing, Online Scams, OTP Theft, Grooming, and Catfishing.');
addParagraph('The platform combines a Flutter cross-platform mobile application, a Node.js Express REST API server, Google Firebase Firestore database, and Google AI Studio Gemini 1.5 Flash LLM engine (@google/generative-ai SDK v0.21.0).');

addBullet('Dual-Engine AI Assistant', 'Functions as a general-purpose educational AI while automatically switching into specialized digital-safety mode when threat-related input is detected.');
addBullet('Explainable AI (XAI)', 'Provides transparent threat scores (0-100), severity levels (Safe, Low, Medium, High, Critical), red flag breakdowns, and protective guidance.');
addBullet('Hardware & Cloud GPS Integration', 'Utilizes device hardware GPS (geolocator) with OpenStreetMap Nominatim reverse geocoding to calculate live distances to nearby police stations and crisis shelters.');
addBullet('Cryptographic Chain of Custody', 'Local AES-256 encrypted storage paired with SHA-256 hashes to preserve legal evidence integrity.');

// 2. TECHNOLOGY STACK
addSection('2. COMPLETE TECHNOLOGY STACK');
addBullet('Frontend Mobile Framework', 'Flutter 3.27+ / Dart 3.x (iOS, Android, Web)');
addBullet('State Management & Router', 'Riverpod (flutter_riverpod v2.6.1) & GoRouter (go_router v14.8.1)');
addBullet('Backend API Framework', 'Node.js (v18/v20 LTS) + Express.js (v4.19.2)');
addBullet('Database Infrastructure', 'Google Firebase Firestore via firebase-admin (v12.1.0)');
addBullet('AI Engine & SDK', 'Google AI Studio — Gemini 1.5 Flash (gemini-1.5-flash) via @google/generative-ai (v0.21.0)');
addBullet('Location & Mapping', 'Device Hardware GPS + OpenStreetMap Nominatim Reverse Geocoding API');
addBullet('Security & Encryption', 'AES-256 Secure Storage, SHA-256 Evidence Hashing, JWT Auth, Helmet, Express Rate Limit');

// New Page for Architecture & Features
doc.addPage();
drawHeader('SYSTEM ARCHITECTURE & FEATURES');

// 3. SYSTEM ARCHITECTURE
addSection('3. SYSTEM ARCHITECTURE & DATA FLOW');
addParagraph('Mobile Client (Flutter) <---> REST API Server (Node.js Express) <---> Google Gemini 1.5 Flash & Firebase Firestore');
addParagraph('All mobile client communications route through HTTPS REST API calls under the /api/v1 namespace. Sensitive API credentials (GEMINI_API_KEY) strictly reside on the backend server environment and are never exposed to the client bundle.');

// 4. AI MODEL INTEGRATION
addSection('4. AI MODEL AUDIT (GOOGLE GEMINI 1.5 FLASH)');
addBullet('Model Identifier', 'gemini-1.5-flash (Primary) / gemini-2.0-flash (Secondary Fallback)');
addBullet('Multimodal Risk Engine', 'POST /api/v1/ai-risk/analyze parses user text snippets and returns structured JSON XAI threat reports.');
addBullet('General Purpose + Security AI', 'POST /api/v1/ai-risk/coach-chat handles general educational/coding queries and dynamically activates Security Mode for digital threats.');
addBullet('Conversation Context', 'Maintains multi-turn context using model.startChat({ history }) mapping up to 10 past messages.');

// 5. IMPLEMENTATION STATUS
addSection('5. VERIFIED IMPLEMENTATION STATUS');
addBullet('Fully Implemented & Verified', 'Gemini 1.5 Flash XAI threat classification, General Purpose + Security AI Assistant, Real-Time Hardware GPS & Nominatim geocoding, Searchable 190+ country dial code selector, 3-Second SOS Emergency Countdown, AES-256 Storage & SHA-256 Hashing, PDF Incident Report Generator, Interactive MIL Learning Center & Extortion Simulator.');
addBullet('Prototypes / Simulated', 'Parental Oversight Dashboard UI (parent_dashboard_screen.dart), Direct SMS Gateway (logs alert payload to server console).');
addBullet('Not Implemented / Fact-Check Warnings', 'No automatic background scraping of third-party chat apps without user paste; No local on-device LLM execution.');

// 6. UNESCO MIL ALIGNMENT
addSection('6. UNESCO MEDIA AND INFORMATION LITERACY (MIL) ALIGNMENT');
addParagraph('Provo Guard directly empowers youth by fostering critical thinking, scam manipulation recognition, digital rights awareness, and safe communication practices under the UNESCO Media and Information Literacy framework.');

// Footer
doc.moveDown(2);
doc.rect(40, doc.y, 515, 40).fill(PRIMARY);
doc.fillColor('#FFFFFF').fontSize(10).font('Helvetica-Bold').text('Provo Guard — Youth Digital Safety Ecosystem', 55, doc.y - 30);
doc.fillColor('#00A2FF').fontSize(9).font('Helvetica').text('GitHub: https://github.com/atheeb11/Provo-Guard', 300, doc.y - 30, { align: 'right' });

doc.end();

stream.on('finish', () => {
  console.log('PDF Report generated successfully at:', outputPath);
});
