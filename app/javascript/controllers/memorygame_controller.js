import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["mygame"];

  initialize() {
    this.cards = [
      {
        name: "logo_a",
        img: "https://res.cloudinary.com/deetrshgq/image/upload/w_200,h_200,c_fill/bewuwnxekpbj1fxxju3i",
        id: 1,
      },
      {
        name: "logo_bavaria",
        img: "https://res.cloudinary.com/deetrshgq/image/upload/w_200,h_200,c_fill/vg3zaqcikz8nwepjizgp",
        id: 2
      },
      {
        name: "logo_efes",
        img: "https://res.cloudinary.com/deetrshgq/image/upload/w_200,h_200,c_fill/tdsapubbmaypcqbovrxu",
        id: 3
      },
      {
        name: "logo_guinness",
        img: "https://res.cloudinary.com/deetrshgq/image/upload/w_200,h_200,c_fill/i7pcvyr7njjyiwffmn2q",
        id: 4
      },
      {
        name: "logo_kozel",
        img: "https://res.cloudinary.com/deetrshgq/image/upload/w_200,h_200,c_fill/nlrqjxlcdgpepiv9uezv",
        id: 5
      },
      {
        name: "logo_krusovice",
        img: "https://res.cloudinary.com/deetrshgq/image/upload/w_200,h_200,c_fill/c1unop3plskd13oi5dcn",
        id: 6
      },
      {
        name: "logo_leffe",
        img: "https://res.cloudinary.com/deetrshgq/image/upload/w_200,h_200,c_fill/tghqjnyv8vmk2oisinxa",
        id: 7
      },
      {
        name: "logo_spaten",
        img: "https://res.cloudinary.com/deetrshgq/image/upload/w_200,h_200,c_fill/brnpsguyspdtzzqevjth",
        id: 8
      },
      {
        name: "logo_stella",
        img: "https://res.cloudinary.com/deetrshgq/image/upload/w_200,h_200,c_fill/cbh3t1ijccrmab5sx9qn",
        id: 9
      },
    ];

    // this.cards = [
    //   {
    //     name: "logo_a",
    //     img: "/assets/memoryimg/logo_a.png",
    //     id: 1,
    //   },
    //   {
    //     name: "logo_bavaria",
    //     img: "/assets/memoryimg/logo_bavaria.png",
    //     id: 2
    //   },
    //   {
    //     name: "logo_efes",
    //     img: "/assets/memoryimg/logo_efes.png",
    //     id: 3
    //   },
    //   {
    //     name: "logo_guinness",
    //     img: "/assets/memoryimg/logo_guinness.png",
    //     id: 4
    //   },
    //   {
    //     name: "logo_kozel",
    //     img: "/assets/memoryimg/logo_kozel.png",
    //     id: 5
    //   },
    //   {
    //     name: "logo_krusovice",
    //     img: "/assets/memoryimg/logo_krusovice.png",
    //     id: 6
    //   },
    //   {
    //     name: "logo_leffe",
    //     img: "/assets/memoryimg/logo_leffe.png",
    //     id: 7
    //   },
    //   {
    //     name: "logo_spaten",
    //     img: "/assets/memoryimg/logo_spaten.png",
    //     id: 8
    //   },
    //   {
    //     name: "logo_stella",
    //     img: "/assets/memoryimg/logo_stella.png",
    //     id: 9
    //   },
    // ];

    this.shuffleCards();
    this.setup();
  }

  shuffleCards() {
    this.cards = this.shuffle(this.cards.concat(this.cards));
  }

  setup() {
    this.mygameTarget.innerHTML = this.buildHTML();
    this.memoryCards = this.mygameTarget.querySelectorAll(".card");
    this.paused = false;
    this.guess = null;
    this.binding();
  }

  binding() {
    this.memoryCards.forEach(card => {
      card.addEventListener("click", this.cardClicked.bind(this));
    });

    this.element.querySelector("button.restart").addEventListener("click", this.reset.bind(this));
  }

  cardClicked(event) {
    const card = event.currentTarget;
    if (!this.paused && !card.querySelector(".inside").classList.contains("matched") && !card.querySelector(".inside").classList.contains("picked")) {
      card.querySelector(".inside").classList.add("picked");
      if (!this.guess) {
        this.guess = card.getAttribute("data-id");
      } else if (this.guess === card.getAttribute("data-id") && !card.classList.contains("picked")) {
        document.querySelectorAll(".picked").forEach(pickedCard => pickedCard.classList.add("matched"));
        this.guess = null;
      } else {
        this.guess = null;
        this.paused = true;
        setTimeout(() => {
          document.querySelectorAll(".picked").forEach(pickedCard => pickedCard.classList.remove("picked"));
          this.paused = false;
        }, 600);
      }
      if (document.querySelectorAll(".matched").length === this.memoryCards.length) {
        this.win();
      }
    }
  }

  win() {
    this.paused = true;
    setTimeout(() => {
      this.showModal();
      this.mygameTarget.style.display = "none";
    }, 1000);
  }

  showModal() {
    this.element.querySelector(".modal-overlay").style.display = "block";
    this.element.querySelector(".modal").style.display = "block";
  }

  hideModal() {
    this.element.querySelector(".modal-overlay").style.display = "none";
    this.element.querySelector(".modal").style.display = "none";
  }

  reset() {
    this.hideModal();
    this.shuffleCards();
    this.setup();
    this.mygameTarget.style.display = "block";
  }

  shuffle(array) {
    let counter = array.length;
    while (counter > 0) {
      let index = Math.floor(Math.random() * counter);
      counter--;
      let temp = array[counter];
      array[counter] = array[index];
      array[index] = temp;
    }
    return array;
  }

  buildHTML() {
    let frag = '';
    this.cards.forEach(card => {
      frag += `<div class="card" data-id="${card.id}"><div class="inside">
      <div class="front"><img src="${card.img}" alt="${card.name}" /></div>
      <div class="back"><img src="https://res.cloudinary.com/deetrshgq/image/upload/v1710511106/zy9uqbjv1qhgppho7xxs.png" width="200" height="200" /></div></div>
      </div>`;
    });
    return frag;
  }
}
