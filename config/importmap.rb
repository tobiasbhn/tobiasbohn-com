# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "snake", preload: true
pin "preserve_player_name", preload: true
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
pin "flowbite", to: "https://ga.jspm.io/npm:flowbite@1.4.1/dist/flowbite.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
