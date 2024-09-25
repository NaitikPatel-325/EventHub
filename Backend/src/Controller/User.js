
import admin from '../Utils/firebase.js';

const register = async (req, res) => {
    const { email, password, username, phone } = req.body; // Destructure new fields
    const profileImage = req.file; // Get the uploaded file
    console.log(email, password, username, phone);
    
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
        // Create a new user in Firebase Auth
        const userRecord = await admin.auth().createUser({
            email: email,
            password: password,
        });

        const db = admin.database();

        // Define the user data
        const userData = {
            email: email,
            username: username, // Save username
            phone: phone,       // Save phone number
            createdAt: new Date().toISOString()
        };

        // Check if there's a profile image and store it
        if (profileImage) {
            // Assuming you are using a file storage service like Firebase Storage
            const bucket = admin.storage().bucket(); // Initialize your storage bucket
            const fileName = `profile_images/${userRecord.uid}.${profileImage.mimetype.split('/')[1]}`; // Generate a file name
            await bucket.upload(profileImage.path, {
                destination: fileName,
                metadata: {
                    contentType: profileImage.mimetype,
                },
            });
            userData.profileImageUrl = `gs://${bucket.name}/${fileName}`; // Get the URL for the uploaded file
        }

        // Save user information to the Realtime Database
        await db.ref('users/' + userRecord.uid).set(userData);
        
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

const getAllEvents = async (req, res) => {
    console.log("get all events");  
    try {
        const db = admin.database();
        const eventsRef = db.ref('events');

        const snapshot = await eventsRef.once('value');
        const events = snapshot.val();

        if (!events) {
            return res.status(404).json({ message: 'No events found.' });
        }
        const eventsArray = Object.keys(events).map(eventId => ({
            eventId,
            ...events[eventId]
        }));

        console.log('Events fetched successfully');
        res.status(200).json(eventsArray);
    } catch (error) {
        console.log('Error:', error);
        if (!res.headersSent) {
            return res.status(500).json({ message: 'Error fetching events.', error: error.message });
        } else {
            console.error('Headers already sent:', error);
        }
    }
};


const profile = async (req, res) => {
    try {
      const userId = req.user.uid;
  
      const userRecord = await admin.auth().getUser(userId);
  
  
      res.status(200).json({
        email: userRecord.email,
      });
    } catch (error) {
      console.error('Error fetching user profile:', error);
      res.status(500).json({ message: 'Error fetching profile' });
    }
  };


export {register,createevent,getAllEvents,profile};