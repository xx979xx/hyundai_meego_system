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

MButtonOnlyRadio {//MButton {
    id: idOptionMenuDelegate
    x: 0; y: 0
    width: delegateWidth; height: opItemHeight
    mEnabled: getEnabled(index)
// 20130428 added by qutiguy - add looping conditions.
    property int limitCount : 8; // 1page view's maximum list count for option menu.
    property bool bCheckedRadioBtn : (index == selectedRadioIndex) //KSW 140613

    function getEnabled(index){
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
        case 11: return menu11Enabled;
        case 12: return menu12Enabled;
        case 13: return menu13Enabled;
        case 14: return menu14Enabled;
        case 15: return menu15Enabled;
        case 16: return menu16Enabled;
        case 17: return menu17Enabled;
        case 18: return menu18Enabled;
        case 19: return menu19Enabled;
        case 20: return menu20Enabled;

        default: return true;
        }
    } // End function

 //dg.jin 20160513 ITS 0272975
    onMEnabledChanged: { 
        console.log(" [onMEnabledChanged]["+index+ "]: "+getEnabled(index)) ;
        console.log(" idOptionMenuDelegate.state: "+idOptionMenuDelegate.state) ;
        if(getEnabled(index) == false && idOptionMenuDelegate.state == "keyReless")
           idOptionMenuDelegate.ListView.view.interactive = true;
    }

//property alias dimCheckFlag: idOptionMenuDimcheck.state  //# for rds radio by HYANG (20120521) //KSW 140613
    property alias dimCheckFlag: idDimCheck.state  //# for rds radio by HYANG (20120521) //KSW 140613

    function opTypeEvent(index, opType){
        if(idOptionMenuDelegate.mEnabled){
            if(opType=="dimCheck"){
                //console.log("[MOptionMenuDelegate] idOptionMenuDimcheck.state : ", idOptionMenuDimcheck.state)
                //KSW 140613 start
//                if(dimCheckFlag == "on"){
//                    dimCheckFlag = "off"
//                    idOptionMenuDimcheck.dimUnchecked()
//                }else if(dimCheckFlag == "off"){
//                    dimCheckFlag = "on"
//                    idOptionMenuDimcheck.dimChecked()
//                } // End if
                if(dimCheckFlag == "on"){
                    dimCheckFlag = "off"
                    dimUncheckEvent(index)
                }else if(dimCheckFlag == "off"){
                    dimCheckFlag = "on"
                    dimCheckEvent(index)
                }
                //KSW 140613 end
            }
            else if(opType=="radioBtn") {
                selectedRadioIndex = index
                radioEvent(index)
            }
            else{ indexEvent(index) } // End if
        } // End if
    } // End function

    //--------------------- Button Info #
    buttonWidth : width
    buttonHeight: height
    bgImage: ""
    bgImagePress: opBgImagePress
    bgImageFocusPress: opBgImageFocusPress
    bgImageFocus: opBgImageFocus

    //--------------------- Clicked/Selected Event #
    onClickOrKeySelected: {
        //console.log("[MOptionMenuDelegate] onClickOrKeySelected : ")
        // 2013.10,.01 added by qutiguy - ITS 0191379 : return while option menu is moving
        if(!menuAnimation)
            return;
        if(idOptionMenuDelegate.state != "pressed" && idOptionMenuDelegate.ListView.view.interactive == false) // JSH 130927
            return;

        ////////////////////////////////////////////////////////
        // JSH 130813 added
        if(!idMOptionMenu.bandMirrorMode){
            if(idMOptionMenu.endX - idMOptionMenu.startX > 100)
                return;
        }
        else{
            if(idMOptionMenu.startX - idMOptionMenu.endX > 100)
                return;
        }
        ////////////////////////////////////////////////////////

        idMOptionMenu.linkedCurrentIndex = index
        idOptionMenuDelegate.ListView.view.currentIndex = index
        idOptionMenuDelegate.ListView.view.focus = true
        idOptionMenuDelegate.ListView.view.forceActiveFocus()
        opTypeEvent(index, opType)
    }

    //--------------------- Menu Item #
    firstText: name
    firstTextX: (!idAppMain.generalMirrorMode) ? listLeftMargine:0 // 2013.12.18 modified by qutiguy ITS 2159431
    firstTextY : (172-systemInfo.statusBarHeight-36)//(130-systemInfo.statusBarHeight) + 5 , JSH 130619 Modify
    firstTextSize: opItemFontSize
    firstTextStyle: opItemFontName
    firstTextWidth: (opType=="") ? opItemWidth-1 : opItemWidth-45-1
    firstTextAlies: (!idAppMain.generalMirrorMode) ? "Left" : "Right"
    firstTextElide : "Right"
    firstTextColor: idOptionMenuDelegate.activeFocus ? colorInfo.brightGrey : colorInfo.subTextGrey // colorInfo.subTextGrey, JSH 140118 modify
    firstTextPressColor: colorInfo.brightGrey
    firstTextFocusPressColor: colorInfo.brightGrey
    firstTextEnabled: getEnabled(index)
    firstTextScrollEnable:((focusImageVisible && (!idAppMain.drsShow)) && (!idAppMain.generalMirrorMode)) ? true : false // JSH 130719

    //dg.jin 20140820 ITS 0243389 full focus issue for KH
    //--------------------- Line Image #
    isoptionmenuline : true
    optionmenuLineY : opLineY
    optionmenuLineHeight : opLineHeight
    optionmenuLineImg : opLineImg
    
    //--------------------- Sub Menu #
    Image{
        id: idOptionMenuSubMenu
        x: opIconX
        source: imgFolderGeneral + "ico_optionmenu_arrow.png"
        anchors.verticalCenter: parent.verticalCenter
        visible: (opType=="subMenu")
    } // End SubMenu

    //--------------------- Dim Check #
    //KSW 140613 start
