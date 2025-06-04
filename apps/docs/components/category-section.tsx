'use client'

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import Image from 'next/image'
import { useState } from 'react'

interface App {
  name: string
  description: string
  icon: string
}

interface CategorySectionProps {
  title: string
  description: string
  apps: App[]
  color: string
}

export default function CategorySection({ title, description, apps, color }: CategorySectionProps) {
  const [expandedApp, setExpandedApp] = useState<string | null>(null)

  return (
    <section className={`py-20 bg-gradient-to-b ${color} min-h-[600px] flex items-center backdrop-blur-sm`}>
      <div className="container mx-auto px-4">
        <h2 className="text-3xl font-bold mb-2">{title}</h2>
        <p className="text-xl mb-8 text-gray-300">{description}</p>
        <div className="grid md:grid-cols-3 gap-8">
          {apps.map((app, index) => (
            <Card key={index} className="bg-gray-800/50 backdrop-blur-sm border-gray-700">
              <CardHeader>
                <div className="flex items-center space-x-4">
                  <CardTitle>{app.name}</CardTitle>
                </div>
              </CardHeader>
              <CardContent>
                <CardDescription>
                  {expandedApp === app.name ? app.description : `${app.description.slice(0, 100)}...`}
                </CardDescription>
                <Button
                  variant="link"
                  onClick={() => setExpandedApp(expandedApp === app.name ? null : app.name)}
                  className="mt-2 p-0 h-auto font-normal text-blue-400 hover:text-blue-300"
                >
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  )
}
