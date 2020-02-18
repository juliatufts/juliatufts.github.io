//------------------------------------------ SVG Utils
function parsePathAsObject(pathCommand) {
  const tokens = pathCommand.split(' ');
  const floatValues = [];
  const commands = [];

  let i = 0;
  for (token of tokens) {
    const tokenAsFloat = parseFloat(token);
    if (isNaN(tokenAsFloat)) {
      commands.push({i, token});
    } else {
      floatValues.push(tokenAsFloat);
      i++;
    }
  }
  return {
    floatValues,
    commands,
  };
}

function convertToPathString(pathObject) {
  const path = pathObject.floatValues;
  for (i = pathObject.commands.length - 1; i >= 0; i--) {
    const command = pathObject.commands[i]
    path.splice(command.i, 0, command.token);
  }
  return path.join(' ');
}

function lerpFloatArrays(a, b, t) {
  let c = [];
  for (let i = 0; i < a.length; i++) {
    c.push((1 - t) * a[i] + t * b[i]);
  }
  return c;
}

function lerpSvgPaths(svgPath, startObject, endObject, t) {
  let floatValues = lerpFloatArrays(
    startObject.floatValues,
    endObject.floatValues,
    t,
  );
  let newObject = {floatValues, 'commands': startObject.commands};
  svgPath.setAttributeNS(null, 'd', convertToPathString(newObject));
}

//----------------------------------------------- SVG Init

var bowSvg = document.getElementById('bowSvg');
var bowPath = bowSvg.getElementById('bowPath');
var bowStringPath = bowSvg.getElementById('bowStringPath');

const bowPathStart = 'M 50 10 Q 40 20 70 40 T 100 100 T 70 160 Q 40 180 50 190';
const bowPathEnd = 'M 40 30 Q 25 35 60 50 T 100 100 T 60 150 Q 25 165 40 170';
const bowObjectStart = parsePathAsObject(bowPathStart);
const bowObjectEnd = parsePathAsObject(bowPathEnd);

const bowStringPathStart = 'M 50 20 L 50 100 L 50 180';
const bowStringPathEnd = 'M 35 35 L 2 100 L 35 165';
const bowStringObjectStart = parsePathAsObject(bowStringPathStart);
const bowStringObjectEnd = parsePathAsObject(bowStringPathEnd);

bowPath.setAttributeNS(null, 'd', bowPathStart);
bowStringPath.setAttributeNS(null, 'd', bowStringPathStart);

//-------------------------------------------- Vector Utils
class Vector {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  static divide(v, n) {
    if (n === 0) { return null; }
    return new Vector(v.x / n, v.y / n);
  }

  normalize() {
    let mag = this.dist(Vector.zero);
    if (mag != 0) {
      this.x /= mag;
      this.y /= mag;
    }
  }

  normalized() {
    let mag = this.dist(Vector.zero);
    let norm = new Vector(0,0);
    if (mag != 0) {
      norm.x = this.x / mag;
      norm.y = this.y / mag;
    }
    return norm;
  }

  setTo(v) { // 🤠
    this.x = v.x;
    this.y = v.y;
  }

  mult(scalar) {
    this.x *= scalar;
    this.y *= scalar;
  }

  add(v) {
    this.x += v.x;
    this.y += v.y;
  }

  dist(v) {
    let x = (this.x - v.x);
    let y = (this.y - v.y);
    return Math.sqrt(x*x + y*y);
  }

  copy() {
    return new Vector(this.x, this.y);
  }
}
Vector.zero = new Vector(0,0);
const gravity = new Vector(0, 0.1);

//----------------------------------------------- Mouse
class Mouse extends Vector {
  constructor() {
    super(0,0);
  }
  onMove(e) {
    this.setTo(e);
  }
  onDown(e) {
    this.setTo(e);
    document.documentElement.style.cursor = 'grabbing';
  }
  onUp(e) {
    document.documentElement.style.cursor = 'pointer';
  }
}

//----------------------------------------------- Arrow
const ArrowState = {
  Ready: 'ready',
  Aim: 'aim',
  Fire: 'fire',
  Released: 'released',
  Hit: 'hit',
};

class Arrow {
  constructor(initialPos, mouse, svgRef){
    this.initialPos = initialPos;
    this.mouse = mouse;
    this.svgRef = svgRef;
    this.height = svgRef.clientHeight;
    this.width = svgRef.clientWidth;

    this.pos = new Vector(0,0); // center?
    this.dir = new Vector(0,0);
    this.theta = 0;
    this.acc = new Vector(0,0);
    this.vel = new Vector(0,0);
    this.mass = 1;

    this.drawPosition = 0; // [0,1]
    this.minDrawDistance = 50;
    this.maxDrawDistance = 100;
    this.drawPower = 16;
    this.state = ArrowState.Ready;

    this.reset();
  }

