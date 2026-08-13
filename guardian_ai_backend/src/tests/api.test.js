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

    // Test 4: Evidence Vault Add Item
    console.log('\n--- Test 4: Evidence Vault Storage ---');
    const evidenceRes = await makeRequest('/evidence', 'POST', {
      title: 'WhatsApp Extortion Threat Screenshot',
      itemType: 'screenshot',
      appSource: 'WhatsApp',
      originalText: 'Pay $500 or I post your photos...'
    });
    console.log('Evidence Vault Status:', evidenceRes.data.message);
    console.log('SHA-256 Hash:', evidenceRes.data.item.sha256Hash);

    // Test 5: Emergency Trigger
    console.log('\n--- Test 5: One-Tap Emergency Trigger ---');
    const emergencyRes = await makeRequest('/emergency/trigger', 'POST', {
      latitude: 37.7749,
      longitude: -122.4194,
      customMessage: 'EMERGENCY: Coercive extortion detected.'
    });
    console.log('Emergency Incident ID:', emergencyRes.data.incident.incidentId);

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
