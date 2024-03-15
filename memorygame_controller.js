import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["mygame"];

  initialize() {
    this.cards = [
      {
        name: "logo_a",
        img: cl_image_tag("memoryimg/logo_a.png", { width: 200, height: 200, crop: "fill" }),
        id: 1,
      },
      {
        name: "logo_bavaria",
        img: cl_image_tag("memoryimg/logo_bavaria.png", { width: 200, height: 200, crop: "fill" }),
        id: 2
      },
      {
        name: "logo_efes",
        img: cl_image_tag("memoryimg/logo_efes.png", { width: 200, height: 200, crop: "fill" }),
        id: 3
      },
      {
        name: "logo_guinness",
        img: cl_image_tag("memoryimg/logo_guinness.png", { width: 200, height: 200, crop: "fill" }),
        id: 4
      },
      {
        name: "logo_kozel",
        img: cl_image_tag("memoryimg/logo_kozel.png", { width: 200, height: 200, crop: "fill" }),
        id: 5
      },
      {
        name: "logo_krusovice",
        img: cl_image_tag("memoryimg/logo_krusovice.png", { width: 200, height: 200, crop: "fill" }),
        id: 6
      },
      {
        name: "logo_leffe",
        img: cl_image_tag("memoryimg/logo_leffe.png", { width: 200, height: 200, crop: "fill" }),
        id: 7
      },
      {
        name: "logo_spaten",
        img: cl_image_tag("memoryimg/logo_spaten.png", { width: 200, height: 200, crop: "fill" }),
        id: 8
      },
      {
        name: "logo_stella",
        img: cl_image_tag("memoryimg/logo_stella.png", { width: 200, height: 200, crop: "fill" }),
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
      <div class="back"><img src="/assets/memoryimg/logo_appheros.png" /></div></div>
      </div>`;
    });
    return frag;
  }
}
