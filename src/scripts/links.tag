<links>
  <div class="links-content container animated fadeIn">
    <div class="columns">
      <div class="column col-12">
        <h3 class="text-center">
          Interesting Links
        </h3>
      </div>
    </div>
    <div class="columns">
      <div class="column col-12">
        <loading if={loading}></loading>
      </div>
      <div each={links in groups} class="column col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-4">
        <h5 class="text-center">{links.title}</h5>
        <div each={item in links.items} class="tile link-box">
          <div class="tile-icon">

            <div class="example-tile-icon">
              <i class="icon icon-file centered"></i>
            </div>
          </div>

          <div class="tile-content">
            <p class="tile-title">{ item.title }</p>
            <p class="tile-subtitle">{ item.sub }</p>
          </div>

          <div class="tile-action">
            <a target="_blank" href={ item.href }>
              <button class="btn btn-primary branded">
                Link
              </button>
            </a>
          </div>
        </div>
      </div>

    </div>
  </div>
<script>
var self = this;

self.loading = false;

self.groups = self.opts.state.links;

getLinks() {
  self.update({"loading" : true});
  window.cached("/blog/glinks/")
  .then((resp) => resp.text())
  .then((resp) => {
    self.update(
    {
      "groups" : JSON.parse(resp),
      "loading" : false
    });
  })
}

self.on("mount", () => {
  if (self.opts.state.page != "links") {
    self.getLinks();
  }
});

</script>
</links>
