import dotenv from 'dotenv';
dotenv.config({ path: './.env' });

import admin from 'firebase-admin';
import serviceAccount from '../../ServiceAccountKey.json' assert { type: 'json' };

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: process.env.FIREBASE_DATABASE_URL 
});
console.log('Database URL:', process.env.FIREBASE_DATABASE_URL);


export default admin;
