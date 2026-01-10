import { defineSecret } from 'firebase-functions/params';
import OpenAI from 'openai';
import { CONFIG } from '../../config';
import { SECRETS } from '../../constants';

const openaiApiKey = defineSecret(SECRETS.OPENAI_API_KEY);

export async function transformText(
  text: string,
  instruction: string
): Promise<string> {
  const openai = new OpenAI({
    apiKey: openaiApiKey.value(),
  });

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
