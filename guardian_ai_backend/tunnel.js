const { spawn } = require('child_process');
const https = require('https');
const fs = require('fs');

let tunnelProcess = null;
const subdomain = 'provoguard-companion-api';
let activeUrl = null;
let consecutiveFailures = 0;

function startTunnel() {
  console.log(`[Tunnel] Starting localtunnel on port 8080 with subdomain "${subdomain}"...`);
  
  if (tunnelProcess) {
    try { tunnelProcess.kill('SIGINT'); } catch(e) {}
  }

  // Use npx -y localtunnel
  tunnelProcess = spawn('npx', ['-y', 'localtunnel', '--port', '8080', '--subdomain', subdomain], {
    shell: true,
    stdio: ['ignore', 'pipe', 'pipe']
  });

  tunnelProcess.stdout.on('data', (data) => {
    const output = data.toString();
    console.log(`[localtunnel stdout] ${output.trim()}`);
    
    // Parse URL from stdout
    const match = output.match(/your url is: (https:\/\/[^\s]+)/);
    if (match) {
      activeUrl = match[1];
      console.log(`[Tunnel] ACTIVE PUBLIC URL: ${activeUrl}`);
      fs.writeFileSync('active_tunnel.txt', activeUrl);
    }
  });

  tunnelProcess.stderr.on('data', (data) => {
    console.error(`[localtunnel stderr] ${data.toString().trim()}`);
  });

  tunnelProcess.on('close', (code) => {
    console.log(`[Tunnel] Process exited with code ${code}. Restarting in 5s...`);
    activeUrl = null;
    setTimeout(startTunnel, 5000);
  });
}

function checkTunnelHealth() {
  if (!activeUrl) {
    console.log('[Health Check] Waiting for tunnel URL to be assigned...');
    return;
  }

  const url = `${activeUrl}/api/health`;
  console.log(`[Health Check] Checking health of ${url}...`);
  
  const options = {
    timeout: 8000,
    headers: {
      'Bypass-Tunnel-Reminder': 'true'
    }
  };

  const req = https.get(url, options, (res) => {
    let data = '';
    res.on('data', (chunk) => data += chunk);
    res.on('end', () => {
      if (res.statusCode === 200) {
        console.log(`[Health Check] Tunnel is healthy (200 OK)`);
        consecutiveFailures = 0;
      } else {
        console.warn(`[Health Check] Tunnel returned status ${res.statusCode}.`);
        handleFailure();
      }
    });
  });

  req.on('error', (err) => {
    console.error(`[Health Check] Connection failed: ${err.message}`);
    handleFailure();
  });

  req.on('timeout', () => {
    console.error(`[Health Check] Request timed out.`);
    req.destroy();
    handleFailure();
  });
}

function handleFailure() {
  consecutiveFailures++;
  console.log(`[Health Check] Failure count: ${consecutiveFailures}/2`);
  if (consecutiveFailures >= 2) {
    console.log('[Tunnel] Self-healing: 2 consecutive failures. Restarting tunnel...');
    consecutiveFailures = 0;
    if (tunnelProcess) {
      try {
        tunnelProcess.kill('SIGINT');
      } catch(e) {}
    }
  }
}

// Start tunnel initially
startTunnel();

// Start checking health every 15 seconds (give it 10 seconds to start first)
setTimeout(() => {
  setInterval(checkTunnelHealth, 15000);
}, 10000);
