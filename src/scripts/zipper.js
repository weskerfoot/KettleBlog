import im from 'immutable';

function Zipper(left, right) {
  return {
    "left" : left,
    "right" : right
  };
}

function fromList(xs) {
  return Zipper(im.Stack(), im.Stack(xs));
}

function focus(z, def_val) {
  var head = z.right.first();
  if (head) {
    return head;
  }
  return def_val;
}

function reset(z) {
  return Zipper(im.Stack(), z.left.reverse().concat(z.right));
}

function swap(z) {
  return Zipper(im.Stack(z.right.reverse().shift()), im.Stack([z.right.last()]));
}

function goRight(z) {
  if (z.right.size == 1) {
    return reset(z);
  }
  return Zipper(z.left.unshift(z.right.first()),
                z.right.shift());
}

function goLeft(z) {
  if (z.left.size == 0) {
    return swap(z);
  }
  return Zipper(z.left.shift(),
                z.right.unshift(z.left.first()));
}

function extend(z, xs) {
  return Zipper(z.left, z.right.concat(xs));
}

function removeCurrent(z) {
  return Zipper(z.left, z.right.shift());
}

var empty = fromList([]);

export default {
  "Zipper" : fromList,
  "focus" : focus,
  "goRight" : goRight,
  "goLeft" : goLeft,
  "empty" : empty,
  "fromList" : fromList,
  "extend" : extend,
  "removeCurrent" : removeCurrent
};
