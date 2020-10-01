/**
 * FileName: RadioHdPopupPreset.qml
 * Author: HYANG
 * Time: 2012-03
 *
 * - 2012-03 Initial Created by HYANG
 */

import Qt 4.7
import "../../../system/DH" as MSystem
import "../../../QML/DH" as MComp
import "../../../../component/Radio/HD" as MRadio

MComp.MPresetPopup{
    id: idRadioHdPopupPreset
    focus: true

    MRadio.RadioHdStringInfo{ id: stringInfo }
    //****************************** # Setting value #
    selectedApp      : "HdRadio"
    btnText          : stringInfo.strHDPopupCancel  //"Cancel"
    titleFirstText   : stringInfo.strHDPopupPresetTitle1  //"The list is full! "
    titleSecondText  : stringInfo.strHDPopupPresetTitle2  //"Select preset to change"
    presetPopupModel : idPresetPopupModel

    //****************************** # Key Click or Pressed #
    onPresetItemClicked: {
        //currentItem.firstText = QmlController.radioFreq//"87.9"
        currentItem.secondText = QmlController.radioFreq

//        if(idAppMain.globalSelectedBand =="FM")
//            QmlController.presetReplace(idRadioHdPopupPreset.currentIndex,QmlController.radioFreq)
//        else if(idAppMain.globalSelectedBand =="AM")
//            QmlController.presetReplace(idRadioHdPopupPreset.currentIndex,QmlController.radioFreq)

// 120917 presetlist HD ICON Number Change Code         
//        if((idRadioHdPopupPreset.currentIndex != (QmlController.presetIndexFM1 -1)) && (idAppMain.alreadySaved == 2)){
//            idAppMain.strPopupText1 = stringInfo.strHDPopupPresetAlreadySave;
//            idAppMain.strPopupText2 = "";
//            return;
//        }

        if(idAppMain.globalSelectedBand =="FM1")
            QmlController.presetReplace(idRadioHdPopupPreset.currentIndex,QmlController.radioFreq)
        else if(idAppMain.globalSelectedBand =="FM2")
            QmlController.presetReplace(idRadioHdPopupPreset.currentIndex,QmlController.radioFreq)
        else if(idAppMain.globalSelectedBand =="AM")
            QmlController.presetReplace(idRadioHdPopupPreset.currentIndex,QmlController.radioFreq)

        gotoBackScreen()

        if(idAppMain.state == "AppRadioHdOptionMenu")
            gotoBackScreen()

        //if(idAppMain.hdRadioOnOff)    // hd on
        //    idAppMain.menuHdRadioFlag = idAppMain.hdRadioOnOff

        idAppMain.toastMessage = stringInfo.strHDPopupPresetSaveSuccessfully;
        idAppMain.toastMessageSecondText    = "";
        setAppMainScreen( "PopupRadioHdDimAcquiring" , true);
    }
    onButtonClicked: {
        console.log(">>>> Button Clicked <<<<")

        gotoBackScreen()
        if(idAppMain.state == "AppRadioHdOptionMenu")
            gotoBackScreen()

        //if(idAppMain.hdRadioOnOff)  // hd on
        //    idAppMain.menuHdRadioFlag = idAppMain.hdRadioOnOff
    }
    onHardBackKeyClicked: {
        console.log(">>>> Hard Back Key Clicked <<<<")

        gotoBackScreen()
        if(idAppMain.state == "AppRadioHdOptionMenu")
            gotoBackScreen()

        //if(idAppMain.hdRadioOnOff)   // hd on
        //    idAppMain.menuHdRadioFlag = idAppMain.hdRadioOnOff
    }
}
