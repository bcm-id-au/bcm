// Lume Configuration - https://lume.land/docs/configuration/config-file/

import { Site } from "$be/site.class.ts";

import lume from "lume/mod.ts";
import date from "lume/plugins/date.ts";
import feed from "lume/plugins/feed.ts";
import nunjucks from "lume/plugins/nunjucks.ts";
import robots from "lume/plugins/robots.ts";
import redirects from "lume/plugins/redirects.ts";
import sitemap from "lume/plugins/sitemap.ts";

import codeHighlight from "lume/plugins/code_highlight.ts";
import langJavaScript from "highlight/lib/languages/javascript";
import langBash from "highlight/lib/languages/bash";
import langPhp from "highlight/lib/languages/php";
import langTypeScript from "highlight/lib/languages/typescript";

// Load Env Vars with suitable defaults

const bcm = new Site("./.site.env");

const buildDir: string = bcm.envVar("SITE_BUILD_DIR", "build");
const publicDir: string = bcm.envVar("SITE_PUBLIC_DIR", "public");
const siteUrl: string = bcm.envVar("SITE_URL", "http://localhost");

// Build the site using Lume

const site = lume({
  src: `./${buildDir}`,
  dest: `./${publicDir}`,
  location: new URL(siteUrl),
  prettyUrls: true,
  emptyDest: true,
});

// Load environment variables

const siteFeedTitle: string = bcm.envVar("SITE_FEED_TITLE");
const siteFeedDesc: string = bcm.envVar("SITE_FEED_DESC");
const siteFeedDefaultTitle: string = bcm.envVar("SITE_FEED_DEFAULT_TITLE");
const siteLang: string = bcm.envVar("SITE_LANG", "en-GB");
const siteAuthor: string = bcm.envVar("SITE_AUTHOR");
const sitePosthogId: string = bcm.envVar("SITE_POSTHOG_ID");
const sitePosthogApiHost: string = bcm.envVar("SITE_POSTHOG_API_HOST");
const sitePosthogUiHost: string = bcm.envVar("SITE_POSTHOG_UI_HOST");

// Save env vars as site data variables so templates can use them

site.data("SITE_FEED_TITLE", siteFeedTitle);
site.data("SITE_FEED_DESC", siteFeedDesc);
site.data("SITE_FEED_DEFAULT_TITLE", siteFeedDefaultTitle);
site.data("SITE_LANG", siteLang);
site.data("SITE_AUTHOR", siteAuthor);
site.data("SITE_URL", siteUrl);
site.data("SITE_POSTHOG_ID", sitePosthogId);
site.data("SITE_POSTHOG_API_HOST", sitePosthogApiHost);
site.data("SITE_POSTHOG_UI_HOST", sitePosthogUiHost);

// Enable plugins

site.use(nunjucks());
site.use(date());
site.use(redirects());

// Configure the Code Highlight plugin

site.use(
  codeHighlight({
    languages: {
      javascript: langJavaScript,
      bash: langBash,
      php: langPhp,
      typescript: langTypeScript,
    },
    theme: {
      name: "tomorrow-night-bright",
      cssFile: "/css/code-highlight.min.css",
    },
  }),
);

// Generate a JSON feed of recent posts

site.use(feed({
  output: ["/posts.json"],
  query: "Post",
  sort: "date=desc",
  limit: 100,
  info: {
    title: siteFeedTitle,
    description: siteFeedDesc,
    published: new Date(),
    self: "/posts.json",
    lang: siteLang,
    generator: false,
    authorName: siteAuthor,
    authorUrl: siteUrl,
  },
  items: {
    title: "=title",
    description: "=excerpt",
    published: "=date",
    updated: undefined,
    content: "=children",
    lang: siteLang,
    image: "=cover",
    authorName: siteAuthor,
    authorUrl: siteUrl,
  },
}));

// Generate a custom robots.txt

site.use(robots(
  {
    "disallow": [
      "Mediapartners-Google",
      "Adsbot-Google",
      "Amazonbot",
      "anthropic-ai",
      "Applebot",
      "Bytespider",
      "CCBot",
      "ChatGPT",
      "Claude-Web",
      "ClaudeBot",
      "Diffbot",
      "FacebookBot",
      "Google-Extended",
      "GPTBot",
      "Image2dataset",
      "ImagesiftBot",
      "Omgili",
      "Omgilibot",
      "PerplexityBot",
      "YouBot",
      "PerplexityBot",
      "YouBot",
    ],
  },
));

// Generate a sitemap
site.use(sitemap());

export default site;
