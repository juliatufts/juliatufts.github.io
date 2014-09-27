---
layout: blogpost
category: blog
date:   2014-08-25 23:00:00
title: Going For a Random Walk in Processing
---

I started reading <a href = "http://natureofcode.com/">The Nature of Code</a> by Daniel Shiffman recently; it's a book about mathematical principles in the physical world and how to program natural systems using Processing. The very first example is to make a random walker class whose instantiation looks something like this:

<canvas data-processing-sources="/Scripts/RandomWalker0.pde"></canvas>

The above random walker is represented by a single black pixel who randomly moves up, down, left or right with equal probability. I iterated on this example a few times: I first made the random walker into a 10x10 pixel square that changed color over time. In this version it's easier to see the walker's current movement and overall walk.

<canvas data-processing-sources="/Scripts/RandomWalker.pde"></canvas>

I next made it so that the walker could only walk on squares it hadn't already visited. This way, the canvas will fill up entirely with colored squares and then stop.

<canvas data-processing-sources="/Scripts/RandomWalkerNoOverlap.pde"></canvas>

Looking at these beautifully moving walkers made me want to paint a river with them, so I did that.

<canvas data-processing-sources="/Scripts/RandomWalkerDefinedRegion.pde"></canvas>

Here I used multiple random walkers and made each a little less random by setting their probability of moving right to 0.5, moving up to 0.25, and moving down to 0.25. I hope you enjoy watching these as much as I do! I'll continue to blog about my progress with <a href = "http://natureofcode.com/">The Nature of Code</a>.