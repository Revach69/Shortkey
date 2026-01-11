'use client';

import { motion } from 'framer-motion';
import useEmblaCarousel from 'embla-carousel-react';
import Autoplay from 'embla-carousel-autoplay';
import { Quote } from 'lucide-react';
import Container from './ui/Container';
import { TESTIMONIALS } from '@/lib/constants';
import { fadeInUp, staggerContainer, viewportConfig } from '@/lib/animations';

export default function Testimonials() {
  const [emblaRef] = useEmblaCarousel(
    { loop: true, align: 'center' },
    [Autoplay({ delay: 5000, stopOnInteraction: false })]
  );

  return (
    <section className="py-20 md:py-32 overflow-hidden">
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
            Testimonials
          </motion.span>
          <motion.h2
            variants={fadeInUp}
            className="text-3xl md:text-5xl font-bold mt-4"
          >
            Loved by creators
          </motion.h2>
        </motion.div>
      </Container>

      {/* Carousel */}
      <motion.div
        variants={fadeInUp}
        initial="hidden"
        whileInView="visible"
        viewport={viewportConfig}
        className="overflow-hidden"
        ref={emblaRef}
      >
        <div className="flex">
          {TESTIMONIALS.map((testimonial, index) => (
            <div
              key={index}
              className="flex-[0_0_90%] md:flex-[0_0_50%] lg:flex-[0_0_33.333%] min-w-0 pl-4"
            >
              <div className="bg-white rounded-2xl p-8 border border-[var(--color-border)] h-full mx-2 hover:shadow-lg transition-shadow">
                {/* Quote icon */}
                <div className="w-10 h-10 rounded-full bg-[var(--color-accent)] flex items-center justify-center mb-6">
                  <Quote className="w-5 h-5 text-[var(--color-primary)]" />
                </div>

                {/* Quote */}
                <p className="text-lg text-[var(--color-foreground)] mb-6 leading-relaxed">
                  &ldquo;{testimonial.quote}&rdquo;
                </p>

                {/* Author */}
                <div className="flex items-center gap-3">
                  {/* Avatar placeholder */}
                  <div className="w-10 h-10 rounded-full bg-[var(--color-primary)] flex items-center justify-center text-white font-semibold">
                    {testimonial.author.charAt(0)}
                  </div>
                  <div>
                    <p className="font-semibold text-[var(--color-foreground)]">
                      {testimonial.author}
                    </p>
                    <p className="text-sm text-[var(--color-muted)]">
                      {testimonial.role}
                    </p>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </motion.div>
    </section>
  );
}
