$ ->
  if $('#application-index').size() > 0
    window.app = new CalendarRouter()
    Backbone.history.start()