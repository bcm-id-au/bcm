// Lume Configuration - https://lume.land/docs/configuration/config-file/

import { load } from "@std/dotenv";

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

// Load variables from the Env Var file, or directly from
// the build terminal session if set there.

await load({
  envPath: ".site.env",
  export: true,
});

const buildDir: string = Deno.env.get("SITE_BUILD_DIR") || "build";
const publicDir: string = Deno.env.get("SITE_PUBLIC_DIR") || "public";
const siteUrl: string = Deno.env.get("SITE_URL") || "http://localhost";

// Build the site using Lume

const site = lume({
  src: `./${buildDir}`,
  dest: `./${publicDir}`,
  location: new URL(siteUrl),
  prettyUrls: true,
  emptyDest: true,
});

// Load environment variables

const siteFeedTitle: string = Deno.env.get("SITE_FEED_TITLE") || "";
const siteFeedDesc: string = Deno.env.get("SITE_FEED_DESC") || "";
const siteFeedDefaultTitle: string = Deno.env.get("SITE_FEED_DEFAULT_TITLE") || "";
const siteLang: string = Deno.env.get("SITE_LANG") || "en-GB";
const siteAuthor: string = Deno.env.get("SITE_AUTHOR") || "";

// Save env vars as site data variables so templates can use them

site.data("SITE_FEED_TITLE", siteFeedTitle);
site.data("SITE_FEED_DESC", siteFeedDesc);
site.data("SITE_FEED_DEFAULT_TITLE", siteFeedDefaultTitle);
site.data("SITE_LANG", siteLang);
site.data("SITE_AUTHOR", siteAuthor);
site.data("SITE_URL", siteUrl);

// Enable plugins

site.use(nunjucks());
site.use(date());
site.use(redirects());

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
