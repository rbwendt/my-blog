#! /bin/bash

wintersmith build
rsync -rvz build/ benwendt.ca:/var/www/html
open "https://benwendt.ca"
