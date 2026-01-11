'use client';

import { motion } from 'framer-motion';
import { Briefcase, MapPin, Clock } from 'lucide-react';
import Container from '@/components/ui/Container';
import Button from '@/components/ui/Button';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { fadeInUp, staggerContainer, viewportConfig } from '@/lib/animations';

const openings = [
  {
    title: 'Senior Frontend Engineer',
    location: 'Remote (US)',
    type: 'Full-time',
    department: 'Engineering',
    description: 'Build beautiful, performant interfaces for our macOS app using Swift and AppKit.',
  },
  {
    title: 'Product Designer',
    location: 'Remote',
    type: 'Full-time',
    department: 'Design',
    description: 'Shape the user experience of Spellify and create delightful interactions.',
  },
  {
    title: 'ML Engineer',
    location: 'Remote (US)',
    type: 'Full-time',
    department: 'Engineering',
    description: 'Optimize our AI models and build new text transformation capabilities.',
  },
];

const perks = [
  'Competitive salary & equity',
  'Comprehensive health benefits',
  'Flexible remote work',
  'Generous PTO policy',
  'Learning & development budget',
  'Latest MacBook Pro',
];

export default function CareersPage() {
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
              Join the Spellify Team
            </motion.h1>
            <motion.p
              variants={fadeInUp}
              className="text-lg text-[var(--color-muted)] max-w-2xl mx-auto"
            >
              Help us build the future of productivity on macOS. We're a small, ambitious team making AI accessible to everyone.
            </motion.p>
          </motion.div>

          {/* Perks */}
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            whileInView="visible"
            viewport={viewportConfig}
            className="bg-white rounded-2xl border border-[var(--color-border)] p-8 mb-16"
          >
            <h2 className="text-2xl font-bold mb-6">Why Work With Us</h2>
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
              {perks.map((perk) => (
                <div
                  key={perk}
                  className="flex items-center gap-2 text-[var(--color-muted)]"
                >
                  <div className="w-2 h-2 rounded-full bg-[var(--color-primary)]" />
                  {perk}
                </div>
              ))}
            </div>
          </motion.div>

          {/* Open Positions */}
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            whileInView="visible"
            viewport={viewportConfig}
          >
            <motion.h2
              variants={fadeInUp}
              className="text-3xl font-bold mb-8"
            >
              Open Positions
            </motion.h2>
            <div className="grid gap-6">
              {openings.map((job) => (
                <motion.div
                  key={job.title}
                  variants={fadeInUp}
                  className="bg-white rounded-xl border border-[var(--color-border)] p-6 hover:border-[var(--color-primary)] transition-all hover:shadow-lg"
                >
                  <div className="flex flex-col md:flex-row md:items-start md:justify-between gap-4 mb-4">
                    <div>
                      <h3 className="text-xl font-bold mb-2">{job.title}</h3>
                      <div className="flex flex-wrap gap-3 text-sm text-[var(--color-muted)]">
                        <span className="flex items-center gap-1">
                          <Briefcase className="w-4 h-4" />
                          {job.department}
                        </span>
                        <span className="flex items-center gap-1">
                          <MapPin className="w-4 h-4" />
                          {job.location}
                        </span>
                        <span className="flex items-center gap-1">
                          <Clock className="w-4 h-4" />
                          {job.type}
                        </span>
                      </div>
                    </div>
                    <Button variant="secondary" className="whitespace-nowrap">
                      Apply Now
                    </Button>
                  </div>
                  <p className="text-[var(--color-muted)]">{job.description}</p>
                </motion.div>
              ))}
            </div>
          </motion.div>

          {/* No openings match */}
          <motion.div
            variants={fadeInUp}
            initial="hidden"
            whileInView="visible"
            viewport={viewportConfig}
            className="mt-12 text-center bg-[var(--color-accent)] rounded-xl p-8"
          >
            <h3 className="text-xl font-semibold mb-2">Don't see a fit?</h3>
            <p className="text-[var(--color-muted)] mb-4">
              We're always interested in hearing from talented people. Send us your resume and tell us what you'd love to work on.
            </p>
            <Button variant="secondary" href="/contact">
              Get in Touch
            </Button>
          </motion.div>
        </Container>
      </main>
      <Footer />
    </>
  );
}
