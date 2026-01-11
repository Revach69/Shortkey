'use client';

import { motion } from 'framer-motion';
import { Target, Users, Sparkles, Heart } from 'lucide-react';
import Container from '@/components/ui/Container';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { fadeInUp, staggerContainer, viewportConfig } from '@/lib/animations';

const values = [
  {
    icon: Target,
    title: 'Focus on Productivity',
    description: 'We believe your tools should work for you, not the other way around. Every feature is designed to save you time.',
  },
  {
    icon: Sparkles,
    title: 'AI That Enhances',
    description: 'AI should amplify human capability, not replace it. Spellify puts powerful AI at your fingertips, exactly when you need it.',
  },
  {
    icon: Users,
    title: 'Built for Creators',
    description: 'From writers to developers to business professionals, we create tools for people who value their workflow.',
  },
  {
    icon: Heart,
    title: 'Privacy First',
    description: 'Your text is yours. We process it securely and never use it to train models or share with third parties.',
  },
];

export default function AboutPage() {
  return (
    <>
      <Header />
      <main className="pt-32 pb-20">
        <Container size="lg">
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="visible"
            className="text-center mb-16"
          >
            <motion.h1
              variants={fadeInUp}
              className="text-4xl md:text-5xl font-bold mb-6"
            >
              About Spellify
            </motion.h1>
            <motion.p
              variants={fadeInUp}
              className="text-lg text-[var(--color-muted)] max-w-2xl mx-auto"
            >
              We're on a mission to make AI accessible right where you work—no context switching, no copy-pasting, just seamless productivity.
            </motion.p>
          </motion.div>

          {/* Story */}
          <motion.div
            variants={fadeInUp}
            initial="hidden"
            whileInView="visible"
            viewport={viewportConfig}
            className="bg-white rounded-2xl border border-[var(--color-border)] p-8 md:p-12 mb-16"
          >
            <h2 className="text-3xl font-bold mb-6">Our Story</h2>
            <div className="prose prose-lg max-w-none">
              <p className="text-[var(--color-muted)] mb-4">
                Spellify was born from a simple frustration: the constant copy-paste dance between work and AI tools.
                As productivity enthusiasts ourselves, we knew there had to be a better way.
              </p>
              <p className="text-[var(--color-muted)] mb-4">
                We built Spellify to be the AI assistant that lives in your workflow, not outside of it.
                A keyboard shortcut away, ready to transform text instantly—whether you're writing emails,
                coding, or crafting the perfect message.
              </p>
              <p className="text-[var(--color-muted)]">
                Today, thousands of Mac users rely on Spellify to streamline their writing, translation,
                and text transformation workflows. And we're just getting started.
              </p>
            </div>
          </motion.div>

          {/* Values */}
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            whileInView="visible"
            viewport={viewportConfig}
          >
            <motion.h2
              variants={fadeInUp}
              className="text-3xl font-bold mb-12 text-center"
            >
              What We Stand For
            </motion.h2>
            <div className="grid md:grid-cols-2 gap-8">
              {values.map((value) => {
                const Icon = value.icon;
                return (
                  <motion.div
                    key={value.title}
                    variants={fadeInUp}
                    className="bg-white rounded-xl border border-[var(--color-border)] p-6 hover:border-[var(--color-primary)] transition-colors"
                  >
                    <div className="w-12 h-12 rounded-lg bg-[var(--color-accent)] flex items-center justify-center mb-4">
                      <Icon className="w-6 h-6 text-[var(--color-primary)]" />
                    </div>
                    <h3 className="text-xl font-semibold mb-2">{value.title}</h3>
                    <p className="text-[var(--color-muted)]">{value.description}</p>
                  </motion.div>
                );
              })}
            </div>
          </motion.div>

          {/* CTA */}
          <motion.div
            variants={fadeInUp}
            initial="hidden"
            whileInView="visible"
            viewport={viewportConfig}
            className="mt-16 text-center bg-[var(--color-primary)] text-white rounded-2xl p-12"
          >
            <h2 className="text-3xl font-bold mb-4">Join the Spellify Community</h2>
            <p className="text-lg mb-8 opacity-90">
              Experience the future of text transformation. Download Spellify today.
            </p>
            <a
              href="/download"
              className="inline-flex items-center gap-2 px-6 py-3 bg-white text-[var(--color-primary)] rounded-lg font-semibold hover:bg-[var(--color-accent)] transition-colors"
            >
              Download for Free
            </a>
          </motion.div>
        </Container>
      </main>
      <Footer />
    </>
  );
}
