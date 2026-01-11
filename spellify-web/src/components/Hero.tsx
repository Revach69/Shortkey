'use client';

import { motion } from 'framer-motion';
import { Apple, ArrowRight } from 'lucide-react';
import Container from './ui/Container';
import Button from './ui/Button';
import { fadeInUp, staggerContainer } from '@/lib/animations';

export default function Hero() {
  return (
    <section className="pt-32 pb-20 md:pt-40 md:pb-32 overflow-hidden">
      <Container>
        <motion.div
          className="text-center max-w-4xl mx-auto"
          variants={staggerContainer}
          initial="hidden"
          animate="visible"
        >
          {/* Badge */}
          <motion.div variants={fadeInUp} className="mb-6">
            <span className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-[var(--color-accent)] text-sm font-medium text-[var(--color-primary)]">
              <Apple className="w-4 h-4" />
              Available for macOS
            </span>
          </motion.div>

          {/* Headline */}
          <motion.h1
            variants={fadeInUp}
            className="text-4xl md:text-6xl lg:text-7xl font-bold tracking-tight mb-6"
          >
            Stop copy-pasting
            <br />
            <span className="text-[var(--color-primary)]">to AI</span>
          </motion.h1>

          {/* Subheadline */}
          <motion.p
            variants={fadeInUp}
            className="text-lg md:text-xl text-[var(--color-muted)] max-w-2xl mx-auto mb-10"
          >
            Transform any text with a keyboard shortcut. Translate, shorten,
            formalize — instantly, in any app.
          </motion.p>

          {/* CTAs */}
          <motion.div
            variants={fadeInUp}
            className="flex flex-col sm:flex-row items-center justify-center gap-4 mb-16"
          >
            <Button href="#download" size="lg">
              <Apple className="w-5 h-5" />
              Download for Free
            </Button>
            <Button href="#how-it-works" variant="secondary" size="lg">
              See how it works
              <ArrowRight className="w-5 h-5" />
            </Button>
          </motion.div>

          {/* Before/After Demo */}
          <motion.div
            variants={fadeInUp}
            className="relative max-w-3xl mx-auto"
          >
            <div className="bg-white rounded-2xl shadow-2xl border border-[var(--color-border)] overflow-hidden">
              {/* Window Header */}
              <div className="flex items-center gap-2 px-4 py-3 bg-gray-50 border-b border-[var(--color-border)]">
                <div className="flex gap-2">
                  <div className="w-3 h-3 rounded-full bg-red-400" />
                  <div className="w-3 h-3 rounded-full bg-yellow-400" />
                  <div className="w-3 h-3 rounded-full bg-green-400" />
                </div>
                <span className="text-sm text-[var(--color-muted)] ml-2">Email Draft</span>
              </div>

              {/* Demo Content */}
              <div className="p-6 md:p-8">
                <div className="grid md:grid-cols-2 gap-6">
                  {/* Before */}
                  <div className="text-left">
                    <div className="flex items-center gap-2 mb-3">
                      <span className="text-xs font-semibold uppercase tracking-wider text-[var(--color-muted)]">
                        Before
                      </span>
                    </div>
                    <div className="p-4 bg-gray-50 rounded-lg text-sm text-[var(--color-muted)] leading-relaxed">
                      hey so i was thinking maybe we could like push back the meeting a bit?
                      im kinda swamped rn and also need to prep some stuff first.
                      lmk if thats cool or whatever
                    </div>
                  </div>

                  {/* Shortcut Animation */}
                  <motion.div
                    className="hidden md:flex items-center justify-center"
                    initial={{ opacity: 0, scale: 0.8 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: 0.8, duration: 0.4 }}
                  >
                    <motion.div
                      className="flex items-center gap-1 px-4 py-2 bg-[var(--color-primary)] text-white rounded-lg font-mono text-sm shadow-lg"
                      animate={{
                        scale: [1, 1.05, 1],
                        boxShadow: [
                          '0 4px 6px -1px rgba(0, 0, 0, 0.1)',
                          '0 10px 15px -3px rgba(3, 79, 70, 0.3)',
                          '0 4px 6px -1px rgba(0, 0, 0, 0.1)',
                        ],
                      }}
                      transition={{
                        repeat: Infinity,
                        duration: 2,
                        ease: 'easeInOut',
                      }}
                    >
                      ⌘⇧1
                    </motion.div>
                  </motion.div>

                  {/* After */}
                  <div className="text-left md:col-start-1">
                    <div className="flex items-center gap-2 mb-3">
                      <span className="text-xs font-semibold uppercase tracking-wider text-[var(--color-primary)]">
                        After
                      </span>
                      <span className="text-xs px-2 py-0.5 bg-[var(--color-accent)] text-[var(--color-primary)] rounded-full">
                        Formalized
                      </span>
                    </div>
                    <div className="p-4 bg-[var(--color-accent)] rounded-lg text-sm text-[var(--color-foreground)] leading-relaxed border-2 border-[var(--color-primary)]">
                      Hi, I was wondering if we could reschedule our meeting.
                      I&apos;m currently quite busy and need some additional time to prepare.
                      Please let me know if that works for you.
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Decorative gradient */}
            <div className="absolute -bottom-10 left-1/2 -translate-x-1/2 w-3/4 h-20 bg-gradient-to-t from-white to-transparent" />
          </motion.div>
        </motion.div>
      </Container>
    </section>
  );
}
