import { Controller } from "@hotwired/stimulus"
import Typed from 'typed.js';

// Connects to data-controller="typed"
export default class extends Controller {
  static targets = ["test"]

  connect() {
    console.log("heyy")
  }

  display(){
    this.testTarget.style.display="flex"
    const typed = new Typed('.text', {
      strings: ['Receiving your photo...^1500','Breaking down your image ...^1500', ' Checking each photos risk levels....^1500', ' Building data...^1500', 'Comparing your data to our algorithm...^1500','Flagging areas with high risk....','Cleaning up...^1500'],
      typeSpeed: 100,
      backSpeed: 40,
    });
  }
}
