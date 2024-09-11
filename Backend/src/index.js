import express from 'express';
import admin from 'firebase-admin';
import cors from 'cors';
import dotenv from 'dotenv';
import userRoutes from './Routes/UserRoutes.js';

dotenv.config({
    path: './.env'
})


const app = express();
app.use(express.json());
app.use(cors({
  origin: process.env.port,
  credentials: true
}))


app.use('/user', userRoutes); 



app.listen(3000, () => {
    console.log('Server is running on port 3000');
});