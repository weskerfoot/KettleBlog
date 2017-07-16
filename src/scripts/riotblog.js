import riot from 'riot';
import './bbutton.tag';
import './post.tag';
import './posts.tag';
import './editor.tag';
import './projects.tag';
import './app.tag';
import './grid.js';
import { default as promise } from 'es6-promise';

promise.Promise.polyfill()

riot.mount("app");
riot.mount("editor");
riot.mount("post",
  {
    "creator" : "author"
  });

riot.mount("decision");
riot.mount("bbutton");
riot.mount("projects");
