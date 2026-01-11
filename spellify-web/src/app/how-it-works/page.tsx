'use client';

import Header from '@/components/Header';
import Footer from '@/components/Footer';
import HowItWorks from '@/components/HowItWorks';

export default function HowItWorksPage() {
  return (
    <>
      <Header />
      <main className="pt-24 md:pt-32">
        <HowItWorks />
      </main>
      <Footer />
    </>
  );
}
