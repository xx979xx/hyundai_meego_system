/**
 * FileName: MOptionMenuDelegate.qml
 * Author: WSH
 * Time: 2012-03-13
 *
 * - 2012-03-13 Modified by WSH
 * - 2013-01-03 Modified function (onClickOrKeySelected) by WSH
 * - 2013-01-03 Updated Component (MButton.qml) by WSH
 * - 2013-01-03 Changed function (getDimmed() -> getEnabled()) by WSH
 */
import QtQuick 1.0

MButton {
    id: idOptionMenuDelegate
    x: 0; y: 0
    width: delegateWidth; height: opItemHeight
    mEnabled: getEnabled()

    function getEnabled(){
        switch(index){
        case 0: return menu0Enabled;
        case 1: return menu1Enabled;
        case 2: return menu2Enabled;
        case 3: return menu3Enabled;
        case 4: return menu4Enabled;
        case 5: return menu5Enabled;
        case 6: return menu6Enabled;
        case 7: return menu7Enabled;
        case 8: return menu8Enabled;
        case 9: return menu9Enabled;
        case 10: return menu10Enabled;
        default: return true;
        }
    } // End function

    function getIsEnabled(tindex){
        switch(tindex){
        case 0: return menu0Enabled;
        case 1: return menu1Enabled;
        case 2: return menu2Enabled;
        case 3: return menu3Enabled;
        case 4: return menu4Enabled;
        case 5: return menu5Enabled;
        case 6: return menu6Enabled;
        case 7: return menu7Enabled;
        case 8: return menu8Enabled;
        case 9: return menu9Enabled;
        case 10: return menu10Enabled;
        default: return true;
        }
    } // End function
    //onMEnabledChanged: { console.log(" [MOptionMenuDelegate]["+index+"]: "+getEnabled()) }

    function opTypeEvent(index, opType){
        if(idOptionMenuDelegate.mEnabled){
            indexEvent(index)
        } // End if
    } // End function

    //--------------------- Button Info #
    buttonWidth : width
    buttonHeight: height
    bgImage: ""
    bgImagePress: opBgImagePress
    bgImageFocus: getEnabled() == true ? opBgImageFocus : ""

    //--------------------- Clicked/Selected Event #
    onClickOrKeySelected: {
        if(pressAndHoldFlag == false){
            if(idAppMain.isSettings == true) return;

            //console.log("[QML] MOptionMenuDelegate :: onClickOrKeySelected  ")
            idMOptionMenu.linkedCurrentIndex = index
            idOptionMenuDelegate.ListView.view.currentIndex = index
            idOptionMenuDelegate.ListView.view.focus = true
            idOptionMenuDelegate.ListView.view.forceActiveFocus()
            opTypeEvent(index, opType)
        }
    }

    onClickReleased: {
        if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
    }

    //--------------------- Menu Item #
    firstText: name
    firstTextX: listLeftMargine
    firstTextY : (172-systemInfo.statusBarHeight)-opItemFontSize
    firstTextSize: opItemFontSize
    firstTextStyle: opItemFontName
    firstTextWidth: 416-listLeftMargine*2 //(opType=="") ? 416 : 376
    firstTextHorizontalAlies: "Left"
    firstTextElide : "Right"
    firstTextColor: getEnabled() == true ? colorInfo.subTextGrey : firstTextDisableColor
    firstTextPressColor: getEnabled() == true ? colorInfo.brightGrey : firstTextDisableColor
    firstTextEnabled: getEnabled()
    firstTextScrollEnable: ( (idOptionMenuDelegate.firstTextOverPaintedWidth == true)  && (idOptionMenuDelegate.activeFocus == true)
                          && (idAppMain.drivingRestriction == false) ) ? true : false

    //--------------------- Line Image #
    Image {
        id: imgLine
        y: opLineY
        //height: opLineHeight
        source: opLineImg
    } // End Imgae

//    // # Restart Timer # by WSH(121030)
//    onPressed: { idMOptionMenuTimer.restart() }

    //# 5s Timer stop(), start() for Flickable (disabled) : KEH (20130416)
    Item{
        width: parent.width; height: parent.height
        visible: (idOptionMenuDelegate.mEnabled == false)
        MouseArea{
            anchors.fill: parent
            onPressed: { idMOptionMenuTimer.stop();}
            onReleased:{ idMOptionMenuTimer.start();}
        }
    }

    onPressAndHold: {
        if(idOptionMenuDelegate.state == "pressed" ||idOptionMenuDelegate.state == "keyPress" )
        {
            idMOptionMenuTimer.stop();
        }
    }

    onAnyKeyReleased: {
        idOptionMenuDelegate.state = "keyRelease"
        idMOptionMenuTimer.restart();
    }

    onMouseExit:{
 //       console.log(" [JEON][MOptionMenuDelegate][onMouseExit")
            idMOptionMenuTimer.restart();
    }

    Keys.onPressed: {
        //console.log("[QML] MOptionMenuDelegate :: Keys.onPressed : currentIndex = ",idOptionMenuDelegate.ListView.view.currentIndex  )

        var i, tindex, tcount;
        tindex = idOptionMenuDelegate.ListView.view.currentIndex;
        tcount = idOptionMenuDelegate.ListView.view.count-1;
        i=0;

        if(event.key == Qt.Key_Up)
        {
            event.accepted = true;
            return;
//            while(i != tcount){

//                if(tindex <= 0){
//                    //tindex = tcount;
//                    break;      //# KEH (20130316)
//                }
//                else{
//                    tindex--;
//                }

////                console.log("[QML] MOptionMenuDelegate :: Keys.onPressed : getIsEnabled(tindex) = "+getIsEnabled(tindex)+"  index ="+ tindex )
//                if( getIsEnabled(tindex) == false )
//                {
//                    idOptionMenuDelegate.ListView.view.currentIndex = tindex;
//                }
//                else
//                {
//                    break;
//                }
//                i++;
//            }
        }
        else if(event.key == Qt.Key_Down)
        {
            event.accepted = true;
            return;
//            while(i != tcount){

//                if(tindex >= tcount){
//                    //tindex = 0;
//                    break;      //# KEH (20130316)
//                }
//                else{
//                    tindex++;
//                }

////                console.log("[QML] MOptionMenuDelegate :: Keys.onPressed : getIsEnabled(tindex) = "+getIsEnabled(tindex)+"  index ="+ tindex )
//                if( getIsEnabled(tindex) == false )
//                {
//                    idOptionMenuDelegate.ListView.view.currentIndex = tindex;
//                }
//                else
//                {
//                    break;
//                }

//                i++;
//            }
        }
    }


    onWheelLeftKeyPressed: {
        if(idAppMain.isSettings == true) return;
        if(idOptionMenuDelegate.ListView.view.flicking || idOptionMenuDelegate.ListView.view.moving) return;

        //console.log("[QML] MOptionMenuDelegate :: onWheelLeftKeyPressed : currentIndex = ",idOptionMenuDelegate.ListView.view.currentIndex )

        var i, tindex, tcount;
        tindex = idOptionMenuDelegate.ListView.view.currentIndex;
        tcount = idOptionMenuDelegate.ListView.view.count-1;
        i=0;

        while(i != tcount){

            if(tindex <= 0){
//                tindex = tcount;
                break;
            }
            else{
                tindex--;
            }

            if( getIsEnabled(tindex) == true )
            {
                idOptionMenuDelegate.ListView.view.currentIndex = tindex;
                break;
            }
            i++;
        }     
    }

    onWheelRightKeyPressed: {
        if(idAppMain.isSettings == true) return;
        if(idOptionMenuDelegate.ListView.view.flicking || idOptionMenuDelegate.ListView.view.moving) return;

        // console.log("[QML] MOptionMenuDelegate :: onWheelRightKeyPressed : currentIndex = ",idOptionMenuDelegate.ListView.view.currentIndex )

        var i, tindex, tcount;
        tindex = idOptionMenuDelegate.ListView.view.currentIndex;
        tcount = idOptionMenuDelegate.ListView.view.count-1;
        i=0;

        while(i != tcount){

            if(tindex >= tcount){
//                tindex = 0;
                break;
            }
            else{
                tindex++;
            }

            if( getIsEnabled(tindex) == true )
            {
                idOptionMenuDelegate.ListView.view.currentIndex = tindex;
                break;
            }
            i++;
        }       
    }

    Connections{
        target: idMOptionMenu
        onPressedForFlickableEnded:{
            if(idOptionMenuDelegate.active == false){
                idOptionMenuDelegate.state = "keyRelease"
            }
            idMOptionMenuTimer.start();
        }
    } // End Connections
} // End MButton
