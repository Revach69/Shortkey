'use client';

import { motion } from 'framer-motion';
import { Check, X, Clock, Zap } from 'lucide-react';
import Container from './ui/Container';
import { COMPARISON } from '@/lib/constants';
import { fadeInUp, staggerContainer, viewportConfig, slideInFromLeft, slideInFromRight } from '@/lib/animations';

export default function SpeedComparison() {
  return (
    <section className="py-20 md:py-32 bg-[var(--color-primary)] text-white overflow-hidden">
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
            className="text-sm font-semibold uppercase tracking-wider opacity-80"
          >
            Why Spellify?
          </motion.span>
          <motion.h2
            variants={fadeInUp}
            className="text-3xl md:text-5xl font-bold mt-4"
          >
            7 steps vs 2 steps
          </motion.h2>
        </motion.div>

        <div className="grid md:grid-cols-2 gap-8 md:gap-12">
          {/* Old Way */}
          <motion.div
            variants={slideInFromLeft}
            initial="hidden"
            whileInView="visible"
            viewport={viewportConfig}
            className="relative"
          >
            <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 border border-white/20">
              <div className="flex items-center gap-3 mb-6">
                <div className="w-10 h-10 rounded-full bg-red-500/20 flex items-center justify-center">
                  <Clock className="w-5 h-5 text-red-300" />
                </div>
                <div>
                  <h3 className="text-xl font-semibold">The Old Way</h3>
                  <p className="text-sm opacity-60">~30 seconds per action</p>
                </div>
              </div>

              <div className="space-y-3">
                {COMPARISON.oldWay.map((step, index) => (
                  <motion.div
                    key={step}
                    initial={{ opacity: 0, x: -10 }}
                    whileInView={{ opacity: 1, x: 0 }}
                    transition={{ delay: index * 0.1 }}
                    viewport={{ once: true }}
                    className="flex items-center gap-3"
                  >
                    <div className="w-6 h-6 rounded-full bg-white/10 flex items-center justify-center flex-shrink-0">
                      <span className="text-xs font-medium">{index + 1}</span>
                    </div>
                    <span className="opacity-80">{step}</span>
                  </motion.div>
                ))}
              </div>

              {/* Strikethrough effect */}
              <motion.div
                className="absolute inset-0 flex items-center justify-center pointer-events-none"
                initial={{ opacity: 0 }}
                whileInView={{ opacity: 1 }}
                transition={{ delay: 0.8 }}
                viewport={{ once: true }}
              >
                <div className="w-32 h-32 rounded-full border-4 border-red-400/50 flex items-center justify-center">
                  <X className="w-16 h-16 text-red-400/50" />
                </div>
              </motion.div>
            </div>
          </motion.div>

          {/* New Way */}
          <motion.div
            variants={slideInFromRight}
            initial="hidden"
            whileInView="visible"
            viewport={viewportConfig}
          >
            <div className="bg-white rounded-2xl p-8 text-[var(--color-foreground)] shadow-2xl">
              <div className="flex items-center gap-3 mb-6">
                <div className="w-10 h-10 rounded-full bg-[var(--color-accent)] flex items-center justify-center">
                  <Zap className="w-5 h-5 text-[var(--color-primary)]" />
                </div>
                <div>
                  <h3 className="text-xl font-semibold">With Spellify</h3>
                  <p className="text-sm text-[var(--color-muted)]">Instant</p>
                </div>
              </div>

              <div className="space-y-4">
                {COMPARISON.newWay.map((step, index) => (
                  <motion.div
                    key={step}
                    initial={{ opacity: 0, x: 10 }}
                    whileInView={{ opacity: 1, x: 0 }}
                    transition={{ delay: index * 0.15 + 0.3 }}
                    viewport={{ once: true }}
                    className="flex items-center gap-3"
                  >
                    <div className="w-6 h-6 rounded-full bg-[var(--color-primary)] flex items-center justify-center flex-shrink-0">
                      <Check className="w-4 h-4 text-white" />
                    </div>
                    <span className="font-medium">{step}</span>
                  </motion.div>
                ))}
              </div>

              {/* Highlight */}
              <motion.div
                className="mt-8 p-4 bg-[var(--color-accent)] rounded-xl"
                initial={{ opacity: 0, scale: 0.95 }}
                whileInView={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.8 }}
                viewport={{ once: true }}
              >
                <p className="text-center font-semibold text-[var(--color-primary)]">
                  Save 30+ seconds on every text transformation
                </p>
              </motion.div>
            </div>
          </motion.div>
        </div>
      </Container>
    </section>
  );
}
