import * as functions from 'firebase-functions';
import OpenAI from 'openai';
import { CONFIG } from '../../config';

const openai = new OpenAI({
  apiKey: functions.config().openai.key,
});

export async function transformText(
  text: string,
  instruction: string
): Promise<string> {
  const response = await openai.chat.completions.create({
    model: CONFIG.openai.model,
    messages: [
      { role: 'system', content: instruction },
      { role: 'user', content: text },
    ],
    temperature: CONFIG.openai.temperature,
    max_tokens: CONFIG.openai.maxTokens,
  });
  
  return response.choices[0].message.content || '';
}
