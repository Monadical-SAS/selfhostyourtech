import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'

export default function NewsletterSignup() {
  return (
    <section className="py-20 bg-purple-900">
      <div className="container mx-auto px-4 text-center">
        <h2 className="text-3xl font-bold mb-4">Stay Updated</h2>
        <p className="mb-8 text-xl">Get the latest news and updates about our self-hosted solutions.</p>
        <form className="flex flex-col sm:flex-row gap-4 max-w-md mx-auto">
          <Input type="email" placeholder="Enter your email" className="flex-grow" />
          <Button type="submit">Subscribe</Button>
        </form>
      </div>
    </section>
  )
}
