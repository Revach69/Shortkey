'use client';

import { motion } from 'framer-motion';
import { Twitter, Github, Linkedin, Mail } from 'lucide-react';
import Container from './ui/Container';
import { SITE_CONFIG } from '@/lib/constants';
import { fadeInUp, viewportConfig } from '@/lib/animations';

const footerLinks = {
  Product: [
    { label: 'Features', href: '#features' },
    { label: 'How It Works', href: '#how-it-works' },
    { label: 'Pricing', href: '#pricing' },
    { label: 'Download', href: '#download' },
  ],
  Company: [
    { label: 'About', href: '/about' },
    { label: 'Blog', href: '/blog' },
    { label: 'Careers', href: '/careers' },
    { label: 'Contact', href: '/contact' },
  ],
  Legal: [
    { label: 'Privacy', href: '/privacy' },
    { label: 'Terms', href: '/terms' },
  ],
};

const socialLinks = [
  { icon: Twitter, href: 'https://twitter.com/spellify', label: 'Twitter' },
  { icon: Github, href: 'https://github.com/spellify', label: 'GitHub' },
  { icon: Linkedin, href: 'https://linkedin.com/company/spellify', label: 'LinkedIn' },
  { icon: Mail, href: 'mailto:hello@spellify.app', label: 'Email' },
];

export default function Footer() {
  const currentYear = new Date().getFullYear();

  return (
    <footer id="download" className="bg-[var(--color-foreground)] text-white py-16 md:py-20">
      <Container>
        <motion.div
          initial="hidden"
          whileInView="visible"
          viewport={viewportConfig}
          variants={fadeInUp}
        >
          <div className="grid md:grid-cols-4 gap-12 md:gap-8 mb-12">
            {/* Brand */}
            <div className="md:col-span-1">
              <a href="/" className="text-2xl font-bold">
                {SITE_CONFIG.name}
              </a>
              <p className="text-white/60 mt-4 text-sm leading-relaxed">
                AI shortcuts for your Mac. Transform any text with a keyboard shortcut.
              </p>

              {/* Social links */}
              <div className="flex gap-4 mt-6">
                {socialLinks.map((social) => (
                  <a
                    key={social.label}
                    href={social.href}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center hover:bg-white/20 transition-colors"
                    aria-label={social.label}
                  >
                    <social.icon className="w-5 h-5" />
                  </a>
                ))}
              </div>
            </div>

            {/* Links */}
            {Object.entries(footerLinks).map(([title, links]) => (
              <div key={title}>
                <h3 className="font-semibold mb-4">{title}</h3>
                <ul className="space-y-3">
                  {links.map((link) => (
                    <li key={link.label}>
                      <a
                        href={link.href}
                        className="text-white/60 hover:text-white transition-colors text-sm"
                      >
                        {link.label}
                      </a>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>

          {/* Bottom bar */}
          <div className="pt-8 border-t border-white/10 flex flex-col md:flex-row items-center justify-between gap-4">
            <p className="text-white/40 text-sm">
              &copy; {currentYear} {SITE_CONFIG.name}. All rights reserved.
            </p>
            <p className="text-white/40 text-sm">
              Made with love for Mac users everywhere
            </p>
          </div>
        </motion.div>
      </Container>
    </footer>
  );
}
