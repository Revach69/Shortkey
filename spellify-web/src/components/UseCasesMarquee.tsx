'use client';

import { motion } from 'framer-motion';
import Container from './ui/Container';
import { USE_CASES } from '@/lib/constants';
import { fadeInUp, viewportConfig } from '@/lib/animations';

export default function UseCasesMarquee() {
  // Duplicate for seamless loop
  const duplicatedCases = [...USE_CASES, ...USE_CASES];

  return (
    <section className="py-16 md:py-24 overflow-hidden">
      <Container>
        <motion.div
          className="text-center mb-12"
          initial="hidden"
          whileInView="visible"
          viewport={viewportConfig}
          variants={fadeInUp}
        >
          <h2 className="text-2xl md:text-3xl font-bold">
            One shortcut for <span className="text-[var(--color-primary)]">anything</span>
          </h2>
        </motion.div>
      </Container>

      {/* Marquee */}
      <div className="relative">
        {/* Gradient overlays */}
        <div className="absolute left-0 top-0 bottom-0 w-32 bg-gradient-to-r from-white to-transparent z-10" />
        <div className="absolute right-0 top-0 bottom-0 w-32 bg-gradient-to-l from-white to-transparent z-10" />

        {/* Scrolling content */}
        <div className="flex animate-marquee">
          {duplicatedCases.map((useCase, index) => (
            <div
              key={`${useCase}-${index}`}
              className="flex-shrink-0 mx-3"
            >
              <span className="inline-block px-6 py-3 bg-[var(--color-accent)] text-[var(--color-primary)] rounded-full font-medium whitespace-nowrap hover:bg-[var(--color-accent-hover)] transition-colors cursor-default">
                {useCase}
              </span>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
