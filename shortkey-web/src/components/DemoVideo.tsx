'use client';

import { motion } from 'framer-motion';
import { Play } from 'lucide-react';
import Container from './ui/Container';
import { fadeInUp, staggerContainer, viewportConfig } from '@/lib/animations';

export default function DemoVideo() {
  return (
    <section className="py-20 md:py-32 bg-gray-50">
      <Container>
        <motion.div
          className="text-center mb-12"
          variants={staggerContainer}
          initial="hidden"
          whileInView="visible"
          viewport={viewportConfig}
        >
          <motion.span
            variants={fadeInUp}
            className="text-sm font-semibold text-[var(--color-primary)] uppercase tracking-wider"
          >
            See It In Action
          </motion.span>
          <motion.h2
            variants={fadeInUp}
            className="text-3xl md:text-5xl font-bold mt-4"
          >
            Watch Shortkey work
          </motion.h2>
        </motion.div>

        <motion.div
          variants={fadeInUp}
          initial="hidden"
          whileInView="visible"
          viewport={viewportConfig}
          className="max-w-4xl mx-auto"
        >
          {/* Video Placeholder */}
          <div className="relative aspect-video bg-[var(--color-foreground)] rounded-2xl overflow-hidden shadow-2xl group cursor-pointer">
            {/* Placeholder gradient */}
            <div className="absolute inset-0 bg-gradient-to-br from-[var(--color-primary)] to-[var(--color-primary-hover)]" />

            {/* Grid pattern overlay */}
            <div
              className="absolute inset-0 opacity-10"
              style={{
                backgroundImage: `linear-gradient(rgba(255,255,255,.1) 1px, transparent 1px),
                                  linear-gradient(90deg, rgba(255,255,255,.1) 1px, transparent 1px)`,
                backgroundSize: '20px 20px',
              }}
            />

            {/* Play button */}
            <div className="absolute inset-0 flex items-center justify-center">
              <motion.div
                className="w-20 h-20 md:w-24 md:h-24 rounded-full bg-white flex items-center justify-center shadow-lg group-hover:scale-110 transition-transform"
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.95 }}
              >
                <Play className="w-8 h-8 md:w-10 md:h-10 text-[var(--color-primary)] ml-1" />
              </motion.div>
            </div>

            {/* Coming soon text */}
            <div className="absolute bottom-6 left-0 right-0 text-center">
              <span className="text-white/60 text-sm">Video coming soon</span>
            </div>
          </div>
        </motion.div>
      </Container>
    </section>
  );
}
