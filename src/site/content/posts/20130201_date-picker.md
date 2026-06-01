---
title: Date picker
date: 2013-02-01
url: /posts/20130201_date-picker/
oldUrl: /brendan/posts/20130201_date-picker/
tags:
  - Post
  - PHP
---

A simple date picker designed for use on mobile devices. Creates three dropdown menus allowing for selection of dates in the last 10 years. Also allows for customising the currently selected date, which defaults to today's date.

![Date picker](/images/brendan/date-picker.png)
_The finished result_

```php
// form_date_picker
// Purpose: Create a date picker allowing selection of dates in the next 10 years
// Notes: Defaults to selecting today but custom selected date can be set (in YYYY-MM-DD format)
// Example: form_date_picker('2012-12-25');
function form_date_picker($custom_date = '') {
  $this_year=date('Y');
  $ten_years=$this_year+11;

  if ($custom_date == '') { // Use todays date
    $selected_day=date('j');
    $selected_month=date('m');
    $selected_year=date('Y');
  } else{ // Use a custom date
    $date_parts=explode('-',$custom_date);
    $selected_day=$date_parts['2'];
    $selected_month=$date_parts['1'];
    $selected_year=$date_parts['0'];
  }

  // Day
  $f='<select id="date_day" name="date_day">';
  for ($i=1; $i<32; $i++) {
    $n=$i;
    if($n<10){ $n='0'.$n; }
    $f.='<option label="'.$i.'" value="'.$n.'"';
    if($i==$selected_day){ $f.=' selected="selected"'; }
    $f.='>'.$i.'</option>';
  }
  $f.='</select>';

  // Month
  $f.='<select id="date_month" name="date_month">';
  for ($i=1; $i<13; $i++) {
    $timestamp=mktime(0,0,0,$i,1,$this_year);
    $l=date('M',$timestamp);
    if($i<10){ $i='0'.$i; }
    $f.='<option label="'.$l.'" value="'.$i.'"';
    if($i==$selected_month){ $f.=' selected="selected"'; }
    $f.='>'.$i.'</option>';
  }
  $f.='</select>';

  // Year
  $f.='<select id="date_year" name="date_year">';
  for($i=$this_year; $i<$ten_years; $i++){
    $f.='<option label="'.$i.'" value="'.$i.'"';
    if($i==$selected_year){ $f.=' selected="selected"'; }
    $f.='>'.$i.'</option>';
  }
  $f.='</select>';

  return $f;
}
```