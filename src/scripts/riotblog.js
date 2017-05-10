import riot from 'riot';
import './bbutton.tag';
import './post.tag';
import './posts.tag';
import './editor.tag';

riot.mount("editor");
riot.mount("post",
  {
    "creator" : "author"
  });

riot.mount("decision");
riot.mount("bbutton");
