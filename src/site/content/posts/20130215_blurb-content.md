---
title: Blurb content
date: 2013-02-15
url: /posts/20130215_blurb-content/
oldUrl: /brendan/posts/20130215_blurb-content/
tags:
  - Post
  - PHP
---

Need to shorten some content so it fits in a small area? My _blurb_ function will shorten any content to the given number of characters.

```php
function blurb($content, $length) {
  $content_length = strlen($content);

  if ($content_length >= $length) {
    // Too long, return the shortened string
    return mb_substr($content, 0, $length - 3) . '...';
  }

  // All good, return the string unchanged
  return $content;
}
```