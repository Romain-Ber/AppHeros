import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="taptabiere"
export default class extends Controller {
  static targets= ["startButton", "countDown", "score", "beerLevel"]
  score = 0;
  gameStarted = false;
  initialize() {
  }

  startGame() {
    this.score = 0;
    this.gameStarted = true;
    this.startButtonTarget.disabled = true;


    let counter = 10; // Décompte initial à partir de 10 secondes
    this.countDownTarget.innerText = counter;

    let countDown = setInterval(() => {
      counter -= 1;
      this.countDownTarget.innerText = counter;

      if (counter <= 0) {
        clearInterval(countDown);
        this.endGame();
      }
    }, 1000); // Mettre à jour le décompte toutes les secondes
  }

  endGame() {
    this.gameStarted = false;
    alert('Temps écoulé! Votre score est de ' + this.score + '!');
    this.startButtonTarget.disabled = false;
    this.scoreTarget.innerText = 'Score: ' + this.score;
  }

  tap() {
    if (this.gameStarted) {
      this.score += 1;
      this.scoreTarget.innerText = 'Score: ' + this.score; // Mettre à jour le score en temps réel
      this.updateBeerGlass(this.score);
    }
  }

  updateBeerGlass(score) {
  let increment = 2; // Augmenter de 2 pixels à chaque clic
  let beerLevel = parseFloat(this.beerLevelTarget.style.height) || 0;
  let newBeerLevel = beerLevel + increment;
  let beerLevelMax = 200; // Hauteur maximale de la barre en pixels
  if (newBeerLevel > beerLevelMax) {
      newBeerLevel = beerLevelMax; // Limiter la hauteur maximale de la barre
  }
  this.beerLevelTarget.style.height = newBeerLevel + 'px';
  }
}
