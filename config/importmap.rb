# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "mapbox-gl" # @3.1.2
pin "process" # @2.0.1
pin "glslCanvas" # @0.2.6
pin "global/window", to: "global--window.js" # @4.4.0
pin "is-function" # @1.0.2
pin "parse-headers" # @2.0.5
pin "xhr" # @2.6.0
pin "xtend" # @4.0.2
