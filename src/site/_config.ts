// Lume Configuration - https://lume.land/docs/configuration/config-file/

import lume from "lume/mod.ts";
import date from "lume/plugins/date.ts";
import nunjucks from "lume/plugins/nunjucks.ts";
import robots from "lume/plugins/robots.ts";
import redirects from "lume/plugins/redirects.ts";
import sitemap from "lume/plugins/sitemap.ts";

// Build the site using Lume

const buildDir = Deno.env.get("BUILD_DIR");
const publicDir = Deno.env.get("PUBLIC_DIR");

const site = lume({
  src: buildDir ?? "build",
  dest: publicDir ?? "public",
  prettyUrls: true,
  emptyDest: true,
});

// Load site config values from ".env"

site.data("BLOG_POSTS_DIR", Deno.env.get("BLOG_POSTS_DIR"));
site.data("BLOG_POSTS_URL", Deno.env.get("BLOG_POSTS_URL"));
site.data("JSON_FEED_TITLE", Deno.env.get("JSON_FEED_TITLE"));
site.data("JSON_FEED_DESCRIPTION", Deno.env.get("JSON_FEED_DESCRIPTION"));
site.data("JSON_FEED_DEFAULT_TITLE", Deno.env.get("JSON_FEED_DEFAULT_TITLE"));
site.data("SITE_LANG", Deno.env.get("SITE_LANG"));
site.data("SITE_AUTHOR", Deno.env.get("SITE_AUTHOR"));
site.data("SITE_URL", Deno.env.get("SITE_URL"));
site.data("JSON_FEED_FILE", Deno.env.get("JSON_FEED_FILE"));
site.data("JSON_FEED_URL", Deno.env.get("JSON_FEED_URL"));

// Enable plugins

site.use(nunjucks());
site.use(date());
site.use(redirects());

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