  getPoint() {
    return {
      x: this.pos.x + this.width + 38 * Math.cos(this.theta),
      y: this.pos.y + this.height/2 + 38 * Math.sin(this.theta),
    };
  }

  reset() {
    this.pos.setTo(this.initialPos);
    this.dir.mult(0);
    this.acc.mult(0);
    this.vel.mult(0);
    this.drawPosition = 0;
    this.directAwayFromMouse();
    this.state = ArrowState.Ready;
  }

  directAwayFromMouse() {
    let newDir = new Vector(
      (this.pos.x + this.width - this.mouse.x),
      (this.pos.y + this.height/2 - this.mouse.y),
    );
    newDir.normalize();
    this.dir.setTo(newDir);
  }

  applyForce(v) {
    this.acc.x += (v.x / this.mass);
    this.acc.y += (v.y / this.mass);
  }

  update() {
    switch (this.state) {
      case ArrowState.Ready:
        this.directAwayFromMouse();
        break;
      case ArrowState.Aim:
        this.directAwayFromMouse();

        // calculate distance from mouse to arrow point
        const point = new Vector(
          this.pos.x + this.width - 6,
          this.pos.y + this.height/2,
        );
        let dist = this.mouse.dist(point);
        dist = Math.max(dist, this.minDrawDistance);
        dist = Math.min(dist, this.maxDrawDistance);

        // calculate target draw position
        const targetDrawPosition = (dist - this.minDrawDistance) / (this.maxDrawDistance - this.minDrawDistance);

        // if target is sufficiently close to previous draw position, set
        // otherwise, move smoothly towards target
        const epsilon = 0.1;
        if (Math.abs(this.drawPosition - targetDrawPosition) < epsilon) {
          this.drawPosition = targetDrawPosition;
        } else {
          this.drawPosition =
            (0.6) * this.drawPosition +
            (0.4) * targetDrawPosition;
        }
        break;
      case ArrowState.Fire:
        this.directAwayFromMouse();

        // If not sufficiently drawn, go back to ready state
        if (this.drawPosition < 0.02) {
          this.state = ArrowState.Ready;
          break;
        }

        // apply force based on draw position/power
        let f = this.dir.copy()
        f.mult(this.drawPosition * this.drawPower);
        this.applyForce(f);
        this.state = ArrowState.Released;
        this.drawPosition = 0;
      case ArrowState.Released:
        this.applyForce(gravity);
        this.vel.add(this.acc);
        this.pos.add(this.vel);
        this.acc.mult(0);
        this.dir.setTo(this.vel.normalized());

        const buffer = 2 * this.width;
        let outOfBounds = this.pos.x < (-buffer);
        outOfBounds = outOfBounds || this.pos.y < (-buffer);
        outOfBounds = outOfBounds || this.pos.x > (document.documentElement.clientWidth + buffer);
        outOfBounds = outOfBounds || this.pos.y > (document.documentElement.clientHeight + buffer);

        if (outOfBounds) {
          this.reset();
        }
        break;
      default:
        // you fucked up
    }
  }

  render() {
    this.theta = Math.atan2(this.dir.y, this.dir.x);
    const thetaInDegrees = this.theta * 180 / Math.PI;
    const x = this.pos.x;
    const y = this.pos.y;
    const offsetX = 40 + this.drawPosition * (-30); // in [40, 10]

    this.svgRef.style.cssText =
      'transform: translate(' + x + 'px, ' + y + 'px) ' +
      'rotate(' + thetaInDegrees + 'deg) ' +
      'translateX(' + offsetX + 'px);';
  }

  draw() {
    this.state = ArrowState.Aim;
  }

  shoot() {
    this.state = ArrowState.Fire;
  }
}


//----------------------------------------------- bow
class Bow {
  constructor(arrow, mouseRef, svgRef) {
    this.arrow = arrow;
    this.mouseRef = mouseRef;
    this.svgRef = svgRef;
    this.height = this.svgRef.clientHeight;
    this.width = this.svgRef.clientWidth;

    this.pos = arrow.pos.copy();
    this.arrowPoint = new Vector(
      arrow.pos.x + arrow.width,
      arrow.pos.y + arrow.height/2,
    );
    this.dir = new Vector(0,0);
    this.minDist = 20;
    this.maxDist = 90;

    // make right edge of bow rect line up with arrow rect
    // so that they rotate around the same point
    this.pos.add({
      x: (this.arrow.width - this.width),
      y:(-0.5 * this.height) + (0.5 * this.arrow.height)
    });
  }

