'use client';

import { motion } from 'framer-motion';
import { Calendar, Clock, ArrowRight } from 'lucide-react';
import Container from '@/components/ui/Container';
import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { fadeInUp, staggerContainer, viewportConfig } from '@/lib/animations';

const blogPosts = [
  {
    slug: 'introducing-shortkey',
    title: 'Introducing Shortkey: AI Shortcuts for Your Mac',
    excerpt: 'Learn how Shortkey can transform your text workflow with powerful AI shortcuts, right where you work.',
    date: '2024-01-15',
    readTime: '5 min read',
    category: 'Product',
  },
  {
    slug: 'productivity-tips',
    title: '10 Productivity Tips Using Shortkey',
    excerpt: 'Discover advanced workflows and shortcuts to maximize your productivity with Shortkey.',
    date: '2024-01-10',
    readTime: '7 min read',
    category: 'Tips',
  },
  {
    slug: 'ai-writing-assistant',
    title: 'Why Every Mac User Needs an AI Writing Assistant',
    excerpt: 'Explore how AI-powered text transformation can save hours of work every week.',
    date: '2024-01-05',
    readTime: '6 min read',
    category: 'AI',
  },
];

export default function BlogPage() {
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
              Shortkey Blog
            </motion.h1>
            <motion.p
              variants={fadeInUp}
              className="text-lg text-[var(--color-muted)] max-w-2xl mx-auto"
            >
              Tips, updates, and insights on productivity, AI, and making the most of Shortkey.
            </motion.p>
          </motion.div>

          <motion.div
            variants={staggerContainer}
            initial="hidden"
            whileInView="visible"
            viewport={viewportConfig}
            className="grid gap-8"
          >
            {blogPosts.map((post) => (
              <motion.article
                key={post.slug}
                variants={fadeInUp}
                className="bg-white rounded-2xl border border-[var(--color-border)] p-8 hover:border-[var(--color-primary)] transition-all hover:shadow-lg group"
              >
                <div className="flex items-center gap-4 mb-4">
                  <span className="px-3 py-1 bg-[var(--color-accent)] text-[var(--color-primary)] text-sm font-semibold rounded-full">
                    {post.category}
                  </span>
                  <div className="flex items-center gap-4 text-sm text-[var(--color-muted)]">
                    <span className="flex items-center gap-1">
                      <Calendar className="w-4 h-4" />
                      {new Date(post.date).toLocaleDateString('en-US', {
                        month: 'short',
                        day: 'numeric',
                        year: 'numeric',
                      })}
                    </span>
                    <span className="flex items-center gap-1">
                      <Clock className="w-4 h-4" />
                      {post.readTime}
                    </span>
                  </div>
                </div>
                <h2 className="text-2xl font-bold mb-3 group-hover:text-[var(--color-primary)] transition-colors">
                  {post.title}
                </h2>
                <p className="text-[var(--color-muted)] mb-4">{post.excerpt}</p>
                <a
                  href={`/blog/${post.slug}`}
                  className="inline-flex items-center gap-2 text-[var(--color-primary)] font-semibold hover:gap-3 transition-all"
                >
                  Read More
                  <ArrowRight className="w-4 h-4" />
                </a>
              </motion.article>
            ))}
          </motion.div>

          <motion.div
            variants={fadeInUp}
            initial="hidden"
            whileInView="visible"
            viewport={viewportConfig}
            className="mt-12 text-center p-8 bg-[var(--color-accent)] rounded-xl"
          >
            <p className="text-[var(--color-muted)]">
              More articles coming soon. Stay tuned!
            </p>
          </motion.div>
        </Container>
      </main>
      <Footer />
    </>
  );
}
