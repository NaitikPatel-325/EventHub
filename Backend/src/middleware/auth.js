import admin from '../Utils/firebase.js';

async function auth(req, res, next) {
  if ((!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) &&
      !req.cookies.__session) {
    console.error('No Firebase ID token was passed in the Authorization header.');
    return res.status(403).json({ message: 'Unauthorized' });
  }

  let idToken;
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer ')) {
    idToken = req.headers.authorization.split('Bearer ')[1];
  }
  else{
    return res.status(403).json({ message: 'Unauthorized' });
  }
  try {
    const decodedIdToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedIdToken;  
    console.log('decodedIdToken', decodedIdToken,req.user.uid);
    next();
  } catch (error) {
    console.error('Error while verifying Firebase ID token:', error);
    return res.status(403).json({ message: 'Unauthorized' });
  }
  next();
}

export default auth;