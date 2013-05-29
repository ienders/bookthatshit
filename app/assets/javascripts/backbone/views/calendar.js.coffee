class window.CalendarView extends Backbone.View

  events:
    'click .custom-next': 'nextMonth'
    'click .custom-prev': 'prevMonth'
    'click .custom-current': 'currentMonth'

  render: ->
    @$el.html(JST['calendar']())
    @cal = @$('.fc-calendar-container').calendario
      onDayClick: ($el, $contentEl, dateProperties) ->
        for key of dateProperties
          console.log key + ' = ' + dateProperties[key]
      caldata:
        '06-01-2012': 'Party Time'
    # @cal.setData({ '06-01-2012' : '...', ... })
    # @cal.goto(3,2013, updateMonthYear)
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