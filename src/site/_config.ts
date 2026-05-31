// Lume Configuration - https://lume.land/docs/configuration/config-file/

import { load } from "@std/dotenv";
import lume from "lume/mod.ts";
import date from "lume/plugins/date.ts";
import nunjucks from "lume/plugins/nunjucks.ts";
import robots from "lume/plugins/robots.ts";
import redirects from "lume/plugins/redirects.ts";
import sitemap from "lume/plugins/sitemap.ts";
import feed from "lume/plugins/feed.ts";

// Load variables from the ENV file

await load({
  envPath: ".site.env",
  export: true,
});

const buildDir = Deno.env.get("SITE_BUILD_DIR");
const publicDir = Deno.env.get("SITE_PUBLIC_DIR");

// Build the site using Lume

const site = lume({
  src: buildDir ?? "build",
  dest: publicDir ?? "public",
  prettyUrls: true,
  emptyDest: true,
});

// Load site config values from ".env"

site.data("SITE_FEED_TITLE", Deno.env.get("SITE_FEED_TITLE"));
site.data("SITE_FEED_DESC", Deno.env.get("SITE_FEED_DESC"));
site.data("SITE_FEED_DEFAULT_TITLE", Deno.env.get("SITE_FEED_DEFAULT_TITLE"));
site.data("SITE_LANG", Deno.env.get("SITE_LANG"));
site.data("SITE_AUTHOR", Deno.env.get("SITE_AUTHOR"));
site.data("SITE_URL", Deno.env.get("SITE_URL"));

// Enable plugins

site.use(nunjucks());
site.use(date());
site.use(redirects());

// Generate a JSON feed of recent posts

site.use(feed({
  output: ["/posts.json"],
  query: "Post",
  sort: "date=desc",
  limit: 100,
  info: {
    title: Deno.env.get("SITE_FEED_TITLE"),
    description: Deno.env.get("SITE_FEED_DESC"),
    published: new Date(),
    self: "/posts.json",
    lang: Deno.env.get("SITE_LANG"),
    generator: false,
    authorName: Deno.env.get("SITE_AUTHOR"),
    authorUrl: Deno.env.get("SITE_URL"),
  },
  items: {
    title: "=title",
    description: "=excerpt",
    published: "=date",
    updated: undefined,
    content: "=children",
    lang: Deno.env.get("SITE_LANG"),
    image: "=cover",
    authorName: Deno.env.get("SITE_AUTHOR"),
    authorUrl: Deno.env.get("SITE_URL"),
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
