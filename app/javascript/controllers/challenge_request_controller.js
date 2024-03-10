import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="challenge-request"
export default class extends Controller {
  static targets = ["modalOverlay", "modal"];

  showModal() {
    this.modalOverlayTarget.style.display = 'block';
    this.modalTarget.style.display = 'block';
  }
}
