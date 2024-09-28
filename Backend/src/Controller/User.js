
import admin from '../Utils/firebase.js';

const register = async (req, res) => {
    const { email, password, username, phone } = req.body;
    console.log(email, password, username, phone);

    try {
        const existingUser = await admin.auth().getUserByEmail(email);
        if (existingUser) {
            return res.status(409).send('User already exists.');
        }
    } catch (error) {
        if (error.code !== 'auth/user-not-found') {
            console.log('Error fetching user by email:', error);
            return res.status(500).send('Internal Server Error');
        }
    }

    try {
        const userRecord = await admin.auth().createUser({
            email: email,
            password: password,
            phoneNumber: phone 
        });

        const db = admin.database();
        await db.ref('users/' + userRecord.uid).set({
            email: email,
            username: username, 
            phone: phone, 
            createdAt: new Date().toISOString()
        });

        console.log('User created successfully');
        res.json({ message: 'User created successfully', uid: userRecord.uid });
    } catch (error) {
        console.log('Error creating user:', JSON.stringify(error));
        res.status(400).send(`Failed to create user: ${error.message}`);
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

const countAllEventsAndUsers = async (req, res) => {
    console.log("count all event and user");
    try {
        const db = admin.database();
        const eventsRef = db.ref('events');
        const eventUserRef = db.ref('event_user');

        const eventsSnapshot = await eventsRef.once('value');
        const eventsData = eventsSnapshot.val();

        if (!eventsData) {
            return res.status(404).json({ message: 'No events found' });
        }

        const totalEvents = Object.keys(eventsData).length;

        const eventUserSnapshot = await eventUserRef.once('value');
        const eventUserData = eventUserSnapshot.val();

        const totalUsers = eventUserData ? Object.keys(eventUserData).length : 0;
        console.log("Total events: ", totalEvents);
        console.log("Total users: ", totalUsers);
        res.status(200).json({
            message: 'Total events and users count fetched successfully',
            totalEvents,
            totalUsers
        });
    } catch (error) {
        console.error('Error fetching events and users count:', error);
        res.status(500).json({ message: 'Error fetching events and users count' });
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
        console.log('User record:', userRecord);

        const userProfileSnapshot = await admin.database().ref(`users/${userId}`).once('value');

        if (!userProfileSnapshot.exists()) {
            console.error('User profile not found');
            return res.status(404).json({ message: 'User profile not found' });
        }

        const userProfile = userProfileSnapshot.val();

        res.status(200).json({
            email: userRecord.email,
            phone: userRecord.phoneNumber,
            username: userProfile.username,
        });
    } catch (error) {
        console.error('Error fetching user profile:', error);
        res.status(500).json({ message: 'Error fetching profile' });
    }
};


const eventregister = async (req, res) => {
    console.log("event register");
    const { eventId } = req.body;

    if (!req.user || !req.user.uid) {
        console.log('Invalid user token or uid is missing.');
        return res.status(400).json({ message: 'Invalid user token or uid is missing.' });
    }

    if (!eventId) {
        console.log('Event ID is required.');
        return res.status(400).json({ message: 'Event ID is required.' });
    }

    try {
        const db = admin.database();
        
        const eventUserRef = db.ref('event_user');

        const userSnapshot = await eventUserRef.orderByChild('eventId').equalTo(eventId).once('value');
        const registeredUsers = userSnapshot.val();
        
            if (registeredUsers) {
                const alreadyRegistered = Object.values(registeredUsers).some(registration => registration.userId === req.user.uid);
            
                if (alreadyRegistered) {
                    console.log('User already registered for this event.');
                    return res.status(409).json({ message: 'User already registered for this event.' });
                }
            }

            const newEventUserRef = eventUserRef.push();
            await newEventUserRef.set({
                eventId: eventId,
                userId: req.user.uid,
                registrationDate: new Date().toISOString(),
            });

            console.log('Registered successfully and event_user record created.');
            return res.status(200).json({ message: 'Registered successfully!', eventId });
        } 
        catch (error) {
            console.log('Error:', error);
            if (!res.headersSent) {
                return res.status(500).send(error.message);
            } else {
                console.error('Headers already sent:', error);
            }
        }
};

export {register,createevent,getAllEvents,profile,eventregister,countAllEventsAndUsers};