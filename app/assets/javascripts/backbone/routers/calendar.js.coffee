class window.CalendarRouter extends Backbone.Router

  routes:
    '': 'main'

  main: ->
    $('#application-index').append new CalendarView().render().el