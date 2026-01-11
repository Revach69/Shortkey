import type { Metadata } from 'next';
import { DM_Sans, EB_Garamond, JetBrains_Mono } from 'next/font/google';
import './globals.css';

const dmSans = DM_Sans({
  variable: '--font-dm-sans',
  subsets: ['latin'],
  weight: ['400', '500', '600', '700'],
});

const ebGaramond = EB_Garamond({
  variable: '--font-serif',
  subsets: ['latin'],
  weight: ['400', '500', '600', '700', '800'],
});

const jetbrainsMono = JetBrains_Mono({
  variable: '--font-mono',
  subsets: ['latin'],
  weight: ['400', '500', '600', '700'],
});

export const metadata: Metadata = {
  title: 'Spellify - AI Shortcuts for Your Mac',
  description:
    'Transform any text with a keyboard shortcut. Translate, shorten, formalize — instantly, in any app.',
  keywords: [
    'mac',
    'productivity',
    'AI',
    'text transformation',
    'keyboard shortcuts',
    'AI assistant',
    'automation',
  ],
  authors: [{ name: 'Spellify' }],
  openGraph: {
    title: 'Spellify - AI Shortcuts for Your Mac',
    description:
      'Transform any text with a keyboard shortcut. Translate, shorten, formalize — instantly, in any app.',
    type: 'website',
    locale: 'en_US',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Spellify - AI Shortcuts for Your Mac',
    description:
      'Transform any text with a keyboard shortcut. Translate, shorten, formalize — instantly, in any app.',
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body
        className={`${dmSans.variable} ${ebGaramond.variable} ${jetbrainsMono.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
