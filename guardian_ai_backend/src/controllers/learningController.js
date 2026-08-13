async function getLearningModules(req, res) {
  try {
    const modules = [
      {
        id: 'mod_1',
        title: 'Recognizing Digital Extortion & Sextortion Tactics',
        category: 'Extortion Prevention',
        durationMinutes: 6,
        badge: 'Extortion Shield Master',
        completed: false,
        summary: 'Learn how cybercriminals initiate blackmail, why payment is never the answer, and how to lock down evidence.',
        interactiveQuiz: [
          {
            question: 'What is the most critical first step if someone threatens to publish a private photo unless you send money?',
            options: [
              'Pay them immediately so they delete it',
              'DO NOT pay, save screenshots to Evidence Vault, and block the offender',
              'Delete your messages and pretend nothing happened',
              'Argue with the offender for several hours'
            ],
            correctIndex: 1,
            explanation: 'Paying extortionists almost always leads to further demands. Preserving evidence and refusing payment breaks their leverage.'
          }
        ]
      },
      {
        id: 'mod_2',
        title: 'Spotting Catfishing & AI Deepfakes',
        category: 'Media Literacy',
        durationMinutes: 8,
        badge: 'Deepfake Detective',
        completed: true,
        summary: 'Understand synthetic audio, swapped video faces, and fake social profiles used in social engineering.',
        interactiveQuiz: [
          {
            question: 'Which of the following is a classic indicator of a catfishing or fake persona?',
            options: [
              'Refusal to do a live video call with matching lighting/movement',
              'Having 500 mutual friends',
              'Using a verified badge on an official account',
              'Sharing public news articles'
            ],
            correctIndex: 0,
            explanation: 'Catfish and scammers frequently make excuses to avoid live video calls or use synthetic filters that glitch.'
          }
        ]
      },
      {
        id: 'mod_3',
        title: 'Grooming & Secrecy Red Flags',
        category: 'Personal Safety',
        durationMinutes: 5,
        badge: 'Boundary Defender',
        completed: false,
        summary: 'Identify coercive isolation tactics, gift manipulation, and boundary pushes in online messaging.',
        interactiveQuiz: [
          {
            question: 'Why do abusers demand "Don\'t tell your parents or friends about our chats"?',
            options: [
              'Because they are planning a surprise party',
              'To isolate you from people who can support and protect you',
              'Because they are shy',
              'To keep phone bills low'
            ],
            correctIndex: 1,
            explanation: 'Enforced secrecy is designed to isolate victims so they feel they have nowhere to turn.'
          }
        ]
      }
    ];

    res.json({ success: true, modules });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}

async function getSimulators(req, res) {
  try {
    const simulators = [
      {
        id: 'sim_1',
        title: 'Fake Extortion Chat Simulator',
        description: 'Interactive chat practice to safely navigate an extortion scenario without falling into panic.',
        difficulty: 'Intermediate',
        scenarios: [
          {
            sender: 'Unknown Sender',
            message: 'I have your private pictures from Snapchat. Transfer $300 to this wallet or I blast them to your friends in 10 minutes.',
            choices: [
              { text: 'Pay $300 immediately', feedback: 'INCORRECT: Paying shows you are vulnerable and encourages endless demands.', scoreDelta: -20 },
              { text: 'Tap Emergency Mode & Save Evidence', feedback: 'EXCELLENT: This locks the evidence cryptographically and prepares an official report.', scoreDelta: +30 },
              { text: 'Beg them not to send it', feedback: 'RISKY: Pleading gives the extortionist psychological leverage.', scoreDelta: -10 }
            ]
          }
        ]
      }
    ];

    res.json({ success: true, simulators });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
}

module.exports = {
  getLearningModules,
  getSimulators
};
