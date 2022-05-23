---
title: Transferring Musical Likes Between Services
author: ben-wendt
date: 2022-05-22
template: article.pug
---

After using spotify for many years, I decided to try switching
my music service a few months ago. I was finding that any time
I put on shuffle, spotify would eventually direct me back to
funk and soul music from the seventies. I generally love those
styles of music, but for a service that is supposed to provide
discovery, it wasn't really working for me.

<span class="more"></span>

I compared the various services available in Canada on the
following criteria:

* Library
* Sonos Support
* iOS Support
* Mac Support
* CarPlay Support
* Google Home Support

Tidal met most of my needs, so I gave it a try. It's a good
service, kind of lacking in the polish I got used to with
spotify, but the library was good and I could listen on most
of my devices. I even found it has an app for my roku TV,
which I never really used. I was a bit disappointed with the
CarPlay app, but it was okay. The real sticking point was no
Google Home, so when my trial ended, I signed up for a youtube
music trial.

One thing I will say for tidal was the discovery was like a
bresh of fresh air coming from spotify. I found a lot of 
really great stuff on there.

Youtube Music doesn't have a real mac app, but there is a "web
native" app, which is basically what "chrome apps" are now, from
what I can tell.

When I left spotify, I exported my thousands of Liked songs with
the hope of importing them to whatever service I settled on.
Unfortunately Tidal's API is worse than almost any I've seen,
and Youtube Music doesn't even have an api. There is, however, 
an unofficial API for Youtube Music called
[ytmusicapi](https://ytmusicapi.readthedocs.io/en/latest/).

It's a bit of a kludgey library, working by pretending to be a
client in a browser, but overall it worked great. Youtube Music
seems to have some kind of protection in place to prevent abuse
so if you just fire off a tonne of requests using the library,
you will see a lot of timeouts. The usual way to deal with
something like this would be to use a [retry decorator](https://pypi.org/project/retry/)
But I decided to roll my own, which I thought was nifty and
worth sharing:

```python
def retry_backoff(fn, args, i=1):
    try:
        return fn(*args)
    except ReadTimeout:
        time.sleep(10 * i)
        return retry_backoff(fn, args, i+1)
```

Then you can call this with something like:

```python
retry_backoff(ytmusic.rate_song, [video_id, 'LIKE'])
```

Obviously would be more useful if the Exception type
and sleep multiplier were configurable, but it worked
for me. I got all the Likes imported. I may move off
youtube music, maybe even starting a new spotify account,
but for now I am happy.

