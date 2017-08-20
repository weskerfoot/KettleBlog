import riot from 'riot';
import { default as RiotControl } from 'riotcontrol';
import { default as promise } from 'es6-promise';
import { default as smooth } from 'smoothscroll-polyfill';
import './post.tag';
import './posts.tag';
import './projects.tag';
import './app.tag';
import './grid.js';
import 'element-closest';

import fetchCached from 'fetch-cached';
import 'whatwg-fetch';

window.cache = {};
window.riot = riot;
window.RiotControl = RiotControl;

window.cached = fetchCached({
  fetch: fetch,
  cache: {
    get: ((k) => {
      return new Promise((resolve, reject) => {
        resolve(window.cache[k]);
      });
    }),
    set: (k, v) => { window.cache[k] = v; }
  }
});

window.addEventListener("load", () => {
  promise.Promise.polyfill();
  smooth.polyfill();
  window.RiotControl.addStore(new riot.observable());
});
