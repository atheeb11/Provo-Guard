/**
 * Brevo Transactional Email Service
 */
async function sendVerificationEmail(recipientEmail, recipientName, otpCode) {
  const apiKey = process.env.BREVO_API_KEY || '';
  const senderEmail = process.env.BREVO_SENDER_EMAIL || 'contact.provoguard.ai@gmail.com';

  const url = 'https://api.brevo.com/v3/smtp/email';

  const body = {
    sender: {
      name: 'Provo Guard Support',
      email: senderEmail
    },
    to: [
      {
        email: recipientEmail,
        name: recipientName || 'User'
      }
    ],
    subject: 'Verify Your Guardian AI Account - 6-Digit OTP',
    htmlContent: `
      <html>
        <body style="font-family: Arial, sans-serif; padding: 20px; color: #333;">
          <div style="max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 10px; padding: 24px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
            <h2 style="color: #1D4ED8; text-align: center;">🛡️ Guardian AI Security Code</h2>
            <p>Hello,</p>
            <p>Thank you for registering with **Guardian AI** (Provo Guard). To complete your registration and secure your profile, please enter the following 6-digit verification code:</p>
            
            <div style="background: #F3F4F6; font-size: 32px; font-weight: bold; text-align: center; padding: 16px; margin: 24px 0; border-radius: 8px; letter-spacing: 6px; color: #1E293B;">
              ${otpCode}
            </div>

            <p style="font-size: 13px; color: #64748B;">This security code is active for 15 minutes. If you did not request this code, please ignore this email.</p>
            
            <hr style="border: 0; border-top: 1px solid #E2E8F0; margin: 24px 0;" />
            <p style="font-size: 11px; color: #94A3B8; text-align: center;">Guardian AI Security Ecosystem &bull; Protect. Empower. Prevent.</p>
          </div>
        </body>
      </html>
    `
  };

  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'accept': 'application/json',
        'api-key': apiKey,
        'content-type': 'application/json'
      },
      body: JSON.stringify(body)
    });

    if (response.ok) {
      const data = await response.json();
      console.log(`[EmailService] Verification OTP email successfully sent to ${recipientEmail}. Message ID:`, data.messageId);
      return { success: true, messageId: data.messageId };
    } else {
      const errText = await response.text();
      console.error('[EmailService] Error sending email via Brevo:', errText);
      return { success: false, error: errText };
    }
  } catch (error) {
    console.error('[EmailService] Network error during email dispatch:', error.message);
    return { success: false, error: error.message };
  }
}

module.exports = {
  sendVerificationEmail
};
