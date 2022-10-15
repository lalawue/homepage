#!/bin/sh

# generate html
lua MarkdownProjectCompositor.lua config.lua ..

# generate pagefind source
pagefind --bundle-dir ../publish/pagefind --source ../publish --force-language zh --verbose
