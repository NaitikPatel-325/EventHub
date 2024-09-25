import { Router } from "express";
import dotenv from 'dotenv';
import { register ,createevent, getAllEvents,profile,eventregister} from '../Controller/User.js';
import auth from '../middleware/auth.js';

dotenv.config({
    path: './.env'
})

const router = Router();

router.post('/signup', register);
router.post('/create', auth,createevent);
router.get('/allevent', auth,getAllEvents);
router.get('/profile', auth, profile);
router.post('/eventregister', auth, eventregister);

export default router;