import { Controller } from "@hotwired/stimulus"
let on=false

// Connects to data-controller="pixelate-image"
export default class extends Controller {
  static targets = [ "image", "input" ]
  connect() {
    console.log("ready to pixelate")
  }
  start(){
    on=!on
  }
  coordinates(e){
    if (on) {
      // const imgsrc = this.imageTarget.src
      const width = this.imageTarget.children[0].width
      const height = this.imageTarget.children[0].height
      // console.log(width)
      console.log(height)
      const x_touch = e.offsetX
      const y_touch = e.offsetY
      console.log(x_touch)
      console.log(y_touch)


      // this.imageTarget.children[0].src = `https://res.cloudinary.com/dvo1h6tp2/image/upload/e_blur_region:1000,h_50,w_50,x_${x_touch},y_${y_touch}/v1/development/${imgsrc}`

      fetch(`${window.location.pathname}?x=${x_touch}&y=${y_touch}&h=${height}&w=${width}`, {headers: {"Accept": "text/plain"}})
      .then(response => response.text())
      .then ((data) => {
        this.imageTarget.innerHTML = data
        this.inputTarget.value = this.imageTarget.children[0].src
        console.log(data)
      })

      // this.imageTarget.children[0].src = `https://res.cloudinary.com/demo/image/fetch/c_fill,e_pixelate_region,h_50,w_50,x_${x_touch},y_${y_touch}/${imgsrc}`
    }
  }
}
