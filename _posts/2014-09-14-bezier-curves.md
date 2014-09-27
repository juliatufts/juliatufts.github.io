---
layout: blogpost
category: processing
date: 2014-09-14 14:00:00
title: Bezier Curves
---

I decided to look more into Bezier curves, and try generating some with a sequence of points. I figured I could make a nice looking sine wave by joining two Bezier curves, the first with control points directly above the start and end points, and the second with control points below. This makes a nice pattern of start/end points and control points: the start/end points are always on a horizonal line, equally spaced and the control points are on another horizonal line, directly above or below them. Like dots on a grid. Then I linearly interpolate the control points from this starting position, to the next one in the pattern for the x-position, and increase the first control point's y-position to make it stretch.

<canvas data-processing-sources="/Scripts/BezierJoyDivision.pde"></canvas>

Press space to pause if you want to get a better look!

<center>[Challenge: Make and post a Processing sketch every day for 100 days]</center>