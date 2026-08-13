# Cybersecurity & Zero-Trust Privacy Guide — GUARDIAN AI

Guardian AI is engineered around strict zero-trust security and trauma-informed privacy principles.

---

## Key Security Pillars

### 1. Local On-Device ML Kit OCR Scanning
- Sensitive document photos (Passports, National IDs, Credit Cards) are processed **entirely on-device** using Google ML Kit.
- Raw images are **never sent to cloud servers** without explicit user confirmation.

### 2. AES-256-GCM Encrypted Evidence Vault
- All saved screenshots, chat exports, and audio clips are encrypted locally using AES-256-GCM encryption before writing to disk.
- SHA-256 cryptographic digests are generated for each item, providing tamper-evident chain-of-custody verification for law enforcement audits.

### 3. Transparent Explainable AI (XAI)
- Risk scores (0–100) are never presented in isolation. Every risk level is accompanied by clear, non-jargon explanations of why specific phrases were flagged.

### 4. Trauma-Informed Safety Coach
- The AI Safety Coach is hard-coded with strict zero-blame, zero-shame safety guidelines.
- Automatically provides grounding exercises (5-4-3-2-1) and direct access to crisis helplines (RAINN, 988, NCMEC).

### 5. Explicit Consent & Visible Monitoring
- Monitoring operates **only on visible interactions** via Android Accessibility and Notification services after explicit onboarding consent.
- Never bypasses end-to-end encryption or accesses hidden chat channels.
