import Header from '@/components/Header';
import Hero from '@/components/Hero';
import HowItWorks from '@/components/HowItWorks';
import UseCasesMarquee from '@/components/UseCasesMarquee';
import Features from '@/components/Features';
import SpeedComparison from '@/components/SpeedComparison';
import DemoVideo from '@/components/DemoVideo';
import Testimonials from '@/components/Testimonials';
import Pricing from '@/components/Pricing';
import Footer from '@/components/Footer';

export default function Home() {
  return (
    <>
      <Header />
      <main>
        <Hero />
        <UseCasesMarquee />
        <HowItWorks />
        <Features />
        <SpeedComparison />
        <DemoVideo />
        <Testimonials />
        <Pricing />
      </main>
      <Footer />
    </>
  );
}
