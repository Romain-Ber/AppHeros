import { Controller } from "@hotwired/stimulus";
import JSConfetti from "js-confetti";

export default class extends Controller {
  static values = { userId: Number, challengeId: Number };
  static targets = ["beerLevel", "title", "foam", "continueButton", "countdown", "beerContainer"];
  score = 400; // Start with full glass
  gameStarted = false;

  initialize() {
    this.startCountdown();
  }

  startCountdown() {
    this.count = 3;
    const countdownInterval = setInterval(() => {
      if (this.count === 0) {
        clearInterval(countdownInterval);
        this.countdownTarget.innerText = 'GO!';
        setTimeout(() => {
          this.countdownTarget.remove();
          this.startGame();
        }, 1000);
      } else {
        this.countdownTarget.innerText = this.count;
        this.count--;
      }
    }, 1000);
  }

  startGame() {
    this.titleTarget.innerHTML = "C'est parti !<br><br>";
    this.gameStarted = true;
  }

  endGame() {
    var jsConfetti = new JSConfetti();
    jsConfetti.addConfetti({
      confettiColors: [
        '#AB3B3A', '#7D2224', '#FFAC4A', '#FFD363', '#826645', '#45220A',
      ],
    });
    const pageTitle = document.querySelector('.appheros-content-title h1');
    this.gameStarted = false;

    pageTitle.innerText = "Gagné !";
    this.titleTarget.innerText = 'Tu as vidé ta chope avec une rapidité remarquable compagnon !';
    setTimeout(() => {
      // redirect to result of current challenge id
      window.location.href = `/challenges/${this.challengeIdValue}/result`;
    }, 2000);

    // Update du challenge winner & loser en DB
    const url = `/challenges/${this.challengeIdValue}/update_winner?winner_id=${this.userIdValue}`;
    fetch(url, {
      headers: { "Accept": "text/plain" },
      method: "GET"
    })
      .then(response => response.text())
      .then((data) => {
        console.log(data);
      });
  }

  tap() {
    if (this.gameStarted) {
      this.score -= 10; // Decrease by 10 pixels with each click
      if (this.score <= 0) {
        this.score = 0;
        this.endGame();
      }
      this.updateBeerGlass(this.score);
    }
  }

  updateBeerGlass(score) {
    let beerLevel = score; // Set beer level to current score
    const beerLevelMax = 400; // Maximum height of the bar in pixels
    if (beerLevel < 0) {
      beerLevel = 0; // Ensure beer level doesn't go below 0
    }
    this.beerLevelTarget.style.height = beerLevel + 'px';
    this.foamTarget.style.bottom = beerLevel + 'px';
  }
}
