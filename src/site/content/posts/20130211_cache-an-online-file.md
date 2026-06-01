---
title: Cache an online file
date: 2013-02-11
url: /posts/20130211_cache-an-online-file/
oldUrl: /brendan/posts/20130211_cache-an-online-file/
tags:
  - Post
  - PHP
  - Performance
---

When connecting to a third-party web service, it's a good idea to keep a cached version of the required files in case the third-party service is having issues. This way your website will at least show old data instead of no data at all.

```php
/*
cache - Downloads a file to a certain folder (if required), returns the local path

Notes:
local_folder should start and end with a forward slash
max_age_minutes is the number of minutes before a new file should be downloaded

Usage:
$file_path = cache('http://test.com/data.txt', '/test/data/', 'data2.txt', 15);
*/
function cache($media_url, $local_folder, $local_filename, $max_age_minutes = 5) {
  if ($media_url && $local_folder && $local_filename) {
    // Convert to a real path on the server
    $local_folder = '/cache' . $local_folder;

    // Default to creating a new cached file
    $make_new_file = true;

    // Check if there is already a local version of this file
    if (file_exists($local_folder . $local_filename)) {
      $file_mod_time = time_relative(filemtime($local_folder . $local_filename));
      if (strstr($file_mod_time, 'minute')) {
        // Remove everything besides numbers
        $minutes = ereg_replace('[^0-9]', '', $file_mod_time);

        if ($max_age_minutes - 1 > $minutes) {
          // File isn't old enough to require a download
          $make_new_file = false;
        }
      }
    }

    if ($make_new_file) {
      // Create a new local file
      $file = fopen($media_url, "r");

      if ($file) {
        // Create the local directory
        if (!file_exists($local_folder)) {
          $create_local_path = mkdir($local_folder, 0777);
        }

        // Create the local file
        $fc = fopen($local_folder . $local_filename, "w+");
        while (!feof($file)) {
          $line = fread($file, 1028);
          fwrite($fc, $line);
        }

        fclose($fc);
      }
    }

    // Convert the local path to a URL
    $local_folder = str_replace(
      '/domains/test.com/',
      'http://test.com/',
      $local_folder
    );

    return $local_folder . $local_filename;
  }
}
```
