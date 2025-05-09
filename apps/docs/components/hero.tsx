'use client'

import { Button } from '@/components/ui/button'
import { ArrowDown } from 'lucide-react'

export default function Hero() {
  return (
    <section className="min-h-screen flex items-center justify-center bg-gradient-to-b from-purple-600/20 via-gray-900/50 to-gray-900 text-center backdrop-blur-sm">
      <div className="container mx-auto px-4">
        <h1 className="text-4xl md:text-6xl font-bold mb-6 leading-tight">
          Tired of Big Tech owning all your data?
          <span className="block mt-2 text-purple-400">
            Self-host your business today
          </span>
        </h1>
        <p className="text-xl md:text-2xl mb-8 text-gray-300 max-w-3xl mx-auto">
          Explore our hand-picked, battle-tested selection of open-source self-hosted apps that work cohesively together to get your business off the ground.
        </p>
        <Button size="lg" className="bg-purple-600 hover:bg-purple-700" onClick={() => window.scrollTo({ top: window.innerHeight, behavior: 'smooth' })}>
          Explore Solutions <ArrowDown className="ml-2" size={20} />
        </Button>
      </div>
    </section>
  )
}
