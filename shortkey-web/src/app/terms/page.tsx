'use client';

import { motion } from 'framer-motion';
import Container from '@/components/ui/Container';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { fadeInUp, staggerContainer } from '@/lib/animations';

export default function TermsPage() {
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
              Terms of Service
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
                <h2 className="text-2xl font-bold mb-4">1. Acceptance of Terms</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  By downloading, installing, or using Shortkey, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our service.
                </p>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">2. License</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  Subject to your compliance with these Terms, we grant you a limited, non-exclusive, non-transferable, revocable license to use Shortkey for your personal or commercial use.
                </p>
                <h3 className="text-xl font-semibold mb-3">You may:</h3>
                <ul className="list-disc pl-6 text-[var(--color-muted)] mb-4 space-y-2">
                  <li>Install Shortkey on devices you own or control</li>
                  <li>Use the service for lawful purposes</li>
                  <li>Create custom prompts and transformations</li>
                </ul>
                <h3 className="text-xl font-semibold mb-3">You may not:</h3>
                <ul className="list-disc pl-6 text-[var(--color-muted)] mb-4 space-y-2">
                  <li>Reverse engineer, decompile, or disassemble the software</li>
                  <li>Redistribute or resell the service</li>
                  <li>Use the service to violate any laws or regulations</li>
                  <li>Abuse or overload our systems</li>
                </ul>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">3. Subscription Plans</h2>
                <h3 className="text-xl font-semibold mb-3">Free Tier</h3>
                <p className="text-[var(--color-muted)] mb-4">
                  The Free tier includes limited transformations and features. We reserve the right to modify free tier limits at any time.
                </p>
                <h3 className="text-xl font-semibold mb-3">Paid Tiers</h3>
                <p className="text-[var(--color-muted)] mb-4">
                  Paid subscriptions are billed monthly or annually. All fees are non-refundable except as required by law or as explicitly stated in our refund policy.
                </p>
                <h3 className="text-xl font-semibold mb-3">Cancellation</h3>
                <p className="text-[var(--color-muted)] mb-4">
                  You may cancel your subscription at any time. Your access will continue until the end of your billing period.
                </p>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">4. BYOK (Bring Your Own Key)</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  Developer tier users can provide their own API keys. You are responsible for:
                </p>
                <ul className="list-disc pl-6 text-[var(--color-muted)] mb-4 space-y-2">
                  <li>All costs associated with your API usage</li>
                  <li>Maintaining the security of your API keys</li>
                  <li>Compliance with third-party provider terms</li>
                  <li>Any issues arising from your API key usage</li>
                </ul>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">5. Acceptable Use</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  You agree not to use Shortkey to:
                </p>
                <ul className="list-disc pl-6 text-[var(--color-muted)] mb-4 space-y-2">
                  <li>Generate harmful, abusive, or illegal content</li>
                  <li>Violate intellectual property rights</li>
                  <li>Spread misinformation or spam</li>
                  <li>Attempt to bypass usage limits or restrictions</li>
                  <li>Interfere with other users' access to the service</li>
                </ul>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">6. Privacy</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  Your use of Shortkey is also governed by our Privacy Policy. Please review our{' '}
                  <a
                    href="/privacy"
                    className="text-[var(--color-primary)] hover:underline"
                  >
                    Privacy Policy
                  </a>{' '}
                  to understand our data practices.
                </p>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">7. Disclaimer of Warranties</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  SHORTKEY IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND. WE DO NOT GUARANTEE THAT THE SERVICE WILL BE ERROR-FREE, UNINTERRUPTED, OR MEET YOUR REQUIREMENTS.
                </p>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">8. Limitation of Liability</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  TO THE MAXIMUM EXTENT PERMITTED BY LAW, SHORTKEY SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES ARISING OUT OF YOUR USE OF THE SERVICE.
                </p>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">9. Termination</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  We reserve the right to suspend or terminate your access to Shortkey at any time for violation of these Terms or for any other reason at our discretion.
                </p>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">10. Changes to Terms</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  We may modify these Terms at any time. We will notify you of material changes via email or through the application. Your continued use of Shortkey after changes constitutes acceptance of the new Terms.
                </p>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">11. Governing Law</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  These Terms are governed by the laws of the United States, without regard to conflict of law principles.
                </p>
              </section>

              <section className="mb-8">
                <h2 className="text-2xl font-bold mb-4">12. Contact</h2>
                <p className="text-[var(--color-muted)] mb-4">
                  For questions about these Terms, please contact us at{' '}
                  <a
                    href="mailto:legal@shortkey.app"
                    className="text-[var(--color-primary)] hover:underline"
                  >
                    legal@shortkey.app
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
