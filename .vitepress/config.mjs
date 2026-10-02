import { defineConfig } from 'vitepress'

export default defineConfig({
  srcExclude: ['**/README.md'],
  title: 'pUNC Documentation',
  description: 'Polytoria Unified Naming Convention',
  base: process.env.BASE_PATH || '/',
  cleanUrls: true,
  sitemap: {
    hostname: 'https://punc.bjarnos.dev/'
  },
  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: '/pUNC.svg' }]
  ],
  themeConfig: {
    logo: '/pUNC.svg',
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Modules', link: '/docs/system' },
      { text: 'About us', link: 'https://github.com/PolyQuaternion' }
    ],
    sidebar: [
      {
        text: 'Overview',
        items: [
          { text: 'Introduction', link: '/' }
        ]
      },
      {
        text: 'API',
        items: [
          { text: 'System', link: '/docs/system' },
          { text: 'Environment', link: '/docs/environment' },
          { text: 'Metatable', link: '/docs/metatable' },
          { text: 'Closures', link: '/docs/closures' },
          { text: 'Debug', link: '/docs/debug' },
          { text: 'Filesystem', link: '/docs/filesystem' },
          { text: 'Scripts', link: '/docs/scripts' },
          { text: 'Instances', link: '/docs/instances' },
          { text: 'Signals', link: '/docs/signals' },
          { text: 'Input', link: '/docs/input' },
          { text: 'Cryptography', link: '/docs/cryptography' },
          { text: 'Encoding', link: '/docs/encoding' },
          { text: 'HTTP Networking', link: '/docs/http' }
        ]
      }
    ],
    search: {
      provider: 'local'
    },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/PolyQuaternion/pUNC' }
    ],
    outline: {
      level: [2, 3],
      label: 'On this page'
    },
    footer: {
      message: 'Polytoria Unified Naming Convention (pUNC).',
      copyright: 'Copyright © 2026 Quaternion team'
    }
  }
})
