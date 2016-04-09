---
title: Playing with Vue.js
author: ben-wendt
date: 2016-04-04
layout: post
template: article.jade
---
A coworker recently filled my ear with praise for [vue.js](http://vuejs.org/). 
I'm always eager to try new frameworks, and the benefits over angular
(namely performance and simplicity) sound really promising. I haven't 
had a chance to develop anything serious with this, but my initial
attempt was exhilirating.

<span class="more"></span>

I saw a link to the [xkcd api](https://xkcd.com/json.html) in a [tweet](https://twitter.com/cecycorrea/status/715918793898270720)
the other day, and decided to try it out with vue.js. I don't really enjoy
the comic strip, but it's a publicly availably API that isn't totally
boring. So... what the hell. Why not?

Vue.js template code looks a lot like angular. So here's my 
simple template:

```html
    <div id="app">
      <div>
        <button v-on:click="previous">&lt;</button>
        <button v-on:click="next">&gt;</button>
      </div>
      <template v-if="data.img">
        <img src="{{ data.img }}">
        <h1> {{ data.safe_title }} </h1>
        <p>
          {{ data.transcript }}
        </p>
        <p> {{ number }} / 1600 </p>
        <p> {{ error }}
      </template>
    </div>
```

I'm impressed by how little code gets this running. A good chunk of my
code is native run-of-the-mill XMLHttpRequest boilerplate:

```javascript
      vm = new Vue({
        el: '#app',
        data: {
          number: 400,
          data: {}
        },
        methods: {
          previous: function() {
            this.number --
            this.fetchData()
          },
          next: function() {
            this.number ++
            this.fetchData()
          },
          fetchData: function() {
            var xhr = new XMLHttpRequest()
            var self = this
            xhr.open('GET', 'xkcdpass.php?n=' + self.number)
            xhr.onload = function() {
              self.data = JSON.parse(xhr.responseText)
            }
            xhr.send()
          }
        }
      })
      vm.fetchData()
```

You can try it out [here](http://benwendt.ca/xkcdexplore.html).