//    MDimCheck{
//        id: idOptionMenuDimcheck
//        iconX: opIconX
//        anchors.verticalCenter: parent.verticalCenter
//        visible: (opType=="dimCheck")
//        state: (flagToggle==true)?"on":"off"
//        mEnabled: getEnabled(index)
//        Component.onCompleted:{ // JSH 131107
//            if(visible && (UIListener.GetCountryVariantFromQML() == 1) || (UIListener.GetCountryVariantFromQML() == 6)) // NA , Canada
//                state = check ? "on":"off"
//        }
//    } // End MDimCheck

    Image {
        id : idDimCheck
        x: opIconX
        anchors.verticalCenter: parent.verticalCenter
        visible: (opType=="dimCheck")

        states: [
            State { name: "on" ; PropertyChanges { target: idDimCheck; source: imgFolderGeneral + "ico_check_s.png" } },
            State { name: "off";
                PropertyChanges {
                    target: idDimCheck;
                    source: getEnabled(index) ? imgFolderGeneral + "ico_check_n.png" : imgFolderGeneral + "ico_check_d.png"
                }
            }
        ]
        Component.onCompleted:{ // JSH 131107
            if(visible && (UIListener.GetCountryVariantFromQML() == 1) || (UIListener.GetCountryVariantFromQML() == 6)) // NA , Canada
                state = check ? "on":"off"
        }
    } // End MDimCheck

    //--------------------- Radio Button #
    Image {
        id : idCheckedRadioBtn
        x: opIconX
        anchors.verticalCenter: parent.verticalCenter
        visible: (opType=="radioBtn")

        states: [
            State { name: "on" ; when: bCheckedRadioBtn; PropertyChanges { target: idCheckedRadioBtn; source: imgFolderGeneral + "ico_radio_s.png" } },
            State { name: "off"; when: !bCheckedRadioBtn; PropertyChanges { target: idCheckedRadioBtn; source: imgFolderGeneral + "ico_radio_n.png" } }
        ]
    }

//    MRadioButton{
//        id: idOptionMenuRadioBtn
//        iconX: opIconX
//        z: 1
//        anchors.verticalCenter: parent.verticalCenter
//        visible: (opType=="radioBtn")
//        active: index == selectedRadioIndex
//        mEnabled: getEnabled(index)

