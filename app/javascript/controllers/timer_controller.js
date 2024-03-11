import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="timer"
export default class extends Controller {
  static targets = ["title", "firstPlayer", "secondPlayer", "duel", "gamesChoice", "glslCanvas"]

  connect() {
    const sandbox = new GlslCanvas(this.glslCanvasTarget);
    setTimeout(function(){
      this.glslCanvasTarget.classList.add('show');
    },100);
  }
  buttonClick(event){
    event.preventDefault()
    const path = event.currentTarget.getAttribute("href")
    const firstPlayer = this.firstPlayerTarget.children[0]
    firstPlayer.style.backgroundColor="#008000"

    const pageTitle = document.querySelector('.appheros-content-title h1');
    pageTitle.innerText = "En attente";

    this.duelTarget.classList.remove("d-none")
    this.gamesChoiceTarget.classList.add("d-none")

    setTimeout(() => {
      window.location.href = path;
    }, 7000);


    setTimeout(() => {
      const secondPlayer = this.secondPlayerTarget.children[0]
      secondPlayer.style.backgroundColor="#008000"
      pageTitle.innerText = "Chargement";
    }, 4000);
  }
}
