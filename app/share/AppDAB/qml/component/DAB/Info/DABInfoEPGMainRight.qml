/**
 * FileName: DABInfoEPGMainRight.qml
 * Author: DaeHyungE
 * Time: 2012-07-11
 *
 * - 2012-07-11 Initial Crated by HyungE
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../JavaScript/DabOperation.js" as MDabOperation


MComp.MComponent {
    id : idDabInfoEPGMainRight

    property int selectedIndex: -1
    property int screenListCount: 5

    Connections {
        target: DABListener
        onReceiveEPGData:{
            //            console.log("[QML] ==> Conections: DABInfoEPGMainRight.qml : onReceiveEPGData: " + serviceID +  ensembleName + ", " + serviceName + ", " + hour + ":" + minute + ":" + second + ":" + duration + ", " + programTitle + ", " + description + ", " + reserveIcon);
            idEPGListModel.append({"serviceID":serviceID, "ensembleName":ensembleName, "serviceName":serviceName, "startTime":sTime, "endTime":eTime,"hour":((parseInt(hour)<10)?("0"+hour):hour), "minute":((parseInt(minute)<10)?("0"+minute):minute), "second":((parseInt(second)<10)?("0"+second):second), "duration":duration, "programTitle":programTitle, "description":description, "reservceIcon":reserveIcon});
        }

        onExistenceEPGData:{
            console.log("[QML] ==> Conections: DABInfoEPGMainRight.qml : onOff " + onOff)
            idDabInfoEPGMain.isExist = onOff;

            if( idDabInfoEPGMain.isExist == true) { //# focus to right after date update
                if(idDabInfoEPGMainLeft.focus == false){
                    idDabInfoEPGMain.focus = true;
                    idDabInfoEPGMainRight.focus = true;
                    idProgramInfoList.forceActiveFocus()
                    idProgramInfoList.currentIndex = 0;
                }
            }
            else {
                if(idDabInfoEPGMainLeft.listCountZeroCheck() == true){
                    idDabInfoEPGBand.focus = true;
                    idDabInfoEPGBand.forceActiveFocus()
                }
            }
        }
    }

    Connections {
        target: DABController
        onCmdResponseAddReservation:{
            console.log("[QML] DABInfoEPGDescPopup.qml : onReceiveAddReservation : isReserve =" + isReserve + ", hour = " + hour + ", minute = " + minute + ", second = " + second);

            var rDate = new Date(0,0,0,hour, minute, second);
            var rTime = Qt.formatTime(rDate, "hhmmss")
            var count = idEPGListModel.count;

            if(isReserve)
            {
                for(var i = 0; i < count; i++)
                {
                    var m_hour = idEPGListModel.get(i).hour;
                    var m_minute = idEPGListModel.get(i).minute;
                    var m_second = idEPGListModel.get(i).second;

                    var sDate = new Date(0,0,0,m_hour, m_minute, m_second);
                    var sTime = Qt.formatTime(sDate, "hhmmss")

                    console.log("[QML] DABInfoEPGDescPopup.qml : onCmdResponseAddReservation : rTime =" + rTime + ", sTime = " + sTime);
                    if(rTime == sTime && isReserve)
                    {
                        idEPGListModel.setProperty(i, "reservceIcon", true);
                    }
                    else
                    {
                        idEPGListModel.setProperty(i, "reservceIcon", false);
                    }
                }
            }
            m_bIsPreserve = isReserve;

            gotoBackScreen();
            setAppMainScreen("DabInfoEPGPreservePopup", true);
        }

        onCancelEPGReservation:{
            console.log("[QML] DABInfoEPGDescPopup.qml : onCancelEPGReservation :: isSystemPopup = " + isSystemPopup);
            var count = idEPGListModel.count;
            for(var i = 0; i < count; i++)
            {
                idEPGListModel.setProperty(i, "reservceIcon", false);
            }
            m_bIsPreserve = false;

            if(!isSystemPopup)
            {
                gotoBackScreen();
                setAppMainScreen("DabInfoEPGPreservePopup", true);
            }
        }
    }

    Connections{
        target : idDabInfoEPGMainLeft
        onEpgClear :{
            console.log("[QML] DABInfoEPGMainRight.qml : onEpgClear()");
            idEPGListModel.clear();
        }
    }

    onVisibleChanged: {
        console.log("[QML] DABInfoEPGMainRight.qml : onVisibleChange : visible = " + visible)
    }

    function isCurrentTime(hour, minute, second, duration)
    {
        //current time....
        var sTime = new Date(0,0,0,hour, minute, second);
        var startTime = Qt.formatTime(sTime, "hhmmss")
        var eTime = new Date(0,0,0,hour, minute, parseInt(second)+parseInt(duration));
        var stopTime =  Qt.formatTime(eTime, "hhmmss")
        var temp = new Date(0,0,0,0,0,0);
        var tempTime =  Qt.formatTime(temp, "hhmmss")
        console.log(" start:   " +startTime + " - " + stopTime);

        var nowDate = new Date();
        var cTime = Qt.formatTime(nowDate, "hhmmss")

        if(stopTime == tempTime)
        {
            eTime = new Date(0,0,0,23,59,59);
            var stopTime =  Qt.formatTime(eTime, "hhmmss")
        }

        if(cTime > startTime && cTime <= stopTime)
        {
            console.log(" cTime: " + cTime + " OnAir!!!!!!!")
            return true;
        }
        console.log(" cTime: " + cTime)
        return false;
    }

    function checkCurrentServiceChannel(epgDate, ensembleName, serviceName, hour, minute, second, duration)
    {
        if(DABListener.isCurrentDate(epgDate))
        {
            if(isCurrentTime(hour, minute, second, duration))
            {
                m_sButtonName = stringInfo.strEPGPopup_Listen
            }
            else
            {
                m_sButtonName = stringInfo.strEPGPopup_Timer
            }
        }
        else
        {
            m_sButtonName = stringInfo.strEPGPopup_Timer
        }
    }

    function listCountZeroCheck(){
        if(idProgramInfoList.count == 0) return true;
        else return false;
    }

    MComp.MListView {
        id: idProgramInfoList
        cacheBuffer: idProgramInfoList.count - screenListCount
        x : 0; y: 5 + 2;
        width: 547
        height: 534// 107 * 5
        focus: true
        clip: true
        snapMode: ListView.SnapToItem
        highlightMoveSpeed: 99999
        model: idEPGListModel
        delegate: idProgramInfoListDelegateComponent
        visible: idDabInfoEPGMain.isExist
        criticalPoint: 15
        onMovementEnded: {
            if(idAppMain.state == "DabInfoEPGMain"){
	        idDabInfoEPGBand.focus = false;
                idDabInfoEPGMainLeft.focus = false;
                idDabInfoEPGMainRight.focus = true;
            }
        }
    }

    Text {
        id: idEPGNotAvailable
        x: 0
        y: 247
        width: 510;
        height: 32
        text: stringInfo.strEPG_NotAvailable
        color: colorInfo.brightGrey
        font.family: idAppMain.fonts_HDR
        font.pixelSize: 32
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
        visible: !idDabInfoEPGMain.isExist
    }


    MComp.MScroll {
        x: 582 + 670 - parent.x
        y: 199 - systemInfo.headlineHeight
        height: 476
        width: 14
        visible: idProgramInfoList.count > screenListCount
        scrollArea: idProgramInfoList
        //selectedScrollImage: imageInfo.imgBgScroll_Menu_List
    }      

    Component {
        id : idProgramInfoListDelegateComponent

        MComp.MButton {
            id : idProgramInfoListDelegate
            width : 547
            height : 110 //107
            bgImagePress: imageInfo.imgListDab_EPG_P
            bgImageFocus: imageInfo.imgListDab_EPG_F

            active : (index == selectedIndex)? true : false
            firstText : startTime + "-" + endTime
            firstTextX : 24
            firstTextY : 34
            firstTextColor : "#7CBDFF" //# RGB(124, 189, 255)
            firstTextSelectedColor : idProgramInfoListDelegate.activeFocus ? colorInfo.white : "#7CBDFF" //# RGB(124, 189, 255)
            firstTextFocusColor: colorInfo.white
            firstTextSize : 26
            firstTextStyle : idAppMain.fonts_HDR
            firstTextWidth : 406

            secondText  : programTitle
            secondTextX : 24
            secondTextY : 34 + 3 + 38
            secondTextColor : colorInfo.brightGrey
            secondTextSelectedColor : colorInfo.brightGrey
            secondTextSize : 36
            secondTextStyle : idAppMain.fonts_HDR
            secondTextWidth : 406
            secondTextScrollEnable:  (m_bIsDrivingRegulation == false) && (idProgramInfoListDelegate.activeFocus) ? true : false

            lineImage: imageInfo.imgLineMenuList
            lineImageX: 9
            lineImageY: 110 + 2 //107

            Image {
                id : idReservceImg
                x : 24 + 406 + 20
                y : 34 + 3
                source : imageInfo.imgIconReserve
                visible : (reservceIcon == true)
            }

            onClickOrKeySelected : {
                console.log("[QML] DABInfoEPGMainRight.qml : onClickOrKeySelected : serviceName = " + serviceName + "  Title =" + programTitle + "  Description = " + description + " serviceID = " + serviceID);               
                idDabInfoEPGMainRight.focus = true
                idProgramInfoListDelegate.focus = true
                idProgramInfoList.currentIndex = index
                selectedIndex = index

                checkCurrentServiceChannel(m_xCurrentDate, ensembleName, serviceName, hour, minute, second, duration);
                MDabOperation.checkExistRevervationList(m_xCurrentDate, serviceID, hour, minute, second);
                m_sProgramServiceName = serviceName;
                m_sProgramTitle = (programTitle == "no_label") ? stringInfo.strEPG_NoTitleInfo :  programTitle;
                m_sProgramdDscription = (description == "no_descriptor") ? stringInfo.strEPGPopup_NoInformation :  description;
                m_sProgramServiceID = serviceID;
                m_sProgramTime = startTime + "  -  " + endTime;
                m_iHour = hour;
                m_iMinute = minute;
                m_iSecond = second;
                m_iDuration = duration;
                setAppMainScreen("DabInfoEPGDescPopup", true);
            }

            onWheelLeftKeyPressed:{
                console.log("[QML] DABInfoEPGMainRight.qml : onWheelLeftKeyPressed : index = " + idProgramInfoListDelegate.ListView.view.currentIndex + " count = " + idProgramInfoListDelegate.ListView.view.count);
                idDabInfoEPGMainRight.listLeftPageMovement()
                if( idProgramInfoListDelegate.ListView.view.currentIndex )
                {
                    idProgramInfoListDelegate.ListView.view.decrementCurrentIndex();
                }
                else
                {
                    if(idProgramInfoList.count > screenListCount){
                        idProgramInfoListDelegate.ListView.view.positionViewAtIndex(idProgramInfoListDelegate.ListView.view.count-1, idProgramInfoListDelegate.ListView.view.Visible);
                        idProgramInfoListDelegate.ListView.view.currentIndex = idProgramInfoListDelegate.ListView.view.count-1;
                    }
                }
                selectedIndex = idProgramInfoListDelegate.ListView.view.currentIndex

            }

            onWheelRightKeyPressed: {
                console.log("[QML] DABInfoEPGMainRight.qml : onWheelRightKeyPressed : index = " + idProgramInfoListDelegate.ListView.view.currentIndex + " count = " + idProgramInfoListDelegate.ListView.view.count);
                idDabInfoEPGMainRight.listRightPageMovement()
                if( idProgramInfoListDelegate.ListView.view.count-1 != idProgramInfoListDelegate.ListView.view.currentIndex )
                {
                    idProgramInfoListDelegate.ListView.view.incrementCurrentIndex();
                }
                else
                {
                    if(idProgramInfoList.count > screenListCount){
                        idProgramInfoListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
                        idProgramInfoListDelegate.ListView.view.currentIndex = 0;
                    }
                }
                selectedIndex = idProgramInfoListDelegate.ListView.view.currentIndex

            }

            Keys.onUpPressed: { // Set focus for Band
                event.accepted = true;
                return;
            } // End onUpPressed
            Keys.onDownPressed:{ // No Movement
                event.accepted = true;
                return;
            } // End onDownPressed

            onUpKeyReleased: {
                if(idAppMain.upKeyReleased == true){
                    idDabInfoEPGBand.focus = true
                }
                idAppMain.upKeyReleased  = false;
            }         
        }
    }
    //#****************************** List Page Movement
    function listLeftPageMovement(){

        var startIndex = idProgramInfoList.getStartIndex(idProgramInfoList.contentY);
        if(startIndex == idProgramInfoList.currentIndex){
            if(startIndex < screenListCount){
                idProgramInfoList.positionViewAtIndex(screenListCount-1, ListView.End);
            }
            else{
                idProgramInfoList.positionViewAtIndex(idProgramInfoList.currentIndex-1, ListView.End);
            }
        }
    }
    function listRightPageMovement(){
        if(((idProgramInfoList.currentIndex+1) % screenListCount) == 0){
            if(((idProgramInfoList.count % screenListCount) != 0) && ((idProgramInfoList.count - (((idProgramInfoList.currentIndex+1) / screenListCount) * screenListCount)) < screenListCount)){
                idProgramInfoList.positionViewAtIndex(idProgramInfoList.count-1, ListView.End);
            }
            else{
                idProgramInfoList.positionViewAtIndex(idProgramInfoList.currentIndex+1, ListView.Beginning);
            }
        }
    }
    //#****************************** List Page Movement End
}
