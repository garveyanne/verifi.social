import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

$(document).on('turbolinks:request-start', function () {
  NProgress.start();
});

$(document).on('turbolinks:load', function () {
  NProgress.done();
});
