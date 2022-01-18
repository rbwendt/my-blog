---
title: Setting a custom response header in a Gin response
author: ben-wendt
date: 2015-06-04
template: article.pug
---



I’m using [Gin Gonic](https://github.com/gin-gonic/gin) on a project I’m working on at work these days. I was in a bit of a pickle where I had to specify a response body that I already had as a string, but I needed to put the correct content type header on the response (meaning I couldn’t use the built in .String or .JSON methods.

<span class="more"></span>

I had to dig around a bit in the source code a bit to figure this one out. So, If you want to set a custom response header on a gin response, do it like this

```go
imports (
    "github.com/gin-gonic/gin"
    "github.com/gin-gonic/gin/render"
)
func whatever() {
    ...
    c.Render(
        http.StatusOK, render.Data{
            ContentType: "application/json",
            Data:        []byte(response),
        })
    ...
}
```

