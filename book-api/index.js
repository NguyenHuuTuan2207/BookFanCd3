const express = require('express');
const { Client } = require('pg');
const cors = require('cors');
const path = require('path');
const axios = require('axios');
const bcrypt = require('bcrypt'); // For password hashing
const { v4: uuidv4 } = require('uuid'); // For generating unique user IDs

const app = express();
const port = 3000;

// Enable CORS for Flutter Web app
app.use(cors()); // Allow all origins

// Middleware to parse JSON bodies
app.use(express.json());

// Serve text files from 'assets/text' directory in the project root
app.use('/assets/text', express.static(path.join(__dirname, '../assets/text')));

// Set up PostgreSQL client
const client = new Client({
  host: 'localhost',
  port: 5432,
  user: 'postgres', // Your PostgreSQL username
  password: '22072003', // Your PostgreSQL password
  database: 'bookapp', // Your PostgreSQL database name
});

// Connect to PostgreSQL
client.connect()
  .then(() => console.log('Connected to PostgreSQL database'))
  .catch((err) => console.error('Database connection error:', err.stack));

// ---- USER AUTHENTICATION ROUTES ----

// User Registration
app.post('/register', async (req, res) => {
  const { username, password, email } = req.body;

  if (!username || !password || !email) {
    return res.status(400).json({ error: 'Username, password, and email are required.' });
  }

  try {
    // Check if the email is already in use
    const emailExists = await client.query('SELECT * FROM Users WHERE email = $1', [email]);
    if (emailExists.rows.length > 0) {
      return res.status(400).json({ error: 'Email is already registered.' });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insert the new user into the database
    const userId = uuidv4(); // Generate a unique ID for the user
    await client.query(
      'INSERT INTO Users (id, username, password, email) VALUES ($1, $2, $3, $4)',
      [userId, username, hashedPassword, email]
    );

    res.status(201).json({ message: 'User registered successfully.' });
  } catch (error) {
    console.error('Error registering user:', error);
    res.status(500).json({ error: 'Error registering user.' });
  }
});

// User Login
app.post('/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required.' });
  }

  try {
    // Find the user by email
    const result = await client.query('SELECT * FROM Users WHERE email = $1', [email]);
    const user = result.rows[0];

    if (!user) {
      return res.status(400).json({ error: 'Invalid email or password.' });
    }

    // Compare the provided password with the stored hashed password
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      return res.status(400).json({ error: 'Invalid email or password.' });
    }

    res.status(200).json({ message: 'Login successful.', userId: user.id, username: user.username });
  } catch (error) {
    console.error('Error logging in user:', error);
    res.status(500).json({ error: 'Error logging in user.' });
  }
});
// ---- NEW GEMINI AI ROUTE ----

// Replace with your Gemini API key and URL
const { GoogleGenerativeAI } = require('@google/generative-ai');
const genAI = new GoogleGenerativeAI("AIzaSyDDknm3LdFuQcDnpoWIl_9e78dvtYhZ-YQ");
const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

// Endpoint to handle AI chat requests
app.post("/chat", async (req, res) => {
  const { message } = req.body;

  if (!message) {
    return res.status(400).json({ error: "Message is required" });
  }

  try {
    // Keywords related to books (expand this list as needed)
    const bookKeywords = ['book', 'author', 'genre', 'recommend', 'title', 'story', 'novel'];

    // Check if the message contains any book-related keywords
    const isBookRelated = bookKeywords.some(keyword => message.toLowerCase().includes(keyword));

    if (isBookRelated) {
      // Handle book-related queries like recommendations
      if (message.toLowerCase().includes("book")) {
        const result = await model.generateContent(message);

        // Get the full response text from the model
        let aiResponse = result.response.text();

        // Limit the response to 50 words
        const maxWords = 50;
        const words = aiResponse.split(' '); // Split response into words
        if (words.length > maxWords) {
          aiResponse = words.slice(0, maxWords).join(' ') + '...'; // Truncate and add ellipsis
        }

        // Send the AI response back to the client
        res.json({ reply: aiResponse });
      }
    } else {
      // Non-book-related query response
      return res.json({ reply: "Sorry, I can only assist you with book-related topics." });
    }
  } catch (error) {
    console.error("Error communicating with Gemini API:", error.message);
    res.status(500).json({ error: "Error communicating with AI." });
  }
});


// Endpoint to fetch books
app.get('/books', async (req, res) => {
  try {
    const result = await client.query('SELECT id, image_url, title, author, rating, bookcontent FROM books');
    res.json(result.rows); // Send book data as JSON
  } catch (err) {
    res.status(500).send('Error fetching books');
    console.error('Error fetching books:', err);
  }
});

// Endpoint to add a book to the favorite list
app.post('/add-favorite', async (req, res) => {
  const { id, title, author, image, rating, bookcontent } = req.body;
  try {
    const query = `
      INSERT INTO favorite_books (id, title, author, image, rating, bookcontent)
      VALUES ($1, $2, $3, $4, $5, $6)
    `;
    await client.query(query, [id, title, author, image, rating, bookcontent]);
    res.status(200).send('Book added to favorites');
    console.log('Book added to favorites:', title);
  } catch (err) {
    res.status(500).send('Error adding book to favorites');
    console.error('Error adding book to favorites:', err);
  }
});

// Endpoint to fetch favorite books
app.get('/favorite-books', async (req, res) => {
  try {
    const result = await client.query('SELECT * FROM favorite_books');
    res.json(result.rows); // Send favorite book data as JSON
  } catch (err) {
    res.status(500).send('Error fetching favorite books');
    console.error('Error fetching favorite books:', err);
  }
});

// Endpoint to delete a book from the favorite list
app.post('/delete-favorite', async (req, res) => {
  const { id } = req.body;
  try {
    const query = 'DELETE FROM favorite_books WHERE id = $1';
    await client.query(query, [id]);
    res.status(200).send('Book removed from favorites');
  } catch (err) {
    res.status(500).send('Error removing book from favorites');
    console.error('Error removing book from favorites:', err);
  }
});

// ---- START SERVER ----
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
