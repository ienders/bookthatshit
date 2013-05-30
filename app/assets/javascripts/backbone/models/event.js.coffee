class window.Event extends Backbone.Model

  urlRoot: '/api/events'

  calendarFormat: -> moment(@get('starts_at')).format 'MM-DD-YYYY'

class window.Events extends Backbone.Collection

  model: Event

  url: '/api/events'