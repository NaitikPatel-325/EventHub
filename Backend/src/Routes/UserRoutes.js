import { Router } from "express";
import dotenv from 'dotenv';
import { register } from '../Controller/User.js';

dotenv.config({
    path: './.env'
})

const router = Router();

router.post('/signup', register);

export default router;