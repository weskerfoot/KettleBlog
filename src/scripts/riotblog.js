import riot from 'riot';
import './bbutton.tag';
import './post.tag';
import './posts.tag';
import './editor.tag';
import './projects.tag';
import './app.tag';
import './grid.js';

riot.mount("app");
riot.mount("editor");
riot.mount("post",
  {
    "creator" : "author"
  });

riot.mount("decision");
riot.mount("bbutton");
riot.mount("projects");
