# Firestore Database Schema & Rules — GUARDIAN AI

This document details the production-grade normalized Google Cloud Firestore collection schema, index strategies, and security rules for **Guardian AI**.

---

## Firestore Collections

### 1. `users` (Collection)
- **Document ID**: `uid` (Firebase Auth UID)
- **Fields**:
  - `uid`: `string`
  - `email`: `string`
  - `fullName`: `string`
  - `age`: `number`
  - `country`: `string`
  - `emergencyContacts`: `array` of objects:
    - `name`: `string`
    - `phone`: `string`
    - `relationship`: `string`
  - `privacyPreferences`: `map`:
    - `visibleMonitoringConsent`: `boolean`
    - `localOCRAnalysis`: `boolean`
    - `cloudAnalysisConsent`: `boolean`
    - `biometricLockEnabled`: `boolean`
  - `createdAt`: `timestamp`

### 2. `threat_logs` (Collection)
- **Document ID**: Auto-generated string
- **Fields**:
  - `uid`: `string` (Owner UID)
  - `riskScore`: `number` (0–100)
  - `riskLevel`: `string` (`Safe` | `Low` | `Medium` | `High` | `Critical`)
  - `category`: `string` (`Sextortion` | `Grooming` | `Catfishing` | `Financial Scam` | `Safe`)
  - `appSource`: `string` (`WhatsApp` | `Instagram` | `Telegram` | `SMS`)
  - `scannedTextSnippet`: `string`
  - `explanation`: `string` (Explainable AI breakdown)
  - `redFlags`: `array` of `string`
  - `actionableSteps`: `array` of `string`
  - `psychologicalSupport`: `string`
  - `timestamp`: `timestamp`

### 3. `evidence_items` (Collection)
- **Document ID**: Auto-generated string
- **Fields**:
  - `uid`: `string`
  - `title`: `string`
  - `itemType`: `string` (`screenshot` | `chat_export` | `audio`)
  - `appSource`: `string`
  - `sha256Hash`: `string` (Chain-of-Custody digest)
  - `encryptionAlgorithm`: `string` (`AES-256-GCM`)
  - `fileUrl`: `string` (Encrypted Firebase Storage URI)
  - `timestamp`: `timestamp`

### 4. `emergency_incidents` (Collection)
- **Document ID**: `incidentId` (`INC-xxxxxx`)
- **Fields**:
  - `incidentId`: `string`
  - `uid`: `string`
  - `userName`: `string`
  - `userPhone`: `string`
  - `location`: `map`:
    - `latitude`: `number`
    - `longitude`: `number`
    - `address`: `string`
  - `status`: `string` (`ACTIVE_EMERGENCY` | `RESOLVED`)
  - `alertContacts`: `array` of `map`
  - `timestamp`: `timestamp`

---

## Firestore Security Rules (`firestore.rules`)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // User Profile Rules
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Threat Logs Rules
    match /threat_logs/{logId} {
      allow create: if request.auth != null && request.resource.data.uid == request.auth.uid;
      allow read, delete: if request.auth != null && resource.data.uid == request.auth.uid;
    }
    
    // Evidence Items Rules
    match /evidence_items/{itemId} {
      allow create: if request.auth != null && request.resource.data.uid == request.auth.uid;
      allow read, delete: if request.auth != null && resource.data.uid == request.auth.uid;
    }
    
    // Emergency Incidents Rules
    match /emergency_incidents/{incidentId} {
      allow create, read: if request.auth != null && request.resource.data.uid == request.auth.uid;
    }
  }
}
```
