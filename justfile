#!/usr/bin/env just --justfile
#
#
# Just command runner configuration
#   - You can run the commands from any directory, eg: just list
#   - More info at https://github.com/casey/just
#
#

# Set default config

set shell := ["bash", "-uc"]
set ignore-comments := true
set quiet := true

# Add alias commands

alias help := list
alias ls := list
alias menu := choose

# Default to the 'list' command, when 'just' is run without any parameters
default: list

# Show a graphical selector listing the available options and their script content
choose:
  @just --choose --justfile "{{ justfile() }}"

# Show a list of the available 'just' commands
list:
  @echo '{{ style("warning") }}Listing "just" command options from {{ justfile() }}{{ NORMAL }}'
  just --justfile "{{ justfile() }}" --list --alias-style 'right' --list-heading '' --list-prefix ''

# Start the local instance of Links
[group('links')]
links-start:
  bash ./src/links/bin/start-links.sh

# Stop the local instance of Links
[group('links')]
links-stop:
  bash ./src/links/bin/stop-links.sh

# Generate release notes and save them to a file
[group('release')]
release-notes output_file:
  bash ./bin/release-notes.sh "$output_file"

# Run the build process for Site
[group('site')]
site-build:
  bash ./src/site/bin/site-build.sh

# Create a new post for Site
[group('site')]
site-new-post:
  bash ./src/site/bin/site-new-post.sh

# Run the setup process for Site
[group('site')]
site-setup:
  bash ./src/site/bin/site-setup.sh

# Run a local version of Site
[group('site')]
site-start:
  cd ./src/site && deno task serve
