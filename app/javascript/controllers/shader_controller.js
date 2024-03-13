import { Controller } from "@hotwired/stimulus"
import glslCanvas from "glslCanvas"

export default class extends Controller {
  static targets = ["glslCanvas"]

  connect() {
    sandbox = new glslCanvas(this.glslCanvasTarget);
  }
}
