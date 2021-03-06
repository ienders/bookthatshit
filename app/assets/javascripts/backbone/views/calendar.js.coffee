class window.CalendarView extends Backbone.View

  events:
    'click .custom-next': 'nextMonth'
    'click .custom-prev': 'prevMonth'
    'click .custom-current': 'currentMonth'

  initialize: ->
    @collection.on 'add', @redraw, @
    @collection.on 'remove', @redraw, @

  render: ->
    @$el.html JST['calendar']()
    @cal = @$('.fc-calendar-container').calendario onDayClick: @onDayClick
    @updateMonthYear()
    @$('.fc-calendar-container').on('click', 'div.fc-row > div .remove-event', @removeEvent)
    @redraw()
    @

  nextMonth: ->
    @cal.gotoNextMonth @updateMonthYear

  prevMonth: ->
    @cal.gotoPreviousMonth @updateMonthYear

  currentMonth: ->
    @cal.gotoNow @updateMonthYear

  updateMonthYear: =>
    @$('.custom-month').html @cal.getMonthName()
    @$('.custom-year').html @cal.getYear()

  onDayClick: ($el, $contentEl, date) =>
    description = prompt('Enter a description for your booking:')
    return unless description
    event = new Event
      description: description
      date: "#{date.year}-#{date.month}-#{date.day}"
    event.save {}, success: => @collection.add event

  removeEvent: (e) =>
    return false unless confirm('Are you sure you want to remove this booking?')
    link = $(e.currentTarget)
    event = @collection.get link.data('id')
    event.destroy success: => @collection.remove event
    false

  redraw: ->
    @cal.resetEvents _(@collection.models).reduce (memo, event) ->
        memo[event.calendarFormat()] ||= []
        memo[event.calendarFormat()].push JST['event'](event: event)
        memo
      , {}