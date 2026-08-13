const { getGenerativeModel, SYSTEM_INSTRUCTIONS } = require('../config/gemini');
const { getDb } = require('../config/firebase');

/**
 * Heuristic fallback AI Risk Engine if Gemini API Key is missing or rate limited
 */
function analyzeThreatHeuristic(text, appSource) {
  const lower = (text || '').toLowerCase();
  
  let riskScore = 5;
  let category = 'Safe Interaction';
  let riskLevel = 'Safe';
  let redFlags = [];
  let actionableSteps = ['Continue observing digital safety guidelines.', 'Never share personal passwords or sensitive IDs.'];
  let explanation = 'The conversation shows normal social interaction with no coercive or manipulative patterns detected.';
  let psychologicalSupport = 'You are safe. Keep maintaining healthy digital boundaries!';

  // Sextortion keywords
  if (lower.includes('pay') || lower.includes('bitcoin') || lower.includes('send nude') || lower.includes('expose you') || lower.includes('leak') || lower.includes('send money') || lower.includes('instagram followers') || lower.includes('post your photo')) {
    riskScore = 92;
    riskLevel = 'Critical';
    category = 'Sextortion';
    redFlags = [
      'Financial demand or coercive blackmail detected',
      'Threat of public exposure or unauthorized photo sharing',
      'High urgency time pressure tactics'
    ];
    explanation = 'CRITICAL WARNING: Coercive extortion pattern detected. The sender is attempting blackmail by threatening to publish media unless money or further explicit content is provided.';
    actionableSteps = [
      'DO NOT PAY OR SEND MONEY. Extortionists will continue demanding more.',
      'DO NOT delete messages or screenshots — save them in your Encrypted Evidence Vault.',
      'Block the extortionist account immediately across all social media.',
      'Tap One-Tap Emergency to generate an official incident report.'
    ];
    psychologicalSupport = 'Take a slow, deep breath. You are not at fault, and you are not alone. Sextortion perpetrators rely on panic — remaining calm and preserving evidence is your best shield.';
  } 
  // Grooming & Emotional Manipulation
  else if (lower.includes('don\'t tell your parents') || lower.includes('our secret') || lower.includes('keep this private') || lower.includes('send me a picture') || lower.includes('nobody understands you like me')) {
    riskScore = 78;
    riskLevel = 'High';
    category = 'Grooming';
    redFlags = [
      'Secrecy enforcement ("don\'t tell anyone")',
      'Isolation tactics aimed at cutting off family/friends',
      'Inappropriate boundary push for private photos'
    ];
    explanation = 'HIGH RISK: Coercive secrecy pattern. The sender is attempting to isolate you and establish an exclusive secret relationship.';
    actionableSteps = [
      'Refuse demands for secrecy — share this conversation with a trusted adult or contact.',
      'Do not share private personal photos or live location.',
      'Document all conversation history into the Evidence Vault.'
    ];
    psychologicalSupport = 'Anyone who asks you to keep secrets from people who care about you does not have your best interests at heart.';
  }
  // Financial Scams & Identity Theft
  else if (lower.includes('bank account') || lower.includes('verification code') || lower.includes('ssn') || lower.includes('gift card') || lower.includes('crypto deposit') || lower.includes('passport picture')) {
    riskScore = 65;
    riskLevel = 'Medium';
    category = 'Financial Scam';
    redFlags = [
      'Request for sensitive identity documents or credentials',
      'Unsolicited request for payment or gift cards'
    ];
    explanation = 'MEDIUM RISK: Identity theft or financial scam attempt detected. Never share identification cards or OTP credentials.';
    actionableSteps = [
      'Never send photos of official IDs, Passports, or Banking credentials.',
      'Verify identity through an alternative trusted communication channel.'
    ];
    psychologicalSupport = 'Protecting your personal data is smart self-defense. You have full right to decline sharing identity documents.';
  }

  return {
    riskScore,
    riskLevel,
    category,
    explanation,
    redFlags,
    actionableSteps,
    psychologicalSupport,
    scannedTextSnippet: text.length > 200 ? text.substring(0, 197) + '...' : text,
    appSource: appSource || 'WhatsApp',
    timestamp: new Date().toISOString()
  };
}

