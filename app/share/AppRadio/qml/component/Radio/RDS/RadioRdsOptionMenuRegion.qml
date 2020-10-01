/**
 * FileName: RadioRdsOptionMenuRegion.qml
 * Author: HYANG
 * Time: 2012-04
 *
 * - 2012-04 Initial Created by HYANG
 */

import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComp.MOptionMenu{
    id: idRadioRdsOptionMenuRegion
    focus: true

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    RadioRdsStringInfo{ id: stringInfo }
    //****************************** # Item Model #

    menuDepth : "TwoDepth"
    linkedModels: {
        if(globalSelectedBand == 0x01) idRadioRdsFmOptionMenuRegionModel
    }

    //****************************** # Item Clicked #
    onRadio0Click:{
        console.log(">>>>>>>>>>>>>  Auto")
//        menuRegionFlag = true
        if(QmlController.rdssettingsRegion == 0x00)
            QmlController.setRDSSettingsRegion(0x02);
        gotoBackScreen();
        gotoBackScreen(); // JSH 130418 added menuAnimation
    }

    onRadio1Click:{
        console.log(">>>>>>>>>>>>>  Off")
//        menuRegionFlag = false
        if(QmlController.rdssettingsRegion == 0x02)
            QmlController.setRDSSettingsRegion(0x00);
        gotoBackScreen();
        gotoBackScreen(); // JSH 130418 added menuAnimation
    }

    //****************************** # Menu Open when clicked I, L, Slash key #
// 20130107 updated by qutiguy
    onClickMenuKey: {
        if(visible)
            menuAnimation = false; // JSH 130418 added menuAnimation
//        if(visible)
//            gotoBackScreen()
//        gotoBackScreen()
    }
//    onLeftKeyPressed: {
//        if(idAppMain.state != "AppRadioRdsOptionMenuRegion")
//            return;

//        subMenuClose  = true ;
//        menuAnimation = false;
//    } // JSH 130418 added menuAnimation //gotoBackScreen()
    //****************************** # Back Key (Clicked Comma key) #
    onBackKeyPressed: {
        if(idAppMain.state != "AppRadioRdsOptionMenuRegion")
            return;

        subMenuClose  = true ;
        menuAnimation = false;
    } // JSH 130418 added menuAnimation //gotoBackScreen()
    //****************************** # OptionMenu Timer #
    onOptionMenuFinished:{
        //KSW 131024 [ITS][195847][major] oneDepth menu closed before to do close twodepth menu.
        //console.log("KSW3 AppRadioRdsOptionMenuRegion ==",idAppMain.state)
        if(idAppMain.state != "AppRadioRdsOptionMenuRegion")
            return;
        if(visible) menuAnimation = false; // JSH 130418 added menuAnimation
            //gotoBackScreen()
            //gotoBackScreen()
    }

    onActiveFocusChanged: {
        console.log("[[[[[[ Option Menu Region focuse changed ]]]]]]");
        if(idAppMain.globalSelectedBand == 0x01){
            //****************************** # News On/Off #
            //idRadioRdsOptionMenuRegion.linkedCurrentIndex = 0 //dg.jin 20150205 first focus issues
            if(QmlController.getRDSSettingsRegion() == 0x02)
            {
                idRadioRdsOptionMenuRegion.linkedCurrentIndex = 1 //dg.jin 20150205 first focus issues
                console.log("set Region flag on")
                selectedRadioIndex = 0x00;
            }
            else if(QmlController.getRDSSettingsRegion() == 0x00){
                idRadioRdsOptionMenuRegion.linkedCurrentIndex = 0 //dg.jin 20150205 first focus issues
                console.log("set Region flag off")
                selectedRadioIndex = 0x01;
            }
            else {
                idRadioRdsOptionMenuRegion.linkedCurrentIndex = 0 //dg.jin 20150205 first focus issues
            }
        }
    }
    // 20130428 added by qutiguy.
    //****************************** # init current/selected index = 0 (first item)#
    onVisibleChanged: {
        if(visible)
            //dg.jin 20150205 first focus issues
            if(QmlController.getRDSSettingsRegion() == 0x02)
            {
                idRadioRdsOptionMenuRegion.linkedCurrentIndex = 1;
            }
            else
            {
                idRadioRdsOptionMenuRegion.linkedCurrentIndex = 0;
            }
            //idRadioRdsOptionMenuRegion.linkedCurrentIndex = 0;
    }

    //****************************** # Item Model #
    ListModel { //# FM
        id: idRadioRdsFmOptionMenuRegionModel
        ListElement { name: "Auto"; opType: "radioBtn"}
        ListElement { name: "Off"; opType:"radioBtn"}
    }

    //****************************** # Translation #
    function setModelString(){
        idRadioRdsFmOptionMenuRegionModel.get(0).name = stringInfo.strRDSMenuAuto;
        idRadioRdsFmOptionMenuRegionModel.get(1).name = stringInfo.strRDSMenuOff;
    }
    Component.onCompleted: setModelString()
    Connections{
        target: UIListener
        onRetranslateUi: {
            setModelString()
        }
    }
}
