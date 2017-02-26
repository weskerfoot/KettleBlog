import riot from 'riot';
import './comments.tag';
import './comment.tag';
import './bbutton.tag';
import './post.tag';
import './posts.tag';

riot.mount("post",
  {
    "creator" : "wes",
    "title" : "A cool post here"
  });

riot.mount("comments");
riot.mount("bbutton");
