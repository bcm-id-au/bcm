// Frontmatter of Post Markdown files
export type YamlData = {
  tags?: string[];
  url?: string;
  draft?: boolean;
  renderOrder?: number;
  content?: unknown;
  layout?: string;
  templateEngine?: string | string[];
  [index: string]: unknown;
};

// JSON Feed - Feed details
export type JsonFeedData = {
  version: string;
  title: string;
  home_page_url?: string;
  feed_url?: string;
  description?: string;
  author?: JsonFeedAuthor;
  language?: string;
  items: JsonFeedItem[];
};

// JSON Feed - Author details
export type JsonFeedAuthor = {
  name: string;
  url: string;
};

// JSON Feed - Feed item details
export type JsonFeedItem = {
  id: string;
  url: string;
  title: string;
  date_published: string;
  content_text: string;
};
