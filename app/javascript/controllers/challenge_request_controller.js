import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="challenge-request"
export default class extends Controller {
  static targets = ["choicegame", "modalOverlay", "modal"];


  connect() {
    console.log("Controller connected");
  }

  initialize() {

  }

  showModal() {
    this.modalOverlayTarget.style.display = 'block';
    this.modalTarget.style.display = 'block';
    console.log("lala")
  }

}