//        //KSW 131212 [211424][ITS]
//        onPressedForFlickable: {
//            console.debug("state ?? " + idOptionMenuDelegate.state)
//            if(idOptionMenuDelegate.mEnabled) {
//                //console.log("[QML] MButton onPressedForFlickable. state:"+ idOptionMenuDelegate.state);
//                idOptionMenuDelegate.state = "pressed";
//            } else {
//                idOptionMenuDelegate.state = "disabled"
//            }
//            idOptionMenuDelegate.pressedForFlickable(x,y);
//        }

//        onMousePosChanged : {
//            //console.log("[QML] MButton onMousePosChanged. state:x = "+ x + ", y = " + y);
//            if(idOptionMenuDelegate.state == "pressed"){
//                if( x < 0 ){
//                    idOptionMenuDelegate.state="keyReless"
//                }
//            }
//        }
//        onClickReleased :{
//            //console.log("[QML] MButton onClickReleased. active:"+ idOptionMenuDelegate.active);
//            if(idOptionMenuDelegate.mEnabled){
//                if(idOptionMenuDelegate.active==true){
//                    idOptionMenuDelegate.state="active"
//                }else{
//                    idOptionMenuDelegate.state="keyReless";
//                }
//            }else{
//                idOptionMenuDelegate.state = "disabled"
//            }
//            idOptionMenuDelegate.clickReleased();
//        }

//        onCancel:{
//            //console.log("[QML] MButton onCancel. active:"+ idOptionMenuDelegate.mEnabled);
//            if(!idOptionMenuDelegate.mEnabled)
//                return;

//            if(idOptionMenuDelegate.active==true){
//                idOptionMenuDelegate.state="active";
//            }else{
//                idOptionMenuDelegate.state="keyReless";
//            }
//        }

//        onActiveFocusChanged: {
//            //console.log("[QML] MButton onActiveFocusChanged. activeFocus:"+ idOptionMenuDelegate.activeFocus);
//            if(idOptionMenuDelegate.activeFocus == false && idOptionMenuDelegate.state == "pressed"){
//                if(active==true){
//                    container.state="active"
//                }else{
//                    container.state="keyReless";
//                }
//            }
//        }

//        onPressAndHold: {idMOptionMenuTimer.stop();}
//        //KSW 131212 end

