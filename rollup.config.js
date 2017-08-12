import riot from 'rollup-plugin-riot'
import nodeResolve from 'rollup-plugin-node-resolve'
import commonjs from 'rollup-plugin-commonjs'
import buble from 'rollup-plugin-buble'
import uglify from 'rollup-plugin-uglify';

function makeBundle(item) {
  var entry = item[0];
  var dest = item[1];
  return {
    entry: entry,
    dest: dest,
    plugins: [
      riot(),
      nodeResolve({ jsnext: true, preferBuiltins: false}),
      commonjs(),
      buble(),
      uglify()
    ],
    format: 'iife'
  };
}

const items = [
  ["src/scripts/riotblog.js", "build/bundle.js"],
  ["src/scripts/editor.js", "build/editor.bundle.js"]
];

var bundles = items.map(makeBundle);

export default bundles;
