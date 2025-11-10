import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { GoogleGenerativeAI } from '@google/generative-ai';

dotenv.config();

const app = express();
const PORT = process.env.PORT ?? 3000;

const apiKey = process.env.GEMINI_API_KEY;

if (!apiKey) {
  throw new Error('Missing GEMINI_API_KEY in backend/.env');
}

const modelId = process.env.GEMINI_MODEL ?? 'gemini-2.5-flash';
const genAI = new GoogleGenerativeAI(apiKey);
const model = genAI.getGenerativeModel({ model: modelId });

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ status: 'ok', message: 'Express + Gemini bridge online', model: modelId });
});

app.post('/api/chat', async (req, res) => {
  try {
    const { messages = [] } = req.body ?? {};

    if (!Array.isArray(messages) || messages.length === 0) {
      return res.status(400).json({
        error: 'Request body must include a non-empty "messages" array.',
      });
    }

    const contents = messages.map((message) => {
      const role = message.role === 'assistant' || message.role === 'model' ? 'model' : 'user';

      let text = '';
      if (typeof message.content === 'string') {
        text = message.content;
      } else if (Array.isArray(message.content)) {
        text = message.content
          .map((part) => {
            if (part && typeof part === 'object') {
              if (typeof part.text === 'string') return part.text;
              if (typeof part.content === 'string') return part.content;
              if (Array.isArray(part.parts)) {
                return part.parts
                  .map((nested) => (nested && typeof nested.text === 'string' ? nested.text : ''))
                  .filter((chunk) => typeof chunk === 'string' && chunk.trim().length > 0)
                  .join('\n');
              }
              return JSON.stringify(part);
            }
            return typeof part === 'string' ? part : String(part ?? '');
          })
          .join('\n');
      } else if (message.content != null) {
        text = String(message.content);
      }

      if (message.role === 'system') {
        text = `System: ${text}`;
      }

      return {
        role,
        parts: [{ text }],
      };
    });

    const response = await model.generateContent({ contents });

    let reply = response.response?.text?.().trim?.() ?? '';
    if (!reply) {
      const parts = response.response?.candidates?.[0]?.content?.parts;
      if (Array.isArray(parts)) {
        reply = parts
          .map((part) => (part && typeof part.text === 'string' ? part.text : ''))
          .join('\n')
          .trim();
      }
    }

    res.json({
      reply,
      raw: response,
    });
  } catch (error) {
    console.error('Gemini API error:', error);

    const safeMessage = error.response?.data ?? error.message ?? 'Unknown error';

    res.status(500).json({
      error: 'Failed to fetch response from Gemini API.',
      details: safeMessage,
    });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