/**
 * AI Risk Analysis Endpoint
 */
async function analyzeInteraction(req, res) {
  try {
    try { require('dotenv').config({ override: true }); } catch (e) {}
    const { text, appSource, extractedOCRText } = req.body;
    const contentToAnalyze = text || extractedOCRText || '';

    if (!contentToAnalyze.trim()) {
      return res.status(400).json({ success: false, error: 'Text or OCR content is required for AI risk analysis.' });
    }

    let analysisResult;

    // Try Gemini API powered multimodal XAI analysis
    try {
      if (process.env.GEMINI_API_KEY && process.env.GEMINI_API_KEY !== 'DEMO_GEMINI_API_KEY') {
        const model = getGenerativeModel('gemini-flash-latest');
        const prompt = `${SYSTEM_INSTRUCTIONS.THREAT_ANALYZER}\n\nApp Context: ${appSource || 'Social Media/Chat App'}\nMessage Text Content:\n"${contentToAnalyze}"`;
        
        const result = await model.generateContent(prompt);
        const responseText = result.response.text();
        
        // Clean markdown backticks if present
        const cleanedJson = responseText.replace(/```json/g, '').replace(/```/g, '').trim();
        analysisResult = JSON.parse(cleanedJson);
        analysisResult.scannedTextSnippet = contentToAnalyze.substring(0, 200);
        analysisResult.appSource = appSource || 'Visible Monitoring';
        analysisResult.timestamp = new Date().toISOString();
      } else {
        analysisResult = analyzeThreatHeuristic(contentToAnalyze, appSource);
      }
    } catch (aiError) {
      console.warn('[AI Risk Engine] Gemini API fallback triggered:', aiError.message);
      analysisResult = analyzeThreatHeuristic(contentToAnalyze, appSource);
    }

    // Persist threat log in Firestore
    const db = getDb();
    const threatDoc = {
      uid: req.user.uid,
      ...analysisResult
    };
    const ref = await db.collection('threat_logs').add(threatDoc);

    res.json({
      success: true,
      threatId: ref.id,
      analysis: analysisResult
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}

/**
 * Trauma-Informed Safety Coach Chat Endpoint
 */
async function chatSafetyCoach(req, res) {
  try {
    try { require('dotenv').config({ override: true }); } catch (e) {}
    const { message, conversationHistory } = req.body;
    if (!message) {
      return res.status(400).json({ success: false, error: 'Message text is required.' });
    }

    let reply = '';
    let groundingTechnique = null;

    try {
      if (process.env.GEMINI_API_KEY && process.env.GEMINI_API_KEY !== 'DEMO_GEMINI_API_KEY') {
        const model = getGenerativeModel('gemini-flash-latest');
        const prompt = `${SYSTEM_INSTRUCTIONS.SAFETY_COACH}\nUser Input: "${message}"`;
        const result = await model.generateContent(prompt);
        reply = result.response.text();
      } else {
        // Fallback trauma-informed response
        reply = `I hear how stressful and uncomfortable this situation is, but I want you to remember something critical: **You have done nothing wrong.**\n\nWhen people use blackmail or extortion, their power comes entirely from fear and isolation. By reaching out here, you have already taken control back.\n\nHere are 3 steps we can take together right now:\n1. **Do not respond or pay** — extortionists rely on panic to demand more.\n2. **Lock your evidence** — tap the Evidence Vault button to save screenshots with encrypted timestamps.\n3. **Breathe with me** — let's do a 4-7-8 deep breathing cycle together.`;
        
        groundingTechnique = {
          title: '5-4-3-2-1 Grounding Technique',
          steps: [
            '5 things you can see around you right now',
            '4 things you can physically touch',
            '3 things you can hear',
            '2 things you can smell',
            '1 deep breath in and out slowly'
          ]
        };
      }
    } catch (err) {
      console.warn('[Safety Coach] Gemini call failed, using rule-based response:', err.message);
      const lower = message.toLowerCase();
      if (lower.includes('catfish') || lower.includes('scam')) {
        reply = `To spot a catfishing scam, watch out for these key red flags:\n\n• **Refusal to video call:** They always have excuses or "connection issues."\n• **Professions in high-risk zones:** Claiming to be in the military, working on oil rigs, or traveling constantly.\n• **Perfect photos:** Their profile pictures look like professional models.\n• **Moving too fast:** Expressing deep feelings or professing love within days.\n• **Asking for financial help:** Requesting gift cards, crypto, or help with emergency bills.`;
      } else if (lower.includes('link') || lower.includes('url') || lower.includes('click')) {
        reply = `To verify if a link is safe to click:\n\n• **Inspect the spelling:** Fraudsters use lookalike domains (e.g. \`g00gle.com\` instead of \`google.com\`).\n• **Verify HTTPS:** Secure sites use \`https://\` and show a padlock icon.\n• **Use lookup tools:** You can check links using Google Safe Browsing or VirusTotal.\n• **Trust your gut:** If a stranger sends you a link out of nowhere, do not open it.`;
      } else {
        reply = `I am here to support you. Please remember:\n\n• **Do not share private photos or passwords.**\n• **Save any screenshots to your secure Evidence Vault.**\n• **You have done nothing wrong.**\n\nHow else can I help guide you through this situation?`;
      }
    }

    res.json({
      success: true,
      reply,
      groundingTechnique,
      crisisHotlines: [
        { name: 'National Sexual Assault Hotline (RAINN)', phone: '1-800-656-4673', website: 'https://www.rainn.org' },
        { name: 'Cyber Civil Rights Helpline', phone: '1-844-878-2274', website: 'https://www.cybercivilrights.org' },
        { name: 'NCMEC CyberTipline', phone: '1-800-843-5678', website: 'https://www.report.cybertip.org' },
        { name: '988 Suicide & Crisis Lifeline', phone: '988', text: 'Text 988' }
      ]
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}

/**
 * Get Recent Scanned Threat Logs for User
 */
async function getThreatLogs(req, res) {
  try {
    const db = getDb();
    const snapshot = await db.collection('threat_logs').where('uid', '==', req.user.uid).get();
    
    const logs = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    // If no logs, return mock initial set for visual demonstration
    if (logs.length === 0) {
      return res.json({
        success: true,
        threats: [
          {
            id: 'log_mock_1',
            riskScore: 94,
            riskLevel: 'Critical',
            category: 'Sextortion',
            appSource: 'WhatsApp',
            scannedTextSnippet: 'Pay $500 in crypto or I send your private photos to your Instagram followers...',
            explanation: 'Critical extortion threat with coercive financial demands and public exposure warnings.',
            timestamp: new Date(Date.now() - 3600000).toISOString(),
            redFlags: [
              'Financial demand or coercive blackmail detected',
              'Threat of public exposure or unauthorized photo sharing',
              'High urgency time pressure tactics'
            ],
            actionableSteps: [
              'DO NOT PAY OR SEND MONEY. Extortionists will continue demanding more.',
              'DO NOT delete messages or screenshots — save them in your Encrypted Evidence Vault.',
              'Block the extortionist account immediately across all social media.',
              'Tap One-Tap Emergency to generate an official incident report.'
            ],
            psychologicalSupport: 'Take a slow, deep breath. You are not at fault, and you are not alone.'
          },
          {
            id: 'log_mock_2',
            riskScore: 72,
            riskLevel: 'High',
            category: 'Grooming',
            appSource: 'Instagram Direct',
            scannedTextSnippet: 'Don\'t tell your parents or friends about our chats. It\'s our special secret...',
            explanation: 'High risk grooming indicator enforcing secrecy and social isolation.',
            timestamp: new Date(Date.now() - 86400000).toISOString(),
            redFlags: [
              'Secrecy enforcement ("don\'t tell anyone")',
              'Isolation tactics aimed at cutting off family/friends',
              'Inappropriate boundary push for private photos'
            ],
            actionableSteps: [
              'Refuse demands for secrecy — share this conversation with a trusted adult or contact.',
              'Do not share private personal photos or live location.',
              'Document all conversation history into the Evidence Vault.'
            ],
            psychologicalSupport: 'Anyone who asks you to keep secrets from people who care about you does not have your best interests at heart.'
          }
        ]
      });
    }

    res.json({ success: true, threats: logs });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}

module.exports = {
  analyzeInteraction,
  chatSafetyCoach,
  getThreatLogs
};
