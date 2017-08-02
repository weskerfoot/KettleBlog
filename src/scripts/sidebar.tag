<sidebar>
  <button
    if={!open}
    class="animated fadeIn btn tooltip tooltip-right"
    data-tooltip="Filter Categories"
    style={this.closedButton()}
    onclick={swipe}
    >
      <i
        class="fa fa-filter"
        aria-hidden="true"
      >
      </i>
  </button>
  <div
    show={this.swiped !== undefined}
    style={ this.styles() }
    id="sidebar"
    class={`animated ${this.swiped !== undefined ? (this.swiped ? "fadeInLeft" : "fadeOutLeft") : "" } container`}
  >
    <div
      style={{"height" : "100%", "overflow-x" : "hidden"}}
      class="columns col-oneline col-gapless"
    >
      <div style={nobg} class="panel column col-11">
        <div class="panel-header">
          <div class="panel-title">
            { opts.name }
          </div>
        </div>

        <div style={R.merge(panelStyles, nobg)} class="panel-body">
          <ul style={nobg} class="menu">

            <li style={R.merge(nobg, subtitle)} class="divider sidebar-divider" data-content="Categories">
            </li>

            <li style={R.merge(menuStyles, nobg)} each={item in opts.items} class="menu-item">
              <a
                style={nobg}
                class="btn btn-primary sidebar-button"
                href="#"
              >
                { item }
              </a>
              <yield/>
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

import { default as jquery } from 'jquery';
import { default as lodash } from 'lodash';
import { default as R } from 'ramda';
var self = this;

self.R = R;

var background = "rgba(255, 255, 255, 0.95)";

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
    "top": "0"
  };
});

self.closedButton = (() => {
  return {
    "background-color" : background,
    "font-color" : "black",
    "height": "30px",
    "width": "30px",
    "font-size" : "20px",
    "position": "fixed",
    "z-index": "1",
    "top": "10px",
    "left": "10px"
  };
});

self.styles = (() => {
  return {
    "box-shadow" : "6px 8px 16px -4px rgba(0,0,0,0.75)",
    "-webkit-box-shadow" : "6px 8px 16px -4px rgba(0,0,0,0.75)",
    "-moz-box-shadow" : "6px 8px 16px -4px rgba(0,0,0,0.75)",
    "height": "80%",
    "width": "250px",
    "position": "fixed",
    "z-index": "1",
    "top": "0",
    "left": "0",
    "overflow-x": "hidden",
    "padding-top": "60px",
    "border" : "1px solid",
    "background-color" : background
  };
});

self.panelStyles = {
  "width" : "100%",
  "height" : "100%",
  "margin" : "0 auto",
  "padding" : "0px 0px 0px 0px"
};

self.menuStyles = {
  "width" : "100%",
  "margin" : "0 auto"
};

self.nobg = {
  "background-color" : "transparent",
  "background" : "none",
  "border" : "none",
  "box-shadow" : "none"
};

self.subtitle = {
  "color" : "#4b93c1",
  "width" : "100%"
};

self.one("updated",
  () => {
      jquery(document).click(function(event) {
          if(!jquery(event.target).closest('#sidebar').length) {
            console.log("clicked outside of the sidebar");
            if (self.open) {
              self.swipe();
            }
          }
      });
  });

</script>
</sidebar>
