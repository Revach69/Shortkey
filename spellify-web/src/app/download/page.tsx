'use client';

import { motion } from 'framer-motion';
import { Apple, CheckCircle2, Download as DownloadIcon } from 'lucide-react';
import Container from '@/components/ui/Container';
import Button from '@/components/ui/Button';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { fadeInUp, staggerContainer, viewportConfig } from '@/lib/animations';

export default function DownloadPage() {
  return (
    <>
      <Header />
      <main className="pt-32 pb-20">
        <Container size="md">
          <motion.div
            variants={staggerContainer}
            initial="hidden"
            animate="visible"
            className="text-center"
          >
            <motion.div variants={fadeInUp} className="mb-6">
              <Apple className="w-16 h-16 mx-auto text-[var(--color-primary)]" />
            </motion.div>

            <motion.h1
              variants={fadeInUp}
              className="text-4xl md:text-5xl font-bold mb-6"
            >
              Download Spellify
            </motion.h1>

            <motion.p
              variants={fadeInUp}
              className="text-lg text-[var(--color-muted)] mb-10 max-w-2xl mx-auto"
            >
              Get started with Spellify for macOS. Transform your text workflow with AI-powered shortcuts.
            </motion.p>

            <motion.div variants={fadeInUp} className="mb-16">
              <Button size="lg" className="mb-4">
                <DownloadIcon className="w-5 h-5" />
                Download for macOS
              </Button>
              <p className="text-sm text-[var(--color-muted)]">
                Version 1.0.0 • macOS 12.0 or later • Free Download
              </p>
            </motion.div>

            <motion.div
              variants={fadeInUp}
              className="bg-white rounded-2xl border border-[var(--color-border)] p-8 text-left max-w-2xl mx-auto"
            >
              <h2 className="text-2xl font-bold mb-6">System Requirements</h2>
              <ul className="space-y-3">
                <li className="flex items-start gap-3">
                  <CheckCircle2 className="w-5 h-5 text-[var(--color-primary)] flex-shrink-0 mt-0.5" />
                  <span>macOS 12.0 (Monterey) or later</span>
                </li>
                <li className="flex items-start gap-3">
                  <CheckCircle2 className="w-5 h-5 text-[var(--color-primary)] flex-shrink-0 mt-0.5" />
                  <span>Apple Silicon (M1/M2/M3) or Intel processor</span>
                </li>
                <li className="flex items-start gap-3">
                  <CheckCircle2 className="w-5 h-5 text-[var(--color-primary)] flex-shrink-0 mt-0.5" />
                  <span>100 MB of available disk space</span>
                </li>
                <li className="flex items-start gap-3">
                  <CheckCircle2 className="w-5 h-5 text-[var(--color-primary)] flex-shrink-0 mt-0.5" />
                  <span>Internet connection for AI features</span>
                </li>
              </ul>
            </motion.div>

            <motion.div
              variants={fadeInUp}
              initial="hidden"
              whileInView="visible"
              viewport={viewportConfig}
              className="mt-12 p-6 bg-[var(--color-accent)] rounded-xl"
            >
              <h3 className="text-lg font-semibold mb-2">Installation Instructions</h3>
              <ol className="text-left text-sm text-[var(--color-muted)] space-y-2 max-w-xl mx-auto">
                <li>1. Download the Spellify.dmg file</li>
                <li>2. Open the downloaded file</li>
                <li>3. Drag Spellify to your Applications folder</li>
                <li>4. Launch Spellify from Applications</li>
                <li>5. Grant necessary permissions when prompted</li>
              </ol>
            </motion.div>
          </motion.div>
        </Container>
      </main>
      <Footer />
    </>
  );
}
