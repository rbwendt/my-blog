---
title: A "100 emoji" maker
author: ben-wendt
date: 2021-11-01
template: article.pug
---

The 100 emoji is iconic; it’s a symbol recognized across cultures and it has a semiotic impact globally. In a world where most societies have standardized around a base-10 (or decimal) number system, a doubly-underlined 100 is a shining beacon of success, or total mastery. The forthright and striking symbol of flawless execution, total knowledge, and success lends itself naturally, in this remix culture we live in, to imitations. If 100 can be thus underlined, can we convey the same messages by borrowing the style of the emoji but with different content? Of course we can, that’s what cultures do.

<span class="more"></span>

So let’s whip up a 100 emoji generator. I do most of my f-around work in python in a notebook these days, for several reasons:

*   I do most of my day job in python,
*   Libraries. As much as I love mucking around in elixir or whatever you can’t beat having numpy and PIL for something like this.
*   Jupyter: not having to duck in and out of terminal and preview windows tightens up the cognitive loop of development. You arguably end up with shittier code but who really cares for something like this. It’s better to finish a stupid project than get bogged down with irrelevancies and decide it’s not worth the effort.

So here’s a method that makes 100 emoji:

```python
    # font from https://www.dafont.com/captain-redemption.font?text=100+365&back=theme
    # copied some stuff from https://stackoverflow.com/a/63005869/973810
    # reference https://stackoverflow.com/questions/17056209/python-pil-affine-transformation
    
    from PIL import Image, ImageFont, ImageDraw, ImageFilter
    import numpy as np
    
    def make_image(number, w=100, h=100):
    
        fill = (222, 0, 0) # a nice red
        img = Image.new('RGB', (2*w, 2*h), (255, 255, 255))
    
        # found this free for personal use font. It't more a 300 vibe, but close enough.
        font_filename = 'Captain Redemption.ttf'
        font_size = 0
        number = str(number)
    
        # find a good font-size to fit the width
        for i in range(1, w):
            font = ImageFont.truetype (font_filename, i)
            x, y = font.getsize(number)
            if x > 0.9 * w:
                font_size = i
                break
        draw = ImageDraw.Draw(img)
        i = 0
        # do the underlines
        for y in range(int(2*0.53*h), int(2*0.58*h)):
            draw.arc([(int(2*-0.10*w), y), (int(2*1.60*w), int(y + 2*0.20*w))], start=230, end=280-i, fill=fill)
            i += 2
        i = 0
        for y in range(int(2*0.62*h), int(2*0.67*h)):
            draw.arc([(int(2*-0.10*w), y), (int(2*1.60*w), int(y + 2*0.20*w))], start=233, end=274-i, fill=fill)
            i += 2
        # Use supersampling to achieve anti-aliased underlines
        img = img.resize((w, h), Image.ANTIALIAS)
        draw = ImageDraw.Draw(img)        
        font = ImageFont.truetype (font_filename, font_size)
        x, y = font.getsize(number)
    
        draw.text((0, 0), text=number, font=font, fill=fill)
    
        draw = ImageDraw.Draw(img)
        width = int(w/17.5)
    
        # warp/sheer the image with more height on the left.
        img = img.transform((w, h),
                        Image.AFFINE, (1, -0.1, -3, 0.1, 0.62, 5),
                        resample=Image.BICUBIC, fillcolor=(255,255,255))
        return img
```

![828 emoji](/articles/100-emoji-maker/828.png)

![yeet emoji](/articles/100-emoji-maker/yeet.png)

I like to finish off my blog posts with a list of things I would like to improve, so here goes:

*   The first character should be taller, but not rendered with a larger font as that would make it wider. This goes beyond the capabilities of true type fonts.
*   It doesn’t work for longer words.
*   Related to point 1, a lot of the “math” in the method was trial-and-error. It would be a lot better to have a system of drawing different elements in their own areas. In the 100 emoji these are polygonal, which would get quite complex so I didn’t bother for a joke project.
