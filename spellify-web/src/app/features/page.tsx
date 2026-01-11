'use client';

import Header from '@/components/Header';
import Footer from '@/components/Footer';
import Features from '@/components/Features';

export default function FeaturesPage() {
  return (
    <>
      <Header />
      <main className="pt-24 md:pt-32">
        <Features />
      </main>
      <Footer />
    </>
  );
}
