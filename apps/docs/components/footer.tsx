import Link from 'next/link'

export default function Footer() {
  return (
    <footer className="bg-black py-8 border-t border-gray-800">
      <div className="container mx-auto px-4">
        <div className="flex flex-col md:flex-row justify-between items-center">
          <p className="text-gray-400 mb-4 md:mb-0">
            © {new Date().getFullYear()} SelfHostYourTech. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  )
}

