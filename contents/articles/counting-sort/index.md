---
title: Counting sort
author: ben-wendt
date: 2014-05-09
template: article.pug
---

I have a thing for sorting algorithms. They're fairly accessible as far as algorithms go, and it's always fun to look under the hood of how computers go about their business. Thinking algorithmically makes you a better programmer too.

<span class="more"></span>

So I was interested to see this post on hacker news about [count sort in C][1], and decided to implement it in languages more within my milieu.

### PHP

```php
function count_sort($in) {
	$counting = array_fill(0, max($in), 0);

	for ($i = 0, $l = count($in); $i &lt; $l; $i++) {
		$counting[$in[$i] - 1]++;
	}
	for ($i = 0, $j = 0, $l = count($counting); $i &lt; $l; $i++) {
		while ($counting[$i] &gt; 0) {
			$in[$j] = $i + 1;
			$counting[$i]--;
			$j++;
		}
	}

	return $in;
}
```

### Javascript

```javascript
function count_sort(a) {
    var i, j, l = Math.max.apply(null, a), counting = [];	
    for (i = 0; i &lt; l; i++) {
        counting[i] = 0;
    }
    l = a.length;

    for (i = 0; i &lt; l; i++) {
        counting[a[i] - 1]++;
    }
    for (i = 0, j = 0, l = counting.length; i &lt; l; i++) {
        while (counting[i] &gt; 0) {
            a[j] = i + 1;
            counting[i]--;
            j++;
        }
    }

    return a;
}
```

### python

```python
    def countsort(a):
	counts = [0] * max(a)
	l = len(a) 
	for i in range(0, l):
		counts[a[i] - 1] += 1
	j = 0
	l = len(counts)
	for i in range(0, l):
		while counts[i] &gt; 0:
			a[j] = i + 1
			counts[i] -= 1
			j += 1
	return a
```

### c#

```c-sharp
static int[] countSort(int[] a) {
            int i, j, l = a.Count();
            int[] counting = new int[a.Max()];	
            for (i = 0; i &lt; l; i++) {
                counting[i] = 0;
            }

            for (i = 0; i &lt; l; i++) {
                counting[a[i] - 1]++;
            }
            for (i = 0, j = 0, l = counting.Count(); i &lt; l; i++) {
                while (counting[i] &gt; 0) {
                    a[j] = i + 1;
                    counting[i]--;
                    j++;
                }
            }

            return a;
        }
```

### powershell

```powershell
Function countSort ($in) {
	$l = $in | Measure -Maximum
	$l = $l.Maximum
	$counting = @()

    for ($i = 0; $i -lt $l; $i++) {
        $counting += 0;
    }

	$l = $in.length

	for ($i = 0; $i -lt $l; $i++) {
		$counting[$in[$i] - 1]++;
	}
	
	$l = $counting.length
	$j = 0
	
	for ($i = 0; $i -lt $l; $i++) {
		while ($counting[$i] -gt 0) {
			$in[$j] = $i + 1;
			$counting[$i]--;
			$j++;
		}
	}

	return $in;
	
}
```

### Conclusion

The sort only works with positive integers.

As it mentions in the blog I linked that inspired this column, the time and space of the algorithm are O(n + k), where k is the maximum element size in the array. That&#8217;s the real problem with the algorithm. If you sort something like `[1, 3, 5, 1287614]`, you end up with a count array of 1287614 elements, which is definitely excessive for the array being sorted. Sorting an array shouldn't fail because the elements in the array are too big. Running the PHP sort in a standard configuration with 5000000 in the input array will cause an out of memory exception.

 [1]: http://austingwalters.com/counting-sort-in-c/
