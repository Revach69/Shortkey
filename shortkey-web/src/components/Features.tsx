'use client';

import { motion } from 'framer-motion';
import { Keyboard, Globe, Zap, Sparkles } from 'lucide-react';
import Container from './ui/Container';
import { FEATURES } from '@/lib/constants';
import { fadeInUp, staggerContainer, viewportConfig } from '@/lib/animations';

const iconMap: Record<string, React.ComponentType<{ className?: string }>> = {
  Keyboard,
  Globe,
  Zap,
  Sparkles,
};

export default function Features() {
  return (
    <section id="features" className="py-20 md:py-32">
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
            Features
          </motion.span>
          <motion.h2
            variants={fadeInUp}
            className="text-3xl md:text-5xl font-bold mt-4 mb-6 font-[family-name:var(--font-serif)]"
          >
            Everything you need
          </motion.h2>
          <motion.p
            variants={fadeInUp}
            className="text-lg text-[var(--color-muted)] max-w-2xl mx-auto"
          >
            Shortkey is designed to get out of your way and let you write faster.
          </motion.p>
        </motion.div>

        <motion.div
          className="grid md:grid-cols-2 gap-6 md:gap-8"
          variants={staggerContainer}
          initial="hidden"
          whileInView="visible"
          viewport={viewportConfig}
        >
          {FEATURES.map((feature) => {
            const Icon = iconMap[feature.icon];
            return (
              <motion.div
                key={feature.title}
                variants={fadeInUp}
                className="group relative bg-white rounded-2xl p-8 border border-[var(--color-border)] hover:border-[var(--color-primary)] hover:shadow-lg transition-all duration-300"
              >
                {/* Icon */}
                <div className="w-14 h-14 rounded-xl bg-[var(--color-accent)] flex items-center justify-center mb-6 group-hover:bg-[var(--color-primary)] transition-colors">
                  <Icon className="w-7 h-7 text-[var(--color-primary)] group-hover:text-white transition-colors" />
                </div>

                {/* Content */}
                <h3 className="text-xl font-semibold mb-3">{feature.title}</h3>
                <p className="text-[var(--color-muted)] leading-relaxed">
                  {feature.description}
                </p>

                {/* Decorative corner */}
                <div className="absolute top-0 right-0 w-20 h-20 bg-gradient-to-bl from-[var(--color-accent)] to-transparent rounded-tr-2xl opacity-0 group-hover:opacity-100 transition-opacity" />
              </motion.div>
            );
          })}
        </motion.div>
      </Container>
    </section>
  );
}
