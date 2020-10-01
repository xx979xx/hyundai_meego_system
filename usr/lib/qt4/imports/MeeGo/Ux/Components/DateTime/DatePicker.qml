/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass DatePicker
  \section1 DatePicker
  \qmlcm Displays control elements to choose a date by day, month and year. The values
         can either be chosen using the three PopupLists at the top or by the calender
         grid in the center.
         The min... and max... properties can be used to restrict the choosable date
         to a specific date. Selecting a date outside that range will disable the ok
         button. Make sure valid values for min and max are set, otherwise the datePicker
         might not work as expected.

  \section1  API properties

  \qmlproperty string title
  \qmlcm title of the date picker dialogs. This is defined in ModalDialog.

  \qmlproperty variant selectedDate
  \qmlcm contains the currently selected date.

  \qmlproperty int startYear
  \qmlcm sets the first year available in the year spinner, needs a positive value smaller or equal to endYear.

  \qmlproperty int endYear
  \qmlcm sets the last year available in the year spinner, needs a positive value bigger or equal to startYear.

  \qmlproperty int minYear
  \qmlcm sets the first selectable year, needs a positive value smaller or equal to maxYear.

  \qmlproperty int minMonth
  \qmlcm sets the first selectable month, needs a value from 1 to 12.

  \qmlproperty int minDay
  \qmlcm sets the first selectable day, needs a value from 1 to 31.

  \qmlproperty int maxYear
  \qmlcm sets the last selectable year, needs a positive value bigger or equal to minYear.

  \qmlproperty int maxMonth
  \qmlcm sets the last selectable month, needs a value from 1 to 12.

  \qmlproperty int maxDay
  \qmlcm sets the last selectable day, needs a value from 1 to 31.

  \qmlproperty bool isDateInRange
  \qmlcm true if the selected date is in range of the min and max values.

  \section1  Private properties (for internal use only)

  \qmlproperty list<string> daysOfWeek
  \qmlcm contains the names of the days in a week.

  \qmlproperty list<string> shortMonths
  \qmlcm contains the names of the months shortened to the first three characters.

  \qmlproperty list<string> fullMonths
  \qmlcm contains the full names of the months.

  \qmlproperty variant dayModel
  \qmlcm contains a listModel for the days.

  \qmlproperty variant monthModel
  \qmlcm contains a listModel for the months.

  \qmlproperty variant yearModel
  \qmlcm contains a listModel for the years.

  \section1  Signals
  \qmlproperty [signal] dateSelected
  \qmlcm emitted when ok button is clicked, propagates the selected date.
        \param variant date
        \qmlcm holds a Date object.\endparam

  \section1  Functions

  \qmlfn setSelectedDate
  \qmlcm sets the current date to the given values.
  \param int  newDay \endparam
  \param int  newMonth \endparam
  \param int  newYear \endparam

  \qmlfn show
  \qmlcm fades the picker in, inherited from ModalFog.

  \qmlfn hide
  \qmlcm fades the picker out, inherited from ModalFog.

  \qmlfn today
  \qmlcm returns the current date, internal use only.
        \retval variant date
        \qmlcm the current date \endretval

  \qmlfn isCurrentDate
  \qmlcm returns true if parameter date matches the current date, internal use only.
        \param   date    \qmlcm date object.\endparam
        \retval  bool	 \qmlcm true if the parameter date matches the current date \endretval

  \qmlfn daysInMonth
  \qmlcm returns the number of days of month mm in year yyyy, internal use only.
  \param int    mm  \endparam
  \param int    yyyy \endparam
  \retval  integer the number of days in the given month and year \endretval

  \qmlfn isSelectedDate
  \qmlcm returns true if the currently selected date is dd-mm-yyyy, internal use only.
  \param   int  dd  \endparam
  \param   int  mm  \endparam
  \param   int  yyyy   \endparam
  \retval  bool    true if the currently selected date matches the given date \endretval

  \qmlfn nexthMonth
  \qmlcm returns the index of the following month, internal use only.
  \param   Date refDate \endparam
  \retval  int    the index of the following month \endretval

  \qmlfn prevMonth
  \qmlcm returns the index of the former month, internal use only.
  \param   Date refDate \endparam
  \retval  int    the index of the former month \endretval

  \qmlfn setFuturePast
  \qmlcm checks if the currently selected date is in the future or the past and
         sets the properties isFuture and isPast accordingly.

  \qmlfn updateSelectedDate
  \qmlcm updates the day model if necessary, updates the spinners and sets the selected date.
  \param   int  d   the new day \endparam
  \param   int  m   the new month \endparam
  \param   int  y   the new year \endparam

  \qmlfn setDays
  \qmlcm updates the selected day.
  \param   int  d    the new day \endparam
  \param   int  m    the new month \endparam
  \param   int  y    the new year \endparam

  \qmlfn changeDayModel
  \qmlcm updates the day model if necessary.
  \param   int  d    the new day \endparam
  \param   int  m    the new month \endparam
  \param   int  y    the new year \endparam

  \qmlfn updateYears
  \qmlcm called when minYear or maxYear have been changed. Updates the year model to contain only
         the years from minYear to maxYear and sets the selected year into that range if needed.
         At the end updateSelectedDate is called to propagate the new date and selection.

  \qmlfn checkSelectedDate
  \qmlcm checks if the given date is in the range given by the properties minYear, minMonth,
         minDay, maxYear, maxMonth and maxDay
  \param   int  d    the given day \endparam
  \param   int  m    the given month \endparam
  \param   int  y    the given year \endparam

  \section1  Example
  \code
      //a button labeled with the selected date
      Button {
          id: dateButton

          DatePicker {
              id: datePicker

              onDateSelected: {
                  dateButton.text = //TODO: where does Date come from?
              }
          }

          onClicked: {
              datePicker.show()
          }
      }
  \endcode
