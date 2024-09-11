
import admin from '../Utils/firebase.js';


const register =  async (req, res) => {
    const { email, password } = req.body;
    // console.log(email,password);
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
  
const createevent = async (req, res) => {
    console.log(req.body, req.user);
    const { name, description, date, time, location } = req.body;

    if (!req.user || !req.user.uid) {
        console.log('Invalid user token or uid is missing.');
        return res.status(400).json({ message: 'Invalid user token or uid is missing.' });
    }

    if (!name || !description || !date || !time || !location) {
        console.log('Missing required fields.');
        return res.status(400).json({ message: 'Missing required fields.' });
    }

    try {
        const db = admin.database();
        const eventsRef = db.ref('events');
        const newEventRef = eventsRef.push();  

        await newEventRef.set({  
            name: name,
            description: description,
            date: date,
            location: location,
            time: time,
            createdBy: req.user.uid,
            createdAt: new Date().toISOString()
        });

        console.log('Event created successfully');
        res.status(200).json({ message: 'Event created successfully', eventId: newEventRef.key });
    } catch (error) {
        console.log('Error:', error);
        if (!res.headersSent) {
            return res.status(400).send(error.message);
        } else {
            console.error('Headers already sent:', error);
        }
    }
};



export {register,createevent};