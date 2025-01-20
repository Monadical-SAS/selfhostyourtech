'use client'

import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { CodeBlock } from '@/components/ui/code-block'

const dockerComposeCode = `# Self-Hosted Business Kit
# MIT License | https://github.com/yourusername/self-hosted-business-kit

version: '3.8'

services:

  # File Sharing
  nextcloud:
    image: nextcloud
    ports:
      - "8080:80"
    volumes:
      - nextcloud_data:/var/www/html
    environment:
      - MYSQL_HOST=nextcloud_db
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_PASSWORD=your_password_here
    depends_on:
      - nextcloud_db

  nextcloud_db:
    image: mariadb
    volumes:
      - nextcloud_db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=your_root_password_here
      - MYSQL_PASSWORD=your_password_here
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud

  # Communication
  zulip:
    image: zulip/docker-zulip:latest
    ports:
      - "80:80"
      - "443:443"
    environment:
      - SECRETS_email_password=your_email_password
      - SECRETS_postgres_password=your_postgres_password
      - SECRETS_rabbitmq_password=your_rabbitmq_password
      - SETTING_EXTERNAL_HOST=your_domain.com
    volumes:
      - zulip_data:/data

  # CRM
  suitecrm:
    image: bitnami/suitecrm:latest
    ports:
      - "8081:8080"
    environment:
      - SUITECRM_DATABASE_HOST=suitecrm_db
      - SUITECRM_DATABASE_PORT_NUMBER=3306
      - SUITECRM_DATABASE_NAME=suitecrm
      - SUITECRM_DATABASE_USER=suitecrm
      - SUITECRM_DATABASE_PASSWORD=your_password_here
    volumes:
      - suitecrm_data:/bitnami/suitecrm
    depends_on:
      - suitecrm_db

  suitecrm_db:
    image: mariadb:10.5
    environment:
      - MYSQL_ROOT_PASSWORD=your_root_password_here
      - MYSQL_DATABASE=suitecrm
      - MYSQL_USER=suitecrm
      - MYSQL_PASSWORD=your_password_here
    volumes:
      - suitecrm_db:/var/lib/mysql

  # Project Management
  redmine:
    image: redmine
    ports:
      - "8082:3000"
    environment:
      - REDMINE_DB_MYSQL=redmine_db
      - REDMINE_DB_PASSWORD=your_password_here
    volumes:
      - redmine_data:/usr/src/redmine/files
    depends_on:
      - redmine_db

  redmine_db:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=your_root_password_here
      - MYSQL_DATABASE=redmine
    volumes:
      - redmine_db:/var/lib/mysql

  # Development Tools
  gitlab:
    image: gitlab/gitlab-ce:latest
    ports:
      - "8083:80"
      - "8443:443"
      - "8022:22"
    volumes:
      - gitlab_config:/etc/gitlab
      - gitlab_logs:/var/log/gitlab
      - gitlab_data:/var/opt/gitlab

  # Office Suite
  collabora:
    image: collabora/code
    ports:
      - "9980:9980"
    environment:
      - domain=your_nextcloud_domain
    cap_add:
      - MKNOD

  # Publishing
  wordpress:
    image: wordpress:latest
    ports:
      - "8084:80"
    environment:
      - WORDPRESS_DB_HOST=wordpress_db
      - WORDPRESS_DB_USER=wordpress
      - WORDPRESS_DB_PASSWORD=your_password_here
      - WORDPRESS_DB_NAME=wordpress
    volumes:
      - wordpress_data:/var/www/html
    depends_on:
      - wordpress_db

  wordpress_db:
    image: mysql:5.7
    volumes:
      - wordpress_db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=your_root_password_here
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - MYSQL_PASSWORD=your_password_here

volumes:
  nextcloud_data:
  nextcloud_db:
  zulip_data:
  suitecrm_data:
  suitecrm_db:
  redmine_data:
  redmine_db:
  gitlab_config:
  gitlab_logs:
  gitlab_data:
  wordpress_data:
  wordpress_db:`

export default function CallToAction() {
  return (
    <section className="py-20 bg-gradient-to-b from-gray-900 to-purple-600/20 min-h-[600px] flex items-center backdrop-blur-sm">
      <div className="container mx-auto px-4">
        <h2 className="text-4xl font-bold mb-12 text-center">Ready to Take Control?</h2>
        <div className="grid md:grid-cols-2 gap-8">
          <Card className="bg-gray-800/50 backdrop-blur-sm border-gray-700">
            <CardHeader>
              <CardTitle>Run this kit yourself</CardTitle>
              <CardDescription>Quick start with our Docker Compose setup</CardDescription>
            </CardHeader>
            <CardContent className="max-h-[600px] overflow-y-auto">
              <CodeBlock code={dockerComposeCode} language="yaml" />
              <Button className="mt-4 w-full">View on GitHub</Button>
            </CardContent>
          </Card>
          <Card className="bg-gray-800/50 backdrop-blur-sm border-gray-700">
            <CardHeader>
              <CardTitle>Let us handle it for you</CardTitle>
              <CardDescription>Professional setup and management</CardDescription>
            </CardHeader>
            <CardContent>
              <p className="mb-4 text-gray-300">We'll set up and run this kit for you on your preferred hosting provider and integrate it with your existing systems.</p>
              <Button className="w-full">Get in Touch</Button>
            </CardContent>
          </Card>
        </div>
        <div className="mt-12 text-center">
          <p className="text-xl mb-4">Or join our community</p>
          <Button variant="outline" className="text-gray-800">Join us on Zulip</Button>
        </div>
      </div>
    </section>
  )
}

