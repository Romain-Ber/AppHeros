import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.adjustScrollHeight();
    window.addEventListener('resize', this.adjustScrollHeight.bind(this));
    this.intervalId = setInterval(this.checkForChanges.bind(this), 200);
  }

  disconnect() {
    window.removeEventListener('resize', this.adjustScrollHeight.bind(this));
    clearInterval(this.intervalId);
  }

  // adjustScrollHeight() {
  //   const content = this.element.querySelector('#parchment');
  //   const container = this.element.querySelector('#contain');
  //   const newHeight = container.offsetHeight + 16;
  //   content.style.transition = 'height 0.1s ease';
  //   content.style.height = newHeight + 'px';
  // }

  checkForChanges() {
    // Check if the content size has changed
    const content = this.element.querySelector('#parchment');
    const container = this.element.querySelector('#contain');
    const currentHeight = container.offsetHeight + 16;
    if (parseInt(content.style.height) !== currentHeight) {
      this.adjustScrollHeight();
    }
  }
}
