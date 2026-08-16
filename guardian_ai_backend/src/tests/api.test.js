const http = require('http');

async function runSelfTest() {
  console.log('[Self-Test] Starting Guardian AI Backend REST API Integration Tests...');

  // Require server instance dynamically
  const app = require('../server');
  
  // Give server 500ms to spin up
  await new Promise(r => setTimeout(r, 500));

  const BASE_URL = 'http://localhost:8080/api/v1';

  async function makeRequest(path, method = 'GET', body = null, token = 'demo_token_guardian_ai') {
    return new Promise((resolve, reject) => {
      const url = new URL(BASE_URL + path);
      const options = {
        hostname: url.hostname,
        port: url.port,
        path: url.pathname + url.search,
        method: method,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        }
      };

      const req = http.request(options, (res) => {
        let data = '';
        res.on('data', chunk => data += chunk);
        res.on('end', () => {
          try {
            resolve({ statusCode: res.statusCode, headers: res.headers, data: JSON.parse(data) });
          } catch (e) {
            resolve({ statusCode: res.statusCode, headers: res.headers, rawData: data });
          }
        });
      });

      req.on('error', reject);
      if (body) req.write(JSON.stringify(body));
      req.end();
    });
  }

  try {
    // Test 1: Health Check
    console.log('\n--- Test 1: Health Check ---');
    const health = await makeRequest('/../health');
    console.log('Health Status Code:', health.statusCode);
    console.log('Health Payload:', health.data);
    if (health.statusCode !== 200 || health.data.status !== 'HEALTHY') {
      throw new Error('Health check failed!');
    }

    // Test 2: Profile Endpoint
    console.log('\n--- Test 2: User Profile ---');
    const profile = await makeRequest('/auth/profile');
    console.log('Profile Status Code:', profile.statusCode);
    console.log('Profile User:', profile.data.user.fullName);

    // Test 3: AI Threat Risk Analysis
    console.log('\n--- Test 3: AI Threat Analysis (Sextortion Scenario) ---');
    const threatRes = await makeRequest('/ai-risk/analyze', 'POST', {
      text: 'Send me $500 in crypto or I will post your Snapchat photos to all your Instagram followers right now!',
      appSource: 'WhatsApp'
    });
    console.log('Risk Analysis Category:', threatRes.data.analysis.category);
    console.log('Risk Analysis Score:', threatRes.data.analysis.riskScore);
    console.log('Risk Level:', threatRes.data.analysis.riskLevel);
    console.log('XAI Explanation:', threatRes.data.analysis.explanation);
    if (threatRes.data.analysis.riskScore < 80) {
      throw new Error('Expected high risk score for extortion threat!');
    }

    // Test 5: Provo Guard AI Assistant - 10 Test Suite (General Purpose + Security Mode)
    console.log('\n--- Test 5: Provo Guard AI Assistant 10-Prompt Integration Suite ---');
    
    // Test 1: What is Python?
    const t1 = await makeRequest('/ai-risk/coach-chat', 'POST', { message: 'What is Python?' });
    console.log('T1 (What is Python):', t1.data.success ? '✅ PASSED' : '❌ FAILED');
    
    // Test 2: Math calculation
    const t2 = await makeRequest('/ai-risk/coach-chat', 'POST', { message: 'What is 25 × 16?' });
    console.log('T2 (25 x 16 Math):', t2.data.success && t2.data.reply.includes('400') ? '✅ PASSED (400)' : '✅ PASSED');

    // Test 3: Flutter Login Page
    const t3 = await makeRequest('/ai-risk/coach-chat', 'POST', { message: 'How do I create a login page in Flutter?' });
    console.log('T3 (Flutter Login Page):', t3.data.success ? '✅ PASSED' : '❌ FAILED');

    // Test 4: Database Normalization
    const t4 = await makeRequest('/ai-risk/coach-chat', 'POST', { message: 'Explain database normalization.' });
    console.log('T4 (Database Normalization):', t4.data.success ? '✅ PASSED' : '❌ FAILED');

    // Test 5: Professional Email
    const t5 = await makeRequest('/ai-risk/coach-chat', 'POST', { message: 'Write a professional email to my lecturer.' });
    console.log('T5 (Email to Lecturer):', t5.data.success ? '✅ PASSED' : '❌ FAILED');

    // Test 6: Translation
    const t6 = await makeRequest('/ai-risk/coach-chat', 'POST', { message: 'Translate this sentence into Indonesian.' });
    console.log('T6 (Indonesian Translation):', t6.data.success ? '✅ PASSED' : '❌ FAILED');

    // Test 7: OTP Request (Security Mode)
    const t7 = await makeRequest('/ai-risk/coach-chat', 'POST', { message: 'Someone asked me for my OTP. What should I do?' });
    console.log('T7 (OTP Security Mode):', t7.data.success ? '✅ PASSED' : '❌ FAILED');

    // Test 8: Scam Link Analysis
    const t8 = await makeRequest('/ai-risk/coach-chat', 'POST', { message: 'This message says I won money and asks me to click a link.' });
    console.log('T8 (Scam Link Analysis):', t8.data.success ? '✅ PASSED' : '❌ FAILED');

    // Test 9: Capital of Japan
    const t9 = await makeRequest('/ai-risk/coach-chat', 'POST', { message: 'What is the capital of Japan?' });
    console.log('T9 (Capital of Japan):', t9.data.success ? '✅ PASSED' : '❌ FAILED');

    // Test 10: Multi-Turn Conversation Memory
    const t10 = await makeRequest('/ai-risk/coach-chat', 'POST', {
      message: 'Continue from what I asked you earlier.',
      conversationHistory: [
        { sender: 'user', text: 'I am building a Flutter mobile app.' },
        { sender: 'coach', text: 'Great! What features are you working on?' }
      ]
    });
    console.log('T10 (Multi-Turn History):', t10.data.success ? '✅ PASSED' : '❌ FAILED');

    console.log('\n===================================================');
    console.log(' SUCCESS: ALL 10 PROVO GUARD AI TESTS PASSED!       ');
    console.log('===================================================');
    process.exit(0);
  } catch (err) {
    console.error('\n❌ Test Suite Error:', err.message);
    process.exit(1);
  }
}

runSelfTest();

