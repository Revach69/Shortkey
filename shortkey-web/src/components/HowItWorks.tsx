'use client';

import { motion } from 'framer-motion';
import { MousePointer2, Command, Sparkles } from 'lucide-react';
import Container from './ui/Container';
import { fadeInUp, staggerContainer, viewportConfig } from '@/lib/animations';

const steps = [
  {
    number: '01',
    title: 'Select any text',
    description: 'Highlight the text you want to transform in any app.',
    icon: MousePointer2,
  },
  {
    number: '02',
    title: 'Press your shortcut',
    description: 'Hit your custom keyboard combo like ⌘⇧1.',
    icon: Command,
  },
  {
    number: '03',
    title: 'Get instant results',
    description: 'Your text is transformed and replaced automatically.',
    icon: Sparkles,
  },
];

export default function HowItWorks() {
  return (
    <section id="how-it-works" className="py-20 md:py-32 bg-gray-50">
      <Container>
        <motion.div
          className="text-center mb-16"
          variants={staggerContainer}
          initial="hidden"
          whileInView="visible"
          viewport={viewportConfig}
        >
          <motion.span
            variants={fadeInUp}
            className="text-sm font-semibold text-[var(--color-primary)] uppercase tracking-wider"
          >
            How It Works
          </motion.span>
          <motion.h2
            variants={fadeInUp}
            className="text-3xl md:text-5xl font-bold mt-4 font-[family-name:var(--font-serif)]"
          >
            Three steps. Zero friction.
          </motion.h2>
        </motion.div>

        <motion.div
          className="grid md:grid-cols-3 gap-8 md:gap-12"
          variants={staggerContainer}
          initial="hidden"
          whileInView="visible"
          viewport={viewportConfig}
        >
          {steps.map((step, index) => (
            <motion.div
              key={step.number}
              variants={fadeInUp}
              className="relative"
            >
              {/* Connector line */}
              {index < steps.length - 1 && (
                <div className="hidden md:block absolute top-12 left-1/2 w-full h-0.5 bg-[var(--color-border)]" />
              )}

              <div className="relative bg-white rounded-2xl p-8 shadow-sm border border-[var(--color-border)] hover:shadow-md transition-shadow">
                {/* Step number */}
                <span className="absolute -top-4 left-8 px-3 py-1 bg-[var(--color-primary)] text-white text-sm font-bold rounded-full font-[family-name:var(--font-mono)]">
                  {step.number}
                </span>

                {/* Icon */}
                <div className="w-14 h-14 rounded-xl bg-[var(--color-accent)] flex items-center justify-center mb-6">
                  <step.icon className="w-7 h-7 text-[var(--color-primary)]" />
                </div>

                {/* Content */}
                <h3 className="text-xl font-semibold mb-3">{step.title}</h3>
                <p className="text-[var(--color-muted)]">{step.description}</p>
              </div>
            </motion.div>
          ))}
        </motion.div>
      </Container>
    </section>
  );
}
