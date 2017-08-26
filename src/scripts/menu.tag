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
      <li class="divider" data-content="LINKS">
      </li>
      <!-- menu item -->
      <div each={item in opts.items} class="menu-item">
        <a
          class="btn btn-primary menu-button"
          style={styles}
          onclick={parent.opts.onfilter(item)}
        >
          { item }
        </a>
        <yield/>
        <li class="divider"></li>
      </div>
    </ul>
  </div>
<script>

preventDefault(ev) {
  ev.preventDefault;
}

this.styles = {
  "text-transform" : "capitalize"
};

</script>
</menu>
