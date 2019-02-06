import riot from 'rollup-plugin-riot'
import nodeResolve from 'rollup-plugin-node-resolve'
import commonjs from 'rollup-plugin-commonjs'
import buble from 'rollup-plugin-buble'
import uglify from 'rollup-plugin-uglify';

function makeBundle(item) {
  console.log(item);
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

export default makeBundle(["./scripts/riotblog.js", "./build/scripts/riotblog.min.js"]);
