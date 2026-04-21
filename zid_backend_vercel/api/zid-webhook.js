const admin = require('firebase-admin');


const projectId = process.env.FIREBASE_PROJECT_ID;
const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
const rawPrivateKey = process.env.FIREBASE_PRIVATE_KEY;
const formattedPrivateKey = rawPrivateKey ? rawPrivateKey.replace(/\\n/g, '\n') : undefined;

if (!admin.apps.length) {
  if (projectId && clientEmail && formattedPrivateKey) {
    try {
      admin.initializeApp({
        credential: admin.credential.cert({ projectId, clientEmail, privateKey: formattedPrivateKey })
      });
    } catch (e) { console.error("Init Error:", e.message); }
  }
}

const db = admin.firestore();


function getOrderNotificationDetails(payload) {
  const status = (payload.order_status?.code || payload.display_status?.code || '').toLowerCase();
  const orderId = payload.id || payload.order_id || '';

  let details = {
    title: '🔔 تحديث حالة طلب',
    body: `الطلب #${orderId} جرى عليه تحديث جديد`
  };

  if (status.includes('new')) {
    details.title = '💰 طلب جديد!';
    details.body = `وصلك طلب جديد برقم #${orderId}`;
  }
  else if (status.includes('cancelled')) {
    details.title = '❌ تم إلغاء طلب';
    details.body = `الطلب رقم #${orderId} تم إلغاؤه`;
  }
  else if (status.includes('delivered')) {
    details.title = '✅ تم توصيل الطلب';
    details.body = `الطلب رقم #${orderId} وصل للعميل بنجاح`;
  }
  else if (status.includes('ready')) {
    details.title = '📦 الطلب جاهز';
    details.body = `الطلب رقم #${orderId} جاهز الآن للشحن`;
  }
  else if (status.includes('preparing')) {
    details.title = '👨‍🍳 جاري التجهيز';
    details.body = `بدأ العمل على تجهيز الطلب رقم #${orderId}`;
  }
  else if (status.includes('shipping') || status.includes('delivery')) {
    details.title = '🚚 الطلب في الطريق';
    details.body = `الطلب رقم #${orderId} خرج مع مندوب التوصيل`;
  }

  return details;
}

module.exports = async (req, res) => {
  if (req.method !== 'POST') return res.status(405).send('Use POST');

  let currentFcmToken = "Not Found";
  let currentStoreId = "Unknown";

  try {
    const payload = req.body;
    let eventType = req.headers['x-zid-event'] || req.headers['X-Zid-Event'] || payload.event || '';

    if (eventType === '') {
      if (payload.order_status || payload.invoice_number) eventType = 'order.status.update';
      else if (payload.sku || payload.quantity !== undefined) eventType = 'product.update';
      else if (payload.subscription) eventType = 'account.subscription.updated';
    }

    currentStoreId = req.headers['x-store-id'] || req.headers['X-Store-Id'] || payload.store_id || '';

    if (!currentStoreId) return res.status(200).send('No Store ID');


    if (eventType === 'app.uninstalled') {
        console.log(`⚠️ App Uninstalled for Store: ${currentStoreId}`);

        await db.collection('stores').doc(String(currentStoreId)).delete();
        await db.collection('tokens').doc(String(currentStoreId)).delete();
        return res.status(200).send('Store Data Cleaned');
    }



    if (eventType.includes('subscription') || payload.subscription) {
        const subStatus = payload.subscription?.status || payload.status;
        const endDate = payload.subscription?.end_date || payload.end_date;

        if (subStatus) {
            await db.collection('stores').doc(String(currentStoreId)).set({
                subscription_status: subStatus,
                last_webhook_update: admin.firestore.FieldValue.serverTimestamp(),
                end_date: endDate || null
            }, { merge: true });

            console.log(`🔔 Webhook: Subscription updated for Store ${currentStoreId}`);
            return res.status(200).send('Subscription Processed');
        }
    }


    const tokenDoc = await db.collection('tokens').doc(String(currentStoreId)).get();
    if (!tokenDoc.exists) return res.status(200).send('Store Token Not Found');

    currentFcmToken = tokenDoc.data().fcmToken;
    let title = '';
    let body = '';

    if (eventType.includes('order')) {
      const orderInfo = getOrderNotificationDetails(payload);
      title = orderInfo.title;
      body = orderInfo.body;
    }
    else if (eventType.includes('product')) {
      const quantity = parseInt(payload.quantity);
      const productName = payload.name?.ar || payload.name?.en || 'منتج';

      if (!isNaN(quantity) && quantity <= 5) {
        title = '⚠️ تحذير مخزون منخفض!';
        body = `المنتج "${productName}" قارب على النفاد. المتبقي: ${quantity} فقط!`;
      } else {
        title = '📦 تحديث منتج';
        body = `تم تحديث بيانات المخزون للمنتج: ${productName}`;
      }
    }

    if (title !== '' && currentFcmToken) {
      await admin.messaging().send({
        notification: { title, body },
        data: {
          store_id: String(currentStoreId),
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        },
        token: currentFcmToken
      });
      console.log(`🚀 Notification Sent: ${title}`);
    }

    res.status(200).send('OK');

  } catch (error) {
    console.error(`🔥 Error [Store:${currentStoreId}]:`, error.message);
    res.status(200).send('Error Processed');
  }
};
