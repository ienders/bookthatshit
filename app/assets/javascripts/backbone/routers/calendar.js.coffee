class window.CalendarRouter extends Backbone.Router

  routes:
    '': 'main'

  main: ->
    window.session = $('#session').data('session')
    events = new Events()
    events.on 'reset', ->
      $('#application-index').append new CalendarView(collection: events).render().el
    events.fetch()