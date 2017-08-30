<categoryfilter>
  <div class="categorybar">
    <h4>
      { opts.name }
    </h4>

    <div
      class="fewer-categories"
    >
      <button
        style={moreStyle}
        class="btn btn-primary branded"
        if={start > 0}
        onclick={up}
      >
        <i
          class="fa fa-angle-double-up"
          aria-hidden="true"
        >
        </i>
      </button>
    </div>

    <ul>
      <!-- menu header text -->
      <li class="divider">
      </li>
      <!-- menu item -->
      <div each={item in items.slice(start, start+pagesize)} class="menu-item menu-element">
        <button
          class="btn btn-primary category-button"
          style={highlight(item)}
          onclick={parent.opts.onfilter(item)}
        >
          { item }
        </button>
        <yield/>
      </div>
    </ul>

    <div
      class="more-categories"
    >
      <button
        if={items.length > pagesize}
        style={moreStyle}
        class="btn btn-primary branded"
        onclick={down}
      >
        <i
          class="fa fa-angle-double-down"
          aria-hidden="true"
        >
        </i>
      </button>
    </div>

  </div>
<script>

var self = this;

self.start = 0;
self.pagesize = 10;
self.items = self.opts.items;

preventDefault(ev) {
  ev.preventDefault;
}

self.moreStyle = {
  "margin" : "auto"
};

up() {
  if (self.start >= self.pagesize) {
    self.update({"start" : self.start - self.pagesize});
  }
}

down() {
  console.log(self.pagesize);
  console.log(self.start);
  console.log(self.items.length);
  if (self.start+self.pagesize < (self.items.length)) {
    self.update({"start" : self.start + self.pagesize});
  }
}

highlight(item) {

  var styles = {
    "text-transform" : "capitalize",
    "background-color" : "white"
  };

  if (this.opts.category == item) {
    styles["background-color"] = "rgba(103, 173, 219, 0.40)";
  }
  return styles;
}

</script>
</categoryfilter>
