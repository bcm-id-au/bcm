---
title: Visitor redirection
date: 2012-11-05
url: /posts/20121105_visitor-redirection/
oldUrl: /brendan/posts/20121105_visitor-redirection/
tags:
  - Post
  - PHP
---

Redirecting a user consistently can be a challenging in a complex website, as you can't be sure which method (JavaScript or the [HTTP location header](http://en.wikipedia.org/wiki/HTTP_location)) is most suitable.

This can be handled with a rather simple PHP function:

```php
function redirect($url) {
  if (headers_sent()) {
    print '<script>window.location="' . $url . '"</script>';
  } else {
    header('Location: ' . $url);
  }

  exit();
}
```
