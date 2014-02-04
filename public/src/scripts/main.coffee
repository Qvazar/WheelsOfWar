requirejs.config
    paths: {
        'text': '../lib/requirejs-plugins/src/text',
        'image': '../lib/requirejs-plugins/src/image',
        'json': '../lib/requirejs-plugins/src/json',
        #'knockout': '../lib/knockout.js/knockout',
        #'bootstrap': '../lib/bootstrap/dist/js/bootstrap',
        #'jquery': '../lib/jquery/jquery',
        #'socket.io': '/socket.io/socket.io',
        'underscore': '../lib/underscore/underscore'
        #'lazy': '../lib/lazy/dist/lazy',
        #'requestAnimationFrame': '../shims/requestAnimationFrame',
        'newton': '../lib/newton/newton'
    },
    shim: {
#      'requestAnimationFrame': {
#        exports: 'requestAnimationFrame'
#      },
      'newton': {
        exports: 'Newton'
      },
#        'bootstrap': {
#            deps: ['jquery'],
#            exports: 'jQuery'
#        },
#        'socket.io': {
#            exports: 'io'
#        },
      'underscore': {
          exports: '_'
      }
    }

define(
  ['engine/log', 'engine/Engine', 'engine/components/Viewport', 'engine/components/Html'],
  (log, Engine, Viewport, HtmlComponent) ->
    log.debugEnabled = yes

#    class Rotator extends HtmlComponent
#      update: (context) ->
#        @transformation.rotation += Math.PI / 16
#        super

#    rootComponent = new Rotator({width:10, height:10, cssClasses: 'root-node'})

    viewport = new Viewport()
    mainView = document.getElementById('mainView')

    engine = new Engine({viewport})

    viewport.element.style.backgroundColor = 'skyblue'

    mainView.innerHTML = ''
    mainView.appendChild viewport.element
    engine.start()

    window.engine = engine;
)