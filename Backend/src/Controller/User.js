
import admin from '../Utils/firebase.js';


const register =  async (req, res) => {
    const { email, password } = req.body;
    console.log(email,password);
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
  };
  
export {register};