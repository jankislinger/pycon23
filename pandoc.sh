#!/usr/bin/env bash

CDN=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.9.2

pandoc presentation.md \
  -s \
  -t revealjs \
  -o presentation.html \
  -V revealjs-url=${CDN}
