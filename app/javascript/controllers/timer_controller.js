import { Controller } from "@hotwired/stimulus"
import glslCanvas from "glslCanvas"

let sandbox;
// Connects to data-controller="timer"
export default class extends Controller {
  static targets = ["title", "firstPlayer", "secondPlayer", "duel", "gamesChoice", "glslCanvas", "animateSword"]
  connect() {
    sandbox = new glslCanvas(this.glslCanvasTarget);
    //const sandbox = new glslCanvas(this.glslCanvasTarget);
    sandbox.setUniform("u_fire",1.0); 
  }

  buttonClick(event){
    event.preventDefault()
    sandbox.setUniform("u_fire",2.0); 
    const path = event.currentTarget.getAttribute("href")
    const firstPlayer = this.firstPlayerTarget.children[0]
    firstPlayer.style.backgroundColor="#008000"

    const pageTitle = document.querySelector('.appheros-content-title h1');
    pageTitle.innerText = "En attente";

    this.duelTarget.classList.remove("d-none")
    this.gamesChoiceTarget.classList.add("d-none")

    setTimeout(() => {
      window.location.href = path;
    }, 9000);


    setTimeout(() => {
      const secondPlayer = this.secondPlayerTarget.children[0]
      secondPlayer.style.backgroundColor="#008000"
      pageTitle.innerText = "Chargement";

    }, 6000);


      setInterval(() => {
        this.animateSwordTarget.checked = !this.animateSwordTarget.checked;
      }, 2000);
  }
}
