import { Controller } from "@hotwired/stimulus"
import JSConfetti from "js-confetti"

export default class extends Controller {
  static values = {userId: Number, challengeId: Number}
  static targets = ["beerLevel", "title", "foam", "continueButton"]
  score = 0;
  gameStarted = false;

  initialize() {
    this.countdown();
  }

  countdown() {
    const countdownText = document.createElement('div');
    countdownText.id = 'countdown';
    document.getElementById('game-container').appendChild(countdownText);

    let count = 3;
    const countdownInterval = setInterval(() => {
      if (count === 0) {
        clearInterval(countdownInterval);
        countdownText.innerText = 'GO!';
        setTimeout(() => {
          countdownText.remove();
          this.startGame();
        }, 1000);
      } else {
        countdownText.innerText = count;
        count--;
      }
    }, 1000);
  }

  startGame() {
    this.titleTarget.innerHTML = "C'est parti !<br><br>";
    this.score = 0;
    this.gameStarted = true;
  }

  endGame() {
    var jsConfetti = new JSConfetti()
    jsConfetti.addConfetti({
      confettiColors: [
        '#AB3B3A', '#7D2224', '#FFAC4A', '#FFD363', '#826645', '#45220A',
      ],
    });
    const pageTitle = document.querySelector('.appheros-content-title h1');
    this.gameStarted = false;

    pageTitle.innerText = "Gagné !";
    this.titleTarget.innerText = 'Bravo ! Score: ' + this.score;
    this.continueButtonTarget.style.display = 'block'

    // Update du challenge winner & loser en DB
    // Id du winner = userId
    // Faire une requête HTTP (AJAX) avec fetch sur une route existante
    const url = `/challenges/${this.challengeIdValue}/update_winner?winner_id=${this.userIdValue}`
    fetch(url, {
      headers: {"Accept": "text/plain"},
      method: "GET"
    })
    .then(response => response.text())
    .then((data) => {
      console.log(data)
    })
  }

  tap() {
    if (this.gameStarted) {
      this.score += 1;
      this.titleTarget.innerHTML = `Score: ${this.score} <br><br>`;
      this.updateBeerGlass(this.score);
    }
  }

  updateBeerGlass(score) {
    let increment = 10; // Augmenter de 20 pixels à chaque clic
    let beerLevel = parseFloat(this.beerLevelTarget.style.height) || 0;
    let newBeerLevel = beerLevel + increment;
    let beerLevelMax = 400; // Hauteur maximale de la barre en pixels
    if (newBeerLevel > beerLevelMax) {
      newBeerLevel = beerLevelMax; // Limiter la hauteur maximale de la barre
    }
    this.beerLevelTarget.style.height = newBeerLevel + 'px';
    this.foamTarget.style.bottom = newBeerLevel + 'px';
    if (newBeerLevel === beerLevelMax) {
      this.endGame()
    }
  }
}
