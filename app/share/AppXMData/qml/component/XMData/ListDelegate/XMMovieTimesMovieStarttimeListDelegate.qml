import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData
import "../../XMData/Javascript/ConvertUnit.js" as MConvertUnit

//XMDataLargeTypeListDelegate{
MComp.MComponent {
    id: idListItem
    x:101; y:0
    z: index
    width:ListView.view.width-x; height:90

    property bool clockTime: interfaceManager.DBIsClockTimeSaving;
    property bool timeFormatChange: interfaceManager.DBIs24TimeFormat;
    property bool summerTime: false; // interfaceManager.DBIsDayLightSaving;
    KeyNavigation.right: idEditButton

    onClickOrKeySelected: {
        ListView.view.currentIndex = index;
    }
    Image {
        x: -86; y: parent.height
        source: imageInfo.imgFolderGeneral + "list_line.png"
    }

    //Movie Name
    MComp.DDScrollTicker{
        id: idText
        x: 0; y: 0;
        width: 350
        height: 90;
        text: movieName
        fontFamily : systemInfo.font_NewHDB
        fontSize: 32
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }
    //Divider
    Image {
        x: idText.x+idText.width+5; y: 0
        source: imageInfo.imgFolderXMData + "movie_divider.png"
    }
    //Info Button
    //Movie Info Button(i)
    MComp.MButton{
        id:idEditButton
        x: idText.x+idText.width+25; y: 16
        width:62
        height:62
        bgImage:            imageInfo.imgFolderXMData + "btn_info_n.png"
        bgImagePress:       imageInfo.imgFolderXMData + "btn_info_p.png"
        bgImageFocus:       imageInfo.imgFolderXMData + "btn_info_f.png"
        focus: true

//        KeyNavigation.left: idText//[Smoke Test - disppear focus]

        onClickOrKeySelected: {
            idListItem.ListView.view.currentIndex = index;
            popupMovieInfo(movieName, grade, runningTime, actors, synopsis, rating);
        }
    }

    // Time.
    MComp.DDScrollTicker{
        id: idStartTime
        x: idEditButton.x+idEditButton.width+25; y: 0;
        width: 650
        height: parent.height
        text: getDate(clockTime)
        fontFamily : systemInfo.font_NewHDB
        fontSize: 32
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }

    onWheelRightKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        if( ListView.view.count-1 != index )
        {
            ListView.view.incrementCurrentIndex();
        }
        else
        {
            if(ListView.view.count <= rowPerPage)
                return;
            ListView.view.positionViewAtIndex(0, ListView.Visible);
            ListView.view.currentIndex = 0;
        }
//        ListView.view.moveOnPageByPage(rowPerPage, true);

    }
    onWheelLeftKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        if( index )
        {
            ListView.view.decrementCurrentIndex();
        }
        else
        {
            if(ListView.view.count <= rowPerPage)
                return;
            ListView.view.positionViewAtIndex(ListView.view.count-1, ListView.Visible);
            ListView.view.currentIndex = ListView.view.count-1;
        }
//        ListView.view.moveOnPageByPage(rowPerPage, false);
    }

    MXData.XMRectangleForDebug{
        Column{
            Text{ x:0; width:1240
                text: "movieByTheaterUniq = " + movieByTheaterUniq + "  , startTimeCount("+startTimeCount+"),startTime("+startTime+")";font.pixelSize: 12; color: "red"; font.bold: true;}
        }
    }

    function  getDate(clockTime){
        var currentDateTime = new Date();
        var allTimes = new Array();
        var tomorrow = true;
        var weekday = new Array(7);
        weekday[0]=  "[SUN]";
        weekday[1] = "[MON]";
        weekday[2] = "[TUE]";
        weekday[3] = "[WED]";
        weekday[4] = "[THU]";
        weekday[5] = "[FRI]";
        weekday[6] = "[SAT]";

        if(startTimeCount == 0)
        {
            return stringInfo.sSTR_XMDATA_MOVIE_NO_TIME_CALL_THEATER;
        }
        else
        {
            for(var i = 0 ; i < startTimeCount ; i++)
            {
                var date = new Date((startTime[i] + (summerTime == true ? 60*60 : 0))*1000);
                var strWeek = "";

                if(currentDateTime.getDate() == date.getUTCDate() &&
                        (currentDateTime.getHours() < date.getUTCHours() || (currentDateTime.getHours() == date.getUTCHours() && currentDateTime.getMinutes() < date.getUTCMinutes())))
                {
                    if( allTimes[MConvertUnit.convertTimeFormatForOthers(startTime[i], summerTime, timeFormatChange)] == null)
                    {
                        allTimes[MConvertUnit.convertTimeFormatForOthers(startTime[i], summerTime, timeFormatChange)] = MConvertUnit.convertTimeFormatForOthers(startTime[i], summerTime, timeFormatChange);
                        allTimes.push(MConvertUnit.convertTimeFormatForOthers(startTime[i], summerTime, timeFormatChange));
                    }
                }
                else if( (currentDateTime.getDay()+1) == date.getUTCDay() || ( currentDateTime.getDay() == 6 && date.getUTCDay() == 0) )
                {
                    if(tomorrow)
                    {
                        strWeek = weekday[date.getUTCDay()];
                        tomorrow = false;
                    }
                    if( allTimes["tomorrow" + MConvertUnit.convertTimeFormatForOthers(startTime[i], summerTime, timeFormatChange)] == null)
                    {
                        allTimes["tomorrow" + MConvertUnit.convertTimeFormatForOthers(startTime[i], summerTime, timeFormatChange)] = MConvertUnit.convertTimeFormatForOthers(startTime[i], summerTime, timeFormatChange);
                        allTimes.push(strWeek + MConvertUnit.convertTimeFormatForOthers(startTime[i], summerTime, timeFormatChange));
                    }
                }
                else if(isDebugMode())
                {
                    strWeek = date.getUTCDate();
                    if( allTimes["else" + MConvertUnit.convertTimeFormatForOthers(startTime[i], summerTime, timeFormatChange)] == null)
                    {
                        allTimes["else" + MConvertUnit.convertTimeFormatForOthers(startTime[i], summerTime, timeFormatChange)] = MConvertUnit.convertTimeFormatForOthers(startTime[i], summerTime, timeFormatChange);
                        allTimes.push(strWeek + "else " + MConvertUnit.convertTimeFormatForOthers(startTime[i], summerTime, timeFormatChange));
                    }
                }
            }
        }
        return allTimes.join(", ");
    }

}
