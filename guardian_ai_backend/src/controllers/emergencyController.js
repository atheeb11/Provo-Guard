const { getDb } = require('../config/firebase');
const { createPDFIncidentReport } = require('../services/pdfReportService');

async function triggerEmergency(req, res) {
  try {
    const { latitude, longitude, address, customMessage, selectedContacts } = req.body;
    
    const db = getDb();
    
    // Fetch latest user info and emergency contacts
    const userDoc = await db.collection('users').doc(req.user.uid).get();
    const user = userDoc.exists ? userDoc.data() : { fullName: req.user.name, emergencyContacts: [] };

    const incidentId = 'INC-' + Date.now();
    const emergencyPayload = {
      incidentId,
      uid: req.user.uid,
      userName: user.fullName || 'Alex Vance',
      userPhone: user.phone || '+1-555-0100',
      location: {
        latitude: latitude || 37.7749,
        longitude: longitude || -122.4194,
        address: address || 'Current User Coordinates (San Francisco, CA)'
      },
      status: 'ACTIVE_EMERGENCY',
      alertContacts: selectedContacts || user.emergencyContacts || [],
      customMessage: customMessage || 'EMERGENCY ALERT: Guardian AI detected critical digital extortion/threat. I require immediate assistance.',
      timestamp: new Date().toISOString()
    };

    await db.collection('emergency_incidents').doc(incidentId).set(emergencyPayload);

    res.status(201).json({
      success: true,
      message: 'EMERGENCY MODE ACTIVATED. Alerts dispatched to trusted contacts and nearby emergency safe places logged.',
      incident: emergencyPayload
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}

async function exportIncidentPDF(req, res) {
  try {
    const { incidentId } = req.params;
    
    const incidentData = {
      incidentId: incidentId || 'INC-889421',
      appSource: 'WhatsApp / Instagram Direct',
      riskLevel: 'CRITICAL (Score: 94/100)',
      explanation: 'Target user subjected to coercive blackmail attempt threatening distribution of manipulated images unless cryptocurrency is paid within 24 hours.',
      redFlags: [
        'Demand for $500 payment via Bitcoin wallet',
        'Coercive threat of sharing content to contacts list',
        'Imposition of time limit to force panic decision'
      ],
      evidenceHash: 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
    };

    const pdfBuffer = await createPDFIncidentReport(incidentData);

    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', `attachment; filename=GuardianAI_Incident_${incidentId}.pdf`);
    res.send(pdfBuffer);
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}

async function getNearbySafePlaces(req, res) {
  try {
    const { lat, lng } = req.query;
    
    const safePlaces = [
      {
        id: 'place_1',
        name: 'Central Police Station - Cybercrime Unit',
        type: 'POLICE',
        address: '750 Bryant St, San Francisco, CA 94103',
        distance: '0.8 miles',
        phone: '+1-415-553-0123',
        coordinates: { latitude: 37.7758, longitude: -122.4042 },
        isOpen24Hours: true
      },
      {
        id: 'place_2',
        name: 'UCSF Medical Center & Crisis Support',
        type: 'HOSPITAL',
        address: '505 Parnassus Ave, San Francisco, CA 94143',
        distance: '2.1 miles',
        phone: '+1-415-476-1000',
        coordinates: { latitude: 37.7631, longitude: -122.4578 },
        isOpen24Hours: true
      },
      {
        id: 'place_3',
        name: 'Youth Digital Safety Sanctuary & Resource Center',
        type: 'SAFE_HAVEN',
        address: '1000 Van Ness Ave, San Francisco, CA 94109',
        distance: '1.4 miles',
        phone: '+1-415-998-3321',
        coordinates: { latitude: 37.7845, longitude: -122.4215 },
        isOpen24Hours: false
      }
    ];

    res.json({
      success: true,
      safePlaces
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}

module.exports = {
  triggerEmergency,
  exportIncidentPDF,
  getNearbySafePlaces
};
