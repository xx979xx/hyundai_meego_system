/**
 * FileName: DABInfoSLSBand.qml
 * Author: HYANG
 * Time: 2013-01-23
 *
 * - 2013-01-23 Initial Created by HYANG
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MBand{
    id: idDabInfoSLSBand
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
    selectedBand: stringInfo.strSLS_Image
    signalTextFlag: true
    signalText: m_sServiceName  //"BBC Radio 5 Live"
    signalTextX: 545
    signalTextSize: 40
    signalTextWidth : 581
    signalTextColor: idAppMain.m_bViewMode? colorInfo.bandBlue : Qt.rgba( 180/255, 191/255, 205/255, 1)
    signalTextAlies: "Left"
    signalTextStyle: idAppMain.fonts_HDR
    signalTextVariant: true;
    signalTextVariantTickerEnable: idDabInfoSLSBand.visible == true;

    onTabBtn1Clicked: {
        idDabInfoSLSBand.giveForceFocus(2)
        setAppMainScreen("DabInfoDLSMain", false);
    }

    onTabBtn2Clicked: {
        idDabInfoSLSBand.focus = true;
        idDabInfoSLSBand.giveForceFocus(2)
    }

    onTabBtn3Clicked: {
        idDabInfoSLSBand.giveForceFocus(2)
        setAppMainScreen("DabInfoEPGMain", false);
    }
    onBackBtnClicked: {
        console.log("[QML] DABInfoSLSBand.qml : onBackBtnClicked")
        gotoBackScreen();
    }  

    onVisibleChanged: {
        idDabInfoSLSBand.focus = true;
        idDabInfoSLSBand.giveForceFocus(2)
    }
}
