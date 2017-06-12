<postcontrols>
    <div class="container centered">
      <div class="columns">
        <div class="column col-6">
          <button class={"btn btn-lg nav-button float-right " + (this.opts.state.pid <= 1 ? "disabled" : " ") + this.opts.prevloading}
                  onclick={this.opts.prev}
          >

            <i class="fa fa-arrow-left" aria-hidden="true"></i>
          </button>
        </div>
        <div class="column col-6">
          <button class={"btn btn-lg nav-button float-left  " + (this.opts.nomore ? "disabled" : " ") + this.opts.nextloading}
                  onclick={this.opts.next}
          >
            <i class="fa fa-arrow-right" aria-hidden="true"></i>
          </button>
        </div>
      </div>
    </div>
</postcontrols>
