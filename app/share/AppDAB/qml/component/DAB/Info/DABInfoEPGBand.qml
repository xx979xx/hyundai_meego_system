/**
 * FileName: DABInfoDLSBand.qml
 * Author: DaeHyungE
 * Time: 2013-01-24
 *
 * - 2013-01-24 Initial Created by DaeHyungE
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MBand {
    id: idDabInfoEPGBand
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true
    tabBtnCount: 3
    tabBtnFlag: true
    tabBtnText: stringInfo.strPlayerMenu_Text
    tabBtnText2: stringInfo.strSLS_Image
    tabBtnText3: stringInfo.strEPG_EPG
    selectedBand: stringInfo.strEPG_EPG

    signalTextFlag: true
    signalText: m_sServiceName
    signalTextX: 545
    signalTextSize: 40
    signalTextWidth : 312
    signalTextColor: idAppMain.m_bViewMode? colorInfo.bandBlue : Qt.rgba( 180/255, 191/255, 205/255, 1)
    signalTextAlies: "Left"
    signalTextStyle: idAppMain.fonts_HDR
    signalTextVariant: true;
    signalTextVariantTickerEnable: idDabInfoEPGBand.visible == true;

    subBtnFlag: true
    subBtnText: m_sSelectEPGDate   //"20-05-12, Wed"
    subBtnWidth: 273
    subBtnBgImage: imageInfo.imgTitleDate_N
    subBtnBgImageFocus: imageInfo.imgTitleDate_F
    subBtnBgImagePress: imageInfo.imgTitleDate_P

    onTabBtn1Clicked: {
        console.log("[QML] DABInfoEPGBand.qml : onTabBtn1Clicked Clicked")
        idDabInfoEPGBand.giveForceFocus(3)
        setAppMainScreen("DabInfoDLSMain", false);
    }

    onTabBtn2Clicked: {
        console.log("[QML] DABInfoEPGBand.qml : onTabBtn2Clicked Clicked")
        idDabInfoEPGBand.giveForceFocus(3)
        setAppMainScreen("DabInfoSLSMain", false);
    }

    onTabBtn3Clicked: {
        console.log("[QML] DABInfoEPGBand.qml : onTabBtn3Clicked Clicked")
        idDabInfoEPGBand.giveForceFocus(3)
    }

    onSubBtnClicked: {
        console.log("[QML] DABInfoEPGBand.qml : Ensemble Clicked")
        idDabInfoEPGMain.focusPositionSetting();
        setAppMainScreen("DabInfoEPGDateListPopup", true);
    }

    onVisibleChanged: {
        idDabInfoEPGBand.giveForceFocus(3)
    }

    onBackBtnClicked: {
        console.log("[QML] DABInfoEPGBand.qml : onBackBtnClicked")
        gotoBackScreen();
    }
}
