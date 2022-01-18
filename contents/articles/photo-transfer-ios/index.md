---
title: Archiving photos from iOS to a network drive
author: ben-wendt
date: 2020-08-01
template: article.pug
---

I wrote a while back about a script I wrote to run on my android phone that would sort and archive any photos I had on the device into dated folders I have on a network drive. Privacy and de-googling concerns led me to get an iphone when the time came to upgrade (essential, my old phone’s manufacturer shut down, and faced with an aging battery and a looming lack of support I decided to upgrade). This left me with a problem, how would I sort my images into my archive?

<span class="more"></span>

I’ve found it a bit harder to do fun hacks like the photo sorting hack on iOs as compared to android. My new work flow is:

1.  import (and delete) everything into i photo.
2.  export everything from there to a folder on my laptop.
3.  run this script:

```ruby
    require 'set'
    
    class Copier
    
        def initialize(path)
            @path = path
            @created_folders = [].to_set
            @path = ''
            @userhost = 'network-host'
            @destpath = '/mnt/big-disk/photos'
        end
    
        def get_date(file)
            # some say Modified, other Modification.
            mod_date = `exiftool "#{file}" | grep 'Modif'`
            mod_date = mod_date.split("\n")[0] # first line
                            .split(" : ")[1] # the date time part
                            .split(" ")[0] # the date part
            mod_date.split(':')
        end
    
        def create_folder_if_need_be(date)
            year, month, day = date
            unless @created_folders.include?(date)
                puts "creating folder for #{date.join('-')}"
                `ssh #{@userhost} "mkdir #{@destpath}/#{year}" 2> /dev/null`
                `ssh #{@userhost} "mkdir #{@destpath}/#{year}/#{month}" 2> /dev/null`
                `ssh #{@userhost} "mkdir #{@destpath}/#{year}/#{month}/#{day}" 2> /dev/null`
                @created_folders << date
            end
        end
    
        def transfer_file_to_dated_folder(file, date)
            year, month, day = date
            `scp "#{file}" #{@userhost}:#{@destpath}/#{year}/#{month}/#{day}`
            puts "transferred #{file}"
        end
    
        def delete_local_file(file)
            `rm "#{file}"`
        end
    end
    
    path = "./photos/"
    files = Dir["#{path}*"].sort_by(&:downcase)
    c = Copier.new(path)
    files.each do |file|
        date = c.get_date(file)
        c.create_folder_if_need_be(date)
        c.transfer_file_to_dated_folder(file, date)
        c.delete_local_file(file)
    end
```

Looking at this now, it would be great to move the core of the files.each block into the class, and read the path and host from `argv` but it works so I’m happy with it.
