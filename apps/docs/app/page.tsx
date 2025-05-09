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
        icon: "/icons/nextcloud.svg"
      },
      {
        name: "Seafile",
        description: "A high-performance file sync and share solution with a focus on reliability and speed. It offers features like file encryption, version control, and selective sync, making it ideal for businesses with large amounts of data.",
        icon: "/icons/seafile.svg"
      },
      {
        name: "ownCloud",
        description: "An open-source file sync and share software that provides a safe, secure, and compliant file synchronization and sharing solution. ownCloud can be extended with apps for calendars, contacts, task management, and more.",
        icon: "/icons/owncloud.svg"
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
        icon: "/icons/zulip.svg"
      },
      {
        name: "Mattermost",
        description: "A flexible, open-source messaging platform that's secure and scalable. Mattermost offers features like persistent chat, file sharing, and integrations with DevOps tools. It's highly customizable and can be self-hosted for complete data control.",
        icon: "/icons/mattermost.svg"
      },
      {
        name: "Rocket.Chat",
        description: "A customizable open-source chat solution that provides team chat, video conferencing, file sharing, and live chat widgets for websites. Rocket.Chat offers end-to-end encryption and can be extended with a marketplace of apps and integrations.",
        icon: "/icons/rocketchat.svg"
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
        icon: "/icons/twenty.svg"
      },
      {
        name: "SuiteCRM",
        description: "An award-winning open-source CRM with a comprehensive set of features including sales, marketing, and customer support modules. SuiteCRM is highly customizable and scalable, making it suitable for businesses of all sizes.",
        icon: "/icons/suitecrm.svg"
      },
      {
        name: "EspoCRM",
        description: "A lightweight, responsive CRM solution that focuses on simplicity and user experience. EspoCRM offers features like sales automation, email marketing, and project management. It's easily customizable with its extension framework.",
        icon: "/icons/espocrm.svg"
      },
    ],
    color: "from-green-400/20 to-green-600/20",
  },
  {
    title: "Project Management",
    description: "Tools for organizing and tracking projects",
    apps: [
      {
        name: "Redmine",
        description: "A flexible project management web application written using Ruby on Rails. Redmine includes features like multiple project support, role-based access control, Gantt chart and calendar, time tracking, and integrations with various version control systems.",
        icon: "/icons/redmine.svg"
      },
      {
        name: "OpenProject",
        description: "An open-source project collaboration software that offers classic, agile, and hybrid project management. OpenProject includes features like Gantt charts, kanban boards, team planner, time and cost reporting, and a built-in wiki for documentation.",
        icon: "/icons/openproject.svg"
      },
      {
        name: "Taiga",
        description: "An open-source agile project management tool that supports Scrum, Kanban, and other agile methodologies. Taiga offers a clean, intuitive interface with features like backlog management, sprint planning, task boards, and team wiki.",
        icon: "/icons/taiga.svg"
      },
    ],
    color: "from-red-400/20 to-red-600/20",
  },
  {
    title: "Development Tools",
    description: "Version control and CI/CD solutions",
    apps: [
      {
        name: "GitLab",
        description: "A complete DevOps platform that provides source code management, CI/CD, security, and more. GitLab offers a unified interface for the entire software development lifecycle, from planning to monitoring. It includes features like built-in container registry, package registry, and Kubernetes integration.",
        icon: "/icons/gitlab.svg"
      },
      {
        name: "Gitea",
        description: "A lightweight, self-hosted Git service written in Go. Gitea is designed to be easy to install and run, even on low-powered systems. It offers features like repository management, issue tracking, pull requests, and webhooks, making it a great choice for small to medium-sized teams.",
        icon: "/icons/gitea.svg"
      },
      {
        name: "Jenkins",
        description: "An open-source automation server that enables developers to build, test, and deploy their software. Jenkins offers a wide range of plugins to support building, deploying, and automating any project. It supports distributed builds and can be extended to fit complex workflows.",
        icon: "/icons/jenkins.svg"
      },
    ],
    color: "from-indigo-400/20 to-indigo-600/20",
  },
  {
    title: "Office",
    description: "Collaborative document editing and note-taking",
    apps: [
      {
        name: "Collabora Online",
        description: "A powerful online office suite that provides collaborative editing of text documents, spreadsheets, and presentations. It integrates well with file sharing platforms like Nextcloud and offers a familiar interface similar to traditional desktop office suites.",
        icon: "/icons/collabora.svg"
      },
      {
        name: "ONLYOFFICE",
        description: "A comprehensive office suite that includes editors for text documents, spreadsheets, and presentations. ONLYOFFICE offers high compatibility with Microsoft Office formats and provides real-time collaboration features.",
        icon: "/icons/onlyoffice.svg"
      },
      {
        name: "HedgeDoc",
        description: "A real-time collaborative markdown editor that allows multiple users to work on documents simultaneously. It supports various markdown extensions and can be used for note-taking, documentation, and more.",
        icon: "/icons/hedgedoc.svg"
      },
    ],
    color: "from-yellow-400/20 to-yellow-600/20",
  },
  {
    title: "Publishing",
    description: "Content management systems and static site generators",
    apps: [
      {
        name: "WordPress",
        description: "The world's most popular content management system, powering a large percentage of websites. WordPress offers a user-friendly interface, extensive plugin ecosystem, and is highly customizable for various types of websites and blogs.",
        icon: "/icons/wordpress.svg"
      },
      {
        name: "Hugo",
        description: "A fast and flexible static site generator written in Go. Hugo is known for its speed in building sites and offers a wide range of themes and customization options. It's great for blogs, documentation sites, and more.",
        icon: "/icons/hugo.svg"
      },
      {
        name: "Django CMS",
        description: "A content management system built on top of the Django web framework. It offers a powerful and flexible solution for creating complex websites with custom functionality. Django CMS is particularly well-suited for sites that require custom development alongside content management.",
        icon: "/icons/django-cms.svg"
      },
    ],
    color: "from-pink-400/20 to-pink-600/20",
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
        <CallToAction />
      </main>
      <Footer />
    </div>
  )
}

