$ ->
  updateMonthYear = ->
    $month.html cal.getMonthName()
    $year.html cal.getYear()

  cal = $('#calendar').calendario
    onDayClick: ($el, $contentEl, dateProperties) ->
      for key of dateProperties
        console.log key + ' = ' + dateProperties[key]
    caldata:
      '06-01-2012': 'Party Time'

  $month = $('#custom-month').html cal.getMonthName()
  $year = $('#custom-year').html cal.getYear()
  
  $('#custom-next').on 'click', -> cal.gotoNextMonth updateMonthYear
  $('#custom-prev').on 'click', -> cal.gotoPreviousMonth updateMonthYear
  $('#custom-current').on 'click', -> cal.gotoNow updateMonthYear

  # cal.setData({ '06-01-2012' : '...', ... })
  # cal.goto(3,2013, updateMonthYear)