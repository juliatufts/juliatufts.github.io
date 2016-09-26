//---------- A script that covers the screen with spiral shaped things.
//---------- It uses the Poisson-disc sampling algorithm to create a list of
//---------- sample points, then draws at those points in sequence using Paper.js
//---------- This version draws the spirals starting from both ends of the point list.

// Create a layer that will fit to the center
var layer = project.activeLayer;

// Spiral variables
var startRadius = 0;
var maxRadius = 60;
var strokeWidth = 14;
var slow = 5;			// the higher this is, the more spiral path points there are and the longer it takes to draw
var expandRate = 0.55;
var fill = new Color(0, 255, 255, 0.4);	// cyan
var counterClockWise = false;	// the spirals drawn from the front of the list are counterclockwise
var maxSamples = 30;	// keep this low so that sampling doesn't take forever

// Start from the left hand corner
var startPoint = new Point( 0, view.size.height - (maxRadius + strokeWidth) );

// Use Poisson-disc method to get random sample points
var samplePointsRight = poissonDisc(maxRadius * 1.5, maxSamples, {width: view.size.width, height: startPoint.y}, startPoint);
var samplePointsLeft = samplePointsRight.splice( 0, Math.ceil( samplePointsRight.length / 2) );
samplePointsRight.reverse();

// Each path (left and right) draws this many spirals
var maxSpirals = Math.floor(samplePointsRight.length / 2);

// Path and point variables
var sampleIndexRight = 0;
var sampleIndexLeft = 0;
var spiralIterLeft = samplePointsLeft.length;
var spiralIterRight = samplePointsRight.length;

var spiralPointsLeft = [];
var spiralPointsRight = [];

var pathLeft = new Path({
	strokeColor: fill,
	strokeWidth: strokeWidth,
	strokeCap: 'round'
});
var pathRight = new Path({
	strokeColor: fill,
	strokeWidth: strokeWidth,
	strokeCap: 'round'
});


//------------------------------------------------ MAIN
function onFrame(event) {
	// If we've drawn enough spirals then stop
	if (sampleIndexLeft > maxSpirals) return;

	// draw spirals starting from the start point
	if (sampleIndexLeft < samplePointsLeft.length) {
		var ret = drawSpiral(samplePointsLeft,
							 sampleIndexLeft,
							 spiralPointsLeft,
							 spiralIterLeft,
							 pathLeft,
							 counterClockWise);
		spiralPointsLeft = ret.spiralPoints;
		spiralIterLeft = ret.spiralIter;
		sampleIndexLeft = ret.sampleIndex;
		pathLeft = ret.path;
	}

	// draw spirals starting from the end of the sample points list
	if (sampleIndexRight < samplePointsRight.length) {
		var retBack = drawSpiral(samplePointsRight,
								 sampleIndexRight,
								 spiralPointsRight,
								 spiralIterRight,
								 pathRight,
								 !counterClockWise);
		spiralPointsRight = retBack.spiralPoints;
		spiralIterRight = retBack.spiralIter;
		sampleIndexRight = retBack.sampleIndex;
		pathRight = retBack.path;
	}
}
//-------------------------------------------- END MAIN

function drawSpiral(samplePoints, sampleIndex, spiralPoints, spiralIter, path, clockWise) {
	
	if (spiralIter < spiralPoints.length) {
		// If the spiral has not yet reached its maximum radius, add next point
		path.add(spiralPoints[spiralIter++]);

	} else {
		// Otherwise, start a new spiral
		spiralPoints = makeSpiralPoints(
			maxRadius,
			samplePoints[sampleIndex],
			slow,
			clockWise
		);

		sampleIndex++;
		spiralIter = 0;

		var path = new Path({
			strokeColor: fill,
			strokeWidth: strokeWidth,
			strokeCap: 'round'
		});
	}

	return {
		spiralPoints: spiralPoints,
		spiralIter: spiralIter,
		sampleIndex: sampleIndex,
		path: path
	};
}

function makeSpiralPoints(maxRadius, center, slow, clockWise) {
	// variables
	var radius = 0;
	var points = [];
	var i = 0;
	var xtrans = clockWise ? Math.cos: Math.sin;
	var ytrans = clockWise ? Math.sin: Math.cos;

	// make spiral
	do {
		points.push( (new Point(xtrans(i/slow), ytrans(i/slow)) * radius) + center);
		i++;
		radius += expandRate;
	} while (radius < maxRadius)

	// add some extra points to make the spiral nest in a circle
	// note that we use the same i from the previous loop
	for (var c = 0; (c/slow) <= 2 * Math.PI; c++) {
		points.push( (new Point(xtrans(i/slow), ytrans(i/slow)) * radius) + center);
		i++;
	}
	return points;
}

