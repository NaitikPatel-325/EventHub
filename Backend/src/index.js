import express from 'express';
import admin from 'firebase-admin';
import cors from 'cors';
import dotenv from 'dotenv';
import serviceAccount from '../ServiceAccountKey.json' assert { type: 'json' };

dotenv.config({
    path: './.env'
})

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.FIREBASE_DATABASE_URL 
});
const app = express();
app.use(express.json());
app.use(cors({
  origin: process.env.port,
  credentials: true
}))


app.post('/signup', async (req, res) => {
  const { email, password } = req.body;
  try {
      const existingUser = await admin.auth().getUserByEmail(email);
      if (existingUser) {
          return res.status(409).send('User already exists.');
      }
  } catch (error) {
      if (error.code !== 'auth/user-not-found') {
          console.log(error);
          return res.status(500).send('Internal Server Error');
      }
  }

  try {
      const userRecord = await admin.auth().createUser({
          email: email,
          password: password,
      });

      const db = admin.database();
      await db.ref('users/' + userRecord.uid).set({
          email: email,
          createdAt: new Date().toISOString()
      });
      console.log('User created successfully');
      res.json({ message: 'User created successfully', uid: userRecord.uid });
  } catch (error) {
      console.log(error);
      res.status(400).send(error.message);
  }
});



app.listen(3000, () => {
    console.log('Server is running on port 3000');
});