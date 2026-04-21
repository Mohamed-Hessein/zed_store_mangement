const axios = require('axios');
const qs = require('querystring');

module.exports = async (req, res) => {
  if (req.method !== 'POST') return res.status(405).send('Method Not Allowed');

  // تأمين استلام الـ body: لو جاي فاضي بنخليه object فاضي عشان البرنامج ميهنجش
  const body = req.body || {};
  const { code } = body;

  const clientId = process.env.ZID_CLIENT_ID;
  const clientSecret = process.env.ZID_CLIENT_SECRET;
  const redirectUri = process.env.ZID_REDIRECT_URI;

  console.log("Client ID Status:", clientId ? "EXISTS" : "MISSING");

  // إذا لم يتم إرسال code، نرجع رسالة واضحة بدل ما السيرفر ينهار
  if (!code) {
    return res.status(400).json({
      error: 'Code is missing',
      debug_info: {
        hasClientId: !!clientId,
        hasClientSecret: !!clientSecret,
        hasRedirectUri: !!redirectUri
      }
    });
  }

  try {
    const data = qs.stringify({
      'grant_type': 'authorization_code',
      'client_id': clientId,
      'client_secret': clientSecret,
      'redirect_uri': redirectUri,
      'code': code
    });

    const response = await axios.post('https://oauth.zid.sa/oauth/token', data, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }
    });

    res.status(200).json(response.data);
  } catch (error) {
    console.error("Zid Auth Error:", error.response?.data || error.message);

    res.status(error.response?.status || 500).json({
      error: 'Auth failed',
      details: error.response?.data || error.message,
      debug_info: {
        hasClientId: !!clientId,
        hasClientSecret: !!clientSecret,
        hasRedirectUri: !!redirectUri
      }
    });
  }
};