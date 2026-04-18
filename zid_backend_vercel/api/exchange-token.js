const axios = require('axios');
const qs = require('querystring'); // مكتبة موجودة في node تلقائياً

module.exports = async (req, res) => {
  if (req.method !== 'POST') return res.status(405).send('Method Not Allowed');

  const { code } = req.body;


  const clientId = process.env.ZID_CLIENT_ID;
  const clientSecret = process.env.ZID_CLIENT_SECRET;
  const redirectUri = process.env.ZID_REDIRECT_URI;

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

    res.status(error.response?.status || 500).json(error.response?.data || { error: 'Auth failed' });
  }
};
