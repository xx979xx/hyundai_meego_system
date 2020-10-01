/**
 * FileName: RadioHdPopupPresetWarning.qml
 * Author: HYANG
 * Time: 2012-05
 *
 * - 2012-05 Initial Created by HYANG
 */

import Qt 4.7
import "../../../system/DH" as MSystem
import "../../../QML/DH" as MComp
import "../../../../component/Radio/HD" as MRadio

MComp.MPopupTypeText{//MWarningPopup{
    id: idRadioHdPopupPresetWarning
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true
    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }
    MRadio.RadioHdStringInfo{ id: stringInfo }
    property bool firstLoad : false
    popupBtnCnt  : 1

    //****************************** # Line Count (1 or 2 or 3) #
    popupLineCnt: strPopupText3 != "" ? 3 : strPopupText2 != ""? 2 : 1

    //****************************** # Text Setting #
    //titleText: stringInfo.strRadioPopupWarning   //"Warning"

    popupFirstText   : strPopupText1//stringInfo.strHDPopupPresetAlreadySave  //"Already saved as preset"
    popupSecondText  : strPopupText2
    popupThirdText   : strPopupText3

    popupFirstBtnText: stringInfo.strHDPopupOk   //"OK"
    //****************************** # Button Click Event #
    onPopupFirstBtnClicked: {
        console.log("button clicked")
        gotoBackScreen();
        idAppMain.strPopupText3 =idAppMain.strPopupText2 =idAppMain.strPopupText1 = ""
    }

    onHardBackKeyClicked: {
        console.log("comma pressed")
        gotoBackScreen();
        idAppMain.strPopupText3 =idAppMain.strPopupText2 =idAppMain.strPopupText1 = ""
    }
    onVisibleChanged: {
        if((!visible) && firstLoad) // JSH 130814 ITS [0184309]
            idAppMain.strPopupText3 =idAppMain.strPopupText2 =idAppMain.strPopupText1 = ""
        else
            firstLoad = true;
    }
}
