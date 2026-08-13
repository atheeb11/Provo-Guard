require('dotenv').config();
const { sendVerificationEmail } = require('./src/services/emailService');

async function test() {
  console.log("Testing Brevo Email Dispatch...");
  console.log("BREVO_API_KEY:", process.env.BREVO_API_KEY ? "Loaded (Ends with " + process.env.BREVO_API_KEY.slice(-5) + ")" : "NOT LOADED");
  console.log("BREVO_SENDER_EMAIL:", process.env.BREVO_SENDER_EMAIL);

  const res = await sendVerificationEmail("atheeb1311@gmail.com", "Mubarak Atheeb", "998877");
  console.log("Result:", res);
}

test();
