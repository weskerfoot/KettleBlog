import riot from 'riot';
import './comments.tag';
import './comment.tag';
import './bbutton.tag';
import './post.tag';
import './posts.tag';

riot.mount("post",
  {
    "creator" : "author"
  });

riot.mount("decision");
riot.mount("bbutton");
