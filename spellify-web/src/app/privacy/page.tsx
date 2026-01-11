'use client';

import { motion } from 'framer-motion';
import Container from '@/components/ui/Container';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { fadeInUp, staggerContainer } from '@/lib/animations';

export default function PrivacyPage() {
  return (
    <>
      <Header />
      <main className="pt-32 pb-20">
        <Container size="md">
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="visible"
          >
            <motion.h1
              variants={fadeInUp}
              className="text-4xl md:text-5xl font-bold mb-6"
            >
              Privacy Policy
            </motion.h1>
            <motion.p
              variants={fadeInUp}
              className="text-[var(--color-muted)] mb-8"
            >
              Last updated: January 12, 2026
            </motion.p>

            <motion.div
              variants={fadeInUp}
              className="prose prose-lg max-w-none"
            >
              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">Introduction</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  At Spellify, we take your privacy seriously. This Privacy Policy explains how we collect, use, and protect your information when you use our macOS application and services.
                </p>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">Information We Collect</h2>
                <h3 className="text-xl font-semibold mb-3">Text Processing</h3>
                <p className="text-[var(--color-muted)] mb-4">
                  When you use Spellify to transform text, we temporarily process your text through our AI services. This text is:
                </p>
                <ul className="list-disc pl-6 text-[var(--color-muted)] mb-4 space-y-2">
                  <li>Encrypted in transit</li>
                  <li>Not stored on our servers after processing</li>
                  <li>Not used to train AI models</li>
                  <li>Not shared with third parties</li>
                </ul>

                <h3 className="text-xl font-semibold mb-3">Usage Data</h3>
                <p className="text-[var(--color-muted)] mb-4">
                  We collect anonymous usage statistics to improve our service:
                </p>
                <ul className="list-disc pl-6 text-[var(--color-muted)] mb-4 space-y-2">
                  <li>Feature usage frequency</li>
                  <li>Performance metrics</li>
                  <li>Error reports (anonymized)</li>
                  <li>macOS version information</li>
                </ul>

                <h3 className="text-xl font-semibold mb-3">Account Information</h3>
                <p className="text-[var(--color-muted)] mb-4">
                  If you create an account, we collect:
                </p>
                <ul className="list-disc pl-6 text-[var(--color-muted)] mb-4 space-y-2">
                  <li>Email address</li>
                  <li>Display name (optional)</li>
                  <li>Subscription status</li>
                  <li>Payment information (processed by Stripe)</li>
                </ul>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">How We Use Your Information</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  We use collected information to:
                </p>
                <ul className="list-disc pl-6 text-[var(--color-muted)] mb-4 space-y-2">
                  <li>Provide and improve our services</li>
                  <li>Process your text transformations</li>
                  <li>Send important service updates</li>
                  <li>Respond to support requests</li>
                  <li>Prevent fraud and abuse</li>
                </ul>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">BYOK (Bring Your Own Key)</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  For Developer tier users:
                </p>
                <ul className="list-disc pl-6 text-[var(--color-muted)] mb-4 space-y-2">
                  <li>API keys are stored exclusively in your macOS Keychain</li>
                  <li>We never see or have access to your API keys</li>
                  <li>Your text is processed directly with your chosen provider</li>
                  <li>No intermediary storage on our servers</li>
                </ul>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">Data Security</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  We implement industry-standard security measures:
                </p>
                <ul className="list-disc pl-6 text-[var(--color-muted)] mb-4 space-y-2">
                  <li>End-to-end encryption for all text processing</li>
                  <li>Secure HTTPS connections</li>
                  <li>Regular security audits</li>
                  <li>Limited data retention</li>
                </ul>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">Your Rights</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  You have the right to:
                </p>
                <ul className="list-disc pl-6 text-[var(--color-muted)] mb-4 space-y-2">
                  <li>Access your personal data</li>
                  <li>Request data deletion</li>
                  <li>Opt-out of analytics</li>
                  <li>Export your data</li>
                  <li>Withdraw consent at any time</li>
                </ul>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">Third-Party Services</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  We use the following third-party services:
                </p>
                <ul className="list-disc pl-6 text-[var(--color-muted)] mb-4 space-y-2">
                  <li>OpenAI (text processing)</li>
                  <li>Anthropic (text processing)</li>
                  <li>Stripe (payment processing)</li>
                  <li>Vercel (hosting)</li>
                </ul>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">Changes to This Policy</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.
                </p>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">Contact Us</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  If you have any questions about this Privacy Policy, please contact us at{' '}
                  <a
                    href="mailto:privacy@spellify.app"
                    className="text-[var(--color-primary)] hover:underline"
                  >
                    privacy@spellify.app
                  </a>
                </p>
              </section>
            </motion.div>
          </motion.div>
        </Container>
      </main>
      <Footer />
    </>
  );
}
