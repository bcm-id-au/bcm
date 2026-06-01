---
title: Custom error handler
date: 2013-02-04
url: /posts/20130204_custom-error-handler/
oldUrl: /brendan/posts/20130204_custom-error-handler/
tags:
  - Post
  - PHP
---

When a website or web app is viewable publically, it's a good idea to modify how PHP errors are handled. The default is to show a, sometimes dangerously detailed, error to the visitor. A much better way of handling this is to send an email to the developer and hide the error details from the visitor.

![Sample error messages](/images/brendan/error-messages.jpg)
_Showing error details to the visitor isn't good_

```php
set_error_handler('error_handle');

function error_handle($errno, $errstr, $errfile, $errline){
  // The email address to send the email to
  $mail_to = 'developers@test.com';

  // The email address the email comes from
  $mail_from = 'errors@test.com';

  // Extract the visitor's browser information
  $browser = get_browser(null,true);

  // Setup the content of the email
  $mail_text  = 'Error '.$errno.' in '.$errfile.' (line '.$errline.'):'."\r\n".$errstr."\r\n"."\r\n";
  $mail_text .= 'Current URL: '.$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI']."\r\n";
  $mail_text .= 'Visitor IP: '.$_SERVER['REMOTE_ADDR']."\r\n";
  $mail_text .= 'Visitor Browser: '.$browser['browser'].' '.$browser['version'].' ('.$browser['platform'].')';

  // Configure the email headers
  $mail_headers = 'From: '.$mail_from."\r\n".'X-Mailer: PHP/'.phpversion();

  // The subject of the email
  $mail_subject = 'Error';

  // Send the email
  mail($mail_to, $mail_subject, $mail_text, $mail_headers);
}
```