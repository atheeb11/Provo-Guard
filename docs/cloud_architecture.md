# Google Cloud & Backend Architecture — GUARDIAN AI

This document details the backend production cloud infrastructure for **Guardian AI** built on Google Cloud Platform (GCP) and Firebase.

---

## Cloud Architecture Topology

```
+--------------------------------------------------------------------------------+
|                             ANDROID CLIENT APP (Flutter)                       |
|               (ML Kit Local OCR + AES-256 Vault + Material 3 UI)               |
+--------------------------------------------------------------------------------+
                                        |
                            (HTTPS REST / TLS 1.3)
                                        v
+--------------------------------------------------------------------------------+
|                               CLOUD RUN SERVICE                                |
|             Node.js REST API + Express + Helmet + Rate Limiter                 |
+--------------------------------------------------------------------------------+
       |                                |                                 |
       v                                v                                 v
+--------------+               +------------------+               +--------------+
| GEMINI 1.5   |               | FIRESTORE DB     |               | FIREBASE     |
| FLASH API    |               | (Normalized Logs)|               | STORAGE      |
| (XAI Engine) |               +------------------+               | (Encrypted)  |
+--------------+                        |                         +--------------+
                                        v
                               +------------------+
                               | CLOUD FUNCTIONS  |
                               | (Emergency FCM   |
                               | Push Alerts)     |
                               +------------------+
```

---

## Component Breakdown

1. **Google Cloud Run**:
   - Hosts the Node.js Express REST API server containerized via Docker.
   - Autoscaling from 0 to 100 instances with zero infrastructure friction.

2. **Gemini 1.5 Flash AI Engine**:
   - Analyzes incoming text snippets for extortion, blackmail, sextortion, and grooming tactics.
   - Delivers JSON structured Explainable AI (XAI) risk scores (0–100), red flag indicators, and trauma-informed safety recommendations.

3. **Firebase Authentication & App Check**:
   - Handles multi-factor authentication (Google Sign-In, Email/Password, Biometric tokens).
   - Firebase App Check prevents unauthorized API abuse using Play Integrity attestation.

4. **Secret Manager**:
   - Stores `GEMINI_API_KEY`, `FIREBASE_SERVICE_ACCOUNT`, and JWT signing keys securely.

5. **Cloud Functions for Firebase (FCM)**:
   - Triggers real-time high-priority push notifications to emergency contacts when Emergency Mode is activated.
