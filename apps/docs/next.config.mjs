/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  // This ensures Next.js works behind a proxy
  experimental: {
    serverActions: {
      allowedOrigins: ['selfhostyour.tech', 'www.selfhostyour.tech'],
    },
  },
};

export default nextConfig;
