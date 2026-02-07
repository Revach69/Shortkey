'use client';

import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Check, X, Sparkles, Zap, Code } from 'lucide-react';
import Container from './ui/Container';
import Button from './ui/Button';
import { fadeInUp, staggerContainer, viewportConfig } from '@/lib/animations';

interface PricingTier {
  name: string;
  icon: typeof Sparkles;
  monthlyPrice: string;
  yearlyPrice: string;
  yearlySavings?: string;
  period: string;
  description: string;
  highlighted: boolean;
  cta: string;
  badge?: string;
  limits: string[];
  features: string[];
  excluded: string[];
  note?: string;
}

const pricingTiers: PricingTier[] = [
  {
    name: 'Free',
    icon: Sparkles,
    monthlyPrice: '$0',
    yearlyPrice: '$0',
    period: 'forever',
    description: 'Get started for free',
    highlighted: false,
    cta: 'Download Free',
    limits: [
      '50 actions / month',
      '3 custom actions',
      '500 character limit',
    ],
    features: [
      'Basic text transformations',
      'Keyboard shortcuts & context menu',
      '3 built-in actions',
      'Custom prompt editor (basic)',
    ],
    excluded: [
      'No prompt chaining',
      'No history search',
      'No multi-device sync',
    ],
  },
  {
    name: 'Pro',
    icon: Zap,
    monthlyPrice: '$9',
    yearlyPrice: '$79',
    yearlySavings: 'Save 27%',
    period: 'month',
    description: 'For power users',
    highlighted: true,
    cta: 'Start Pro Trial',
    limits: [
      '2,000 actions / month',
      'Unlimited custom actions',
      '2,000 character limit',
    ],
    features: [
      'Everything in Free',
      'Unlimited custom actions',
      'Prompt chaining',
      'Prompt templates with variables',
      'Action history & search',
      'Multi-device sync',
      'Priority support',
    ],
    excluded: [],
  },
  {
    name: 'Developer',
    icon: Code,
    monthlyPrice: '$5',
    yearlyPrice: '$49',
    yearlySavings: 'Save 18%',
    period: 'month',
    description: 'Bring Your Own Key',
    highlighted: false,
    cta: 'Get Started',
    badge: 'BYOK',
    limits: [
      'Unlimited actions',
      'Choose your AI model',
      'You pay model costs directly',
    ],
    features: [
      'Choose provider (OpenAI, Anthropic, etc.)',
      'Select any model',
      'Local Keychain storage (keys never leave your Mac)',
      'All Pro features included',
      'Prompt chaining & templates',
      'Export/import action presets',
    ],
    excluded: [
      'No included AI credits (you use your own key)',
    ],
    note: 'Keys stored in macOS Keychain, not our servers',
  },
];

export default function Pricing() {
  const [isYearly, setIsYearly] = useState(false);

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
            className="text-3xl md:text-5xl font-bold mt-4 mb-4 font-[family-name:var(--font-serif)]"
          >
            Choose your plan
          </motion.h2>
          <motion.p
            variants={fadeInUp}
            className="text-lg text-[var(--color-muted)] max-w-2xl mx-auto"
          >
            Start free, upgrade as you grow. All plans include a 14-day money-back guarantee.
          </motion.p>

          {/* Yearly/Monthly Toggle */}
          <motion.div
            variants={fadeInUp}
            className="flex items-center justify-center gap-3 mt-8"
          >
            <span
              className={`text-sm font-medium transition-colors ${
                !isYearly ? 'text-[var(--color-foreground)]' : 'text-[var(--color-muted)]'
              }`}
            >
              Monthly
            </span>
            <button
              onClick={() => setIsYearly(!isYearly)}
              className={`relative w-12 h-6 rounded-full transition-colors ${
                isYearly ? 'bg-[var(--color-primary)]' : 'bg-gray-300'
              }`}
              aria-label="Toggle yearly pricing"
            >
              <motion.div
                className="absolute top-1 left-1 w-4 h-4 bg-white rounded-full"
                animate={{ x: isYearly ? 24 : 0 }}
                transition={{ type: 'spring', stiffness: 500, damping: 30 }}
              />
            </button>
            <span
              className={`text-sm font-medium transition-colors ${
                isYearly ? 'text-[var(--color-foreground)]' : 'text-[var(--color-muted)]'
              }`}
            >
              Yearly
            </span>
          </motion.div>
        </motion.div>

        <motion.div
          className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8 max-w-5xl mx-auto"
          variants={staggerContainer}
          initial="hidden"
          whileInView="visible"
          viewport={viewportConfig}
        >
          {pricingTiers.map((tier) => {
            const Icon = tier.icon;
            const displayPrice = isYearly ? tier.yearlyPrice : tier.monthlyPrice;
            const displayPeriod = tier.period === 'forever'
              ? 'forever'
              : isYearly
                ? 'year'
                : 'month';

            return (
              <motion.div
                key={tier.name}
                variants={fadeInUp}
                className={`relative bg-white rounded-2xl p-6 border-2 transition-all hover:shadow-lg ${
                  tier.highlighted
                    ? 'border-[var(--color-primary)] shadow-xl md:scale-105'
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
                    <AnimatePresence mode="wait">
                      <motion.span
                        key={displayPrice}
                        initial={{ opacity: 0, y: -10 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: 10 }}
                        transition={{ duration: 0.2 }}
                        className="text-3xl font-bold font-[family-name:var(--font-mono)]"
                      >
                        {displayPrice}
                      </motion.span>
                    </AnimatePresence>
                    {displayPeriod !== 'forever' && (
                      <span className="text-sm text-[var(--color-muted)]">
                        /{displayPeriod}
                      </span>
                    )}
                  </div>
                  {isYearly && tier.yearlySavings && (
                    <motion.span
                      initial={{ opacity: 0, scale: 0.8 }}
                      animate={{ opacity: 1, scale: 1 }}
                      className="inline-block mt-2 px-2 py-0.5 bg-green-100 text-green-700 text-xs font-semibold rounded-full"
                    >
                      {tier.yearlySavings}
                    </motion.span>
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
                        <span className="text-[var(--color-muted)] mt-0.5">&bull;</span>
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
            Questions?{' '}
            <a href="mailto:hello@shortkey.app" className="text-[var(--color-primary)] font-medium hover:underline">
              Contact us
            </a>
            .
          </p>
        </motion.div>
      </Container>
    </section>
  );
}
