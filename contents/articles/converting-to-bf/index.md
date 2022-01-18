---
title: Converting strings to bf code
author: ben-wendt
date: 2015-10-11
template: article.pug
---

I was playing around with the [esoteric programming language brainfuck](https://en.wikipedia.org/wiki/Brainfuck). I found that it was pretty time consuming writing out strings of text using only increments and decrements of the data pointer.

So I decided to write a bf string maker in go. Code generation is pretty important in go, so it is fun to generate code for another language using go.

<span class="more"></span>


```go
package main
 
import (
    "os"
    "fmt"
    "strings"
)
 
func main() {
    buffer := 0;
    if len(os.Args) > 1 {
        in := strings.Join(os.Args[1:], " ")
        runes := []rune(in)
        for _, rune := range runes {
            current := int(rune)
            symbols := ""
            if current > buffer {
                symbols = strings.Repeat("+", current - buffer)
            } else {
                symbols = strings.Repeat("-", buffer - current)
            }
            fmt.Println(symbols + ".")
            buffer = current
        }
    } else {
        fmt.Println("no params")
    }
}
```

The idea is that any acscii string (a collection of runes in go) can be translated to bf by playing with the bf data pointer. This pointer starts at zero, and we just walk through the string moving the pointer: increments are + commands and decrements are - commands. The . operator outputs the current data pointer.


