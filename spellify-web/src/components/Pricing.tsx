'use client';

import { motion } from 'framer-motion';
import { Check, X, Sparkles, Zap, Rocket, Users, Code } from 'lucide-react';
import Container from './ui/Container';
import Button from './ui/Button';
import { fadeInUp, staggerContainer, viewportConfig } from '@/lib/animations';

const pricingTiers = [
  {
    name: 'Free',
    icon: Sparkles,
    price: '$0',
    period: 'forever',
    description: 'Perfect for getting started',
    highlighted: false,
    cta: 'Download Free',
    limits: [
      '3 transformations',
      '100 actions / month',
      'Standard speed',
    ],
    features: [
      'Create from templates',
      'Custom prompt editor (basic)',
      'Hotkeys + context menu',
      'Basic safety rails',
    ],
    excluded: [
      'No variables or chaining',
      'No history search',
      'No priority queue',
    ],
  },
  {
    name: 'Pro',
    icon: Zap,
    price: '$12',
    yearlyPrice: '$99',
    period: 'per month',
    description: 'For power users',
    highlighted: true,
    cta: 'Start Pro Trial',
    limits: [
      'Unlimited transformations',
      '2,000 actions / month',
      'Higher input/output caps',
    ],
    features: [
      'Everything in Free',
      'Prompt templates with variables',
      'Folders & tags',
      'Prompt history + search',
      'Faster queue / priority',
      'Multi-device sync',
    ],
    excluded: [],
  },
  {
    name: 'Power',
    icon: Rocket,
    price: '$25',
    yearlyPrice: '$199',
    period: 'per month',
    description: 'For advanced workflows',
    highlighted: false,
    cta: 'Get Power',
    limits: [
      'Unlimited transformations',
      '10,000 actions / month',
      'Highest input/output caps',
      'Highest priority execution',
    ],
    features: [
      'Everything in Pro',
      'Batch runs',
      'Chained transformations',
      'Advanced variables',
      'Export/import presets',
      'Priority support',
    ],
    excluded: [],
  },
  {
    name: 'Team',
    icon: Users,
    price: '$15',
    yearlyPrice: '$12',
    period: 'per user/month',
    description: 'Minimum 5 seats',
    highlighted: false,
    cta: 'Contact Sales',
    limits: [
      'Unlimited transformations',
      '5,000 actions/user/month',
      'Pooled workspace quota',
    ],
    features: [
      'Shared workspace library',
      'Admin controls',
      'Team templates',
      'Central billing',
      'Audit log',
      'Priority support',
      'Compliance mode (add-on)',
    ],
    excluded: [],
  },
  {
    name: 'Developer',
    icon: Code,
    price: '$8',
    yearlyPrice: '$69',
    period: 'per month',
    description: 'Bring Your Own Key',
    highlighted: false,
    cta: 'Get BYOK',
    badge: 'BYOK',
    limits: [
      'Unlimited transformations',
      '50,000 actions / month',
      'You pay model costs',
    ],
    features: [
      'Choose provider/model',
      'Local keychain storage',
      'Advanced prompt features',
      'Variables & folders',
      'Export/import',
      'Priority execution',
    ],
    excluded: [
      'No model credit coverage',
      'No team features',
    ],
    note: 'Keys stored in macOS Keychain, not our servers',
  },
];

