import Qt 4.7
import "DHAVN_PopUp_Resources.js" as RES
import "DHAVN_PopUp_Constants.js" as CONST
import PopUpConstants 1.0

import AppEngineQMLConstants 1.0


DHAVN_PopUp_Base
{
    id: time_picker

    /** --- Input parameters --- */
    property ListModel buttons: ListModel {}
    property ListModel amPMModel: ListModel {}

    property int maxDaysInMonth

    property string year_text:"Year"
    property string month_text:"Month"
    property string day_text:"Day"
    property string am_text:"AM"
    property string pm_text:"PM"
    property string hour_text:"Hour"
    property string minute_text:"Minute"
    property bool selectionMode:false
    property bool btwentyFourh:true
    property variant year
    property variant month
    property variant day
    property variant hour
    property variant minute
    property variant am_pm

    onBtwentyFourhChanged: {

        setMinMax(time_picker.btwentyFourh == true ? CONST.const_TIME_PICKER_CLOCK_MIN_HOUR_24H : CONST.const_TIME_PICKER_CLOCK_MIN_HOUR, time_picker.btwentyFourh == true ? CONST.const_TIME_PICKER_CLOCK_MAX_HOUR_24H : CONST.const_TIME_PICKER_CLOCK_MAX_HOUR)
        setCurrentTime(year, month, day, am_pm, hour, minute)

    }

    focus_index:-1
    focus_visible:false

    onVisibleChanged:
    {
        focus_visible = visible
    }

    /** --- Signals --- */
    signal btnClicked( variant btnId )
    signal updateCurrentTime(variant year,variant month,variant day,variant hour,variant minute,variant am_pm)


    /** Functions */
    function setDefaultFocus( arrow )
    {
        focus_index = 0;
        return focus_index;
    }

    function setMinMax(min, max)
    {
        popup_loader.item.setMinMax(min,max)
    }

    function setCurrentTime(current_year, current_month, current_day,current_am_pm, current_hour, current_minute)
    {
        console.log("[SystemPopUp] setCurrentTime year:"+current_year+", month:"+current_month+", day:"+current_day
                    +", am_pm:"+current_am_pm+",hour:"+current_hour+",minute:"+current_minute);

//        current_year = 2011; // test

        if (current_year < CONST.const_TIME_PICKER_CLOCK_MIN_YEAR) {
            console.log("[SystemPopUp] setCurrentTime convert");

            current_year = CONST.const_TIME_PICKER_CLOCK_MIN_YEAR;
            current_month = CONST.const_TIME_PICKER_CLOCK_MIN_MONTH;
            current_day = CONST.const_TIME_PICKER_CLOCK_MIN_DAY;
            current_am_pm = 0;

            if (time_picker.btwentyFourh == true) {
                current_hour = CONST.const_TIME_PICKER_CLOCK_MIN_HOUR_24H;
            }
            else {
                current_hour = CONST.const_TIME_PICKER_CLOCK_MAX_HOUR;
            }

            current_minute = CONST.const_TIME_PICKER_CLOCK_MIN_MINUTE;

            console.log("[SystemPopUp] setCurrentTime convert year:"+current_year+", month:"+current_month+", day:"+current_day
                        +", am_pm:"+current_am_pm+",hour:"+current_hour+",minute:"+current_minute);
        }

        year = current_year
        month = current_month
        day = current_day
        am_pm = current_am_pm
        hour = current_hour
        minute = current_minute
        popup_loader.item.setCurrentTime(current_year, current_month, current_day,current_am_pm, current_hour, current_minute);
        return;

//        yearSpin.setValue(current_year);
//        monthSpin.setValue(current_month);

//        console.log("amPMModel.get(0)" + amPMModel.get(0).text);
//        console.log("amPMModel.get(1)" + amPMModel.get(1).text);
//        if(current_am_pm == 0)
//            {
//                timeTypeSpin.setValue(amPMModel.get(0).text)
//            }
//        else
//            {
//                timeTypeSpin.setValue(amPMModel.get(1).text)
//            }

//        console.log("timeTypeSpin.sCurrentValue" + timeTypeSpin.sCurrentValue);

//        //timeTypeSpin.setValue(current_am_pm);
//        hourSpin.setValue(current_hour);
//        minuteSpin.setValue(current_minute);

//        //console.log("maxDaysInMonth initially = " + maxDaysInMonth);
//        console.log("year : " + yearSpin.sCurrentValue + " month : " + monthSpin.sCurrentValue + " maxDaysInMonth onMonth initially = " + maxDaysInMonth);

//        maxDaysInMonth = getDaysInMonth((yearSpin.minimum +yearSpin.__index),(monthSpin.minimum+monthSpin.__index))
//        //console.log("maxDaysInMonth set to = " + maxDaysInMonth);
//        console.log("year : " + (yearSpin.minimum + yearSpin.__index) + " month : " + (monthSpin.minimum+monthSpin.__index) + " maxDaysInMonth onMonthChange = " + maxDaysInMonth);

//        daySpin.setValue(current_day);



    }

    function initializeTimePickerText(yearText, monthText, dayText, amText,pmText, hourText, minuteText)
    {
        console.log("[SystemPopUp] initializeTimePickerText " );
        year_text = yearText;
        month_text = monthText;
        day_text = dayText;
        am_text = amText;
        pm_text = pmText;
        hour_text =  hourText;
        minute_text = minuteText;
    }

    function setDaysInMonth(noOfDays)
    {
        console.log("[SystemPopUp] setDaysInMonth " + noOfDays );
        maxDaysInMonth = noOfDays;
    }

    function getDaysInMonth(year,month)
    {
        switch (month)
        {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            return 31;
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
        case 2:
            return isLeapYear(year) ? 29 : 28;
        default:
            return 0;
        }
    }

    function isLeapYear(year)
    {
        if (((year % 4) == 0 && (year % 100) != 0) || ((year % 400) == 0))
        {
            return true;
        }

        return false;
    }


    function updateTimePickerTitle(titleText)
    {
        title = titleText;
    }

    type: RES.const_POPUP_TYPE_B

    content: Item
    {

        Item{
            anchors.fill: parent
            anchors.centerIn: parent
            Loader{ id:popup_loader;
                sourceComponent:{
    //                UIListener.GetCountryVariantFromQML() != 5 ? id_TIMEPICKER_NORMAL : id_TIMEPICKER_NORTHAMERICA
                    // korea, china - year, month, day
                    if (UIListener.GetCountryVariantFromQML() == 0 || UIListener.GetCountryVariantFromQML() == 2) {
                        id_TIMEPICKER_NORMAL
                    }
                    // usa, canada, general, middle east - month, day, year
                    else if (UIListener.GetCountryVariantFromQML() == 1 || UIListener.GetCountryVariantFromQML() == 6
                             || UIListener.GetCountryVariantFromQML() == 3 || UIListener.GetCountryVariantFromQML() == 4) {
                        id_TIMEPICKER_NORTHAMERICA
                    }
                    // europe, russia - day, month, year
                    else {
                        id_TIMEPICKER_EUROPE
                    }
                }
               // id:popup_loader; sourceComponent:  id_TIMEPICKER_NORMAL
                anchors.left: parent.left
                anchors.top: parent.top
                //anchors.verticalCenter: parent.verticalCenter
                onLoaded: {
                    console.log("[SystemPopUp] Timepicker Loader  onLoaded!!!!!!!!")
                }
            }

            // year, month, day -----------------------------------------------------------------------------------------------------------
            Component{
                id: id_TIMEPICKER_NORMAL
                Item{
                    function setMinMax(min, max)
                    {
                        hourSpin.minimum = min
                        hourSpin.maximum = max
                    }

                    function setCurrentTime(current_year, current_month, current_day,current_am_pm, current_hour, current_minute)
                    {
                        console.log("[SystemPopUp] popup setCurrentTime NORMAL" );
                        if(id_TIMEPICKER_NORMAL.status != Loader.Ready) {

                            return;
                        }
                        yearSpin.setValue(current_year);
                        monthSpin.setValue(current_month);

                        console.log("[SystemPopUp] amPMModel.get(0)" + amPMModel.get(0).text);
                        console.log("[SystemPopUp] amPMModel.get(1)" + amPMModel.get(1).text);
                        if(current_am_pm == 0)
                            {
                                timeTypeSpin.setValue(amPMModel.get(0).text)
                            }
                        else
                            {
                                timeTypeSpin.setValue(amPMModel.get(1).text)
                            }

                        console.log("[SystemPopUp] timeTypeSpin.sCurrentValue" + timeTypeSpin.sCurrentValue);

                        //timeTypeSpin.setValue(current_am_pm);
                        hourSpin.setValue(current_hour);
                        minuteSpin.setValue(current_minute);

                        //console.log("maxDaysInMonth initially = " + maxDaysInMonth);
                        console.log("[SystemPopUp] year : " + yearSpin.sCurrentValue + " month : " + monthSpin.sCurrentValue + " maxDaysInMonth onMonth initially = " + maxDaysInMonth);

                        maxDaysInMonth = getDaysInMonth((yearSpin.minimum +yearSpin.__index),(monthSpin.minimum+monthSpin.__index))
                        //console.log("maxDaysInMonth set to = " + maxDaysInMonth);
                        console.log("[SystemPopUp] year : " + (yearSpin.minimum + yearSpin.__index) + " month : " + (monthSpin.minimum+monthSpin.__index) + " maxDaysInMonth onMonthChange = " + maxDaysInMonth);

                        daySpin.setValue(current_day);



                    }
                Rectangle
                {
                    id:first
                    x: time_picker.langID != 20 ? CONST.const_TIME_PICKER_START_POSITION_X : CONST.const_TIME_PICKER_START_POSITION_X_REVERSE
                    y:CONST.const_TIME_PICKER_START_POSITION_Y
                    width:CONST.const_TIME_PICKER_YEAR_WIDTH
                    height:yearText.height + yearSpin.height
                    color:"transparent"

                    Text
                    {
                        id: yearText
                        width:parent.width
                        height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                        anchors.horizontalCenter: parent.horizontalCenter
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignHCenter
                        color: CONST.const_COLOR_TEXT_GREY
                        font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                        font.family: time_picker.fontFamily
                        text: ( year_text.substring( 0, 4 ) != "STR_") ? year_text :
                        qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, year_text )
                    }
                    DHAVN_PopUp_Item_VertSpinControl
                    {
                        id: yearSpin
                        y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                        width:parent.width
                        bLargeSpiner: true
                        _fontFamily:time_picker.fontFamily
                        focus_visible: focus_index == 0
                        minimum: CONST.const_TIME_PICKER_CLOCK_MIN_YEAR
                        maximum: CONST.const_TIME_PICKER_CLOCK_MAX_YEAR
                        focus_id: 0
                        _selectionMode: selectionMode
                        onSpinControlValueChanged: {
                            maxDaysInMonth = getDaysInMonth((yearSpin.minimum + yearSpin.__index),(monthSpin.minimum+monthSpin.__index))
                            console.log("[SystemPopUp] year : " + (yearSpin.minimum + yearSpin.__index) + " month : " +(monthSpin.minimum+monthSpin.__index) + " maxDaysInMonth onMonthChange = " + maxDaysInMonth);
                            focus_index=yearSpin.focus_id
                        }
                    }
                }

                Rectangle{
                    id:second
                    width:CONST.const_TIME_PICKER_OTHER_WIDTH
                    height:monthText.height + monthSpin.height
                    anchors.top : first.top
                    anchors.left: time_picker.langID != 20 ? first.right : first.left
                    anchors.leftMargin: time_picker.langID != 20 ? CONST.const_TIME_PICKER_ELEMENTS_MARGIN : -111
                    color:"transparent"
                    Text
                    {
                        id: monthText
                        width:parent.width
                        height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                        anchors.horizontalCenter: parent.horizontalCenter
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignHCenter
                        color: CONST.const_COLOR_TEXT_GREY
                        font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                        font.family: time_picker.fontFamily
                        text: ( month_text.substring( 0, 4 ) != "STR_") ? month_text :
                        qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, month_text )
                    }
                    DHAVN_PopUp_Item_VertSpinControl
                    {
                        id: monthSpin
                        y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                        width:parent.width
                        minimum: CONST.const_TIME_PICKER_CLOCK_MIN_MONTH
                        maximum: CONST.const_TIME_PICKER_CLOCK_MAX_MONTH
                        focus_id: 1
                        focus_visible:focus_index ==1
                        _selectionMode: selectionMode
                        _fontFamily:time_picker.fontFamily
                        onSpinControlValueChanged: {
                            maxDaysInMonth = getDaysInMonth((yearSpin.minimum +  yearSpin.__index),(monthSpin.minimum+monthSpin.__index))
                            focus_index=monthSpin.focus_id
                            console.log("[SystemPopUp] year : " + (yearSpin.minimum +yearSpin.__index) + " month : " +(monthSpin.minimum+monthSpin.__index) + " maxDaysInMonth onMonthChange = " + maxDaysInMonth);
                        }
                    }
                }

                Rectangle{
                    id:third
                    anchors.left:time_picker.langID != 20 ?  second.right : second.left
                    anchors.leftMargin: time_picker.langID != 20 ? CONST.const_TIME_PICKER_ELEMENTS_MARGIN : -111
                    width:CONST.const_TIME_PICKER_OTHER_WIDTH
                    height:dayText.height + daySpin.height
                    anchors.top : first.top
                    color:"transparent"
                    Text
                    {
                        id: dayText
                        width:parent.width
                        height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                        anchors.horizontalCenter: parent.horizontalCenter
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignHCenter
                        color: CONST.const_COLOR_TEXT_GREY
                        font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                        font.family: time_picker.fontFamily
                        text: ( day_text.substring( 0, 4 ) != "STR_") ? day_text :
                        qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, day_text )
                    }
                    DHAVN_PopUp_Item_VertSpinControl
                    {
                        id: daySpin
                        y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                        width:parent.width
                        minimum: CONST.const_TIME_PICKER_CLOCK_MIN_DAY
                        maximum: maxDaysInMonth
                        _fontFamily:time_picker.fontFamily
                        _selectionMode: selectionMode
                        focus_id: 2
                        focus_visible: focus_index==2
                        onSpinControlValueChanged: {
                            focus_index=daySpin.focus_id
                        }
                    }
                }
                Rectangle{
                    id:fourth
                    width:CONST.const_TIME_PICKER_OTHER_WIDTH
                    height:hourText.height + hourSpin.height
                    anchors.top : first.top
                    anchors.left: time_picker.langID != 20 ? third.right : third.left
                    anchors.leftMargin: time_picker.langID != 20 ? CONST.const_TIME_PICKER_ELEMENTS_MARGIN : -111
                    color:"transparent"
                    Text
                    {
                        id: hourText
                        width:parent.width
                        height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                        anchors.horizontalCenter: parent.horizontalCenter
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignHCenter
                        color: CONST.const_COLOR_TEXT_GREY
                        font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                        font.family: time_picker.fontFamily
                        text: ( hour_text.substring( 0, 4 ) != "STR_") ? hour_text :
                        qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, hour_text )
                    }
                    DHAVN_PopUp_Item_VertSpinControl
                    {
                        id: hourSpin
                        y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                        width:parent.width
                        minimum: time_picker.btwentyFourh == true ? CONST.const_TIME_PICKER_CLOCK_MIN_HOUR_24H : CONST.const_TIME_PICKER_CLOCK_MIN_HOUR
                        maximum: time_picker.btwentyFourh == true ? CONST.const_TIME_PICKER_CLOCK_MAX_HOUR_24H : CONST.const_TIME_PICKER_CLOCK_MAX_HOUR
                        _fontFamily:time_picker.fontFamily
                        _selectionMode: selectionMode
                        focus_id: 3
                        focus_visible: focus_index == 3
                        onSpinControlValueChanged: {
                            focus_index=hourSpin.focus_id
                        }
                    }
                }
                Rectangle{
                    id:fifth
                    anchors.left: time_picker.langID != 20 ? fourth.right : fourth.left
                    anchors.leftMargin: time_picker.langID != 20 ? CONST.const_TIME_PICKER_ELEMENTS_MARGIN : -111
                    width:CONST.const_TIME_PICKER_OTHER_WIDTH
                    height:minuteText.height + minuteSpin.height
                    anchors.top : first.top
                    color:"transparent"
                    Text
                    {
                        id: minuteText
                        width:parent.width
                        height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                        anchors.horizontalCenter: parent.horizontalCenter
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignHCenter
                        color: CONST.const_COLOR_TEXT_GREY
                        font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                        font.family: time_picker.fontFamily
                        text: ( minute_text.substring( 0, 4 ) != "STR_") ? minute_text :
                        qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, minute_text )
                    }
                    DHAVN_PopUp_Item_VertSpinControl
                    {
                        id: minuteSpin
                        y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                        width:parent.width
                        minimum: CONST.const_TIME_PICKER_CLOCK_MIN_MINUTE
                        maximum: CONST.const_TIME_PICKER_CLOCK_MAX_MINUTE
                        _fontFamily:time_picker.fontFamily
                        _selectionMode: selectionMode
                        focus_id: 4
                        focus_visible: focus_index == 4
                        onSpinControlValueChanged: {
                            focus_index=minuteSpin.focus_id
                        }
                    }
                }
                Rectangle{
                    id:sixth
                    anchors.left: time_picker.langID != 20 ? fifth.right : fifth.left
                    anchors.leftMargin: time_picker.langID != 20 ? CONST.const_TIME_PICKER_ELEMENTS_MARGIN : -111
                    y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                    width:CONST.const_TIME_PICKER_OTHER_WIDTH
                    height:yearText.height + timeTypeSpin.height
                    anchors.top : first.top
                    color:"transparent"
                    DHAVN_PopUp_Item_VertSpinControl
                    {
                        id: timeTypeSpin
                        y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                        width:parent.width
                        aSpinControlTextModel: amPMModel
                        _fontFamily:time_picker.fontFamily
                        _selectionMode: selectionMode
                        focus_id: 5
                        focus_visible: focus_index == 5
                        bEnabled:!btwentyFourh
                        onSpinControlValueChanged:
                        {
                            focus_index=timeTypeSpin.focus_id
                        }
                    }
                }
                    DHAVN_PopUp_Item_Button
                    {
                        id: okBtn
                        anchors.left: parent.left
                        anchors.leftMargin: time_picker.langID != 20 ? CONST.const_BUTTON_LEFT_MARGIN : CONST.const_BUTTON_LEFT_MARGIN_REVERSE
                        anchors.top: parent.top
                        anchors.topMargin:18
                        bg_img_n: time_picker.langID != 20 ?  RES.const_POPUP_B_02_01_BUTTON_N : RES.const_POPUP_B_02_01_BUTTON_N_REVERSE
                        bg_img_p: time_picker.langID != 20 ? RES.const_POPUP_B_02_01_BUTTON_P : RES.const_POPUP_B_02_01_BUTTON_P_REVERSE
                        bg_img_f: time_picker.langID != 20 ? RES.const_POPUP_B_02_01_BUTTON_F : RES.const_POPUP_B_02_01_BUTTON_F_REVERSE
                        _fontFamily: "DH_HDB"
                        caption:  buttons.get(0).msg
                        bFocused:focus_index == 6
                        onBtnClicked:
                        {
                            console.log("[SystemPopUp] on Update, timeTypeSpin.sCurrentValue " + timeTypeSpin.sCurrentValue);
                            time_picker.updateCurrentTime( yearSpin.sCurrentValue, monthSpin.sCurrentValue, daySpin.sCurrentValue, hourSpin.sCurrentValue, minuteSpin.sCurrentValue, timeTypeSpin.__index/* .sCurrentValue*/)
                        }
                    }
                    DHAVN_PopUp_Item_Button
                    {
                        id:  cancelBtn
                        anchors.left: parent.left
                        anchors.leftMargin: time_picker.langID != 20 ? CONST.const_BUTTON_LEFT_MARGIN : CONST.const_BUTTON_LEFT_MARGIN_REVERSE
                        anchors.top: parent.top
                        anchors.topMargin:18+171
                        bg_img_n: time_picker.langID != 20 ? RES.const_POPUP_B_02_02_BUTTON_N : RES.const_POPUP_B_02_02_BUTTON_N_REVERSE
                        bg_img_p: time_picker.langID != 20 ? RES.const_POPUP_B_02_02_BUTTON_P : RES.const_POPUP_B_02_02_BUTTON_P_REVERSE
                        bg_img_f:time_picker.langID != 20 ? RES.const_POPUP_B_02_02_BUTTON_F : RES.const_POPUP_B_02_02_BUTTON_F_REVERSE
                        _fontFamily:"DH_HDB"
                        caption: buttons.get(1).msg
                        bFocused:focus_index == 7
                        onBtnClicked:
                        {
                            console.log("[SystemPopUp] on Close, timeTypeSpin.sCurrentValue " + timeTypeSpin.sCurrentValue);
                            time_picker.closeBtnClicked();
                        }
                    }
                }
            }//component ------------------------------------------------------------------------------------------------------------------

            // month, day, year -----------------------------------------------------------------------------------------------------------
            Component{
                id: id_TIMEPICKER_NORTHAMERICA
                Item{
                    function setCurrentTime(current_year, current_month, current_day,current_am_pm, current_hour, current_minute)
                    {
                        console.log("[SystemPopUp] setCurrentTime NORTHAMERICA" );
                        if(id_TIMEPICKER_NORMAL.status != Loader.Ready)
                            return;

                        yearSpin.setValue(current_year);
                        monthSpin.setValue(current_month);

                        console.log("[SystemPopUp] amPMModel.get(0)" + amPMModel.get(0).text);
                        console.log("[SystemPopUp] amPMModel.get(1)" + amPMModel.get(1).text);
                        if(current_am_pm == 0)
                            {
                                timeTypeSpin.setValue(amPMModel.get(0).text)
                            }
                        else
                            {
                                timeTypeSpin.setValue(amPMModel.get(1).text)
                            }

                        console.log("[SystemPopUp] timeTypeSpin.sCurrentValue" + timeTypeSpin.sCurrentValue);

                        //timeTypeSpin.setValue(current_am_pm);
                        hourSpin.setValue(current_hour);
                        minuteSpin.setValue(current_minute);

                        //console.log("maxDaysInMonth initially = " + maxDaysInMonth);
                        console.log("[SystemPopUp] year : " + yearSpin.sCurrentValue + " month : " + monthSpin.sCurrentValue + " maxDaysInMonth onMonth initially = " + maxDaysInMonth);

                        maxDaysInMonth = getDaysInMonth((yearSpin.minimum +yearSpin.__index),(monthSpin.minimum+monthSpin.__index))
                        //console.log("maxDaysInMonth set to = " + maxDaysInMonth);
                        console.log("[SystemPopUp] year : " + (yearSpin.minimum + yearSpin.__index) + " month : " + (monthSpin.minimum+monthSpin.__index) + " maxDaysInMonth onMonthChange = " + maxDaysInMonth);

                        daySpin.setValue(current_day);
                    }

                    Rectangle{
                        id:first//second
//                        x: CONST.const_TIME_PICKER_START_POSITION_X
                        x: time_picker.langID != 20 ? CONST.const_TIME_PICKER_START_POSITION_X : CONST.const_TIME_PICKER_START_POSITION_X_REVERSE
                        y: CONST.const_TIME_PICKER_START_POSITION_Y
                        width:CONST.const_TIME_PICKER_OTHER_WIDTH
                        height:monthText.height + monthSpin.height
                            color:"transparent"
                        Text
                        {
                            id: monthText
                            width:parent.width
                            height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignTop
                            horizontalAlignment: Text.AlignHCenter
                            color: CONST.const_COLOR_TEXT_GREY
                            font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            font.family: time_picker.fontFamily
                            text: ( month_text.substring( 0, 4 ) != "STR_") ? month_text :
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, month_text )
                        }
                        DHAVN_PopUp_Item_VertSpinControl
                        {
                            id: monthSpin
                            y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                            width:parent.width
                            minimum: CONST.const_TIME_PICKER_CLOCK_MIN_MONTH
                            maximum: CONST.const_TIME_PICKER_CLOCK_MAX_MONTH
                            focus_id: 0
                            focus_visible:focus_index == monthSpin.focus_id
                            _selectionMode: selectionMode
                            _fontFamily:time_picker.fontFamily
                            onSpinControlValueChanged: {
                                maxDaysInMonth = getDaysInMonth((yearSpin.minimum +  yearSpin.__index),(monthSpin.minimum+monthSpin.__index))
                                focus_index=monthSpin.focus_id
                                console.log("[SystemPopUp] year : " + (yearSpin.minimum +yearSpin.__index) + " month : " +(monthSpin.minimum+monthSpin.__index) + " maxDaysInMonth onMonthChange = " + maxDaysInMonth);
                            }
                        }
                    }
                    Rectangle{
                        id:second//third
//                        anchors.left:first.right
//                        anchors.leftMargin: CONST.const_TIME_PICKER_ELEMENTS_MARGIN
                        anchors.left: time_picker.langID != 20 ? first.right : first.left
                        anchors.leftMargin: time_picker.langID != 20 ? CONST.const_TIME_PICKER_ELEMENTS_MARGIN : -111
                        width:CONST.const_TIME_PICKER_OTHER_WIDTH
                        height:dayText.height + daySpin.height
                        anchors.top : first.top
                        color:"transparent"
                        Text
                        {
                            id: dayText
                            width:parent.width
                            height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignTop
                            horizontalAlignment: Text.AlignHCenter
                            color: CONST.const_COLOR_TEXT_GREY
                            font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            font.family: time_picker.fontFamily
                            text: ( day_text.substring( 0, 4 ) != "STR_") ? day_text :
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, day_text )
                        }
                        DHAVN_PopUp_Item_VertSpinControl
                        {
                            id: daySpin
                            y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                            width:parent.width
                            minimum: CONST.const_TIME_PICKER_CLOCK_MIN_DAY
                            maximum: maxDaysInMonth
                            _fontFamily:time_picker.fontFamily
                            _selectionMode: selectionMode
                            focus_id: 1
                            focus_visible: focus_index==daySpin.focus_id
                            onSpinControlValueChanged: {
                                focus_index=daySpin.focus_id
                            }
                        }
                    }
                    Rectangle
                    {
                        id:third//first
//                        anchors.left: second.right
//                        anchors.leftMargin: CONST.const_TIME_PICKER_ELEMENTS_MARGIN
                        anchors.left:time_picker.langID != 20 ?  second.right : second.left
                        anchors.leftMargin: time_picker.langID != 20 ? CONST.const_TIME_PICKER_ELEMENTS_MARGIN : -169
                        anchors.top : first.top
                        width:CONST.const_TIME_PICKER_YEAR_WIDTH
                        height:yearText.height + yearSpin.height
                        color:"transparent"

                        Text
                        {
                            id: yearText
                            width:parent.width
                            height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignTop
                            horizontalAlignment: Text.AlignHCenter
                            color: CONST.const_COLOR_TEXT_GREY
                            font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            font.family: time_picker.fontFamily
                            text: ( year_text.substring( 0, 4 ) != "STR_") ? year_text :
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, year_text )
                        }
                        DHAVN_PopUp_Item_VertSpinControl
                        {
                            id: yearSpin
                            y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                            width:parent.width
                            bLargeSpiner: true
                            _fontFamily:time_picker.fontFamily
                            focus_visible: focus_index == yearSpin.focus_id
                            minimum: CONST.const_TIME_PICKER_CLOCK_MIN_YEAR
                            maximum: CONST.const_TIME_PICKER_CLOCK_MAX_YEAR
                            focus_id: 2
                            _selectionMode: selectionMode
                            onSpinControlValueChanged: {
                                maxDaysInMonth = getDaysInMonth((yearSpin.minimum + yearSpin.__index),(monthSpin.minimum+monthSpin.__index))
                                console.log("[SystemPopUp] year : " + (yearSpin.minimum + yearSpin.__index) + " month : " +(monthSpin.minimum+monthSpin.__index) + " maxDaysInMonth onMonthChange = " + maxDaysInMonth);
                                focus_index=yearSpin.focus_id
                            }
                        }
                    }

                    Rectangle{
                        id:fourth
                        width:CONST.const_TIME_PICKER_OTHER_WIDTH
                        height:hourText.height + hourSpin.height
                        anchors.top : first.top
//                        anchors.left: third.right
//                        anchors.leftMargin: CONST.const_TIME_PICKER_ELEMENTS_MARGIN
                        anchors.left: time_picker.langID != 20 ? third.right : third.left
                        anchors.leftMargin: time_picker.langID != 20 ? CONST.const_TIME_PICKER_ELEMENTS_MARGIN : -111
                        color:"transparent"
                        Text
                        {
                            id: hourText
                            width:parent.width
                            height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignTop
                            horizontalAlignment: Text.AlignHCenter
                            color: CONST.const_COLOR_TEXT_GREY
                            font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            font.family: time_picker.fontFamily
                            text: ( hour_text.substring( 0, 4 ) != "STR_") ? hour_text :
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, hour_text )
                        }
                        DHAVN_PopUp_Item_VertSpinControl
                        {
                            id: hourSpin
                            y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                            width:parent.width
                            //minimum: CONST.const_TIME_PICKER_CLOCK_MIN_HOUR
                            //maximum: CONST.const_TIME_PICKER_CLOCK_MAX_HOUR
                            minimum: time_picker.btwentyFourh == true ? CONST.const_TIME_PICKER_CLOCK_MIN_HOUR_24H : CONST.const_TIME_PICKER_CLOCK_MIN_HOUR
                            maximum: time_picker.btwentyFourh == true ? CONST.const_TIME_PICKER_CLOCK_MAX_HOUR_24H : CONST.const_TIME_PICKER_CLOCK_MAX_HOUR

                            _fontFamily:time_picker.fontFamily
                            _selectionMode: selectionMode
                            focus_id: 3
                            focus_visible: focus_index == 3
                            onSpinControlValueChanged: {
                                focus_index=hourSpin.focus_id
                            }
                        }
                    }

                    Rectangle{
                        id:fifth
//                        anchors.left: fourth.right
//                        anchors.leftMargin: CONST.const_TIME_PICKER_ELEMENTS_MARGIN
                        anchors.left: time_picker.langID != 20 ? fourth.right : fourth.left
                        anchors.leftMargin: time_picker.langID != 20 ? CONST.const_TIME_PICKER_ELEMENTS_MARGIN : -111
                        width:CONST.const_TIME_PICKER_OTHER_WIDTH
                        height:minuteText.height + minuteSpin.height
                        anchors.top : first.top
                        color:"transparent"
                        Text
                        {
                            id: minuteText
                            width:parent.width
                            height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignTop
                            horizontalAlignment: Text.AlignHCenter
                            color: CONST.const_COLOR_TEXT_GREY
                            font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            font.family: time_picker.fontFamily
                            text: ( minute_text.substring( 0, 4 ) != "STR_") ? minute_text :
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, minute_text )
                        }
                        DHAVN_PopUp_Item_VertSpinControl
                        {
                            id: minuteSpin
                            y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                            width:parent.width
                            minimum: CONST.const_TIME_PICKER_CLOCK_MIN_MINUTE
                            maximum: CONST.const_TIME_PICKER_CLOCK_MAX_MINUTE
                            _fontFamily:time_picker.fontFamily
                            _selectionMode: selectionMode
                            focus_id: 4
                            focus_visible: focus_index == 4
                            onSpinControlValueChanged: {
                                focus_index=minuteSpin.focus_id
                            }
                        }
                    }

                    Rectangle{
                        id:sixth
//                        anchors.left: fifth.right
//                        anchors.leftMargin: CONST.const_TIME_PICKER_ELEMENTS_MARGIN
                        anchors.left: time_picker.langID != 20 ? fifth.right : fifth.left
                        anchors.leftMargin: time_picker.langID != 20 ? CONST.const_TIME_PICKER_ELEMENTS_MARGIN : -111
                        y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                        width:CONST.const_TIME_PICKER_OTHER_WIDTH
                        height:yearText.height + timeTypeSpin.height
                        anchors.top : first.top
                        color:"transparent"
                        DHAVN_PopUp_Item_VertSpinControl
                        {
                            id: timeTypeSpin
                            y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                            width:parent.width
                            aSpinControlTextModel: amPMModel
                            _fontFamily:time_picker.fontFamily
                            _selectionMode: selectionMode
                            focus_id: 5
                            bEnabled:!btwentyFourh
                            focus_visible: focus_index == 5
                            onSpinControlValueChanged:
                            {
                                focus_index=timeTypeSpin.focus_id
                            }
                        }
                    }

                    DHAVN_PopUp_Item_Button
                    {
                        id: okBtn
                        anchors.left: parent.left
                        anchors.leftMargin: time_picker.langID != 20 ? CONST.const_BUTTON_LEFT_MARGIN : CONST.const_BUTTON_LEFT_MARGIN_REVERSE
                        anchors.top: parent.top
                        anchors.topMargin:18
                        bg_img_n: time_picker.langID != 20 ?  RES.const_POPUP_B_02_01_BUTTON_N : RES.const_POPUP_B_02_01_BUTTON_N_REVERSE
                        bg_img_p: time_picker.langID != 20 ? RES.const_POPUP_B_02_01_BUTTON_P : RES.const_POPUP_B_02_01_BUTTON_P_REVERSE
                        bg_img_f: time_picker.langID != 20 ? RES.const_POPUP_B_02_01_BUTTON_F : RES.const_POPUP_B_02_01_BUTTON_F_REVERSE
                        _fontFamily:"DH_HDB"
                        caption:  buttons.get(0).msg
                        bFocused:focus_index == 6
                        onBtnClicked:
                        {
                            console.log("[SystemPopUp] on Update, timeTypeSpin.sCurrentValue " + timeTypeSpin.sCurrentValue);
                            time_picker.updateCurrentTime( yearSpin.sCurrentValue, monthSpin.sCurrentValue, daySpin.sCurrentValue, hourSpin.sCurrentValue, minuteSpin.sCurrentValue, timeTypeSpin.__index/* .sCurrentValue*/)
                        }
                    }

                    DHAVN_PopUp_Item_Button
                    {
                        id:  cancelBtn
                        anchors.left: parent.left
                        anchors.leftMargin: time_picker.langID != 20 ? CONST.const_BUTTON_LEFT_MARGIN : CONST.const_BUTTON_LEFT_MARGIN_REVERSE
                        anchors.top: parent.top
                        anchors.topMargin:18+171
                        bg_img_n: time_picker.langID != 20 ? RES.const_POPUP_B_02_02_BUTTON_N : RES.const_POPUP_B_02_02_BUTTON_N_REVERSE
                        bg_img_p: time_picker.langID != 20 ? RES.const_POPUP_B_02_02_BUTTON_P : RES.const_POPUP_B_02_02_BUTTON_P_REVERSE
                        bg_img_f: time_picker.langID != 20 ? RES.const_POPUP_B_02_02_BUTTON_F : RES.const_POPUP_B_02_02_BUTTON_F_REVERSE
                        _fontFamily:"DH_HDB"
                        caption: buttons.get(1).msg
                        bFocused:focus_index == 7
                        onBtnClicked:
                        {
                            console.log("[SystemPopUp] on Close, timeTypeSpin.sCurrentValue " + timeTypeSpin.sCurrentValue);
                            time_picker.closeBtnClicked();
                        }
                    }

                }   // item
            }   // component - id_TIMEPICKER_NORTHAMERICA ---------------------------------------------------------------------------------

            // day, month, year -----------------------------------------------------------------------------------------------------------
            Component{
                id: id_TIMEPICKER_EUROPE
                Item{
                    function setCurrentTime(current_year, current_month, current_day,current_am_pm, current_hour, current_minute)
                    {
                        console.log("[SystemPopUp] setCurrentTime EUROPE" );
                        if(id_TIMEPICKER_NORMAL.status != Loader.Ready)
                            return;

                        yearSpin.setValue(current_year);
                        monthSpin.setValue(current_month);

                        console.log("[SystemPopUp] amPMModel.get(0)" + amPMModel.get(0).text);
                        console.log("[SystemPopUp] amPMModel.get(1)" + amPMModel.get(1).text);
                        if(current_am_pm == 0)
                            {
                                timeTypeSpin.setValue(amPMModel.get(0).text)
                            }
                        else
                            {
                                timeTypeSpin.setValue(amPMModel.get(1).text)
                            }

                        console.log("[SystemPopUp] timeTypeSpin.sCurrentValue" + timeTypeSpin.sCurrentValue);

                        //timeTypeSpin.setValue(current_am_pm);
                        hourSpin.setValue(current_hour);
                        minuteSpin.setValue(current_minute);

                        //console.log("maxDaysInMonth initially = " + maxDaysInMonth);
                        console.log("[SystemPopUp] year : " + yearSpin.sCurrentValue + " month : " + monthSpin.sCurrentValue + " maxDaysInMonth onMonth initially = " + maxDaysInMonth);

                        maxDaysInMonth = getDaysInMonth((yearSpin.minimum +yearSpin.__index),(monthSpin.minimum+monthSpin.__index))
                        //console.log("maxDaysInMonth set to = " + maxDaysInMonth);
                        console.log("[SystemPopUp] year : " + (yearSpin.minimum + yearSpin.__index) + " month : " + (monthSpin.minimum+monthSpin.__index) + " maxDaysInMonth onMonthChange = " + maxDaysInMonth);

                        daySpin.setValue(current_day);
                    }

                    // day
                    Rectangle{
                        id:dayRect
                        x: CONST.const_TIME_PICKER_START_POSITION_X
                        y: CONST.const_TIME_PICKER_START_POSITION_Y
                        width:CONST.const_TIME_PICKER_OTHER_WIDTH
                        height:dayText.height + daySpin.height
                        color:"transparent"
                        Text
                        {
                            id: dayText
                            width:parent.width
                            height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignTop
                            horizontalAlignment: Text.AlignHCenter
                            color: CONST.const_COLOR_TEXT_GREY
                            font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            font.family: time_picker.fontFamily
                            text: ( day_text.substring( 0, 4 ) != "STR_") ? day_text :
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, day_text )
                        }
                        DHAVN_PopUp_Item_VertSpinControl
                        {
                            id: daySpin
                            y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                            width:parent.width
                            minimum: CONST.const_TIME_PICKER_CLOCK_MIN_DAY
                            maximum: maxDaysInMonth
                            _fontFamily:time_picker.fontFamily
                            _selectionMode: selectionMode
                            focus_id: 0
                            focus_visible: focus_index==daySpin.focus_id
                            onSpinControlValueChanged: {
                                focus_index=daySpin.focus_id
                            }
                        }
                    }

                    // month
                    Rectangle{
                        id:monthRect
                        anchors.left:dayRect.right
                        anchors.leftMargin: CONST.const_TIME_PICKER_ELEMENTS_MARGIN
                        anchors.top : dayRect.top
                        width:CONST.const_TIME_PICKER_OTHER_WIDTH
                        height:monthText.height + monthSpin.height
                        color:"transparent"
                        Text
                        {
                            id: monthText
                            width:parent.width
                            height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignTop
                            horizontalAlignment: Text.AlignHCenter
                            color: CONST.const_COLOR_TEXT_GREY
                            font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            font.family: time_picker.fontFamily
                            text: ( month_text.substring( 0, 4 ) != "STR_") ? month_text :
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, month_text )
                        }
                        DHAVN_PopUp_Item_VertSpinControl
                        {
                            id: monthSpin
                            y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                            width:parent.width
                            minimum: CONST.const_TIME_PICKER_CLOCK_MIN_MONTH
                            maximum: CONST.const_TIME_PICKER_CLOCK_MAX_MONTH
                            focus_id: 1
                            focus_visible:focus_index == monthSpin.focus_id
                            _selectionMode: selectionMode
                            _fontFamily:time_picker.fontFamily
                            onSpinControlValueChanged: {
                                maxDaysInMonth = getDaysInMonth((yearSpin.minimum +  yearSpin.__index),(monthSpin.minimum+monthSpin.__index))
                                focus_index=monthSpin.focus_id
                                console.log("[SystemPopUp] year : " + (yearSpin.minimum +yearSpin.__index) + " month : " +(monthSpin.minimum+monthSpin.__index) + " maxDaysInMonth onMonthChange = " + maxDaysInMonth);
                            }
                        }
                    }

                    // year
                    Rectangle
                    {
                        id:yearRect
                        anchors.left: monthRect.right
                        anchors.leftMargin: CONST.const_TIME_PICKER_ELEMENTS_MARGIN
                        anchors.top : dayRect.top
                        width:CONST.const_TIME_PICKER_YEAR_WIDTH
                        height:yearText.height + yearSpin.height
                        color:"transparent"

                        Text
                        {
                            id: yearText
                            width:parent.width
                            height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignTop
                            horizontalAlignment: Text.AlignHCenter
                            color: CONST.const_COLOR_TEXT_GREY
                            font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            font.family: time_picker.fontFamily
                            text: ( year_text.substring( 0, 4 ) != "STR_") ? year_text :
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, year_text )
                        }
                        DHAVN_PopUp_Item_VertSpinControl
                        {
                            id: yearSpin
                            y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                            width:parent.width
                            bLargeSpiner: true
                            _fontFamily:time_picker.fontFamily
                            focus_visible: focus_index == yearSpin.focus_id
                            minimum: CONST.const_TIME_PICKER_CLOCK_MIN_YEAR
                            maximum: CONST.const_TIME_PICKER_CLOCK_MAX_YEAR
                            focus_id: 2
                            _selectionMode: selectionMode
                            onSpinControlValueChanged: {
                                maxDaysInMonth = getDaysInMonth((yearSpin.minimum + yearSpin.__index),(monthSpin.minimum+monthSpin.__index))
                                console.log("[SystemPopUp] year : " + (yearSpin.minimum + yearSpin.__index) + " month : " +(monthSpin.minimum+monthSpin.__index) + " maxDaysInMonth onMonthChange = " + maxDaysInMonth);
                                focus_index=yearSpin.focus_id
                            }
                        }
                    }

                    // hour
                    Rectangle{
                        id:hourRect
                        width:CONST.const_TIME_PICKER_OTHER_WIDTH
                        height:hourText.height + hourSpin.height
                        anchors.top : dayRect.top
                        anchors.left: yearRect.right
                        anchors.leftMargin: CONST.const_TIME_PICKER_ELEMENTS_MARGIN
                        color:"transparent"
                        Text
                        {
                            id: hourText
                            width:parent.width
                            height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignTop
                            horizontalAlignment: Text.AlignHCenter
                            color: CONST.const_COLOR_TEXT_GREY
                            font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            font.family: time_picker.fontFamily
                            text: ( hour_text.substring( 0, 4 ) != "STR_") ? hour_text :
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, hour_text )
                        }
                        DHAVN_PopUp_Item_VertSpinControl
                        {
                            id: hourSpin
                            y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                            width:parent.width
                            //minimum: CONST.const_TIME_PICKER_CLOCK_MIN_HOUR
                            //maximum: CONST.const_TIME_PICKER_CLOCK_MAX_HOUR
                            minimum: time_picker.btwentyFourh == true ? CONST.const_TIME_PICKER_CLOCK_MIN_HOUR_24H : CONST.const_TIME_PICKER_CLOCK_MIN_HOUR
                            maximum: time_picker.btwentyFourh == true ? CONST.const_TIME_PICKER_CLOCK_MAX_HOUR_24H : CONST.const_TIME_PICKER_CLOCK_MAX_HOUR

                            _fontFamily:time_picker.fontFamily
                            _selectionMode: selectionMode
                            focus_id: 3
                            focus_visible: focus_index == 3
                            onSpinControlValueChanged: {
                                focus_index=hourSpin.focus_id
                            }
                        }
                    }

                    // minute
                    Rectangle{
                        id:minuteRect
                        anchors.left: hourRect.right
                        anchors.leftMargin: CONST.const_TIME_PICKER_ELEMENTS_MARGIN
                        width:CONST.const_TIME_PICKER_OTHER_WIDTH
                        height:minuteText.height + minuteSpin.height
                        anchors.top : dayRect.top
                        color:"transparent"
                        Text
                        {
                            id: minuteText
                            width:parent.width
                            height:CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            anchors.horizontalCenter: parent.horizontalCenter
                            verticalAlignment: Text.AlignTop
                            horizontalAlignment: Text.AlignHCenter
                            color: CONST.const_COLOR_TEXT_GREY
                            font.pointSize:  CONST.const_TIME_PICKER_FONT_SIZE_TEXT_32PT
                            font.family: time_picker.fontFamily
                            text: ( minute_text.substring( 0, 4 ) != "STR_") ? minute_text :
                            qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, minute_text )
                        }
                        DHAVN_PopUp_Item_VertSpinControl
                        {
                            id: minuteSpin
                            y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                            width:parent.width
                            minimum: CONST.const_TIME_PICKER_CLOCK_MIN_MINUTE
                            maximum: CONST.const_TIME_PICKER_CLOCK_MAX_MINUTE
                            _fontFamily:time_picker.fontFamily
                            _selectionMode: selectionMode
                            focus_id: 4
                            focus_visible: focus_index == 4
                            onSpinControlValueChanged: {
                                focus_index=minuteSpin.focus_id
                            }
                        }
                    }

                    // am, pm
                    Rectangle{
                        id:timeTypeRect
                        anchors.left: minuteRect.right
                        anchors.leftMargin: CONST.const_TIME_PICKER_ELEMENTS_MARGIN
                        width:CONST.const_TIME_PICKER_OTHER_WIDTH
                        height:yearText.height + timeTypeSpin.height
                        anchors.top : dayRect.top
                        color:"transparent"
                        DHAVN_PopUp_Item_VertSpinControl
                        {
                            id: timeTypeSpin
                            y:CONST.const_TIME_PICKER_VERT_SPIN_START_POSITION_Y
                            width:parent.width
                            aSpinControlTextModel: amPMModel
                            _fontFamily:time_picker.fontFamily
                            _selectionMode: selectionMode
                            focus_id: 5
                            bEnabled:!btwentyFourh
                            focus_visible: focus_index == 5
                            onSpinControlValueChanged:
                            {
                                focus_index=timeTypeSpin.focus_id
                            }
                        }
                    }

                    DHAVN_PopUp_Item_Button
                    {
                        id: okBtn
                        anchors.left: parent.left
                        anchors.leftMargin: CONST.const_BUTTON_LEFT_MARGIN
                        anchors.top: parent.top
                        anchors.topMargin:18
                        bg_img_n: RES.const_POPUP_B_02_01_BUTTON_N
                        bg_img_p: RES.const_POPUP_B_02_01_BUTTON_P
                        bg_img_f: RES.const_POPUP_B_02_01_BUTTON_F
                        _fontFamily:"DH_HDB"
                        caption:  buttons.get(0).msg
                        bFocused:focus_index == 6
                        onBtnClicked:
                        {
                            console.log("[SystemPopUp] on Update, timeTypeSpin.sCurrentValue " + timeTypeSpin.sCurrentValue);
                            time_picker.updateCurrentTime( yearSpin.sCurrentValue, monthSpin.sCurrentValue, daySpin.sCurrentValue, hourSpin.sCurrentValue, minuteSpin.sCurrentValue, timeTypeSpin.__index/* .sCurrentValue*/)
                        }
                    }
                    DHAVN_PopUp_Item_Button
                    {
                        id:  cancelBtn
                        anchors.left: parent.left
                        anchors.leftMargin: CONST.const_BUTTON_LEFT_MARGIN
                        anchors.top: parent.top
                        anchors.topMargin:18+171
                        bg_img_n: RES.const_POPUP_B_02_02_BUTTON_N
                        bg_img_p: RES.const_POPUP_B_02_02_BUTTON_P
                        bg_img_f: RES.const_POPUP_B_02_02_BUTTON_F
                       _fontFamily:"DH_HDB"
                        caption: buttons.get(1).msg
                        bFocused:focus_index == 7
                        onBtnClicked:
                        {
                            console.log("[SystemPopUp] on Close, timeTypeSpin.sCurrentValue " + timeTypeSpin.sCurrentValue);
                            time_picker.closeBtnClicked();
                        }
                    }
                }   // item
            }   // component - id_TIMEPICKER_EUROPE ---------------------------------------------------------------------------------------

        }   //item
    }   //content


