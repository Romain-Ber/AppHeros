import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["card"]

  connect() {
    //console.log(this.cardTargets)
    // Nouvel instance d'observer qui bouffe les projets
    const projectObserver = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          // Qu'est-ce qui se passe quand l'élément est visible
          entry.target.style.opacity = 1;
          entry.target.style.transform = "scale(1)";
        } else {
          // Qu'est-ce qui se passe quand il est pas visible
          entry.target.style.opacity = 0;
          entry.target.style.transform = "scale(1.3)";
        }
      });
    },
    {
      threshold: 0.25
    }
    );
    this.cardTargets.forEach((card, i) => {
      projectObserver.observe(card);
    });
  }
}

