import riot from 'riot';
import { default as RiotControl } from 'riotcontrol';
import './bbutton.tag';
import './post.tag';
import './posts.tag';
import './projects.tag';
import './app.tag';
import './grid.js';
import { default as promise } from 'es6-promise';
import { default as smooth } from 'smoothscroll-polyfill';
import 'element-closest';

window.addEventListener("load", () => {

  promise.Promise.polyfill();
  smooth.polyfill();

  window.RiotControl = RiotControl;

  RiotControl.addStore(new riot.observable());
  riot.mount("app");
  riot.mount("post",
    {
      "creator" : "author"
    });

  riot.mount("bbutton");
  riot.mount("projects");
});