Connections
{
    target:UIListener// focus_visible ? UIListener : null

    onSignalJogCenterPressed: {  }
    onSignalJogCenterReleased: {  }
    onSignalJogCenterClicked: {}
    onSignalJogNavigation:
    {
        if( status == UIListenerEnum.KEY_STATUS_PRESSED ){
            if(time_picker.langID != 20){
                if ( (arrow == UIListenerEnum.JOG_RIGHT )/*&& focus_index == 5*/  )
                {
                    console.log("[SystemPopUp] focus_index at JOG_RIGHT" + focus_index)
                    if(!selectionMode&&(focus_index>=0&&focus_index<6))
                        focus_index = 6 ;
                    return
                }

                if ( (arrow == UIListenerEnum.JOG_LEFT  )/* && (focus_index==6 || focus_index==7)*/)
                {
                    console.log("[SystemPopUp] focus_index at JOG_LEFT" + focus_index)
                    if(!selectionMode && (focus_index == 6||focus_index==7))
                        focus_index = 0 ;

                    return
                }
            }else{
                if ( (arrow == UIListenerEnum.JOG_LEFT )/*&& focus_index == 5*/  )
                {
                    console.log("[SystemPopUp] focus_index at JOG_LEFT" + focus_index)
                    if(!selectionMode)
                        focus_index = 6 ;
                    return
                }

                if ( (arrow == UIListenerEnum.JOG_RIGHT  ) /*&& (focus_index==6 || focus_index==7)*/)
                {
                    console.log("[SystemPopUp] focus_index at JOG_RIGHT" + focus_index)
                    if(!selectionMode)
                        focus_index = 0 ;
                    return
                }
            }

            if(time_picker.langID != 20){
                if ( arrow == UIListenerEnum.JOG_WHEEL_RIGHT ) //Non ME
                {
                    console.log("[SystemPopUp] focus_index at JOG_WHEEL_RIGHT" + focus_index)
                    if(selectionMode)
                        return;
                    switch(focus_index)
                        {
                            case 0:
                            case 1:
                            case 2:
                            case 3:
                                focus_index++;
                                break;
                            case 4:
                                if(!btwentyFourh)
                                    focus_index++;
                                break;
                            case 6:
                                if(time_picker.langID != 20)
                                    focus_index++
                                break;
                            case 7:
                                if(time_picker.langID == 20)
                                    focus_index--
                                break;
                                default:
                                    break;
                        }
                    return
                }
            }else{ //ME
                if ( arrow == UIListenerEnum.JOG_WHEEL_RIGHT )
                {
                    console.log("[SystemPopUp] focus_index at JOG_WHEEL_RIGHT" + focus_index)
                    if(selectionMode)
                        return;
                    switch(focus_index)
                        {
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                                focus_index--;
                                break;
                            case 6:
                                if(time_picker.langID != 20)
                                    focus_index++
                                break;
                            case 7:
                                if(time_picker.langID == 20)
                                    focus_index--
                                break;
                                default:
                                    break;
                        }
                    return
                }
            }
            if(time_picker.langID != 20){
                if ( arrow == UIListenerEnum.JOG_WHEEL_LEFT )
                {
                    console.log("[SystemPopUp] focus_index at JOG_WHEEL_LEFT" + focus_index)
                    if(selectionMode)
                        return;
                    switch(focus_index)
                        {
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5:
                        focus_index--;
                        break;
                    case 6:
                        if(time_picker.langID == 20 )
                            focus_index++
                        break;
                    case 7:
                        if(time_picker.langID != 20)
                            focus_index--
                        break;
                            default:
                                break;

                        }

                    return
                }
            }else{
                if ( arrow == UIListenerEnum.JOG_WHEEL_LEFT ) //ME
                {
                    console.log("[SystemPopUp] focus_index at JOG_WHEEL_LEFT" + focus_index)
                    if(selectionMode)
                        return;
                    switch(focus_index)
                        {
                    case 0:
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                        focus_index++;
                        break;
                    case 6:
                        if(time_picker.langID == 20 )
                            focus_index++
                        break;
                    case 7:
                        if(time_picker.langID != 20)
                            focus_index--
                        break;
                            default:
                                break;

                        }

                    return
                }
            }
        }
        else if ( status == UIListenerEnum.KEY_STATUS_RELEASED ){
            if ( arrow == UIListenerEnum.JOG_CENTER )
            {
                console.log("[SystemPopUp] focus_index at JOG_CENTER" + focus_index)
                if(focus_index == 6){
                    time_picker.updateCurrentTime( yearSpin.sCurrentValue, monthSpin.sCurrentValue, daySpin.sCurrentValue, hourSpin.sCurrentValue, minuteSpin.sCurrentValue, timeTypeSpin.sCurrentValue)
                }
                else if(focus_index == 7){
                    time_picker.closeBtnClicked();
                }else{
                    console.log("[SystemPopUp] selectionMode = " + selectionMode)
                    selectionMode = !selectionMode
                }
                time_picker.lostFocus(arrow,focus_id);
                return
            }
        }

//        if ( status == UIListenerEnum.KEY_STATUS_CLICKED )
//        {
//            console.log(" KEY_STATUS_CLICKED")
//            if ( arrow == UIListenerEnum.JOG_CENTER )
//            {
//                console.log(" focus_index at JOG_CENTER" + focus_index)
//                if(focus_index == 6){
//                    time_picker.updateCurrentTime( yearSpin.sCurrentValue, monthSpin.sCurrentValue, daySpin.sCurrentValue, hourSpin.sCurrentValue, minuteSpin.sCurrentValue, timeTypeSpin.sCurrentValue)
//                }
//                else if(focus_index == 7){
//                    time_picker.closeBtnClicked();
//                }else{
//                    console.log("selectionMode = " + selectionMode)
//                    selectionMode = !selectionMode
//                }
//                time_picker.lostFocus(arrow,focus_id);
//                return
//            }
//            if(UIListener.GetCountryVariantFromQML() != 4){
//                if ( arrow == UIListenerEnum.JOG_WHEEL_RIGHT ) //Non ME
//                {
//                    console.log(" focus_index at JOG_WHEEL_RIGHT" + focus_index)
//                    if(selectionMode)
//                        return;
//                    switch(focus_index)
//                        {
//                            case 0:
//                            case 1:
//                            case 2:
//                            case 3:
//                            case 4:
//                                focus_index++;
//                                break;
//                            case 6:
//                                if(UIListener.GetCountryVariantFromQML() != 4)
//                                    focus_index++
//                                break;
//                            case 7:
//                                if(UIListener.GetCountryVariantFromQML() == 4)
//                                    focus_index--
//                                break;
//                                default:
//                                    break;
//                        }
//                    return
//                }
//            }else{ //ME
//                if ( arrow == UIListenerEnum.JOG_WHEEL_RIGHT )
//                {
//                    console.log(" focus_index at JOG_WHEEL_RIGHT" + focus_index)
//                    if(selectionMode)
//                        return;
//                    switch(focus_index)
//                        {
//                            case 1:
//                            case 2:
//                            case 3:
//                            case 4:
//                            case 5:
//                                focus_index--;
//                                break;
//                            case 6:
//                                if(UIListener.GetCountryVariantFromQML() != 4)
//                                    focus_index++
//                                break;
//                            case 7:
//                                if(UIListener.GetCountryVariantFromQML() == 4)
//                                    focus_index--
//                                break;
//                                default:
//                                    break;
//                        }
//                    return
//                }
//            }
//            if(UIListener.GetCountryVariantFromQML() != 4){
//                if ( arrow == UIListenerEnum.JOG_WHEEL_LEFT )
//                {
//                    console.log(" focus_index at JOG_WHEEL_LEFT" + focus_index)
//                    if(selectionMode)
//                        return;
//                    switch(focus_index)
//                        {
//                    case 1:
//                    case 2:
//                    case 3:
//                    case 4:
//                    case 5:
//                        focus_index--;
//                        break;
//                    case 6:
//                        if(UIListener.GetCountryVariantFromQML() == 4 )
//                            focus_index++
//                        break;
//                    case 7:
//                        if(UIListener.GetCountryVariantFromQML() != 4)
//                            focus_index--
//                        break;
//                            default:
//                                break;

//                        }

//                    return
//                }
//            }else{
//                if ( arrow == UIListenerEnum.JOG_WHEEL_LEFT ) //ME
//                {
//                    console.log(" focus_index at JOG_WHEEL_LEFT" + focus_index)
//                    if(selectionMode)
//                        return;
//                    switch(focus_index)
//                        {
//                    case 0:
//                    case 1:
//                    case 2:
//                    case 3:
//                    case 4:
//                        focus_index++;
//                        break;
//                    case 6:
//                        if(UIListener.GetCountryVariantFromQML() == 4 )
//                            focus_index++
//                        break;
//                    case 7:
//                        if(UIListener.GetCountryVariantFromQML() != 4)
//                            focus_index--
//                        break;
//                            default:
//                                break;

//                        }

//                    return
//                }
//            }

//        } // clicked


    }
 }

}
