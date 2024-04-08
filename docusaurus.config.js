// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

// const lightCodeTheme = require("prism-react-renderer/themes/github");
// const darkCodeTheme = require("prism-react-renderer/themes/dracula");
// const math = require("remark-math");
// const katex = require("rehype-katex");
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';
import {themes as prismThemes} from 'prism-react-renderer';

/** @type {import('@docusaurus/types').Config} */
const config = {
  // ... Your other configurations.
  title: "PWmat",
  tagline: "Dinosaurs are cool",
  favicon: "img/favicon.jpg",

  // Set the production url of your site here
  url: "http://doc.lonxun.com/",
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: "/",

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: "LonxunQuantum", // Usually your GitHub org/user name.
  projectName: "PWmat-docs", // Usually your repo name.
  trailingSlash: true,

  // onBrokenLinks: "throw",
  // onBrokenMarkdownLinks: "warn",

  // Even if you don't use internalization, you can use this field to set useful
  // metadata like html lang. For example, if your site is Chinese, you may want
  // to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: "zh-Hans",
    locales: ["zh-Hans", "en"],
    path: "i18n",
    // localeConfigs: {
    //   "zh-Hans": {
    //     label: "中文（中国）",
    //     direction: "ltr",
    //     htmlLang: "zh-Hans",
    //     // calendar: "gregory",
    //     path: "zh-Hans",
    //   },
    //   "en": {
    //     label: "English",
    //     direction: "ltr",
    //     htmlLang: "en-US",
    //     // calendar: "gregory",
    //     path: "en",
    //   },
    // },
  },

  presets: [
    [
      "classic",
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          // lastVersion: "current",
          // versions: {
          //   current: {
          //     label: "next",
          //     path: "1.0",
          //   },
          //   1.0: {
          //     label: "1.0",
          //     path: "1.0",
          //   },
          // },
          remarkPlugins: [remarkMath],
          rehypePlugins: [rehypeKatex],
          routeBasePath: "/", // 把文档放在网站根部
          sidebarPath: require.resolve("./sidebars.js"),
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          // editUrl:
          //   "https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/",
        },
        blog: false,
        // blog: {
        //   showReadingTime: true,
        //   // Please change this to your repo.
        //   // Remove this to remove the "edit this page" links.
        //   editUrl:
        //     "https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/",
        // },
        theme: {
          customCss: require.resolve("./src/css/custom.css"),
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      // Replace with your project's social card
      image: "img/docusaurus-social-card.jpg",
      docs: {
        sidebar: {
          hideable: true,
        },
      },
      navbar: {
        // title: "PWmat Manual",
        hideOnScroll: true,
        logo: {
          alt: "PWmat Logo",
          src: "img/lonxun-logo.png",
        },
        items: [
          {
            type: "doc",
            docId: "intro",
            position: "left",
            label: "PWmat产品手册",
          },
          // { to: "/blog", label: "Blog", position: "left" },
          {
            href: "http://www.pwmat.com/",
            label: "PWmat官网",
            position: "right",
          },
          {
            type: "localeDropdown",
            position: "right",
          },
          {
            type: "docsVersionDropdown",
            position: "left",
            dropdownItemsBefore: [],
            // dropdownItemsAfter: [{to: '/versions', label: 'All versions'}],
            dropdownActiveClassDisabled: true,
          }
        ],
      },
      footer: {
        style: "dark",
        links: [
          {
            title: "Docs",
            items: [
              {
                label: "Tutorial",
                to: "/",
              },
            ],
          },
          {
            title: "相关",
            items: [
              {
                label: "论坛",
                href: "http://bbs.pwmat.com/",
              },
              {
                label: "Module",
                href: "http://www.pwmat.com/module-download",
              },
              {
                label: "MCloud手册",
                href: "http://mcloud-doc.lonxun.com/",
              },
            ],
          },
          {
            title: "More",
            items: [
              // {
                //   label: "Blog",
                //   to: "/blog",
                // },
                {
                  label: "GitHub",
                  href: "https://github.com/LonxunQuantum",
                },
              ],
            },
          ],
          copyright: `Copyright © ${new Date().getFullYear()} 北京龙讯旷腾科技有限公司 All rights reserved.京ICP备15057729号. Built with Docusaurus.`,
        },
      prism: {
        theme: prismThemes.github,
        darkTheme: prismThemes.dracula,
      },
      mermaid: {
        theme: {light: 'default', dark: 'dark'},
      },
    }),
    stylesheets: [
    {
      href: "https://cdn.jsdelivr.net/npm/katex@0.13.24/dist/katex.min.css",
      type: "text/css",
      integrity:
        "sha384-odtC+0UGzzFL/6PNoE8rX/SPcQDXBJ+uRepguP4QkPCm2LBxH3FA3y+fKSiJ+AmM",
      crossorigin: "anonymous",
    },
  ],
  markdown: {
    mermaid: true,
  },
  themes: [
    // ... Your other themes.
    [
      require.resolve("@easyops-cn/docusaurus-search-local"),
      /** @type {import("@easyops-cn/docusaurus-search-local").PluginOptions} */
      {
        hashed: true,
        docsRouteBasePath: "/",
        language: ["en", "zh"]
      },
    ],
    "@docusaurus/theme-mermaid",
  ],
};

export default config;