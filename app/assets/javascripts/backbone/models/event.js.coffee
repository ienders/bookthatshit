class window.Event extends Backbone.Model

  urlRoot: '/api/events'

  calendarFormat: -> moment(@get('date')).format 'MM-DD-YYYY'

  isYours: (session) -> session.email == @get('booked_by_email')

class window.Events extends Backbone.Collection

  model: Event

  url: '/api/events'