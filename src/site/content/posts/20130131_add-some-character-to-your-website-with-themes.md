---
title: Add some character to your website with themes
date: 2013-01-31
url: /posts/20130131_add-some-character-to-your-website-with-themes/
oldUrl: /brendan/posts/20130131_add-some-character-to-your-website-with-themes/
tags:
  - Post
  - PHP
  - CSS
---

It's easy to add themes to your website and allow your visitors to customise their experience. This post will guide you through implementing theme support on your website using [PHP](http://php.net/), [CSS](http://en.wikipedia.org/wiki/Cascading_Style_Sheets) and [cookies](http://en.wikipedia.org/wiki/HTTP_cookie).

There are a few requirements of a theming system:

1. Setting up your CSS files
2. Showing a list of themes
3. Allow the user to select a theme
4. Include the selected theme styles

### Setting up your CSS files

This method is designed around the idea of placing common styles in a file named `common.css` and placing theme specific styling in other CSS files. The filename of these files will become the theme name, like so:

- `red.css` is displayed as `Red`
- `dark-blue.css` is displayed as `Dark Blue`
- `salmon.css` is displayed as `Salmon`

For this example, the CSS files are placed in a top level folder named `styles`. Feel free to update this by changing the value of the `$folder` variables in the PHP functions.

Note that themes aren't suitable for every website, so use them wisely to allow for customisations that suit your visitors' needs. Also, don't forget to ensure your default theme remains usable, including suitably sized text and clear link styling.

```php
// theme_get - Return the currently selected theme name
function theme_get() {
  $theme_selected='red';// Set the default theme
  $folder='/styles/';// Path to the themes folder
  session_start();
  if(isset($_COOKIE['theme']) && $_COOKIE['theme']!=''){
    $theme_requested=$_COOKIE['theme'];
    if($folder.$theme_requested.'.css')){
      $theme_selected=$theme_requested;
    }
  }
  return $theme_selected;
}

// Output the CSS includes to the page
$theme_selected=theme_get();
print '<link rel="stylesheet" href="/styles/common.css">';
print '<link rel="stylesheet" href="/styles/'.$theme_selected.'.css">';
```

```php
// theme_list - Return a list of the available themes
function theme_list(){
  $folder='/styles/';// Path to the themes folder

  // Extract a list of files in the folder and sort them
  $dir=opendir($folder);
  $files=array();
  while($files[]=readdir($dir));
  sort($files);
  closedir($dir);

  // Create the theme selector list
  $return='';
  foreach($files as $file){
    $ext=pathinfo($file,PATHINFO_EXTENSION);
    if($file!='.' && $file!='..' && $ext=='css' && $file!='common.css'){
      $theme_name=str_replace('.'.$ext,'',$file);
      $theme_title=str_replace("_"," ",str_replace("-"," ",ucwords(strtolower($theme_name))));
      $return.='<li><a href="/theme-set.php?theme='.$theme_name.'">'.$theme_title.'</a></li>';
    }
  }
  if($return!=''){ return '<ul class="themes">'.$return.'</ul>'; }
}
```

```php
// theme_set - Update the theme in use
function theme_set($theme) {
  if($theme!=''){
    $folder='/styles/'
    if(file_exists($folder.$theme.'.css')){
      session_start();
      setcookie("theme",$theme,time()+60*60*24*14);
    }
  }
}

// Check the URL for a theme
if (isset($_GET['theme']) && $_GET['theme'] != '') {
  // Clean and sanitise this data!
  // One example: http://stackoverflow.com/questions/4223980/the-ultimate-clean-secure-function
  $theme_clean=your_clean_function($_GET['theme']);

  // Set the theme then redirect to the home page
  theme_set($theme_clean);
  header('Location: /');
}
```