  update() {
    let newDir = new Vector(
      (this.arrowPoint.x - this.mouseRef.x),
      (this.arrowPoint.y - this.mouseRef.y),
    );
    newDir.normalize();
    this.dir.setTo(newDir);

    // update bow svg values
    lerpSvgPaths(bowPath, bowObjectStart, bowObjectEnd, this.arrow.drawPosition);

    // update bow string svg values
    lerpSvgPaths(bowStringPath, bowStringObjectStart, bowStringObjectEnd, this.arrow.drawPosition);
  }

  render() {
    const theta = Math.atan2(this.dir.y, this.dir.x);
    const thetaInDegrees = theta * 180 / Math.PI;
    const x = this.pos.x;
    const y = this.pos.y;

    this.svgRef.style.cssText =
      'transform: translate(' + x + 'px, ' + y + 'px) ' +
      'rotate(' + thetaInDegrees + 'deg) ' + ';';
  }
}


/* --------- Main ---------- */
const navbar = document.getElementById('navbar');
const links = navbar.children;
const linkColliderMap = new Map();
for (var i = 0; i < links.length; i++) {
  linkColliderMap.set(links[i].getBoundingClientRect(), links[i]);
}

const arrowSvg = document.getElementById('arrowSvg');
const bowAndArrow = document.getElementById('bowAndArrow');
const initialX = (bowAndArrow.getBoundingClientRect().width / 2) - arrowSvg.getBoundingClientRect().width;
const initialY = bowAndArrow.getBoundingClientRect().y;

let time = 0;
let deltaTime = 0;
let initialPos = new Vector(initialX, initialY);
let hit = null;

const mouse = new Mouse();
const arrow = new Arrow(initialPos, mouse, arrowSvg);
const bow = new Bow(arrow, mouse, bowSvg);

function collision(pos, rect) {
  var clear = pos.x < rect.x;
  clear = clear || pos.x > (rect.x + rect.width);
  clear = clear || pos.y < rect.y;
  clear = clear || pos.y > (rect.y + rect.height);
  return !clear;
}

function touchHandler(e)
{
    var touches = e.changedTouches,
        first = touches[0],
        type = "";
    switch(e.type)
    {
        case "touchstart": type = "mousedown"; break;
        case "touchmove":  type = "mousemove"; break;
        case "touchend":   type = "mouseup";   break;
        default:           return;
    }
    var simulatedEvent = document.createEvent("MouseEvent");
    simulatedEvent.initMouseEvent(type, true, true, window, 1,
                                  first.screenX, first.screenY,
                                  first.clientX, first.clientY, false,
                                  false, false, false, 0/*left*/, null);

    first.target.dispatchEvent(simulatedEvent);
}

function init() {
  time = performance.now() / 1000;

  // make sure bow and arrow are in position before displaying them
  bow.update();
  bow.render();
  bowPath.setAttributeNS(null, 'stroke', 'black');
  bowStringPath.setAttributeNS(null, 'stroke', 'black');
  arrow.update();
  arrow.render();
  document.getElementById('arrowPoly').setAttributeNS(null, 'fill', 'black');

  // prevent scrolling on mobile
  document.body.addEventListener("touchmove", function(e) {
      e.preventDefault();
      e.stopPropagation();
  }, false);

  document.addEventListener("touchstart", touchHandler, true);
  document.addEventListener("touchmove", touchHandler, true);
  document.addEventListener("touchend", touchHandler, true);
  document.addEventListener("touchcancel", touchHandler, true);

  document.addEventListener("mousemove", function(e) {
    mouse.onMove(e);
  });

  document.addEventListener("mousedown", function(e) {
    if (arrow.state == ArrowState.Ready) {
      arrow.draw();
    }
    mouse.onDown(e);
  });

  document.addEventListener("mouseup", function(e) {
    if (arrow.state == ArrowState.Aim) {
      arrow.shoot();
    }
    mouse.onUp(e);
  });

  for (let link of linkColliderMap.values()) {
    link.disabled = true;
    link.addEventListener("click", function (e) {
      alert("CONGRATULATION");
      arrow.reset();
      link.disabled = true;
    });
  }
}

function update() {
  let lastTime = time;
  time = performance.now() / 1000;
  deltaTime = time - lastTime;

  if (!!hit) {
    arrow.state = ArrowState.Hit;
    hit.click();
    hit = null;
  }

  // arrow
  arrow.update();
  arrow.render();

  // bow
  bow.update();
  bow.render();

  // check for collision
  if (arrow.state != ArrowState.Hit) {
    for (let [rect, link] of linkColliderMap) {
      if (collision(arrow.getPoint(), rect)) {
        hit = link;
        link.disabled = false;
      }
    }
  }
}

/* ------------- MAIN ---------------  */
function updateLoop(step) {
  step();
  window.requestAnimationFrame(() => updateLoop(step));
}

init();
updateLoop(update);
/* ------------ end MAIN -----------  */
