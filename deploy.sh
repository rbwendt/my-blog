#! /bin/bash

wintersmith build
rsync -rvzp --delete build/ benwendt.ca:/var/www/html
