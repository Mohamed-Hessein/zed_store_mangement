const admin = require('firebase-admin');

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert({
      projectId: process.env.FIREBASE_PROJECT_ID,
      clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
      privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
    })
  });
}
const db = admin.firestore();

module.exports = async (req, res) => {
  const { store_id, fcmToken } = req.body;
  if (!store_id || !fcmToken) return res.status(400).send('Missing Data');

  try {

    await db.collection('tokens').doc(String(store_id)).set({
      fcmToken: fcmToken,
      lastUpdate: new Date().toISOString()
    }, { merge: true });

    res.status(200).json({ success: true });
  } catch (e) {
    res.status(500).send(e.message);
  }
};
