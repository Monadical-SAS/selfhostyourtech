'use client'

import { Github } from 'lucide-react'
import Link from 'next/link'
import { Button } from '@/components/ui/button'

export default function Header() {
  return (
    <header className="bg-black/50 backdrop-blur-sm fixed top-0 left-0 right-0 z-50 border-b border-gray-800">
      <div className="container mx-auto px-4 py-3 flex justify-between items-center">
        <Link href="/" className="text-xl font-bold text-white hover:text-gray-300 transition-colors">
          SelfHosted<span className="text-purple-500">Kit</span>
        </Link>
        <nav>
          <ul className="flex space-x-4">
            <li>
              <Link href="https://github.com/yourusername/self-hosted-kit" className="text-gray-300 hover:text-white transition-colors flex items-center">
                <Github className="mr-2" size={20} />
                GitHub
              </Link>
            </li>
          </ul>
        </nav>
      </div>
    </header>
  )
}
