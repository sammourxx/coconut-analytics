$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$  = $
moment = require 'moment'
Pikaday = require 'pikaday'

class DateSelectorView extends Backbone.View
  el: "#dateSelector"

  events:
    "change #select-by": "selectBy"
    "click .submitBtn": "updateReportView"
    "click button#dateFilter": "showDateFilter"

  showDateFilter: (e) =>
    e.preventDefault
    $("div#filters-section").slideToggle()

  updateReportView: (e) =>
    e.preventDefault
    startDate = $('#startDate').val()
    endDate = $('#endDate').val()
    
    if $('#select-by :selected').text() is "Week"
      startYearWeek = "#{$('[name=StartYear]').val()}-#{$('[name=StartWeek]').val()}"
      endYearWeek = "#{$('[name=EndYear]').val()}-#{$('[name=EndWeek]').val()}"

      startDate = moment( startYearWeek, 'YYYY-W').startOf("isoweek").format("YYYY-MM-DD")
      endDate = moment( endYearWeek, 'YYYY-W').endOf("isoweek").format("YYYY-MM-DD")
   
    # TODO
    # Select by week should update the startDate/endDate
    # Select by date should update the startWeek/endWeek (tricky because they don't line up)
    if moment(startDate, 'YYYY-MM-DD', true).isValid() and moment(endDate, 'YYYY-MM-DD', true).isValid()
      if !(moment(endDate).isSameOrAfter(moment(startDate)))
        $('#errMsg').html("End Date must be equal or after Start Date")
      else
        $("div#filters-section").slideToggle()
        # Update the URL and rerender page
        Coconut.reportDates.startDate = startDate
        Coconut.reportDates.endDate = endDate
      
        url = "#{Coconut.dateSelectorView.reportType}/"+("#{option}/#{value}" for option,value of Coconut.router.reportViewOptions).join("/")
        Coconut.router.navigate(url,{trigger: true})
    else
      $('#errMsg').html("Invalid Date Format detected")

  selectBy: (e) =>
    selected = $('#select-by :selected').text()
    if (selected == 'Date')
      $('tr.select-by-date').show()
      $('tr.select-by-week').hide()
    else
      $('tr.select-by-date').hide()
      $('tr.select-by-week').show()

  render: =>
    @$el.html "
      <div id='date-range'>
        <span id='filters-drop' class='drop-pointer'>
          <button class='mdl-button mdl-js-button mdl-button--icon' id='dateFilter'> 
            <i class='material-icons'>event</i> 
          </button> 
        </span>
        <span id='date-period'>#{@startDate} to #{@endDate}</span>
        <div><small><i>Click calendar icon to change date</i></small></div>
        <div id='filters-section'>
          <hr />
          <table style='width: 400px; margin-left: 30px'>
            <tbody>
               <tr id='select-date-week'>
                 <td colspan='2'>Select By</td>
                 <td><select name='SelectBy' id='select-by'> 
                    <option value='Week'>Week</option>
                    <option value='Date'>Date</option></select>
                 </td>
                <td clospan='4'> &nbsp; </td>
               </tr>
               <tr class='select-by-date hide'>
                   <td colspan='2'>
                     <label style='display:inline' for='StartDate'>Start Date</label>
                   </td>
                   <td>
                      <div><input id='startDate' class='datepicker' value='#{@startDate}'></input></div>
                   </td>
                   <td colspan='4'> </td>
               </tr>
               <tr class='select-by-date hide'>	   
                   <td colspan='2'>
                     <label style='display:inline' for='EndDate'>End Date</label>
                   </td>
                   <td>
                      <div><input id='endDate' class='datepicker' value='#{@endDate}'></input></div>
                   </td>
                   <td colspan='4'><button class='mdl-button mdl-js-button mdl-button--raised mdl-button--colored submitBtn'>Submit</button></td>
               </tr>	   
               <tr class='select-by-week'>
                 <td colspan='2'>
                   <label style='display:inline' for='StartYear'>Start Year</label>
                 </td>
                 <td>
                   <select name='StartYear'>
                     #{
                       for i in [moment().year()..2012]
                          "<option value='#{i}'>#{i}</option>"
                     }
                   </select>
                 </td>
                 <td> </td>
                 <td colspan='2'>
                   <label style='display:inline' for='StartWeek'>Start Week</label>
                 </td>
                 <td>
                   <select name='StartWeek'> <option></option>
                     #{
                         for i in [1..53]
                           "<option value='#{i}'>Week #{i}</option>"
                     } 
                   </select>
                 </td>
               </tr>
               <tr class='select-by-week'>
                   <td colspan='2'>
                     <label style='display:inline' for='EndYear'>End Year</label>
                   </td>
                   <td>
                     <select name='EndYear'> 
                        #{
                            for i in [moment().year()..2012]
                              "<option value='#{i}'>#{i}</option>"
                        }
                      </select>
                   </td>
                   <td> </td>
                   <td colspan='2'>
                      <label style='display:inline' for='EndWeek'>End Week</label>
                   </td>
                   <td>
                      <select name='EndWeek'><option></option>
                        #{
                            for i in [1..53] 
                              "<option value='#{i}'>Week #{i}</option>" 
                        }
                      </select>
                   </td>
                   <td><button class='mdl-button mdl-js-button mdl-button--raised mdl-button--colored submitBtn'>Submit</button></td> 
               </tr>
               <tr>
                   <td colspan='5'><div id='errMsg'></div></td>
               </tr>	
             </tbody>
           </table>
           
           <hr />
         </div>
       </div>
    "
    startDatePicker = new Pikaday
      field: $(".datepicker")[0]
      position: "bottom right"
      reposition: false
    endDatePicker = new Pikaday
      field: $(".datepicker")[1]
      position: "bottom right"
      reposition: false

module.exports = DateSelectorView
