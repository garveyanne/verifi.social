import { Controller } from "@hotwired/stimulus"
let on=false

// Connects to data-controller="pixelate-image"
export default class extends Controller {
  static targets = [ "image", "input"]
  connect() {
    console.log("ready to pixelate")
    console.log(this.imageTarget.children[0].src);
  }
  start(){
    on=!on
  }
  coordinates(e){
    if (on) {
      const imgsrc = this.imageTarget.children[0].src.split("/")[this.imageTarget.children[0].src.split("/").length - 1]
      const x_touch = e.offsetX
      const y_touch = e.offsetY

      // this.imageTarget.children[0].src = `https://res.cloudinary.com/di4ap7ugr/image/upload/e_blur_region:1000,h_50,w_50,x_${x_touch},y_${y_touch}/v1/development/${imgsrc}`

      fetch(`${window.location.pathname}?x=${x_touch}&y=${y_touch}`, {headers: {"Accept": "text/plain"}})
      .then(response => response.text())
      .then ((data) => {
        this.imageTarget.innerHTML = data
        this.inputTarget.value = this.imageTarget.children[0].src
      })

      // this.imageTarget.children[0].src = `https://res.cloudinary.com/demo/image/fetch/c_fill,e_pixelate_region,h_50,w_50,x_${x_touch},y_${y_touch}/${imgsrc}`
    }
  }
}
