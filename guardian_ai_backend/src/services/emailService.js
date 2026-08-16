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
    subject: 'Verify Your Provo Guard Account - 6-Digit OTP',
    htmlContent: `
      <html>
        <body style="font-family: Arial, sans-serif; padding: 20px; color: #333;">
          <div style="max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 10px; padding: 24px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
            <h2 style="color: #1D4ED8; text-align: center;">🛡️ Provo Guard Security Code</h2>
            <p>Hello,</p>
            <p>Thank you for registering with **Provo Guard**. To complete your registration and secure your profile, please enter the following 6-digit verification code:</p>
            
            <div style="background: #F3F4F6; font-size: 32px; font-weight: bold; text-align: center; padding: 16px; margin: 24px 0; border-radius: 8px; letter-spacing: 6px; color: #1E293B;">
              ${otpCode}
            </div>

            <p style="font-size: 13px; color: #64748B;">This security code is active for 15 minutes. If you did not request this code, please ignore this email.</p>
            
            <hr style="border: 0; border-top: 1px solid #E2E8F0; margin: 24px 0;" />
            <p style="font-size: 11px; color: #94A3B8; text-align: center;">Provo Guard Security Ecosystem &bull; Protect. Empower. Prevent.</p>
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

async function sendProfileUpdateNotificationEmail(recipientEmail, recipientName, summaryDetails) {
  const apiKey = process.env.BREVO_API_KEY || '';
  const senderEmail = process.env.BREVO_SENDER_EMAIL || 'contact.provoguard.ai@gmail.com';
  const url = 'https://api.brevo.com/v3/smtp/email';

  const body = {
    sender: { name: 'Provo Guard Security', email: senderEmail },
    to: [{ email: recipientEmail, name: recipientName || 'User' }],
    subject: '🛡️ Account Settings Updated - Provo Guard Notification',
    htmlContent: `
      <html>
        <body style="font-family: Arial, sans-serif; padding: 20px; color: #333;">
          <div style="max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 10px; padding: 24px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
            <h2 style="color: #1D4ED8; text-align: center;">🛡️ Account Settings Updated</h2>
            <p>Hello ${recipientName || 'User'},</p>
            <p>Your Provo Guard profile details and account settings have been updated in our database.</p>
            
            <div style="background: #F8FAFC; border-left: 4px solid #2563EB; padding: 16px; margin: 20px 0; border-radius: 4px;">
              <p style="margin: 0; font-weight: bold; color: #1E293B;">Updated Details:</p>
              <p style="margin: 6px 0 0 0; color: #475569; font-size: 14px;">${summaryDetails || 'Profile information updated successfully.'}</p>
            </div>

            <p style="font-size: 13px; color: #64748B;">If you did not initiate this change, please contact Provo Guard support immediately or change your password in the app.</p>
            
            <hr style="border: 0; border-top: 1px solid #E2E8F0; margin: 24px 0;" />
            <p style="font-size: 11px; color: #94A3B8; text-align: center;">Provo Guard Security Ecosystem &bull; Protect. Empower. Prevent.</p>
          </div>
        </body>
      </html>
    `
  };

  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: { 'accept': 'application/json', 'api-key': apiKey, 'content-type': 'application/json' },
      body: JSON.stringify(body)
    });
    if (response.ok) {
      const data = await response.json();
      console.log(`[EmailService] Profile update notification sent to ${recipientEmail}. Message ID:`, data.messageId);
      return { success: true, messageId: data.messageId };
    } else {
      const errText = await response.text();
      console.error('[EmailService] Error sending profile update email:', errText);
      return { success: false, error: errText };
    }
  } catch (error) {
    console.error('[EmailService] Network error during profile update email dispatch:', error.message);
    return { success: false, error: error.message };
  }
}

async function sendPasswordChangedNotificationEmail(recipientEmail, recipientName) {
  const apiKey = process.env.BREVO_API_KEY || '';
  const senderEmail = process.env.BREVO_SENDER_EMAIL || 'contact.provoguard.ai@gmail.com';
  const url = 'https://api.brevo.com/v3/smtp/email';

  const body = {
    sender: { name: 'Provo Guard Security Alert', email: senderEmail },
    to: [{ email: recipientEmail, name: recipientName || 'User' }],
    subject: '⚠️ Security Alert: Password Updated - Provo Guard',
    htmlContent: `
      <html>
        <body style="font-family: Arial, sans-serif; padding: 20px; color: #333;">
          <div style="max-width: 600px; margin: 0 auto; border: 1px solid #DC2626; border-radius: 10px; padding: 24px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
            <h2 style="color: #DC2626; text-align: center;">⚠️ Password Changed Successfully</h2>
            <p>Hello ${recipientName || 'User'},</p>
            <p>The password for your Provo Guard account was recently changed.</p>
            
            <div style="background: #FEF2F2; border-left: 4px solid #DC2626; padding: 16px; margin: 20px 0; border-radius: 4px;">
              <p style="margin: 0; font-weight: bold; color: #991B1B;">Security Status:</p>
              <p style="margin: 6px 0 0 0; color: #7F1D1D; font-size: 14px;">Your password was updated on ${new Date().toLocaleString()}. All active security vaults are now secured under your new credentials.</p>
            </div>

            <p style="font-size: 13px; color: #64748B;">If you did not perform this password reset, please lock your account or notify us immediately.</p>
            
            <hr style="border: 0; border-top: 1px solid #E2E8F0; margin: 24px 0;" />
            <p style="font-size: 11px; color: #94A3B8; text-align: center;">Provo Guard Security Ecosystem &bull; Protect. Empower. Prevent.</p>
          </div>
        </body>
      </html>
    `
  };

  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: { 'accept': 'application/json', 'api-key': apiKey, 'content-type': 'application/json' },
      body: JSON.stringify(body)
    });
    if (response.ok) {
      const data = await response.json();
      console.log(`[EmailService] Password changed alert sent to ${recipientEmail}. Message ID:`, data.messageId);
      return { success: true, messageId: data.messageId };
    } else {
      const errText = await response.text();
      console.error('[EmailService] Error sending password update email:', errText);
      return { success: false, error: errText };
    }
  } catch (error) {
    console.error('[EmailService] Network error during password update email dispatch:', error.message);
    return { success: false, error: error.message };
  }
}

async function sendPasswordResetOtpEmail(recipientEmail, recipientName, otpCode) {
  const apiKey = process.env.BREVO_API_KEY || '';
  const senderEmail = process.env.BREVO_SENDER_EMAIL || 'contact.provoguard.ai@gmail.com';
  const url = 'https://api.brevo.com/v3/smtp/email';

  const body = {
    sender: { name: 'Provo Guard Security', email: senderEmail },
    to: [{ email: recipientEmail, name: recipientName || 'User' }],
    subject: '🔑 Password Reset Security Code - Provo Guard',
    htmlContent: `
      <html>
        <body style="font-family: Arial, sans-serif; padding: 20px; color: #333;">
          <div style="max-width: 600px; margin: 0 auto; border: 1px solid #3B82F6; border-radius: 10px; padding: 24px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
            <h2 style="color: #2563EB; text-align: center;">🔑 Password Reset Verification Code</h2>
            <p>Hello ${recipientName || 'User'},</p>
            <p>We received a request to reset the password for your Provo Guard account. Please use the 6-digit verification code below to set a new password:</p>
            
            <div style="background: #EFF6FF; font-size: 32px; font-weight: bold; text-align: center; padding: 16px; margin: 24px 0; border-radius: 8px; letter-spacing: 6px; color: #1D4ED8;">
              ${otpCode}
            </div>

            <p style="font-size: 13px; color: #64748B;">This code is valid for 15 minutes. If you did not request a password reset, you can safely ignore this email — your password will remain unchanged.</p>
            
            <hr style="border: 0; border-top: 1px solid #E2E8F0; margin: 24px 0;" />
            <p style="font-size: 11px; color: #94A3B8; text-align: center;">Provo Guard Security Ecosystem &bull; Protect. Empower. Prevent.</p>
          </div>
        </body>
      </html>
    `
  };

  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: { 'accept': 'application/json', 'api-key': apiKey, 'content-type': 'application/json' },
      body: JSON.stringify(body)
    });
    if (response.ok) {
      const data = await response.json();
      console.log(`[EmailService] Password reset OTP sent to ${recipientEmail}. Message ID:`, data.messageId);
      return { success: true, messageId: data.messageId };
    } else {
      const errText = await response.text();
      console.error('[EmailService] Error sending password reset email:', errText);
      return { success: false, error: errText };
    }
  } catch (error) {
    console.error('[EmailService] Network error during password reset email dispatch:', error.message);
    return { success: false, error: error.message };
  }
}

module.exports = {
  sendVerificationEmail,
  sendProfileUpdateNotificationEmail,
  sendPasswordChangedNotificationEmail,
  sendPasswordResetOtpEmail
};


