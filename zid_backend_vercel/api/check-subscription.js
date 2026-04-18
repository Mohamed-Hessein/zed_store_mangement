const axios = require('axios');
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
    const storeId = req.headers['store-id'];
    const accessToken = req.headers['authorization']?.split(' ')[1];
    const managerToken = req.headers['x-manager-token'];

    if (!storeId) return res.status(400).json({ error: "Missing Store ID" });

    try {

        const storeDoc = await db.collection('stores').doc(String(storeId)).get();
        if (storeDoc.exists && storeDoc.data().subscription_status === 'active') {
            return res.status(200).json({ status: 'active', is_active: true });
        }


        if (accessToken && managerToken) {
            const zidRes = await axios.get('https://api.zid.sa/v1/managers/account/profile', {
                headers: { 'Authorization': `Bearer ${accessToken}`, 'X-MANAGER-TOKEN': managerToken }
            });
            const status = zidRes.data.subscription?.status || 'unknown';
            await db.collection('stores').doc(String(storeId)).set({ subscription_status: status }, { merge: true });

            if (status === 'active') return res.status(200).json({ status: 'active', is_active: true });
        }

        return res.status(402).json({ status: 'expired', is_active: false });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};
