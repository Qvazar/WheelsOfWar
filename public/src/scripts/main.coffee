requirejs.config
    paths: {
        'text': '../lib/requirejs-plugins/src/text',
        'image': '../lib/requirejs-plugins/src/image',
        'json': '../lib/requirejs-plugins/src/json',
        #'knockout': '../lib/knockout.js/knockout',
        #'bootstrap': '../lib/bootstrap/dist/js/bootstrap',
        'jquery': '../lib/jquery/jquery',
        #'socket.io': '/socket.io/socket.io',
        'underscore': '../lib/underscore/underscore'
        #'lazy': '../lib/lazy/dist/lazy',
        'requestAnimationFrame': '../shims/requestAnimationFrame',
        'newton': '../lib/newton/newton'
    },
    shim: {
      'requestAnimationFrame': {
        exports: 'requestAnimationFrame'
      },
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
  ['engine/log', 'engine/Engine', 'engine/components/Component', 'engine/components/Html'],
  (log, Engine, Component, HtmlComponent) ->
    log.debugEnabled = yes

    class Rotator extends HtmlComponent
      update: (context) ->
        @transformation.rotation += Math.PI / 16
        super
      render: (context) ->
        @get('rootHtml').element.innerText = context.fps
        super

    rootComponent = new Rotator()
    rootComponent.add
      rootHtml: html = new HtmlComponent({width:10, height:10, cssClasses: 'root-node'})

    mainView = document.getElementById('mainView')

    engine = new Engine({rootComponent, updateInterval: 500})

    mainView.innerHTML = ''
    mainView.appendChild rootComponent.element
    engine.start()
)