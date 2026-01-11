'use client';

import { motion } from 'framer-motion';
import { Mail, MessageSquare, Twitter, Github } from 'lucide-react';
import Container from '@/components/ui/Container';
import Button from '@/components/ui/Button';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { fadeInUp, staggerContainer, viewportConfig } from '@/lib/animations';

const contactMethods = [
  {
    icon: Mail,
    title: 'Email Us',
    description: 'For general inquiries and support',
    action: 'hello@spellify.app',
    href: 'mailto:hello@spellify.app',
  },
  {
    icon: Twitter,
    title: 'Twitter',
    description: 'Follow us for updates',
    action: '@spellifyapp',
    href: 'https://twitter.com/spellifyapp',
  },
  {
    icon: Github,
    title: 'GitHub',
    description: 'Report bugs and issues',
    action: 'github.com/spellify',
    href: 'https://github.com/spellify',
  },
  {
    icon: MessageSquare,
    title: 'Discord',
    description: 'Join our community',
    action: 'Join Discord',
    href: '#',
  },
];

export default function ContactPage() {
  return (
    <>
      <Header />
      <main className="pt-32 pb-20">
        <Container size="md">
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
              Get in Touch
            </motion.h1>
            <motion.p
              variants={fadeInUp}
              className="text-lg text-[var(--color-muted)] max-w-2xl mx-auto"
            >
              Have a question, feedback, or just want to say hi? We'd love to hear from you.
            </motion.p>
          </motion.div>

          <motion.div
            variants={staggerContainer}
            initial="hidden"
            whileInView="visible"
            viewport={viewportConfig}
            className="grid md:grid-cols-2 gap-6 mb-12"
          >
            {contactMethods.map((method) => {
              const Icon = method.icon;
              return (
                <motion.a
                  key={method.title}
                  variants={fadeInUp}
                  href={method.href}
                  className="bg-white rounded-xl border border-[var(--color-border)] p-6 hover:border-[var(--color-primary)] transition-all hover:shadow-lg group"
                >
                  <div className="w-12 h-12 rounded-lg bg-[var(--color-accent)] flex items-center justify-center mb-4 group-hover:bg-[var(--color-primary)] transition-colors">
                    <Icon className="w-6 h-6 text-[var(--color-primary)] group-hover:text-white transition-colors" />
                  </div>
                  <h3 className="text-xl font-semibold mb-2">{method.title}</h3>
                  <p className="text-sm text-[var(--color-muted)] mb-3">
                    {method.description}
                  </p>
                  <span className="text-[var(--color-primary)] font-medium">
                    {method.action}
                  </span>
                </motion.a>
              );
            })}
          </motion.div>

          {/* Contact Form */}
          <motion.div
            variants={fadeInUp}
            initial="hidden"
            whileInView="visible"
            viewport={viewportConfig}
            className="bg-white rounded-2xl border border-[var(--color-border)] p-8"
          >
            <h2 className="text-2xl font-bold mb-6">Send us a message</h2>
            <form className="space-y-4">
              <div className="grid md:grid-cols-2 gap-4">
                <div>
                  <label
                    htmlFor="name"
                    className="block text-sm font-medium mb-2"
                  >
                    Name
                  </label>
                  <input
                    type="text"
                    id="name"
                    className="w-full px-4 py-2 border border-[var(--color-border)] rounded-lg focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
                    placeholder="Your name"
                  />
                </div>
                <div>
                  <label
                    htmlFor="email"
                    className="block text-sm font-medium mb-2"
                  >
                    Email
                  </label>
                  <input
                    type="email"
                    id="email"
                    className="w-full px-4 py-2 border border-[var(--color-border)] rounded-lg focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
                    placeholder="you@example.com"
                  />
                </div>
              </div>
              <div>
                <label
                  htmlFor="subject"
                  className="block text-sm font-medium mb-2"
                >
                  Subject
                </label>
                <input
                  type="text"
                  id="subject"
                  className="w-full px-4 py-2 border border-[var(--color-border)] rounded-lg focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
                  placeholder="What's this about?"
                />
              </div>
              <div>
                <label
                  htmlFor="message"
                  className="block text-sm font-medium mb-2"
                >
                  Message
                </label>
                <textarea
                  id="message"
                  rows={6}
                  className="w-full px-4 py-2 border border-[var(--color-border)] rounded-lg focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)] resize-none"
                  placeholder="Tell us more..."
                />
              </div>
              <Button type="submit" className="w-full">
                Send Message
              </Button>
            </form>
          </motion.div>

          <motion.div
            variants={fadeInUp}
            initial="hidden"
            whileInView="visible"
            viewport={viewportConfig}
            className="mt-8 text-center text-sm text-[var(--color-muted)]"
          >
            <p>
              For support issues, please check our{' '}
              <a
                href="#"
                className="text-[var(--color-primary)] hover:underline"
              >
                Help Center
              </a>{' '}
              first.
            </p>
          </motion.div>
        </Container>
      </main>
      <Footer />
    </>
  );
}
