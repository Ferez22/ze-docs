import React from "react";
import { DocsThemeConfig } from "nextra-theme-docs";

const config: DocsThemeConfig = {
  logo: <b>ze-docs</b>,
  project: {
    link: "https://github.com/Ferez22",
  },
  chat: {
    link: "https://discord.gg/P5XxPwX8",
  },
  docsRepositoryBase: "https://github.com/shuding/nextra-docs-template",
  footer: {
    text: "ze-docs - by fares",
  },
  head: (
    <>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <meta property="og:title" content="ze-docs" />
      <meta
        property="og:description"
        content="Documentation for ze-company projects"
      />
    </>
  ),
  useNextSeoProps() {
    return {
      titleTemplate: "%s – ze-docs",
      defaultTitle: "ze-docs",
    };
  },
};

export default config;
