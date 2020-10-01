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
    x: iMenuListBgX; y: iMenuListBgY
    width: iMenuAreaWidth; height: iMenuListBgHeight
    mEnabled: getEnabled(index)

    //--------------------- Button Image #
    bgImage: ""
    bgImagePress: sImgBg_OptionMenuListP
    bgImageFocus: sImgBg_OptionMenuListF

    //--------------------- Menu Item #
    firstText: name
    firstTextX: iMenuTextX
    firstTextY: iMenuTextY
    firstTextSize: 32
    firstTextStyle: idAppMain.fonts_HDR
    firstTextWidth: iMenuTextWidth
    firstTextAlies: "Left"   
    firstTextColor: colorInfo.subTextGrey
    firstTextPressColor: colorInfo.brightGrey
    firstTextFocusPressColor: colorInfo.brightGrey
    firstTextEnabled: getEnabled(index)
    firstTextScrollEnable: (m_bIsDrivingRegulation == false) && (idOptionMenuDelegate.activeFocus) ? true : false

    //--------------------- Line Image #
    lineImage: sImgLine_OptionMenu
    lineImageX: iMenuLineX
    lineImageY: iMenuLineY

    //--------------------- Sub Menu #
    Image{
        id: idOptionMenuSubMenu
        x: iMenuIconX
        y: iMenuIconY
        source: sImgIco_OptionMenuArrow
        visible: (opType=="subMenu")
    }

    //--------------------- Radio Button #
    Image {
        id : idUnchecked
        x: iMenuIconX
        y: iMenuIconY
        source :  imgFolderGeneral + "ico_radio_n.png"
        visible: (opType=="radioBtn")
    }

    Image {
        id : idChecked
        anchors.fill : idUnchecked
        source :  imgFolderGeneral + "ico_radio_s.png"
        visible: (opType=="radioBtn") && (index == selectedRadioIndex)
    }

    //--------------------- Clicked/Selected Event #
    onClickOrKeySelected: { opTypeEvent(index, opType) }

    onPressAndHold: { idMOptionMenuTimer.stop(); }

    //--------------------- 5s Timer stop(), start() for Flickable (disabled) #
    Item{
        width: parent.width; height: parent.height
        visible: (idOptionMenuDelegate.mEnabled == false)
        MouseArea{
            anchors.fill: parent
            onPressed: {
                idMOptionMenuTimer.stop();
            }
            onReleased:{
                idMOptionMenuTimer.restart();
            }
        }
    }

    Keys.onPressed: {
        if(idAppMain.isLeft(event))
            leftKeyMenuClose();

        //# Focus skip when Disable
        var i = 0, curIndex, totalCount;
        curIndex = idOptionMenuDelegate.ListView.view.currentIndex;
        totalCount = idOptionMenuDelegate.ListView.view.count-1;

        if(event.key == Qt.Key_Up)
        {
            event.accepted = true;
            return;
            //            while(i != totalCount){
            //                if(curIndex <= 0){ break;}
            //                else{ curIndex--; }
            //                if( getEnabled(curIndex) == false ){ idOptionMenuDelegate.ListView.view.currentIndex = curIndex; }
            //                else{ break; }
            //                i++;
            //            }
        }
        else if(event.key == Qt.Key_Down)
        {
            event.accepted = true;
            return;
            //            while(i != totalCount){
            //                if(curIndex >= totalCount){ break;}
            //                else{ curIndex++; }
            //                if( getEnabled(curIndex) == false ){ idOptionMenuDelegate.ListView.view.currentIndex = curIndex; }
            //                else{ break; }
            //                i++;
            //            }
        }
        else if(event.key == Qt.Key_Right)
        {
            if(opType=="subMenu") rightKeySubMenuOpen()
        }
    }

    onWheelLeftKeyPressed: {
        //# Focus skip when Disable KEH (20130307)
        var i = 0, curIndex, totalCount;
        curIndex = idOptionMenuDelegate.ListView.view.currentIndex;
        totalCount = idOptionMenuDelegate.ListView.view.count-1;

        while(i != totalCount){
            if(curIndex <= 0){
                if(listOptionMenu.count > 8) curIndex = totalCount;
                else break;
            }
            else{ curIndex--; }
            if( getEnabled(curIndex) == true ){
                idOptionMenuDelegate.ListView.view.currentIndex = curIndex;
                break;
            }
            i++;
        }
    }
    onWheelRightKeyPressed: {
        //# Focus skip when Disable KEH (20130307)
        var i = 0, curIndex, totalCount;
        curIndex = idOptionMenuDelegate.ListView.view.currentIndex;
        totalCount = idOptionMenuDelegate.ListView.view.count-1;

        while(i != totalCount){
            if(curIndex >= totalCount){
                if(listOptionMenu.count > 8)
                    curIndex = 0;
                else break;
            }
            else{ curIndex++; }
            if( getEnabled(curIndex) == true )
            {
                idOptionMenuDelegate.ListView.view.currentIndex = curIndex;
                break;
            }
            i++;
        }
    }

    onVisibleChanged: {
        if(visible){    //# Always focus on firstMenu
            if((selectedRadioIndex == 0) && (idAppMain.state == "DabStationListSubMenu")){
                idOptionMenuDelegate.ListView.view.currentIndex = 1
            }
            else{
                idOptionMenuDelegate.ListView.view.currentIndex = 0
            }
        }
    }

    //--------------------- Function #
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
        default: return true;
        }
    } // End function

    //onMEnabledChanged: { console.log(" [MOptionMenuDelegate]["+index+"]: "+getEnabled()) }

    function opTypeEvent(index, opType){
        if(opType=="radioBtn") {
            selectedRadioIndex = index
            radioEvent(index)
        }
        else{ indexEvent(index) } // End if
    } // End function

} // End MButton