export default function Pricing() {
  return (
    <section id="pricing" className="py-20 md:py-32 bg-gray-50">
      <Container size="xl">
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
            Pricing
          </motion.span>
          <motion.h2
            variants={fadeInUp}
            className="text-3xl md:text-5xl font-bold mt-4 mb-4"
          >
            Choose your plan
          </motion.h2>
          <motion.p
            variants={fadeInUp}
            className="text-lg text-[var(--color-muted)] max-w-2xl mx-auto"
          >
            Start free, upgrade as you grow. All plans include a 14-day money-back guarantee.
          </motion.p>
        </motion.div>

        <motion.div
          className="grid md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-6"
          variants={staggerContainer}
          initial="hidden"
          whileInView="visible"
          viewport={viewportConfig}
        >
          {pricingTiers.map((tier) => {
            const Icon = tier.icon;
            return (
              <motion.div
                key={tier.name}
                variants={fadeInUp}
                className={`relative bg-white rounded-2xl p-6 border-2 transition-all hover:shadow-lg ${
                  tier.highlighted
                    ? 'border-[var(--color-primary)] shadow-xl scale-105'
                    : 'border-[var(--color-border)]'
                }`}
              >
                {/* Badge */}
                {tier.highlighted && (
                  <div className="absolute -top-4 left-1/2 -translate-x-1/2">
                    <span className="inline-flex items-center px-3 py-1 bg-[var(--color-primary)] text-white text-xs font-semibold rounded-full">
                      Most Popular
                    </span>
                  </div>
                )}

                {tier.badge && (
                  <div className="absolute -top-4 left-1/2 -translate-x-1/2">
                    <span className="inline-flex items-center px-3 py-1 bg-[var(--color-accent)] text-[var(--color-primary)] text-xs font-bold rounded-full border-2 border-[var(--color-primary)]">
                      {tier.badge}
                    </span>
                  </div>
                )}

                {/* Icon */}
                <div className="w-10 h-10 rounded-lg bg-[var(--color-accent)] flex items-center justify-center mb-4">
                  <Icon className="w-5 h-5 text-[var(--color-primary)]" />
                </div>

                {/* Name & Description */}
                <h3 className="text-xl font-bold mb-1">{tier.name}</h3>
                <p className="text-sm text-[var(--color-muted)] mb-4">
                  {tier.description}
                </p>

                {/* Price */}
                <div className="mb-6">
                  <div className="flex items-baseline gap-1">
                    <span className="text-3xl font-bold">{tier.price}</span>
                    {tier.period && (
                      <span className="text-sm text-[var(--color-muted)]">
                        /{tier.period.replace('per ', '')}
                      </span>
                    )}
                  </div>
                  {tier.yearlyPrice && (
                    <p className="text-xs text-[var(--color-muted)] mt-1">
                      or {tier.yearlyPrice}/year (save 31%)
                    </p>
                  )}
                </div>

                {/* CTA */}
                <Button
                  variant={tier.highlighted ? 'primary' : 'secondary'}
                  className="w-full mb-6"
                  size="sm"
                >
                  {tier.cta}
                </Button>

                {/* Limits */}
                <div className="mb-4">
                  <p className="text-xs font-semibold uppercase tracking-wider text-[var(--color-muted)] mb-2">
                    Limits
                  </p>
                  <ul className="space-y-2">
                    {tier.limits.map((limit) => (
                      <li
                        key={limit}
                        className="text-xs text-[var(--color-foreground)] flex items-start gap-2"
                      >
                        <span className="text-[var(--color-muted)] mt-0.5">•</span>
                        {limit}
                      </li>
                    ))}
                  </ul>
                </div>

                {/* Features */}
                <div className="mb-4">
                  <p className="text-xs font-semibold uppercase tracking-wider text-[var(--color-muted)] mb-2">
                    Includes
                  </p>
                  <ul className="space-y-2">
                    {tier.features.map((feature) => (
                      <li key={feature} className="flex items-start gap-2">
                        <Check className="w-3.5 h-3.5 text-[var(--color-primary)] flex-shrink-0 mt-0.5" />
                        <span className="text-xs text-[var(--color-foreground)]">
                          {feature}
                        </span>
                      </li>
                    ))}
                  </ul>
                </div>

                {/* Excluded */}
                {tier.excluded.length > 0 && (
                  <div className="mb-4">
                    <p className="text-xs font-semibold uppercase tracking-wider text-[var(--color-muted)] mb-2">
                      Excludes
                    </p>
                    <ul className="space-y-2">
                      {tier.excluded.map((item) => (
                        <li key={item} className="flex items-start gap-2">
                          <X className="w-3.5 h-3.5 text-[var(--color-muted)] flex-shrink-0 mt-0.5" />
                          <span className="text-xs text-[var(--color-muted)]">
                            {item}
                          </span>
                        </li>
                      ))}
                    </ul>
                  </div>
                )}

                {/* Note */}
                {tier.note && (
                  <div className="mt-4 p-3 bg-[var(--color-accent)] rounded-lg">
                    <p className="text-xs text-[var(--color-primary)] font-medium">
                      {tier.note}
                    </p>
                  </div>
                )}
              </motion.div>
            );
          })}
        </motion.div>

        {/* FAQ */}
        <motion.div
          variants={fadeInUp}
          initial="hidden"
          whileInView="visible"
          viewport={viewportConfig}
          className="text-center mt-16"
        >
          <p className="text-[var(--color-muted)]">
            Questions? Check our{' '}
            <a href="/faq" className="text-[var(--color-primary)] font-medium hover:underline">
              FAQ
            </a>{' '}
            or{' '}
            <a href="/contact" className="text-[var(--color-primary)] font-medium hover:underline">
              contact us
            </a>
            .
          </p>
        </motion.div>
      </Container>
    </section>
  );
}
