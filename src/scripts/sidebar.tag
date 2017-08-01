<sidebar>
  <button
    if={!open}
    class="animated fadeIn btn tooltip tooltip-right"
    data-tooltip="Filter Categories"
    style={this.closedButton()}
    onclick={swipe}
    >
      <i
        class="fa fa-bars"
        aria-hidden="true"
      >
      </i>
  </button>
  <div show={this.swiped !== undefined} style={ this.styles() } class={`animated ${this.swiped !== undefined ? (this.swiped ? "slideInLeft" : "slideOutLeft") : "" } container`}>
    <div style={{"height" : "100%"}} class="columns col-oneline col-gapless">

      <div class="panel column col-11">
        <div class="panel-header">
          <div class="panel-title">
            { opts.name }
          </div>
        </div>

        <div style={panelStyles} class="panel-body">
          <ul class="menu">

            <li class="divider" data-content="LINKS">
            </li>

            <li each={item in opts.items} class="menu-item">
              <a
                class="btn btn-primary menu-button"
                href="#"
              >
                { item }
              </a>
              <yield/>
              <li class="divider"></li>
            </li>
          </ul>
        </div>
      </div>

      <div
        style={buttonStyles()}
        class={`column ${this.open ? "col-1" : "col-12"}`}
        onclick={this.swipe}
        >
      </div>

    </div>
  </div>

<script>

import { default as lodash } from 'lodash';
var self = this;

self.open = false;
self.swiped = undefined;

self.swipe = lodash.debounce(() => {
    console.log("clicked");
    self.update({
      "swiped" : self.swiped == undefined ? true : !self.swiped,
      "open" : !self.open
    });
  }, 100);

self.buttonStyles = (() => {
  return {
    "top": "0",
    "overflow-x": "hidden"
  };
});

self.closedButton = (() => {
  return {
    "background-color" : "rgba(103, 173, 219, 0.40)",
    "font-color" : "black",
    "height": "50px",
    "width": "50px",
    "font-size" : "40px",
    "position": "fixed",
    "z-index": "1",
    "top": "0",
    "left": "0"
  };
});

self.styles = (() => {
  return {
    "height": "100%",
    "width": "300px",
    "position": "fixed",
    "z-index": "1",
    "top": "0",
    "left": "0",
    "overflow-x": "hidden",
    "padding-top": "60px",
    "background-color" : "rgba(103, 173, 219, 0.40)"
  };
});

self.panelStyles = {
  "width" : "90%",
  "height" : "100%",
  "margin" : "0 auto"
};

</script>
</sidebar>