//---------------------------------------------- Poisson-disc sampling
//--------------------------------------------------------------------
function poissonDisc(r, k, screenSize, startPoint) {
	// r is the minimum-allowable distance between samples
	// k is the maximum number of sample points tested before rejection

	//----------------------------------------------- Helper functions
	// returns a list of n uniformly random points
	function randomPoints(n, screenSize) {
		var points = [];
		for (var i = 0; i < n; i++){
			var x = Math.floor(Math.random() * screenSize.width);
			var y = Math.floor(Math.random() * screenSize.height);

			points.push(new Point ({
				x : x, y : y
			}));
		}
		return points;
	}

	// returns the distance between two points
	function dist(a, b) {

		var dx = b.x - a.x;
		var dy = b.y - a.y;

		return Math.sqrt(dx * dx + dy * dy);
	}

	// function for finding the grid cell of a given point
	function findCell(point, cellSize) {
		var tempX = Math.floor(point.x / cellSize);
		var tempY = Math.floor(point.y / cellSize);
		return [tempX, tempY];
	}

	//---------------------------------------------------- Algorithm
	// grid variables
	var cellSize = (r / Math.sqrt(2));
	var gridWidth = Math.ceil(screenSize.width / cellSize);
	var gridHeight = Math.ceil(screenSize.height / cellSize);
	var grid = [];

	// used to check surrounding cells
	var DIRECTIONS = [[0, 0], [0, 1], [0, 2], [0, -1], [0, -2],
					  [1, 0], [2, 0], [-1, 0], [-2, 0],
					  [1, 1], [1, -1], [-1, 1], [-1, -1],
					  [2, 1], [2, -1], [-2, 1], [-2, -1],
					  [1, 2], [1, -2], [-1, 2], [-1, -2]];

	// initialize the grid
	for (var i = 0; i < gridHeight; i++) {
		var row = [];
		for (var j = 0; j < gridWidth; j++) {
			row.push(null);
		}
		grid.push(row);
	}

	// start with the given start point
	var activePoints = [startPoint];
	var finalPoints = [];

	// and add it to the grid
	var cellCoords = findCell(activePoints[0], cellSize);
	grid[cellCoords[1]][cellCoords[0]] = activePoints[0];


	// while we still have active points
	while (activePoints.length > 0) {

		// pick a random active point
		var currentPointIndex = Math.floor(Math.random() * activePoints.length)
		var currentPoint = activePoints[currentPointIndex];
		var allPointsTooClose = true;

		// generate k sample points
		for (var i = 0; i < k; i++) {

			// new sample point coordinates
			var angle = Math.random() * 2 * Math.PI;
			var radius = Math.random() * r + r;
			var x = currentPoint.x + Math.cos(angle) * radius;
			var y = currentPoint.y + Math.sin(angle) * radius;

			// if it's offscreen, go on to the next sample point
			if (x < 0 || x >= screenSize.width || y < 0 || y >= screenSize.height) {
				continue;
			}
			var samplePoint = new Point(x, y);

			// find its cell position in the grid
			var sampleCell = findCell(samplePoint, cellSize);

			// compare the sample points distance to every other point in neighboring cells
			var foundClosePoint = false;
			for (var j = 0; j < DIRECTIONS.length; j++) {

				var neighborCell = [sampleCell[0] + DIRECTIONS[j][0],
								    sampleCell[1] + DIRECTIONS[j][1]];

				// check if the neighbor cell is within range
				if (neighborCell[0] < 0 || neighborCell[0] >= gridWidth ||
					neighborCell[1] < 0 || neighborCell[1] >= gridHeight) {
					continue;
				} else if (grid[neighborCell[1]][neighborCell[0]]) {
					var neighborPoint = grid[neighborCell[1]][neighborCell[0]]
					var distance = dist(samplePoint, neighborPoint);

					// if there is a neighboring point within r, it's a bad sample point
					if (distance < r) {
						foundClosePoint = true;
						break;
					}
				}
			}

			// if we didn't find any close points, it was a good sample point
			if (!foundClosePoint) {
				activePoints.push(samplePoint);
				grid[sampleCell[1]][sampleCell[0]] = samplePoint;
				allPointsTooClose = false;
				break;
			}
		}

		// after we've checked all the samples
		// if they were all bad samples, then deactivate the current point
		if (allPointsTooClose) {
			finalPoints.push(currentPoint);
			activePoints.splice(currentPointIndex, 1);
		}
	}
	return finalPoints;
}

