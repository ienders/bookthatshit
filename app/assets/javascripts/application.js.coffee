#= require jquery
#= require hamlcoffee
#= require moment
#= require underscore
#= require backbone
#= require backbone/bookthatshit
#= require_tree .


$ ->
  if $('#application-index').size() > 0
    window.app = new CalendarRouter()
    Backbone.history.start()