//        onClickOrKeySelected: {
//            selectedRadioIndex = selectedIndex
//            radioEvent(selectedRadioIndex)
//        }
//    } // End MRadioButton
//KSW 140613 end

    //dg.jin 20140820 ITS 0243389 full focus issue for KH
    //--------------------- Line Image #
    //Image {
    //    id: imgLine
    //    y: opLineY
    //    height: opLineHeight
    //    source: opLineImg
    //} // End Imgae 

    //# 5s Timer stop(), start() for Flickable (disabled) : KEH (20130416)
    Item{
        width: parent.width; height: parent.height
        visible: (idOptionMenuDelegate.mEnabled == false)
        MouseArea{
            id:mouseArea
            anchors.fill: parent
            property bool isExited : false // JSH 131104
            onPressed: { // JSH 131104 Modify
                //idMOptionMenuTimer.stop();
                idMOptionMenu.endX  = idMOptionMenu.startX =  mouseX;
                idMOptionMenu.tempX = 0;
                idMOptionMenuTimer.stop();
                idOptionMenuDelegate.ListView.view.interactive = false
                isExited            = false; // JSH 131104
            }
            onReleased:{ // JSH 131104 Modify
                //idMOptionMenuTimer.start();
                idMOptionMenuTimer.restart();

                if(!isExited){
                    idMOptionMenu.endX = mouseX;
                    if(!idMOptionMenu.bandMirrorMode){
                        if(idMOptionMenu.endX - idMOptionMenu.startX > 100)
                            menuAnimation = false;
                    }
                    else{
                        if(idMOptionMenu.startX - idMOptionMenu.endX > 100)
                            menuAnimation = false;
                    }
                }

                idOptionMenuDelegate.ListView.view.interactive = true
            }
            onExited:  { // JSH 131104 added
                if(!mouseArea.pressed)
                    return;
                isExited = true ;
                idOptionMenuDelegate.ListView.view.interactive = true;//cancel();
            }
        }
    }

    //# 5s Timer stop() for Flickable (disabled) : KEH (20130416)
    onPressAndHold: {idMOptionMenuTimer.stop();}  // JSH 130711 added
    onAnyKeyReleased: {                           // JSH 130711 added
        idOptionMenuDelegate.state = "keyRelease"
        idMOptionMenuTimer.restart();
    }
    onPressedForFlickable:{ // JSH 130813 Modify
        idMOptionMenu.endX = idMOptionMenu.startX =  x;
        idMOptionMenu.tempX = 0;
        idMOptionMenuTimer.stop();
        idOptionMenuDelegate.ListView.view.interactive = false // JSH 130813 Testing
    }
    onClickReleased: { // JSH 130813 Modify
        idMOptionMenuTimer.restart();
        if(!idMOptionMenu.bandMirrorMode){
            if(idMOptionMenu.endX - idMOptionMenu.startX > 100)
            {
                subMenuClose  = true; //KSW 131118
                menuAnimation = false;
            }
        }
        else{
            if(idMOptionMenu.startX - idMOptionMenu.endX > 100)
                menuAnimation = false;
        }
        idOptionMenuDelegate.ListView.view.interactive = true // JSH 130813 Testing
    }
    onMousePosChanged: {
        ///////////////////////////////////////////////////////////////////
        // JSH 130927 Modify
        idMOptionMenu.endX = x
        //console.log("===========================> [MOptionMenuDelegate] onMousePosChanged : " ,idMOptionMenu.endX , idMOptionMenu.startX , idMOptionMenu.tempX)
        if(!idMOptionMenu.bandMirrorMode){
            if(idOptionMenuDelegate.state == "pressed" && (idMOptionMenu.endX - idMOptionMenu.startX > 100)){
                idOptionMenuDelegate.state="keyReless";//idOptionMenuDelegate.cancel();
                idMOptionMenu.tempX = idMOptionMenu.endX;
            }
            else if(idOptionMenuDelegate.state == "keyReless" && (idMOptionMenu.tempX > idMOptionMenu.endX))
                idMOptionMenu.tempX = idMOptionMenu.startX = idMOptionMenu.endX
            else
                idMOptionMenu.tempX = idMOptionMenu.endX;
        }
        else{
            if(idOptionMenuDelegate.state == "pressed" && (idMOptionMenu.startX - idMOptionMenu.endX > 100)){
                idOptionMenuDelegate.state="keyReless";//idOptionMenuDelegate.cancel();
                idMOptionMenu.tempX = idMOptionMenu.endX;
            }
            else if(idOptionMenuDelegate.state == "keyReless" && (idMOptionMenu.tempX < idMOptionMenu.endX))
                idMOptionMenu.tempX = idMOptionMenu.startX = idMOptionMenu.endX
            else
                idMOptionMenu.tempX = idMOptionMenu.endX;
        }
        ///////////////////////////////////////////////////////////////////
    } // JSH 130813 added
    onCancel:{
        idOptionMenuDelegate.ListView.view.interactive = true // JSH 130813 Testing
    }
    //------------------------------------------------------------
    // Updated jog_V1.3 (Close OptionMenu) # by WSH
    /////////////////////////////////////////////////////////////
    // JSH 131107
    Keys.onReleased: {
        if(idAppMain.isLeft(event) && (!bandMirrorMode)){
            subMenuClose  = true;
            menuAnimation = false;//optionMenuFinished();
        }
        else if(idAppMain.isRight(event) && (bandMirrorMode)){
            subMenuClose  = true;
            menuAnimation = false;//optionMenuFinished();
        }
        else if (idAppMain.isRight(event) && opType=="subMenu") { //KSW 130718 Fixed to  problem is not to enter in submenu to "jog right key".
            opTypeEvent(index, opType)
        }
    }
    /////////////////////////////////////////////////////////////
    Keys.onPressed: {
        if((event.key == Qt.Key_Up) || (event.key == Qt.Key_Down)){ // JSH 130724 delete ITS[0181459] Issue
            event.accepted  = true;
            return;
        }
    }

    onWheelLeftKeyPressed: {
        //console.log("idOptionMenuDelegate.ListView.view.flicking",idOptionMenuDelegate.ListView.view.flicking);
        //console.log("idOptionMenuDelegate.ListView.view.moving",idOptionMenuDelegate.ListView.view.moving);
        //console.log("idOptionMenuDelegate.ListView.view.count",idOptionMenuDelegate.ListView.view.count);
        //console.log("idOptionMenuDelegate.ListView.view.currentIndex",idOptionMenuDelegate.ListView.view.currentIndex);
        
        if(idOptionMenuDelegate.ListView.view.flicking)   return;
        if( idOptionMenuDelegate.ListView.view.currentIndex ){
            //idOptionMenuDelegate.ListView.view.decrementCurrentIndex();
            /////////////////////////////////////////////////////////////////////////
            // JSH 130131 focus
            //console.log("++++++++++++++++++1 onWheelLeftKeyPressed+++++++++++++++++++",idOptionMenuDelegate.ListView.view.currentIndex,tmp,index)
            for(var i=idOptionMenuDelegate.ListView.view.currentIndex-1; idOptionMenuDelegate.ListView.view.currentIndex >= 0 ;i--){
                idOptionMenuDelegate.ListView.view.currentIndex = i
                if(!idOptionMenuDelegate.ListView.view.currentItem.mEnabled)
                    continue;
                else
                    break;
            }
            /////////////////////////////////////////////////////////////////////////
        }else{
// 20130428 added by qutiguy - add looping conditions.
            if(idOptionMenuDelegate.ListView.view.count <= limitCount)
                return;
            // 121228 looping delete  => 130328 looping add JSH
            idOptionMenuDelegate.ListView.view.positionViewAtIndex(idOptionMenuDelegate.ListView.view.count-1, idOptionMenuDelegate.ListView.view.Visible);
            idOptionMenuDelegate.ListView.view.currentIndex = idOptionMenuDelegate.ListView.view.count-1;
        } // End if
    }
    onWheelRightKeyPressed: {
        //console.log("idOptionMenuDelegate.ListView.view.flicking",idOptionMenuDelegate.ListView.view.flicking);
        //console.log("idOptionMenuDelegate.ListView.view.moving",idOptionMenuDelegate.ListView.view.moving);
        //console.log("idOptionMenuDelegate.ListView.view.count",idOptionMenuDelegate.ListView.view.count);
        //console.log("idOptionMenuDelegate.ListView.view.currentIndex",idOptionMenuDelegate.ListView.view.currentIndex);
    
        if(idOptionMenuDelegate.ListView.view.flicking)   return;    
        if( idOptionMenuDelegate.ListView.view.count-1 != idOptionMenuDelegate.ListView.view.currentIndex ){
            /////////////////////////////////////////////////////////////////////////
            // JSH 130131 focus
            for(var i=idOptionMenuDelegate.ListView.view.currentIndex+1; idOptionMenuDelegate.ListView.view.count > i ;i++){
                idOptionMenuDelegate.ListView.view.currentIndex = i
                if(!idOptionMenuDelegate.ListView.view.currentItem.mEnabled)
                    continue;
                else
                    break;
            }
            /////////////////////////////////////////////////////////////////////////
        }else{
// 20130428 added by qutiguy - add looping conditions.
            if(idOptionMenuDelegate.ListView.view.count <= limitCount)
                return;
            // 121228 looping delete  => 130328 looping add JSH
            idOptionMenuDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
            idOptionMenuDelegate.ListView.view.currentIndex = 0;
        } // End if
    }

    onVisibleChanged: {
        //# Focus move when From enable to disable KEH (20130311)
        if(visible){
            var i = 0, curIndex, totalCount;
            curIndex = idOptionMenuDelegate.ListView.view.currentIndex;
            totalCount = idOptionMenuDelegate.ListView.view.count-1;

            while( getEnabled(curIndex) == false ){
                if(curIndex >= totalCount){ curIndex = 0; }
                else{ curIndex++; }
                idOptionMenuDelegate.ListView.view.currentIndex  = curIndex;
            }
        } else {
            idOptionMenuDelegate.ListView.view.interactive = true;  //dg.jin 20160513 ITS 0272975
        }
    }
} // End MButton
