# 🛡️ PROVO GUARD
> **AI Companion Against Cyber Extortion, Sextortion & Digital Exploitation**

[![Google Gemini](https://img.shields.io/badge/AI-Gemini%201.5%20Flash-0EA5E9)](https://deepmind.google/technologies/gemini/)
[![Flutter](https://img.shields.io/badge/Frontend-Flutter%203.x-0284C7)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Backend-Node.js%20v24-339933)](https://nodejs.org)
[![License](https://img.shields.io/badge/License-MIT-blue)](LICENSE)

Provo Guard is a production-grade mobile protection ecosystem designed to safeguard teenagers and young adults from **Cyber Extortion, Sextortion, Grooming, Catfishing, Identity Theft, and Digital Exploitation**. Built with Flutter, Material Design 3, Node.js REST API, Google Gemini AI, and Google ML Kit, Provo Guard prioritizes **prevention before damage occurs** while maintaining zero-trust privacy, explainable AI (XAI), and trauma-informed psychological first support.

---

## 🌟 Key Features & Highlights

- 🎯 **AI Risk Engine (0-100 Score & XAI)**: Multimodal threat classifier delivering transparent Explainable AI (XAI) rationale, severity levels (Safe, Low, Medium, High, Critical), and red flag breakdowns.
- 💬 **Trauma-Informed AI Safety Coach**: Empathetic chatbot providing 5-4-3-2-1 grounding exercises, guided 4-7-8 breathing visualizer, zero victim-blaming, and instant crisis helpline routing (988, RAINN, NCMEC).
- 🚨 **One-Tap Emergency Mode**: Instant alert dispatcher with 3-second abort countdown, live GPS location broadcast to emergency contacts, nearby police station route mapping, and automated PDF incident report generator.
- 🔐 **Encrypted Evidence Vault**: Local AES-256 encrypted storage for screenshots and chat exports, paired with SHA-256 chain-of-custody hashes for law enforcement verification.
- 📄 **On-Device Document Privacy Scanner**: Local Google ML Kit OCR scanning for Passports, National IDs, Credit Cards, and PII metadata before sharing.
- 🎓 **Learning Center & Chat Simulator**: Interactive cybersecurity courses, quizzes, and fake extortion chat practice scenario.
- 📍 **Safe Places Map**: Google Maps location view pin-pointing nearby police stations, hospitals, and crisis shelters.

---

## 🏗️ Repository Architecture & Project Layout

```
provo/
├── guardian_ai_backend/          # Node.js Express REST API Server
│   ├── src/
│   │   ├── config/              # Gemini API & Firebase Admin Config
│   │   ├── controllers/         # Auth, AI Risk, Evidence, Emergency & Learning Controllers
│   │   ├── middleware/          # JWT Validation, Rate Limiter & Error Handlers
│   │   ├── routes/              # REST API Router Definitions
│   │   ├── services/            # PDF Incident Report Generator (PDFKit)
│   │   ├── tests/               # Integration Self-Test Suite
│   │   └── server.js            # Express Server Bootstrap
│   └── package.json
│
├── guardian_ai_app/              # Flutter 3.x Mobile Client Application
│   ├── android/                  # Android Manifest with Accessibility & Location Permissions
│   ├── lib/
│   │   ├── core/                # Theme (Material 3), Router (GoRouter), Encryption & ML Kit Services
│   │   ├── domain/              # Data Models (ThreatModel, EvidenceModel, etc.)
│   │   ├── features/            # Onboarding, Threat Monitor, AI Coach, Evidence Vault, Emergency, Learning
│   │   └── main.dart            # Flutter App Bootstrap
│   └── pubspec.yaml
│
└── docs/                         # Whitepapers & Architecture Documentation
    ├── database_schema.md       # Normalized Firestore Schema & Rules
    ├── cloud_architecture.md    # GCP & Firebase Infrastructure Diagram
    └── security_guide.md        # Zero-Trust Privacy & Cybersecurity Whitepaper
```

---

## ⚡ Quick Start & Execution Guide

### 1. Run Backend Server & Integration Tests
```bash
cd guardian_ai_backend
npm install
node src/tests/api.test.js
```

### 2. Launch Backend API Server
```bash
npm start
# Server runs on http://localhost:8080 (Health check: http://localhost:8080/api/health)
```

### 3. Run Flutter Application
```bash
cd guardian_ai_app
flutter pub get
flutter run
```

---

## 📡 REST API Reference Summary

| Endpoint | Method | Description |
| :--- | :--- | :--- |
| `/api/health` | `GET` | Server status and AI Engine health check |
| `/api/v1/auth/login` | `POST` | User authentication & JWT token generation |
| `/api/v1/ai-risk/analyze` | `POST` | Gemini AI threat classification & XAI risk breakdown |
| `/api/v1/ai-risk/coach-chat` | `POST` | Trauma-informed AI Safety Coach support chat |
| `/api/v1/evidence` | `POST` / `GET` | Encrypted evidence storage & SHA-256 hash list |
| `/api/v1/emergency/trigger` | `POST` | One-Tap Emergency activation & location alert dispatch |
| `/api/v1/emergency/pdf-report/:id`| `GET` | Export tamper-evident PDF Incident Report |
| `/api/v1/emergency/safe-places` | `GET` | Fetch nearby police stations & crisis shelters |

---

## 🛡️ License

Built with ❤️ for youth digital safety under the MIT License.
