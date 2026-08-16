---
title: Provo Guard
emoji: 🛡️
colorFrom: blue
colorTo: indigo
sdk: docker
app_port: 7860
---

# 🛡️ PROVO GUARD
> **Personal Digital Safety & AI Threat Prevention Ecosystem**

[![Google Gemini](https://img.shields.io/badge/AI-Gemini%201.5%20Flash-0EA5E9)](https://deepmind.google/technologies/gemini/)
[![Flutter](https://img.shields.io/badge/Frontend-Flutter%203.x-0284C7)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Backend-Node.js%20REST%20API-339933)](https://nodejs.org)
[![License](https://img.shields.io/badge/License-MIT-blue)](LICENSE)

Provo Guard is a production-grade digital safety application designed to protect users from **Phishing, Scams, Suspicious Links, OTP Fraud, Social Engineering, Cyber Extortion, Sextortion, Grooming, and Online Privacy Threats**. Built with Flutter, Material Design 3, Node.js REST API, Google Gemini AI (Gemini 1.5 Flash), and Google ML Kit, Provo Guard prioritizes **prevention before damage occurs** while maintaining zero-trust privacy, explainable AI (XAI), and trauma-informed security guidance.

---

## 🌟 Key Features & Highlights

- 🤖 **Google Gemini 1.5 AI Assistant (Multi-Turn Chat Memory)**: Intelligent digital-safety assistant powered by Google AI Studio (`gemini-1.5-flash`). Helps users analyze suspicious DMs, detect phishing links, protect WhatsApp/social accounts, and respond safely to digital threats. Features native multi-turn conversation memory (`startChat({ history })`), quick action chips, and clear chat history options.
- 🎯 **AI Risk Engine (0-100 Score & XAI)**: Multimodal threat classifier delivering transparent Explainable AI (XAI) rationale, severity levels (Safe, Low, Medium, High, Critical), red flag breakdowns, and actionable mitigation steps.
- 🌐 **Global Country Dial Code Selector**: Searchable dial code modal picker supporting **190+ countries worldwide** (calling codes and flags) for user registration.
- 📍 **Real-Time GPS Tracking & Reverse Geocoding**: High-accuracy device GPS tracking via Geolocator integrated with OpenStreetMap / Nominatim API for live city/country geocoding and real distance calculation to nearby safe havens.
- 🆘 **One-Tap SOS Emergency Button**: Compact circular SOS button with 3-second abort countdown, broadcasting live coordinates to user-added emergency contacts and nearby police stations.
- 🎨 **Official Provo Guard Logo & Flat App Icon**: Sleek 3D metallic blue shield brand logo deployed across Android launcher mipmap drawables (`mipmap-mdpi` through `mipmap-xxxhdpi`), Flutter assets, and web favicons.
- 🔐 **Encrypted Evidence Vault**: Local AES-256 encrypted storage for screenshots and chat exports paired with SHA-256 chain-of-custody hashes for law enforcement verification.
- 📄 **On-Device Document Privacy Scanner**: Local Google ML Kit OCR scanning for Passports, National IDs, Credit Cards, and PII metadata before sharing media online.
- 🎓 **Learning Center & Chat Simulator**: Interactive cybersecurity courses, quizzes, and fake extortion chat practice scenarios.
- 📍 **Safe Places Map**: Interactive map pinpointing nearby police stations, trauma hospitals, and crisis shelters relative to live GPS position.

---

## 📱 Android APK Binary

The pre-compiled production Android APK is available in the root workspace:

- 💾 **File**: [`Provo_Guard_v1.0.apk`](file:///d:/provo/provo-guard-main%20%281%29/provo-guard-main/Provo_Guard_v1.0.apk)
- 🚀 **App Name**: **Provo Guard**

---

## 🏗️ Repository Architecture & Project Layout

```
provo/
├── Provo_Guard_v1.0.apk          # Pre-compiled Android Debug/Release APK
├── run_provo_guard.ps1           # One-Click PowerShell Startup Script (Backend + Web)
├── run_provo_guard.bat           # One-Click Windows Batch Launcher
├── guardian_ai_backend/          # Node.js Express REST API Server
│   ├── src/
│   │   ├── config/              # Gemini 1.5 Flash API & Firebase Admin Config
│   │   ├── controllers/         # Auth, AI Risk, Evidence, Emergency & Learning Controllers
│   │   ├── middleware/          # JWT Validation, Rate Limiter & Error Handlers
│   │   ├── routes/              # REST API Router Definitions (/api/v1/ai-risk/chat)
│   │   ├── services/            # PDF Incident Report Generator (PDFKit) & Email Service
│   │   ├── tests/               # Integration Self-Test Suite (api.test.js)
│   │   └── server.js            # Express Server Bootstrap
│   └── package.json
│
├── guardian_ai_app/              # Flutter 3.x Mobile Client Application
│   ├── android/                  # Android Manifest (Provo Guard) & Mipmap Flat Icons
│   ├── assets/images/            # Provo Guard Transparent 3D Shield & Brand Logos
│   ├── lib/
│   │   ├── core/                # Theme (Material 3), Router (GoRouter), API Service & GPS
│   │   ├── domain/              # Data Models (ThreatModel, EvidenceModel, etc.)
│   │   ├── features/            # Onboarding, Threat Monitor, AI Assistant, Vault, Emergency
│   │   └── main.dart            # Flutter App Bootstrap
│   ├── web/                      # Web Favicons & PWA Manifest
│   └── pubspec.yaml
│
└── README.md                     # Official Project Overview & Documentation
```

---

## ⚡ Quick Start & Execution Guide

### 🚀 Option A: One-Click Startup Script (Windows)
Run the provided startup script to spin up the Node.js backend and local web client simultaneously:

```powershell
.\run_provo_guard.ps1
```

---

### 🛠️ Option B: Manual Execution

#### 1. Start Node.js Backend Server & Run Integration Tests
```bash
cd guardian_ai_backend
npm install
npm test             # Runs full REST API self-test suite
npm start            # Starts server on http://localhost:8080
```

#### 2. Launch Flutter Mobile/Web Application
```bash
cd guardian_ai_app
flutter pub get
flutter run          # Runs Flutter App on Chrome, Edge, or connected Android Device
```

---

## 📡 REST API Reference Summary

| Endpoint | Method | Description |
| :--- | :--- | :--- |
| `/api/health` | `GET` | Server status and Gemini 1.5 AI Engine health check |
| `/api/v1/auth/login` | `POST` | User authentication & JWT token generation |
| `/api/v1/auth/register` | `POST` | Create account with searchable global country calling code |
| `/api/v1/ai-risk/analyze` | `POST` | Gemini AI threat classification & XAI risk breakdown |
| `/api/v1/ai-risk/coach-chat` | `POST` | Multi-turn Provo Guard AI Assistant conversation (`gemini-1.5-flash`) |
| `/api/v1/ai-risk/chat` | `POST` | Alias endpoint for Provo Guard AI Assistant |
| `/api/v1/evidence` | `POST` / `GET` | Encrypted evidence storage & SHA-256 hash list |
| `/api/v1/emergency/trigger` | `POST` | One-Tap SOS Emergency activation & location alert dispatch |
| `/api/v1/emergency/pdf-report/:id`| `GET` | Export tamper-evident PDF Incident Report |
| `/api/v1/emergency/safe-places` | `GET` | Fetch nearby police stations & crisis shelters |

---

## 🛡️ License

Built with ❤️ for digital security and youth safety under the **MIT License**.
