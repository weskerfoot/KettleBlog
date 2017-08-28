<menu>
  <div id="menu" class="dropdown">
    <a
      class="btn btn-primary menu-button dropdown-toggle"
      tabindex="0"
      onclick={preventDefault}
    >
      { opts.name }<i class="icon icon-caret"></i>
    </a>
    <ul class="menu">
      <!-- menu header text -->
      <li class="divider">
      </li>
      <!-- menu item -->
      <div each={item in opts.items} class="menu-item menu-element">
        <a
          class="btn btn-primary menu-button"
          style={styles}
          onclick={parent.opts.onfilter(item)}
        >
          { item }
        </a>
        <yield/>
      </div>
    </ul>
  </div>
<script>

preventDefault(ev) {
  ev.preventDefault;
}

this.styles = {
  "text-transform" : "capitalize",
  "border-color" : "#4b93c1"
};

</script>
</menu>
