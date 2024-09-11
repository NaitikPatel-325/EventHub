import { Router } from "express";
import dotenv from 'dotenv';
import { register ,createevent} from '../Controller/User.js';
import auth from '../middleware/auth.js';

dotenv.config({
    path: './.env'
})

const router = Router();

router.post('/signup', register);
router.post('/create', auth,createevent);

export default router;