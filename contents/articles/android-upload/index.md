---
title: Uploading and sorting photos from android over sftp using termux
author: ben-wendt
date: 2019-10-01
template: article.pug
---

I was super excited to find that I can install bash on my phone, then scp and ruby. It opens up a lot of possibility of what a phone should really be able to do. Too often I feel constrained by limited options in apps.

<span class="more"></span>

An example of this is taking old photos and putting them into my long term storage on my home computer. I backup to google photos, but I like to keep a local copy too. My old workflow for organizing files was to either use usb or “andftp” app on my android to get the files onto my machine, then sort them roughly by date into folders for ease of retrieval. Both of these methods are time consuming and don’t give the best result.

Here is my new work flow…

```
    userhost = 'someguy@192.168.0.100'
    destpath = '/mnt/big/camera'
    
    ['PIC', 'VID'].each do |type|
      transer_files(type)
    end
    
    def transfer_files(type)
      fs = ` ls storage/dcim/camera/#{t}* `.split("\n")
    
      prefixess = fs.map {|f| f.gsub(/.+#{t}_/, '').gsub(/_.+/,'')}.uniq
    
      years = prefixes.map{|p| p.slice(0,4)}.uniq
    
      prefixes.each do |p|
        handle_date_prefix(p)
      end
    end
    
    def handle_date_prefix(p)
      year = p.slice(0,4)
    
      mth = p.slice(4,2)
      day = p.slice(6,2)
    
    
      prefs.each do |p|
        transfer(year, mth, day)
      end
    end
    
    def transfer(year, mth, day)
     `ssh #{userhost} "mkdir #{destpath}/#{year}" `
     `ssh #{userhost} "mkdir #{destpath}/#{year}/#{mth}" `
     `ssh #{userhost} "mkdir #{destpath}/#{year}/#{mth}/#{day}" `
    
      c= `scp storage/dcim/camera/#{t}_#{p}* #{user_host}:#{destpath}m/#{year}/#{mth}/#{day} && rm storage/dcim/camera/#{t}_#{p}*`
      puts c
    end
```

This nicely organizes all my files by date and clears out the space on my phone.