import QtQuick 1.1
import "system" as MSystem
import "component" as MComp

import Transparency 1.0

MComp.MAppMain {
    id: idAppMain
    x:0; y:0
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }
    MSystem.StringInfo {id:stringInfo}

    //DH/DHPE logo (default is DH logo)
    property string blLogo: systemInfo.dhLogoBLImageURI;
    property string noBlLogo: systemInfo.dhLogoNoBLImageURI;

    width: systemInfo.lcdWidth ; height: systemInfo.lcdHeight
    focus: true
    clip: true

    //Video out
    Transparency {
        anchors.fill: parent
    }

    FocusScope {
        x:0; y:0
        id: mainUI
        //objectName: "mainUIObj"
        anchors.centerIn: parent
        width: idAppMain.width
        height: idAppMain.height
        focus: true

        Text {
               id: idAlert1txt
               y: 22
               text: stringInfo.alert2txt
               anchors.horizontalCenter: mainUI.horizontalCenter
               color: colorInfo.brightGrey
               font.family: stringInfo.fontName
               font.pointSize : systemInfo.alertFontSize
               style: Text.Outline; styleColor: "black"
        }

        Image {
            anchors.centerIn: parent
            id: camera_guide_line
            source: (canDB.UseGuideLineInternalImg)? systemInfo.imageInternal + "full_camera_guide.png" : cppToqml.usbImgPath //TODO: USB Img
            visible: cppToqml.showHUParkingline
        }

        //BackKey for only AppEngineeringMode interface
//        MComp.MButton{
//            id: idBackKeyForEngMode
//            x: 1145; y: 14
//            width: systemInfo.widthBackKey; height: systemInfo.heightBackKey
//            bgImage: systemInfo.bgImageBackKey
//            bgImagePress: systemInfo.bgImagePressBackKey
//            bgImageFocus: systemInfo.bgImageFocusBackKey

//            focus: true
//            visible: (canDB.UseBackKeyForEngMode) ? true : false

//            onClickOrKeySelected: canCon.event2BGForEngineerMode();
//            onBackKeyPressed: canCon.event2BGForEngineerMode();

//        }

        Item {
            id: leftRCTAWarn
            visible: false
            x: 19; y: 168
            Image {
                id: iRCTALeftWarningImg
                width: 134; height: 135
                source: systemInfo.imageInternal + "rcta/cam_ico_racta_left_01.png"
            }
        }

        Item {
            id: rightRCTAWarn
            visible: false
            x: 19+1108; y: leftRCTAWarn.y;
            Image {
                id: iRCTARightWarningImg
                width: iRCTALeftWarningImg.width; height: iRCTALeftWarningImg.height
                source: systemInfo.imageInternal + "rcta/cam_ico_racta_right_01.png"
            }
        }

    }

    //Raise VideoWidget Button
    /*MComp.MButton {
        id:raiseVideoBtn
        x: 708; y:600
        width: 200; height: 58
        bgImage: systemInfo.imageInternal + "btn_park_info_n.png"
        bgImagePress: systemInfo.imageInternal + "btn_park_info_p.png"
        bgImageFocus: systemInfo.imageInternal+"btn_park_info_f.png"
        fgImageVisible: false
        firstText: "TEST"

        onClickOrKeySelected: CamPlayer.TestVideo()

    } */// End of Raise VideoWidget Button

    Component.onCompleted:{
        //idBackKeyForEngMode.forceActiveFocus();
        mainUI.forceActiveFocus();
        UIListener.SendAutoTestSignal(); //For AutoTest

        //Genesis old/new logo
        if (cppToqml.IsNewLogo) { //Genesis new logo
            blLogo = systemInfo.dhpeLogoBLImageURI;
            noBlLogo = systemInfo.dhpeLogoNoBLImageURI;
        }
        else {
            blLogo = systemInfo.dhLogoBLImageURI;
            noBlLogo = systemInfo.dhLogoNoBLImageURI;
        }
    }

    onBeep: {
        UIListener.PlayAudioBeep();
    }

    Connections {
        target: UIListener

//        onSignalBGFromUISH: {
//            //idCameraLoading.visible = true;
//        }

        onSignalShowShutter: {
            mainUI.visible = true;
            idCameraLoading.visible = true;
            //idCameraLoading.opacity = 1;
            idDHLogo.visible = false;
        }

        onSignalShowSystemPopup: {
            idAppMain.focus = false;
        }
        onSignalHideSystemPopup: {
            idAppMain.forceActiveFocus();
        }

        onShowLogo: {
            idDHLogo.visible = true;
            mainUI.visible = false;
            idCameraLoading.visible = false;
        }

        onHideLogo: {
            idDHLogo.visible = false;
        }

        onHideUI: {
            mainUI.visible = false;
        }

        onSignalForRCTALeftOn: {
            //isOn가 true면 RCTA Left 표시. false면 hide
            if (isOn) {
                leftRCTAWarn.visible = true;
                idChgRCTALeftTimer.start();
            }
            else {
                leftRCTAWarn.visible = false;
                idChgRCTALeftTimer.stop();
                idChgRCTALeftTimer.leftRCTATimerCnt = 1;
            }
        }

        onSignalForRCTARightOn: {
           //isOn가 true면 RCTA Right 표시. false면 hide
            if (isOn) {
                rightRCTAWarn.visible = true;
                idChngRCTARightTimer.start();
            }
            else {
                rightRCTAWarn.visible = false;
                idChngRCTARightTimer.stop();
                idChngRCTARightTimer.rightRCTATimerCnt = 1;
            }
        }

    }

    Connections {
        target: CamPlayer

        onInvokeAnimation: {
            idCameraLoading.visible = false;
            //bgShowAni.running = true;
        }
    }

    Timer {
        id: idChgRCTALeftTimer
        interval: 500
        running: false
        repeat: true
        property int leftRCTATimerCnt: 1

        onTriggered:
        {
            leftRCTATimerCnt++;
            if (leftRCTATimerCnt>3) {
                leftRCTATimerCnt = 0;
                return;
            }
            else {
                iRCTALeftWarningImg.source = systemInfo.imageInternal + "rcta/cam_ico_racta_left_0" + leftRCTATimerCnt + ".png"
            }
        }
    }

    Timer {
        id: idChngRCTARightTimer
        interval: idChgRCTALeftTimer.interval
        running: false
        repeat: true
        property int rightRCTATimerCnt: 1

        onTriggered:
        {
            rightRCTATimerCnt++;
            if (rightRCTATimerCnt>3) {
                rightRCTATimerCnt = 0;
                return;
            }
            else {
                iRCTARightWarningImg.source = systemInfo.imageInternal + "rcta/cam_ico_racta_right_0" + rightRCTATimerCnt + ".png"
            }
        }
    }

    /*
    Item {
        width: 80; height: 80
        x: parent.width-width
        y: 0

        MouseArea {
            anchors.fill: parent
            onClicked: (decoderWindow.visible)? decoderWindow.visible = false : decoderWindow.visible = true
        }

    }

    MComp.DecoderSettingBar {
        id: decoderWindow;
        width: 620
        height: 160
        x: parent.width-width-10
        y: parent.height-height
        visible: false

        onVisibleChanged: {
            if(visible) {
                decoderWindow.forceActiveFocus();
            }
            else {
                mainUI.forceActiveFocus();
            }
        }

        Connections {
            target: decoderWindow.item
            onCloseWindow: decoderWindow.visible = false;
        }
    }
    */

    //TTS TEST
//    property int count : 0
//    Item {
//        //color: "green"
//        x:0; y:0
//        anchors.fill: parent

//        MouseArea {
//            anchors.fill: parent
//            onReleased: { //onClicked: {
//                canCon.SetPGSTTS(count);
//                count=count+1;
//                if (count>3) count=0;
//            }
//        }
//    }

    MComp.LoadingCamera {
        id: idCameraLoading
        x:0; y:0
        width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
        visible: false

//        onOpacityChanged: {
//            if (opacity==0) visible=false;
//        }
    }

//    ParallelAnimation {
//        id: bgShowAni

//        running: false; loops: 1
//        NumberAnimation { target: idCameraLoading; property: "opacity"; to: 0; duration: 250 }
//    }

    Image {
       id: idDHLogo
       anchors.fill: parent
       property int cv: UIListener.GetCountryVariantFromQML()
       visible: false
       source: cv < 3 ? blLogo : noBlLogo

       Rectangle {
           id: idBlackScreen
           anchors.fill: parent
           color: "black"
           visible: cppToqml.IsBlackMode
       }
    }

}


