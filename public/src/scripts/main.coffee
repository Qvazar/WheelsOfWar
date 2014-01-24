requirejs.config
    paths: {
        'text': '../lib/requirejs-plugins/src/text',
        'image': '../lib/requirejs-plugins/src/image',
        'json': '../lib/requirejs-plugins/src/json',
        #'knockout': '../lib/knockout.js/knockout',
        #'bootstrap': '../lib/bootstrap/dist/js/bootstrap',
        'jquery': '../lib/jquery/jquery',
        #'socket.io': '/socket.io/socket.io',
        #'underscore': '../lib/underscore/underscore'
        'lazy': '../lib/lazy/dist/lazy'
    },
    shim: {
#        'bootstrap': {
#            deps: ['jquery'],
#            exports: 'jQuery'
#        },
#        'socket.io': {
#            exports: 'io'
#        },
#        'underscore': {
#            exports: '_'
#        }
    }

define [], () ->
  # TODO load and start the game!