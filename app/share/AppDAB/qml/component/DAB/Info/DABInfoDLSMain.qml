/**
 * FileName: DABInfoDLSMain.qml
 * Author: HYANG
 * Time: 2013-01-23
 *
 * - 2013-01-23 Initial Created by HYANG
 */

import Qt 4.7
import "../../../component/QML/DH" as MComp
import "../../../component/DAB/JavaScript/DabOperation.js" as MDabOperation

MComp.MComponent {
    id: idDabInfoDLSMain
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

    //******************************# DLS Band
    DABInfoDLSBand{
        id: idDabInfoDLSBand
        x: 0; y: 0
        focus: true
    }   

    //******************************# DLS Contents
    DABInfoDLSContents{
        id: idDabInfoDLSContents
        x: 0; y: systemInfo.titleAreaHeight
    }

    onBackKeyPressed: {
        console.log("[QML] DABInfoDLSMain.qml : onBackKeyPressed")
        gotoBackScreen();
    }

    onSeekPrevKeyReleased : {
        console.log("[QML] DABInfoDLSMain.qml : onSeekPrevKeyReleased")
        gotoMainScreen()
    }

    onSeekNextKeyReleased : {
        console.log("[QML] DABInfoDLSMain.qml : onSeekNextKeyReleased")
        gotoMainScreen()
    }

    onSeekPrevLongKeyPressedChanged: {
        console.log("[QML] DABInfoDLSMain.qml : onSeekPrevLongKeyPressedChanged :: visible = " + idDabInfoDLSMain.visible)
        if(idDabInfoDLSMain.visible)
            gotoMainScreen()
    }

    onSeekNextLongKeyPressedChanged: {
        console.log("[QML] DABInfoDLSMain.qml : onSeekNextLongKeyPressedChanged :: visible = " + idDabInfoDLSMain.visible)
        if(idDabInfoDLSMain.visible)
            gotoMainScreen()
    }
}
