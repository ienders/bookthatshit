$.Calendario = (options, element) ->
  @$el = $(element)
  @_init options
  return

$.Calendario.defaults =  
  #
  #		you can also pass:
  #		month : initialize calendar with this month (1-12). Default is today.
  #		year : initialize calendar with this year. Default is today.
  #		caldata : initial data/content for the calendar.
  #		caldata format:
  #		{
  #			'MM-DD-YYYY' : 'HTML Content',
  #			'MM-DD-YYYY' : 'HTML Content',
  #			'MM-DD-YYYY' : 'HTML Content'
  #			...
  #		}
  #		
  weeks: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  weekabbrs: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
  months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  monthabbrs: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
  
  # choose between values in options.weeks or options.weekabbrs
  displayWeekAbbr: false
  
  # choose between values in options.months or options.monthabbrs
  displayMonthAbbr: false
  
  # left most day in the calendar
  # 0 - Sunday, 1 - Monday, ... , 6 - Saturday
  startIn: 1
  onDayClick: ($el, $content, dateProperties) ->
    false

$.Calendario:: =
  _init: (options) ->
    @options = $.extend(true, {}, $.Calendario.defaults, options)
    @today = new Date()
    @month = (if (isNaN(@options.month) or not @options.month?) then @today.getMonth() else @options.month - 1)
    @year = (if (isNaN(@options.year) or not @options.year?) then @today.getFullYear() else @options.year)
    @caldata = @options.caldata or {}
    @_generateTemplate()
    @_initEvents()

  _initEvents: ->
    self = this
    @$el.on "click", "div.fc-row > div", ->
      $cell = $(this)
      idx = $cell.index()
      $content = $cell.children("div")
      dateProp =
        day: $cell.children("span.fc-date").text()
        month: self.month + 1
        monthname: (if self.options.displayMonthAbbr then self.options.monthabbrs[self.month] else self.options.months[self.month])
        year: self.year
        weekday: idx + self.options.startIn
        weekdayname: self.options.weeks[idx + self.options.startIn]

      self.options.onDayClick $cell, $content, dateProp  if dateProp.day
  
  # Calendar logic based on http://jszen.blogspot.pt/2007/03/how-to-build-simple-calendar-with.html
  _generateTemplate: (callback) ->
    head = @_getHead()
    body = @_getBody()
    rowClass = undefined
    switch @rowTotal
      when 4
        rowClass = "fc-four-rows"
      when 5
        rowClass = "fc-five-rows"
      when 6
        rowClass = "fc-six-rows"
    @$cal = $("<div class=\"fc-calendar " + rowClass + "\">").append(head, body)
    @$el.find("div.fc-calendar").remove().end().append @$cal
    callback.call()  if callback

  _getHead: ->
    html = "<div class=\"fc-head\">"
    i = 0

    while i <= 6
      pos = i + @options.startIn
      j = (if pos > 6 then pos - 6 - 1 else pos)
      html += "<div>"
      html += (if @options.displayWeekAbbr then @options.weekabbrs[j] else @options.weeks[j])
      html += "</div>"
      i++
    html += "</div>"
    html

  _getBody: ->
    d = new Date(@year, @month + 1, 0)
    
    # number of days in the month
    monthLength = d.getDate()
    firstDay = new Date(@year, @month, 1)
    
    # day of the week
    @startingDay = firstDay.getDay()
    html = "<div class=\"fc-body\"><div class=\"fc-row\">"
    
    day = 1
    i = 0
    while i < 7
      j = 0
      while j <= 6
        pos = @startingDay - @options.startIn
        p = (if pos < 0 then 6 + pos + 1 else pos)
        inner = ""
        today = @month is @today.getMonth() and @year is @today.getFullYear() and day is @today.getDate()
        content = ""
        if day <= monthLength and (i > 0 or j >= p)
          inner += "<span class=\"fc-date\">" + day + "</span><span class=\"fc-weekday\">" + @options.weekabbrs[(if j + @options.startIn > 6 then j + @options.startIn - 6 - 1 else j + @options.startIn)] + "</span>"
          
          strdate = ((if @month + 1 < 10 then "0" + (@month + 1) else @month + 1)) + "-" + ((if day < 10 then "0" + day else day)) + "-" + @year
          dayData = @caldata[strdate]
          if dayData
            if dayData instanceof Array
              content = dayData.join ' '
            else
              content = dayData
          inner += "<div>" + content + "</div>"  if content isnt ""
          ++day
        else
          today = false
        cellClasses = (if today then "fc-today " else "")
        cellClasses += "fc-content"  if content isnt ""
        html += (if cellClasses isnt "" then "<div class=\"" + cellClasses + "\">" else "<div>")
        html += inner
        html += "</div>"
        j++
      
      if day > monthLength
        @rowTotal = i + 1
        break
      else
        html += "</div><div class=\"fc-row\">"
      i++
    html += "</div></div>"
    html

  # based on http://stackoverflow.com/a/8390325/989439
  _isValidDate: (date) ->
    date = date.replace(/-/g, "")
    month = parseInt(date.substring(0, 2), 10)
    day = parseInt(date.substring(2, 4), 10)
    year = parseInt(date.substring(4, 8), 10)
    if (month < 1) or (month > 12)
      return false
    else if (day < 1) or (day > 31)
      return false
    else if ((month is 4) or (month is 6) or (month is 9) or (month is 11)) and (day > 30)
      return false
    else if (month is 2) and (((year % 400) is 0) or ((year % 4) is 0)) and ((year % 100) isnt 0) and (day > 29)
      return false
    else return false  if (month is 2) and ((year % 100) is 0) and (day > 29)
    day: day
    month: month
    year: year

  _move: (period, dir, callback) ->
    if dir is "previous"
      if period is "month"
        @year = (if @month > 0 then @year else --@year)
        @month = (if @month > 0 then --@month else 11)
      else @year = --@year  if period is "year"
    else if dir is "next"
      if period is "month"
        @year = (if @month < 11 then @year else ++@year)
        @month = (if @month < 11 then ++@month else 0)
      else @year = ++@year  if period is "year"
    @_generateTemplate callback

  getYear: ->
    @year

  getMonth: ->
    @month + 1

  getMonthName: ->
    (if @options.displayMonthAbbr then @options.monthabbrs[@month] else @options.months[@month])
  
  # gets the cell's content div associated to a day of the current displayed month
  # day : 1 - [28||29||30||31]
  getCell: (day) ->
    row = Math.floor((day + @startingDay - @options.startIn) / 7)
    pos = day + @startingDay - @options.startIn - (row * 7) - 1
    @$cal.find("div.fc-body").children("div.fc-row").eq(row).children("div").eq(pos).children "div"

  setData: (caldata) ->
    caldata = caldata or {}
    $.extend @caldata, caldata
    @_generateTemplate()
  
  addEvent: (date, value) ->
    @caldata[date] ||= []
    @caldata[date].push value
    @_generateTemplate()

  gotoNow: (callback) ->
    @month = @today.getMonth()
    @year = @today.getFullYear()
    @_generateTemplate callback
  
  goto: (month, year, callback) ->
    @month = month
    @year = year
    @_generateTemplate callback

  gotoPreviousMonth: (callback) ->
    @_move "month", "previous", callback

  gotoPreviousYear: (callback) ->
    @_move "year", "previous", callback

  gotoNextMonth: (callback) ->
    @_move "month", "next", callback

  gotoNextYear: (callback) ->
    @_move "year", "next", callback

$.fn.calendario = (options) ->
  instance = $.data(this, "calendario")
  if typeof options is "string"
    args = Array::slice.call(arguments_, 1)
    @each ->
      return unless instance
      return if not $.isFunction(instance[options]) or options.charAt(0) is "_"
      instance[options].apply instance, args
  else
    @each ->
      return instance._init() if instance
      instance = $.data(this, "calendario", new $.Calendario(options, this))
  instance