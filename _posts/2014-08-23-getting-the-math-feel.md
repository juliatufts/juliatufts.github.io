---
layout: blogpost
category: blog
date:   2014-08-23 23:00:00
title: Getting the Math Feel
---

There is delightful satisfaction in experiencing a good math feel. This satisfaction is not only found in solving problems and proving theorems, it also resides in the most basic building blocks of mathematics. It’s a bit hard to describe the feeling that I’m talking about here, but I’ll try to give an easy-to-understand example.

Imagine a person, let’s call them camper Cal, who needs a sleeping bag to survive a cold night in the woods. You’re given a special sleeping bag of mathematics that is adjustable in size, and you need to fit it for Cal. Now keep in mind that this person is a set size - you can’t squeeze them even a tiny bit to fit into a sleeping bag that’s smaller than them. Any sleeping bag bigger than Cal will hold them alright, but you don’t want to settle for just alright, you want to adjust the sleeping bag to have the perfect fit.

<div class="section group">
	<div class="col span_1_of_3">
		<img src="/PostImages/2014-08-23-sleeping-bag3.png" id="outline">
		<h4>too small</h4>
	</div>
	<div class="col span_1_of_3">
		<img src="/PostImages/2014-08-23-sleeping-bag4.png" id="outline">
		<h4>alright</h4>
	</div>
	<div class="col span_1_of_3">
		<img src="/PostImages/2014-08-23-sleeping-bag2.png" id="outline">
		<h4>even better</h4>
	</div>
</div>

So we require two things for our sleeping bag. We need our camper to fit inside it, i.e. it must be bigger than them. We also want our sleeping bag to be the closest fit of all the sleeping bags bigger than Cal. We could also state our sleeping bag criteria as follows:
<ol>
	<li><span>it must be bigger than Cal</span></li>
	<li><span>it must be smaller than all other sleeping bags that are bigger than Cal</span></li>
</ol>
That second point may seem a bit convoluted at first, but it is equivalent to “being the closest fit”.

<div class="section group">
	<div class="col span_1_of_3">
		<img src="/PostImages/2014-08-23-sleeping-bag4.png" id="outline">
	</div>
	<div class="col span_1_of_3">
		<img src="/PostImages/2014-08-23-sleeping-bag2.png" id="outline">
	</div>
	<div class="col span_1_of_3">
		<img src="/PostImages/2014-08-23-sleeping-bag0.png" id="outline">
	</div>
</div>

For me there are a few nice math feels going on here. One is the dual nature of finding the smallest bag of a collection of bags that are bigger than another rigid object. Like infinitely many sleeping bags expanding around a camper and then falling away as a single one with the closest fit remains. Another is thinking about this perfectly snug sleeping bag itself. That of all the bigger-than-Cal sleeping bags, it can fit inside all of them. That if it was even a hair smaller, it wouldn’t have room for Cal to fit. Like a perfectly fit camper container that clicks into place.

What I’ve just described is an analogue to something called the <strong>supremum</strong> of a set. For a subset A of the real numbers (your general purpose numbers that include integers, decimals and pi), the supremum of A is the real number &alpha; that satisfies
<ol>
	<li><span>&alpha; is an upper bound for A, meaning that for all x in A, &alpha; &ge; x</span></li>
	<li><span>for all upper bounds b for A, &alpha; &le; b</span></li>
</ol>

One of my main objectives in learning how to program is to have the ability to embed good math feels into the accessible medium of games and interactive computer entities. Math can be dynamic and engaging, and it's totally worth experiencing that.