/**
 * FileName: DABInfoEPGContents.qml
 * Author: DaeHyungE
 * Time: 2013-01-24
 *
 * - 2013-01-24 Initial Created by DaeHyungE
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent{
    id: idDabInfoEPGContents
    width: systemInfo.lcdWidth
    height: systemInfo.contentAreaHeight

    property string epgFocusPosition: "ServiceList"

    //#****************************** Left/Right Background Image
    Image {
        id: idEPGLeftBgImg
        x: 0; y: 0
        source: epgFocusPosition == "ServiceList" ? imageInfo.imgBgMenu_L_S : ""
    }

    Image {
        id: idEPGRightBgImg
        x: 585; y: 0
        source: epgFocusPosition == "SettingContents" ? imageInfo.imgBgMenu_R_S : ""
    }

    DABInfoEPGMainLeft {
        id: idDabInfoEPGMainLeft
        x: 0; y: 0;
        width: 695; height: 554
        focus: true
        KeyNavigation.right: idDabInfoEPGMainRight
        KeyNavigation.up: idDabInfoEPGBand
        onActiveFocusChanged: {
            console.log("[QML] DABInfoEPGContents.qml : idDabInfoEPGMainLeft - onActiveFocusChanged ")
            if(idDabInfoEPGMainLeft.activeFocus) epgFocusPosition = "ServiceList"
        }
    }

    DABInfoEPGMainRight {
        id : idDabInfoEPGMainRight
        x : 708
        y : 0
        width : 572
        height : 554
        KeyNavigation.left : idDabInfoEPGMainLeft
        onActiveFocusChanged: {
            console.log("[QML] DABInfoEPGContents.qml : idDabInfoEPGMainRight - onActiveFocusChanged ")
            if(idDabInfoEPGMainRight.activeFocus) epgFocusPosition = "SettingContents"
        }        
    }
    onVisibleChanged: {
        idDabInfoEPGMainLeft.focus = true
    }
}
