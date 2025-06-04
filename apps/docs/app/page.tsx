import Header from '@/components/header'
import Hero from '@/components/hero'
import CategorySection from '@/components/category-section'
import CallToAction from '@/components/call-to-action'
import Footer from '@/components/footer'

const categories = [
  {
    title: "File Sharing",
    description: "Secure and efficient file storage and sharing solutions",
    apps: [
      {
        name: "Nextcloud",
        description: "A versatile file hosting and collaboration platform that offers a wide range of features including file sync & share, real-time document editing, calendar, contacts, and more. It's highly customizable with hundreds of apps available.",
        icon: "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/nextcloud.png"
      },
    ],
    color: "from-blue-400/20 to-blue-600/20",
  },
  {
    title: "Communication",
    description: "Team chat and collaboration tools",
    apps: [
      {
        name: "Zulip",
        description: "An open-source team chat application with unique threaded conversations. Zulip's topic-based threading helps teams stay organized and productive, especially for asynchronous communication. It offers powerful search, integrations, and customizable notifications.",
        icon: "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/zulip.png"
      },
    ],
    color: "from-purple-400/20 to-purple-600/20",
  },
  {
    title: "CRM",
    description: "Customer Relationship Management systems",
    apps: [
      {
        name: "Twenty",
        description: "A modern, open-source CRM designed for flexibility and customization. Twenty offers a clean, intuitive interface for managing customer relationships, deals, and tasks. It's built with the latest technologies and can be easily extended to fit specific business needs.",
        icon: "https://kagi.com/proxy/YWJzOi8vZGlzdC9pY29ucy90d2VudHktY3JtXzIyMjY2Ni53ZWJw.png?c=ktUNJsvV_6Mi937H24fM6pFecXGUZJOyzSipagwBjW_MVZ3OzkQab6raJDd_jQcqgM1EscqgD-slkavCSN7gL78Wt9_7pwlu7WLwNDGWGIEEyiqu6GrMV4KG4uLwuTWGuZOITY8Ln8ze0HdRs4PAc1u2Ozls7smQSPpDe7UwpEWBwYnZMBAotWRmt5i0c9iYLLgQTaWwdtmbIEd6crmIWEwq4ZDJsk63YVSnzYJ1OPk%3D"
      },
    ],
    color: "from-green-400/20 to-green-600/20",
  },
  {
    title: "Office",
    description: "Collaborative document editing and note-taking",
    apps: [
      {
        name: "ONLYOFFICE",
        description: "A comprehensive office suite that includes editors for text documents, spreadsheets, and presentations. ONLYOFFICE offers high compatibility with Microsoft Office formats and provides real-time collaboration features.",
        icon: "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/onlyoffice.png"
      },
      {
        name: "HedgeDoc",
        description: "A real-time collaborative markdown editor that allows multiple users to work on documents simultaneously. It supports various markdown extensions and can be used for note-taking, documentation, and more.",
        icon: "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/hedgedoc.png"
      },
    ],
    color: "from-yellow-400/20 to-yellow-600/20",
  },
]

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-gray-900 text-gray-100">
      <Header />
      <main>
        <Hero />
        {categories.map((category, index) => (
          <CategorySection key={index} {...category} />
        ))}
      </main>
      <Footer />
    </div>
  )
}

