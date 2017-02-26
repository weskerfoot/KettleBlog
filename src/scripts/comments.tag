<comments>
  <div if={loading} class="loading comments-loader"></div>
  <comment if={!loading} each={this.comments} data="{this}"></comment>
  <textarea onfocus={clearplaceholder}
            onblur={checkplaceholder}
            oninput={echo}
            __disabled={disabled}
            class={"form-input comments centered " + this.maxed}
            ref="textarea"
            rows="10"
            cols="50"
            maxlength={this.maxlength}>
      { placeholder }
  </textarea>
  <div if={warn} class="toast toast-danger maxwarn centered">
    <button
      onclick={closewarning}
      class="btn btn-clear float-right">
    </button>
    Your comment is too long!
  </div>
<script>
import 'whatwg-fetch';

this.comments = [];
this.maxlength = 700;

this.placeholder = "Comment here!";
this.focused = false;
this.maxed = "";
this.warn = false;
this.disabled = "";
this.loading = true;

clearplaceholder() {
  if (!this.focused) {
    this.update({
      "placeholder" : "",
      "focused"     : true
      })
  }
}

checkplaceholder() {
  if (this.refs.textarea.value.trim().length == 0) {
    this.update({
      "placeholder" : "Comment here!",
      "focused"     : false
    });
  }
}

closewarning() {
  this.update({"warn" : false});
}

echo(ev) {
  if (this.refs.textarea.value.length >= maxlength) {
    this.update({
      "maxed" : "maxinput",
      "warn"  : true
    });
  }
  else {
    this.update({
      "maxed" : "",
      "warn"  : false
    });
    window.setTimeout(this.closewarning, 5000);
  }
}

var self = this;

getComments(pid) {
  fetch("/blog/comments/"+pid)
    .then(
      function(resp) {
        return resp.text();
      })
    .then(
      function(body) {
        self.update(
          {
            "comments" : JSON.parse(body),
            "loading"  : false
          });
      });
}

this.on("mount",
  function() {
    this.getComments(self.opts.pid);
  });
</script>
</comments>
