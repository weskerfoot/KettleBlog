<categoryfilter>
  <div class="categorybar">
    <h4>
      { opts.name }
    </h4>
    <ul>
      <!-- menu header text -->
      <li class="divider">
      </li>
      <!-- menu item -->
      <div each={item in opts.items} class="menu-item menu-element">
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
  </div>
<script>

preventDefault(ev) {
  ev.preventDefault;
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
