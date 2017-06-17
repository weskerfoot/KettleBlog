import riot from 'rollup-plugin-riot'
import nodeResolve from 'rollup-plugin-node-resolve'
import commonjs from 'rollup-plugin-commonjs'
import buble from 'rollup-plugin-buble'

export default {
  entry: 'src/scripts/riotblog.js',
  dest: 'build/bundle.js',
  plugins: [
    riot(),
    nodeResolve({ jsnext: true, preferBuiltins: false}),
    commonjs(),
    buble()
  ],
  format: 'iife'
}
