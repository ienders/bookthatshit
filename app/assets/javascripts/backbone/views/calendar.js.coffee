class window.CalendarView extends Backbone.View

  events:
    'click .custom-next': 'nextMonth'
    'click .custom-prev': 'prevMonth'
    'click .custom-current': 'currentMonth'

  render: ->
    @$el.html JST['calendar']()
    @cal = @$('.fc-calendar-container').calendario
      onDayClick: @onDayClick
      caldata: _(@collection.models).reduce (memo, event) ->
        memo[event.calendarFormat()] ||= []
        memo[event.calendarFormat()].push event.get('description')
        memo
      , {}
    @updateMonthYear()
    @

  nextMonth: ->
    @cal.gotoNextMonth()
    @updateMonthYear()

  prevMonth: ->
    @cal.gotoPreviousMonth()
    @updateMonthYear()

  currentMonth: ->
    @cal.gotoNow()
    @updateMonthYear()

  updateMonthYear: ->
    @$('.custom-month').html @cal.getMonthName()
    @$('.custom-year').html @cal.getYear()

  onDayClick: ($el, $contentEl, date) =>
    description = prompt('Enter a description for your booking:')
    return unless description
    event = new Event
      description: description
      date: "#{date.year}-#{date.month}-#{date.day}"
    event.save {},
      success: => @cal.addEvent(event.calendarFormat(), description)