*/

import Qt 4.7
import MeeGo.Components 0.1

ModalDialog {
    id: datePicker

    property variant selectedDate

    property int startYear: 1700
    property int endYear: 2300

    property int minYear: startYear
    property int minMonth: 1
    property int minDay: 1
    property int maxYear: endYear
    property int maxMonth: 12
    property int maxDay: 31
    property bool isDateInRange: true

    property variant daysOfWeek: [ qsTr("Sun"),
                                   qsTr("Mon"),
                                   qsTr("Tue"),
                                   qsTr("Wed"),
                                   qsTr("Thu"),
                                   qsTr("Fri"),
                                   qsTr("Sat") ]

    property variant shortMonths: [ qsTr("Jan"),
                                    qsTr("Feb"),
                                    qsTr("Mar"),
                                    qsTr("Apr"),
                                    qsTr("May"),
                                    qsTr("Jun"),
                                    qsTr("Jul"),
                                    qsTr("Aug"),
                                    qsTr("Sep"),
                                    qsTr("Oct"),
                                    qsTr("Nov"),
                                    qsTr("Dec") ]

    property variant fullMonths: [  qsTr('January'),
                                    qsTr('February'),
                                    qsTr('March'),
                                    qsTr('April'),
                                    qsTr('May'),
                                    qsTr('June'),
                                    qsTr('July'),
                                    qsTr('August'),
                                    qsTr('September'),
                                    qsTr('October'),
                                    qsTr('November'),
                                    qsTr('December') ]

    property variant dayModel: dummyListModel
    property variant monthModel: dummyListModel
    property variant yearModel: dummyListModel

    property bool isFuture: false
    property bool isPast: false

    property int month: -1
    property int day: -1
    property int year: -1

    property variant oldDate

    property bool allowUpdates: true

    property bool acceptBlocked: false

    //these five properties are only meant to be used in the widgetgallery for
    //demonstration purposes. Don't use them in your applications since they
    //could be removed at any time.
    property alias dateOrder: popupRow.dateOrder
    property alias dateUnitOneText: dateUnitOne.text
    property alias dateUnitTwoText: dateUnitTwo.text
    property alias dateUnitThreeText: dateUnitThree.text
    property alias dateUnitFourText: dateUnitFour.text

    signal dateSelected( variant date )

    function setSelectedDate( newDay, newMonth, newYear ) {
        var newDate = new Date( newYear, newMonth - 1, newDay )
        selectedDate = newDate
    }

    function today() {
        var currentDate = new Date()
        month = currentDate.getMonth()
        day = currentDate.getDate()
        year = currentDate.getFullYear()

        return currentDate
    }

    function isCurrentDate( date ) {
        var currentDate = new Date()
        if (
                ( date.getDate() == currentDate.getDate() ) &&
                ( date.getMonth() == currentDate.getMonth() ) &&
                ( date.getFullYear() == currentDate.getFullYear() )
            )
            return true
        else
            return false;
    }

    function daysInMonth(mm, yyyy) {
        return 32 - new Date(yyyy, mm, 32).getDate();
    }

    function isSelectedDate(dd, mm, yyyy) {
        return ( selectedDate.getFullYear() == yyyy &&
                selectedDate.getMonth() == mm &&
                selectedDate.getDate() == dd )
    }

    function nextMonth(refDate) {
        if ( refDate.getMonth() == 11 )
            return 0
        else
            return refDate.getMonth() + 1
    }

    function prevMonth( refDate ) {
        if ( refDate.getMonth() == 0 )
            return 11
        else
            return refDate.getMonth() - 1
    }

    function getShortMonth(index) {
        var monName = new String(outer.shortMonths[index]) ;
        return monName;
    }

    function createDate( y, m, d ) {
        var dateVal = new Date( y, m, d );
        return dateVal;
    }

    function getTagValue(type,index) {
        var val;
        if( type == 1 ) {
            val = dModel.get(index).tag;
        } else if( type == 2 ) {
            val = mModel.get(index).tag;
        } else if( type == 3 ) {
            val = yModel.get(index).tag;
        }
        return val;
    }

    function setFuturePast() {
        var todaysDate = today()
        var selectedDay = selectedDate.getDate()
        var selectedMonth = selectedDate.getMonth()
        var selectedYear = selectedDate.getFullYear()
        var todaysDay = todaysDate.getDate()
        var todaysMonth = todaysDate.getMonth()
        var todaysYear = todaysDate.getFullYear()

        if( selectedYear > todaysYear ) {
            isFuture = true
            isPast = false
            return
        }else if( selectedYear == todaysYear ) {
            if( selectedMonth > todaysMonth ) {
                isFuture = true
                isPast = false
                return
            }else if ( selectedMonth == todaysMonth ) {
                if( selectedDay > todaysDay ) {
                    isFuture = true
                    isPast = false
                    return
                }else if( selectedDay == todaysDay ) {
                    isFuture = false
                    isPast = false
                    return
                }else{
                    isFuture = false
                    isPast = true
                    return
                }
            }else{
                isFuture = false
                isPast = true
                return
            }
        }else {
            isFuture = false
            isPast = true
            return
        }
    }

    function updateSelectedDate( d, m, y ) {

        if( allowUpdates ) {
            allowUpdates = false
        }else {
            return
        }

        if( d > 15 ) {
            dayButton.value = "1"
        }else {
            dayButton.value = ( daysInMonth( selectedDate.getMonth(), selectedDate.getFullYear() ) ).toString()
        }
        dayButton.reInit()

        monthButton.value = shortMonths[m]
        monthButton.reInit()

        yearButton.value = y.toString()
        yearButton.reInit()

        changeDayModel( d, m, y )

        var newDay = setDays( d, m, y )
        dayButton.value = newDay.toString()
        dayButton.reInit()

        var tempDate = createDate( y, m, newDay )
        selectedDate = tempDate
        calendarView.calendarShown = tempDate

        setFuturePast() //check if the selected date is in the future or past
        isDateInRange = checkSelectedDate( newDay, m + 1, y ) //check if the selected date is in the range given by minYear, ..., maxYear

        allowUpdates = true
    }

    function setDays( d, m, y ) {
        var daysCount = daysInMonth( m, y )
        var retDay = d
        if( d > daysCount ) {
            retDay = daysCount
        }
        return retDay
    }
    function changeDayModel( d, m, y ){
        var daysCount = daysInMonth( m, y )
        if( dModel.count > daysCount ){
            while( dModel.count > daysCount ) {
                dModel.remove( dModel.count - 1 )
            }
        }else if( dModel.count < daysCount ) {
            for( var i = dModel.count; i < daysCount; i++ ) {
                dModel.append( { "tag": i + 1 } );
            }
        }
    }

    function checkSelectedDate( d, m, y ) {
        var day = d
        var month = m
        var year = y

        if( year < minYear || year > maxYear ) { //selected year is not in range
            return false
        }else if( minYear == maxYear ) { //selected year is in range and year range has size one
            if( month < minMonth || month > maxMonth ) { //month outside range
                return false
            }else if( minMonth == maxMonth ){ //month is also in range and month range has size one
                if( day < minDay || day > maxDay ) {
                    return false
                }
            }else if( month == minMonth ) { //month at min range
                if( day < minDay ) { //day outside range
                    return false
                }
            }else if( month == maxMonth ) { //month at max range
                if( day > maxDay ) { //day outside range
                    return false
                }
            }
        }else if( year == minYear ){ //selected year is at min range and the year range is bigger than one
            if( month < minMonth ) { //month outside range
                return false
            }else if( month == minMonth ){ //month at min range
                if( day < minDay ) { //day outside range
                    return false
                }
            }
        }else if( year == maxYear ) { //selected year is at max range and the range is bigger than one
            if( month > maxMonth ) { //month outside range
                return false
            }else if( month == maxMonth ){ //month at max range
                if( day > maxDay ) { //day outside range
                    return false
                }
            }
        }
        return true
    }

    Component.onCompleted: {
        if( !selectedDate ) {
            selectedDate = today();
        }
    }

    //when the DatePicker shows up, store the current date
    onShowCalled: {
        acceptBlocked = false
        oldDate = selectedDate;
        updateSelectedDate( selectedDate.getDate(), selectedDate.getMonth(), selectedDate.getFullYear() )
    }

    //when the DatePicker is closed via cancel, restore the formerly selected date
    onRejected: { selectedDate = oldDate }

    onAccepted: {
        if( !acceptBlocked ) {
            acceptBlocked = true
            dateSelected( selectedDate )
        }
    }

    acceptButtonEnabled: isDateInRange

    width: height * 0.6
    height: (topItem.topItem.height - topItem.topDecorationHeight) * 0.95

    alignTitleCenter: true

    buttonWidth: width / 2.5

    content: BorderImage {
        id: outer

        anchors.fill: parent
        clip:  false
        source: "image://themedimage/images/popupbox_2"

        Image {
            id:titleDivider

            anchors { top: parent.top; left: parent.left; right: parent.right }
            source: "image://themedimage/images/menu_item_separator"
        } //end of titleDivider

        Item {
            id: popupRow

            //: Controls the order in which the three spinners for days, months and years are displayed in the DatePicker. Don't translate this into your language. Instead order the three keywords to match the standards of your language. For example "year-month-day".
            property string dateOrder: qsTr("day-month-year")
            property int unitWidth: ( parent.width - 2 * anchors.margins ) / 13 // 3 * 3 units for the popuplists and 4 * 1 units for the dateunits

            z: 10
            anchors { margins: 10; left: parent.left; top: titleDivider.bottom; right: parent.right }
            height: datePicker.height / 6

            Text {
                id: dateUnitOne

                anchors.left: parent.left
                width: parent.unitWidth
                height: parent.height
                verticalAlignment: "AlignVCenter"
                horizontalAlignment: "AlignHCenter"
                //: Optional! Won't be displayed if left untranslated or if set to more than one or two characters. Positioned left of the left spinner. Meant for displaying units, separators or whatever seems appropiate for a language specific display of the date given by the three spinners.
                text: qsTr("dateUnitOne")
                visible: ( paintedWidth < width * 0.9 ) ? true : false
            }

            Item {
                id: leftSpinnerItem

                anchors.left: dateUnitOne.right
                width: parent.unitWidth * 3
                height: parent.height
            }

            Text {
                id: dateUnitTwo

                anchors.left: leftSpinnerItem.right
                width: parent.unitWidth
                height: parent.height
                verticalAlignment: "AlignVCenter"
                horizontalAlignment: "AlignHCenter"
                //: Optional! Won't be displayed if left untranslated or if set to more than one or two characters. Positioned between left and middle spinner. Meant for displaying units, separators or whatever seems appropiate for a language specific display of the date given by the three spinners.
                text: qsTr("dateUnitTwo")
                visible: ( paintedWidth < width * 0.9 ) ? true : false
            }

            Item {
                id: middleSpinnerItem

                anchors.left: dateUnitTwo.right
                width: parent.unitWidth * 3
                height: parent.height
            }

            Text {
                id: dateUnitThree

                anchors.left: middleSpinnerItem.right
                width: parent.unitWidth
                height: parent.height
                verticalAlignment: "AlignVCenter"
                horizontalAlignment: "AlignHCenter"
                //: Optional! Won't be displayed if left untranslated or if set to more than one or two characters. Positioned between middle and right spinner. Meant for displaying units, separators or whatever seems appropiate for a language specific display of the date given by the three spinners.
                text: qsTr("dateUnitThree")
                visible: ( paintedWidth < width * 0.9 ) ? true : false
            }

            Item {
                id: rightSpinnerItem

                anchors.left: dateUnitThree.right
                width: parent.unitWidth * 3
                height: parent.height
            }

            Text {
                id: dateUnitFour

                anchors.left: rightSpinnerItem.right
                width: parent.unitWidth
                height: parent.height
                verticalAlignment: "AlignVCenter"
                horizontalAlignment: "AlignHCenter"
                //: Optional! Won't be displayed if left untranslated or if set to more than one or two characters. Positioned right of the right spinner. Meant for displaying units, separators or whatever seems appropiate for a language specific display of the date given by the three spinners.
                text: qsTr("dateUnitFour")
                visible: ( paintedWidth < width * 0.9 ) ? true : false
            }


            // pops up a list to choose a day
            PopupList {
                id: dayButton

                popupListModel: dModel
                value: day
                anchors.fill: leftSpinnerItem

                onValueSelected: {
                    if( allowUpdates ) {
                        var d = index + 1
                        var m = selectedDate.getMonth()
                        var y = selectedDate.getFullYear()
                        updateSelectedDate( d, m, y )
                    }
                }

            }

            // pops up a list to choose a month
            PopupList {
                id: monthButton

                popupListModel: mModel
                value: shortMonths[month]
                anchors.fill: middleSpinnerItem

                onValueSelected: {
                    if( allowUpdates ) {
                        var d = selectedDate.getDate()
                        var m = index
                        var y = selectedDate.getFullYear()
                        updateSelectedDate( d, m, y )
                    }
                }
            }

            // pops up a list to choose a year
            PopupList {
                id: yearButton

                popupListModel: yModel
                value: year
                anchors.fill: rightSpinnerItem

                onValueSelected: {
                    if( allowUpdates ) {
                        var d = selectedDate.getDate()
                        var m = selectedDate.getMonth()
                        var y = getTagValue(3,index)
                        updateSelectedDate( d, m, y )
                    }
                }
            }

            states: [
                State {
                    name: "dmy"
                    PropertyChanges { target: dayButton; anchors.fill: leftSpinnerItem }
                    PropertyChanges { target: monthButton; anchors.fill: middleSpinnerItem }
                    PropertyChanges { target: yearButton; anchors.fill: rightSpinnerItem }
                    when: popupRow.dateOrder == "day-month-year"
                },
                State {
                    name: "dym"
                    PropertyChanges { target: dayButton; anchors.fill: leftSpinnerItem }
                    PropertyChanges { target: monthButton; anchors.fill: rightSpinnerItem }
                    PropertyChanges { target: yearButton; anchors.fill: middleSpinnerItem }
                    when: popupRow.dateOrder == "day-year-month"
                },
                State {
                    name: "mdy"
                    PropertyChanges { target: dayButton; anchors.fill: middleSpinnerItem }
                    PropertyChanges { target: monthButton; anchors.fill: leftSpinnerItem }
                    PropertyChanges { target: yearButton; anchors.fill: rightSpinnerItem }
                    when: popupRow.dateOrder == "month-day-year"
                },
                State {
                    name: "myd"
                    PropertyChanges { target: dayButton; anchors.fill: rightSpinnerItem }
                    PropertyChanges { target: monthButton; anchors.fill: leftSpinnerItem }
                    PropertyChanges { target: yearButton; anchors.fill: middleSpinnerItem }
                    when: popupRow.dateOrder == "month-year-day"
                },
                State {
                    name: "ydm"
                    PropertyChanges { target: dayButton; anchors.fill: middleSpinnerItem }
                    PropertyChanges { target: monthButton; anchors.fill: rightSpinnerItem }
                    PropertyChanges { target: yearButton; anchors.fill: leftSpinnerItem }
                    when: popupRow.dateOrder == "year-day-month"
                },
                State {
                    name: "ymd"
                    PropertyChanges { target: dayButton; anchors.fill: rightSpinnerItem }
                    PropertyChanges { target: monthButton; anchors.fill: middleSpinnerItem }
                    PropertyChanges { target: yearButton; anchors.fill: leftSpinnerItem }
                    when: popupRow.dateOrder == "year-month-day"
                }
            ]


        } // date popups

        Item {
            id: calendarView

            property variant calendarShown: today() // points to a date for the currently shown calendar

            anchors { left: parent.left; top: popupRow.bottom;
                      right: parent.right; bottom: todayButton.top;
                      leftMargin: 10; rightMargin: 10; topMargin: 10;
                      bottomMargin: todayButton.anchors.bottomMargin }

            BorderImage {
                id: calBg

                anchors.fill: parent
                source:"image://themedimage/images/notificationBox_bg"
            }

            // displays the currently selected month and offers buttons to switch back and forth between months
            Item {
                id: monthHeader

                property int fontPixelSize

                fontPixelSize: if( theme.fontPixelSizeLarge < parent.height - 4 ) {
                                   return  theme.fontPixelSizeLarge
                               }else {
                                   return parent.height - 4
                               }
                anchors { left:parent.left; top:parent.top; right:parent.right }
                height: datePicker.height / 13

                IconButton {
                    id: prevMonthText

                    icon: "image://themedimage/images/arrow-left"
                    iconDown: "image://themedimage/images/arrow-left"
                    bgSourceUp: ""
                    bgSourceDn: ""
                    anchors { left: parent.left; right: monthAndYear.left; top: parent.top; bottom: parent.bottom }

                    onClicked: {
                        var newMonth = prevMonth( selectedDate )
                        var yearUpdate = 0
                        if( newMonth == 11 && selectedDate.getFullYear() > datePicker.startYear  ) {
                            yearUpdate = - 1
                        }
                        updateSelectedDate( selectedDate.getDate(), prevMonth( selectedDate ), selectedDate.getFullYear() + yearUpdate )
                    }
                }

                Text {
                    id: monthAndYear

                    text: qsTr("%1 %2").arg(fullMonths[ calendarView.calendarShown.getMonth() ]).arg(calendarView.calendarShown.getFullYear())
                        // fullMonths[ calendarView.calendarShown.getMonth() ] + " " + calendarView.calendarShown.getFullYear()
                    font.pixelSize: monthHeader.fontPixelSize;
                    verticalAlignment: "AlignVCenter"; horizontalAlignment: "AlignHCenter"
                    anchors { top: parent.top; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
                    width: parent.width / 2
                }

                IconButton {
                    id: nextMonthText

                    icon: "image://themedimage/images/arrow-right"
                    iconDown: "image://themedimage/images/arrow-right"
                    bgSourceUp: ""
                    bgSourceDn: ""
                    anchors { left: monthAndYear.right; right: parent.right; top: parent.top; bottom: parent.bottom }

                    onClicked: {
                        var newMonth = nextMonth( selectedDate )
                        var yearUpdate = 0
                        if( newMonth == 0 && selectedDate.getFullYear() < datePicker.endYear) {
                            yearUpdate = 1
                        }
                        updateSelectedDate( selectedDate.getDate(), nextMonth( selectedDate ), selectedDate.getFullYear() + yearUpdate )
                    }
                }
            } // month-year header

            Image {
                id:monthDivider

                anchors { left: parent.left; right: parent.right; top: monthHeader.bottom }
                width: parent.width
                source: "image://themedimage/images/menu_item_separator"
            } //end of monthDivider

            // display the day names as some kind of column titles for the calendarGrid
            Item {
                id: dayLabel

                height: monthHeader.height * 0.5
                anchors { left: parent.left; right: parent.right; top: monthDivider.bottom; }

                Grid {
                    id: daysGrid

                    property int cellFontSize;

                    height: dayLabel.height
                    //font size is critical here because of little space, so it's reduced if necessary
                    cellFontSize: if( theme.fontPixelSizeMedium > calendarView.width/daysGrid.columns * 0.4 ){
                                      calendarView.width/daysGrid.columns * 0.4
                                  }else{
                                      theme.fontPixelSizeMedium
                                  }

                    anchors { left: parent.left; top: parent.top; right: parent.right }
                    rows: 1; columns: 7; spacing: 0

                    Repeater {
                        model: daysOfWeek
                        Text {
                            id: daysText
                            text:  ( index + calendarGrid.dayOffset <= 6 ) ? daysOfWeek[index + calendarGrid.dayOffset] : daysOfWeek[index + calendarGrid.dayOffset - 7] //daysOfWeek[index] //
                            horizontalAlignment: "AlignHCenter";
                            verticalAlignment: "AlignVCenter"
                            font.pixelSize: daysGrid.cellFontSize
                            width: calendarView.width / daysGrid.columns
                            height:  daysGrid.height
                        }
                    }
                }
            } // column labels

            Image {
                id: dayDivider

                anchors.top: dayLabel.bottom
                width: parent.width
                source: "image://themedimage/images/menu_item_separator"
            } //end of dayDivider

            Grid {
                id: calendarGrid

                property real cellGridWidth: width / columns
                property real cellGridHeight: height / rows
                property int cellFontSize;

                //: handles with which day the calendar grid starts. Type monday, tuesday, wednesday, thursday, friday, saturday or sunday, without capital letters
                property string firstDayInWeek: qsTr( "firstDayInWeek" )
                property int dayOffset: 0

                function startDay ( mm, yyyy ) {
                    var firstDay = new Date( yyyy, mm, 1, 0, 0, 0, 0 )

                    var temp = firstDay.getDay() - calendarGrid.dayOffset
                    if( temp >= 0 ) {
                        return temp
                    }else {
                        return temp + 7
                    }
                }

                function indexToDay(index) {
                    var firstDay = startDay( calendarView.calendarShown.getMonth(), calendarView.calendarShown.getFullYear() )
                    var dayCount = daysInMonth( calendarView.calendarShown.getMonth(), calendarView.calendarShown.getFullYear() )

                    if ( index < firstDay ) return -1
                    if ( index >= firstDay + dayCount ) return -1

                    return ( index + 1 ) - firstDay
                }

                //font size is critical here because of little space, so reduce it if necessary
                cellFontSize: if( theme.fontPixelSizeLarge < cellGridHeight - 4 ) {
                    return theme.fontPixelSizeLarge
                }else{
                    return cellGridHeight - 4
                }

                anchors { top: dayDivider.bottom;}
                width: calendarView.width;
                height:  parent.height - ( dayLabel.height + monthHeader.height + monthDivider.height + dayDivider.height )
                x: ( width - childrenRect.width ) * 0.5
                rows: 6; columns: 7; spacing: 0

                Component.onCompleted: {
                    if( firstDayInWeek == "monday" ) {
                        dayOffset = 1
                    }else if ( firstDayInWeek == "tuesday" ) {
                        dayOffset = 2
                    }else if ( firstDayInWeek == "wednesday" ) {
                        dayOffset = 3
                    }else if ( firstDayInWeek == "thursday" ) {
                        dayOffset = 4
                    }else if ( firstDayInWeek == "friday" ) {
                        dayOffset = 5
                    }else if ( firstDayInWeek == "saturday" ) {
                        dayOffset = 6
                    }else {
                        dayOffset = 0
                    }
                }

                Repeater {
                    model: 42

                    Rectangle {
                        property bool doTag: isSelectedDate( calendarGrid.indexToDay(index),
                                                             calendarView.calendarShown.getMonth(),
                                                             calendarView.calendarShown.getFullYear())
                        property bool isToday: isCurrentDate( createDate( calendarGrid.indexToDay(index),
                                                                         calendarView.calendarShown.getMonth(),
                                                                         calendarView.calendarShown.getFullYear() ) )

                        border.width: ( calendarGrid.indexToDay(index) == -1 ) ? 1 : ( doTag ? 3 : 1 )
                        border.color: isToday ? theme.fontColorHighlight: theme.fontColorInactive

                        width: calendarGrid.cellGridWidth - ( doTag ? 1 : 0 )
                        height: calendarGrid.cellGridHeight - ( doTag ? 1 : 0 )

                        color: if( doTag ){
                                   return theme.datePickerSelectedColor
                               }else if( calendarGrid.indexToDay( index ) == -1
                                        || !checkSelectedDate( ( index + 1 ) - calendarGrid.startDay( calendarView.calendarShown.getMonth(), calendarView.calendarShown.getFullYear() ), calendarView.calendarShown.getMonth() + 1, calendarView.calendarShown.getFullYear() ) ) {
                                   return theme.datePickerUnselectableColor
                               }else {
                                   return theme.datePickerUnselectedColor
                               }

                        opacity: ( calendarGrid.indexToDay( index) == -1 ) ? 0.25 : 1

                        Text {
                            text: calendarGrid.indexToDay(index)
                            font.pixelSize: calendarGrid.cellFontSize
                            anchors.centerIn: parent
                            visible: ( calendarGrid.indexToDay(index) != -1 )
                            color: isToday ? theme.fontColorHighlight: theme.fontColorNormal
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var d = calendarGrid.indexToDay(index)
                                if ( d > 0 ) {
                                    updateSelectedDate( d, calendarView.calendarShown.getMonth(), calendarView.calendarShown.getFullYear() )
                                }
                            }
                        }
                    }
                } // end repeater
            } //end grid
        } // calendar

        Item {
            id: todayButton

            anchors { left:parent.left; right: parent.right; bottom: parent.bottom;
                      bottomMargin: 6; leftMargin: 10; rightMargin: 10 }

            height: datePicker.height / 16

            Button {
                id: tButton

                anchors.centerIn: parent
                minHeight:  parent.height
                maxHeight: parent.height
                minWidth: parent.width
                maxWidth: parent.width
                textMargins: 4

                font.pixelSize: if( theme.fontPixelSizeLargest < parent.height * 0.85 - 2 * textMargins ) {
                                    return theme.fontPixelSizeLargest
                                }else {
                                    return parent.height * 0.85 - 2 * textMargins
                                }

                text: qsTr( "Today" );

                onClicked: {
                    var todayYear = today().getFullYear()
                    if( todayYear >= startYear && todayYear <= endYear ) {
                        updateSelectedDate( today().getDate(), today().getMonth(), today().getFullYear() )
                    }
                }
            }
        }
    }

    function initializeDays(){
        dayButton.allowSignal = false
        monthButton.allowSignal = false
        yearButton.allowSignal = false
        if ( dModel.count != daysInMonth( selectedDate.getMonth(), selectedDate.getFullYear() ) ) {
            dModel.clear(); // need to clear first since model changes with each month
            for ( var i = 0 ; i < daysInMonth( selectedDate.getMonth(), selectedDate.getFullYear() ); i++ ) {
               dModel.append( { "tag": i + 1 } );
            }
        }
        dayButton.allowSignal = true
        monthButton.allowSignal = true
        yearButton.allowSignal = true
    }

    function setMonths() {
        dayButton.allowSignal = false
        monthButton.allowSignal = false
        yearButton.allowSignal = false
        for ( var i = 0 ; i < shortMonths.length; i++ ) {
            mModel.append( { "tag": shortMonths[i] } );
        }
        dayButton.allowSignal = true
        monthButton.allowSignal = true
        yearButton.allowSignal = true
    }

    function setYears() {
        dayButton.allowSignal = false
        monthButton.allowSignal = false
        yearButton.allowSignal = false
        yModel.clear()
        for ( var i = startYear ; i <= endYear; i++ ) {
            yModel.append( { "tag": i } );
        }
        dayButton.allowSignal = true
        monthButton.allowSignal = true
        yearButton.allowSignal = true
    }

    ListModel {
        id: dModel
        Component.onCompleted: {
            initializeDays()
        }
    }

    ListModel {
        id: mModel
        Component.onCompleted: {
            setMonths();
        }
    }

    ListModel {
        id: yModel
        Component.onCompleted: {
            setYears();
        }
    }

    // need a placeholder to allow the real models to be generated and assigned later.
    ListModel {
        id: dummyListModel
        ListElement { tag: "0" }
    }

    TopItem { id: topItem }
    Theme { id: theme }
}
