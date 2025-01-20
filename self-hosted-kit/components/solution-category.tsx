import Image from 'next/image'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'

interface SolutionCategoryProps {
  title: string
  description: string
  mainSolution: {
    name: string
    description: string
    icon: string
  }
  alternatives: string[]
  color: string
}

export default function SolutionCategory({
  title,
  description,
  mainSolution,
  alternatives,
  color
}: SolutionCategoryProps) {
  return (
    <section className={`py-20 ${color}`}>
      <div className="container mx-auto px-4">
        <h2 className="text-3xl font-bold mb-2">{title}</h2>
        <p className="text-xl mb-8 text-gray-300">{description}</p>
        <div className="grid md:grid-cols-2 gap-8">
          <Card className="bg-black/50 backdrop-blur-sm border-gray-800">
            <CardHeader>
              <div className="flex items-center space-x-4">
                <Image src={mainSolution.icon || "/placeholder.svg"} alt={mainSolution.name} width={48} height={48} />
                <CardTitle>{mainSolution.name}</CardTitle>
              </div>
            </CardHeader>
            <CardContent>
              <CardDescription>{mainSolution.description}</CardDescription>
            </CardContent>
          </Card>
          <div className="bg-black/30 backdrop-blur-sm rounded-lg p-6 border border-gray-800">
            <h3 className="text-xl font-semibold mb-4">Alternatives</h3>
            <div className="flex flex-wrap gap-2">
              {alternatives.map((alt) => (
                <Badge key={alt} variant="secondary" className="text-sm">
                  {alt}
                </Badge>
              ))}
            </div>
          </div>
        </div>
        <div className="mt-8">
          <Image
            src="/placeholder.svg"
            alt={`${mainSolution.name} screenshot`}
            width={1200}
            height={600}
            className="rounded-lg shadow-lg"
          />
        </div>
      </div>
    </section>
  )
}
