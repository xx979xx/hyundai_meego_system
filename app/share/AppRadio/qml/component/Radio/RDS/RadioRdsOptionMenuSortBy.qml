/**
 * FileName: RadioRdsOptionMenuSortBy.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 */

import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MOptionMenu{
    id: idRadioRdsOptionMenuSortBy
    focus: true

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioRdsStringInfo{ id: stringInfo }

    //****************************** # Item Model #

    menuDepth : "TwoDepth"
    linkedModels: {
        if(globalSelectedBand == 0x01) idRadioRdsFmOptionMenuSortByModel
    }

    //****************************** # Station #
    onRadio0Click:{
        QmlController.setSortType(3);
        initStationList();
        gotoBackScreen();
        gotoBackScreen();
    }

    //****************************** # PTY #
    onRadio1Click:{
        QmlController.setSortType(1);
        initStationList();
        gotoBackScreen();
        gotoBackScreen();
    }

    //****************************** # Menu Open when clicked I, L, Slash key #
// 20130107 updated by qutiguy
    onClickMenuKey: {
        if(visible)
            menuAnimation = false; // JSH 130418 added menuAnimation
    }
//    onLeftKeyPressed: {
//        if(idAppMain.state != "AppRadioRdsOptionMenuSortBy")
//            return;
//        subMenuClose  = true ;
//        menuAnimation = false;
//    } // JSH 130418 added menuAnimation //gotoBackScreen()

    //****************************** # Back Key (Clicked Comma key) #
    onBackKeyPressed:  {
        if(idAppMain.state != "AppRadioRdsOptionMenuSortBy")
            return;
        subMenuClose  = true ;
        menuAnimation = false;
    } // JSH 130418 added menuAnimation //gotoBackScreen()

    //****************************** # OptionMenu Timer #
    onOptionMenuFinished:{
        //KSW 131024 [ITS][195847][major] oneDepth menu closed before to do close twodepth menu.
//        console.log("KSW3 AppRadioRdsOptionMenuSortBy == " ,idAppMain.state)
        if(idAppMain.state != "AppRadioRdsOptionMenuSortBy")
            return;
        if(visible) menuAnimation = false;  // JSH 130418 added menuAnimation
    }
    // 20130428 added by qutiguy.
    //****************************** # init current/selected index = 0 (first item)#
    onVisibleChanged: {
        if(visible)
        {
            //ITS 251307 20141029 first focus issues
            if(QmlController.sortType == 3)
            {
                idRadioRdsOptionMenuSortBy.linkedCurrentIndex = 1;
            }
            else
            {
                idRadioRdsOptionMenuSortBy.linkedCurrentIndex = 0;
            }
        }
    }
    //****************************** # Item Model #
    ListModel { //# FM
        id: idRadioRdsFmOptionMenuSortByModel
        ListElement { name: "Station"; opType: "radioBtn"}
        ListElement { name: "PTY"; opType:"radioBtn"}
    }

    //****************************** # Translation #
    function setModelString(){
        idRadioRdsFmOptionMenuSortByModel.get(0).name = stringInfo.strRDSMenuStation;
        idRadioRdsFmOptionMenuSortByModel.get(1).name = stringInfo.strRDSMenuPty;
    }
    Component.onCompleted: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: {
            setModelString()
        }
    }
}
