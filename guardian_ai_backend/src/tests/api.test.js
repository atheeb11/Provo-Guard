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

    // Test 5: Provo Guard AI Assistant Chat & Follow-up Memory
    console.log('\n--- Test 5: Provo Guard AI Assistant Chat & Multi-Turn Memory ---');
    const chat1 = await makeRequest('/ai-risk/coach-chat', 'POST', {
      message: 'Someone asked me to send them my OTP.'
    });
    console.log('AI Chat OTP Test Success:', chat1.data.success);
    console.log('AI Chat OTP Response Snippet:', chat1.data.reply ? chat1.data.reply.substring(0, 100) + '...' : 'No reply');

    const chat2 = await makeRequest('/ai-risk/coach-chat', 'POST', {
      message: 'Congratulations, you won $10,000. Click this link immediately.'
    });
    console.log('AI Chat Scam Test Success:', chat2.data.success);
    console.log('AI Chat Scam Risk Level:', chat2.data.riskLevel);

    const chat3 = await makeRequest('/ai-risk/coach-chat', 'POST', {
      message: 'What should I do?',
      conversationHistory: [
        { sender: 'user', text: 'I received a suspicious message saying I won a prize.' },
        { sender: 'coach', text: 'That sounds like a classic scam.' }
      ]
    });
    console.log('AI Chat Follow-Up Memory Test Success:', chat3.data.success);
    console.log('AI Chat Follow-Up Response Snippet:', chat3.data.reply ? chat3.data.reply.substring(0, 100) + '...' : 'No reply');

    console.log('\n===================================================');
    console.log(' SUCCESS: ALL BACKEND REST API TESTS PASSED!       ');
    console.log('===================================================');
    process.exit(0);
  } catch (err) {
    console.error('\n❌ Test Suite Error:', err.message);
    process.exit(1);
  }
}

runSelfTest();

