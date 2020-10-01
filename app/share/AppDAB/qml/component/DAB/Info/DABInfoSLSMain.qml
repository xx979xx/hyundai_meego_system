/**
 * FileName: DABInfoSLSMain.qml
 * Author: HYANG
 * Time: 2013-01-23
 *
 * - 2013-01-23 Initial Created by HYANG
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent{
    id: idDabInfoSLSMain
    x: 0
    y: 0
    width: systemInfo.lcdWidth
    height: systemInfo.subMainHeight
    focus: true

    property bool seekPrevLongKeyPressed : idAppMain.seekPrevLongKeyPressed;
    property bool seekNextLongKeyPressed : idAppMain.seekNextLongKeyPressed;

    //******************************# Background Image
    Image {
        y: 0//-systemInfo.statusBarHeight
        source: imageInfo.imgBg_Main
    }

    //******************************# SLS Band
    DABInfoSLSBand{
        id: idDabInfoSLSBand
        x: 0; y: 0
        focus: true
        KeyNavigation.down: (idAppMain.m_bSLSOn && (idAppMain.m_sSLS != "")) ? idDabInfoSLSContents : idDabInfoSLSBand
    }

    //******************************# SLS Contents
    DABInfoSLSContents{
        id: idDabInfoSLSContents
        x: 0; y: systemInfo.titleAreaHeight
        KeyNavigation.up: idDabInfoSLSBand
    }

    onBackKeyPressed: {
        console.log("[QML] DABInfoSLSMain.qml : onBackKeyPressed")
        gotoBackScreen();
    }

    onSeekPrevKeyReleased : {
        console.log("[QML] DABInfoSLSMain.qml : onSeekPrevKeyReleased")
        gotoMainScreen()
    }

    onSeekNextKeyReleased : {
        console.log("[QML] DABInfoSLSMain.qml : onSeekNextKeyReleased")
        gotoMainScreen()
    }

    onSeekPrevLongKeyPressedChanged: {
        console.log("[QML] DABInfoSLSMain.qml : onSeekPrevLongKeyPressedChanged :: visible = " + idDabInfoSLSMain.visible)
        if(idDabInfoSLSMain.visible)
            gotoMainScreen()
    }

    onSeekNextLongKeyPressedChanged: {
        console.log("[QML] DABInfoSLSMain.qml : onSeekNextLongKeyPressedChanged :: visible = " + idDabInfoSLSMain.visible)
        if(idDabInfoSLSMain.visible)
            gotoMainScreen()
    }
}
