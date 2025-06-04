/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  // This ensures Next.js works behind a proxy
  experimental: {
    serverActions: {
      allowedOrigins: process.env.ALLOWED_ORIGINS ? 
        process.env.ALLOWED_ORIGINS.split(',') : 
        ['selfhostyour.tech', 'www.selfhostyour.tech'],
    },
  },
};

export default nextConfig;
