import QtQuick 1.0


import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idDTCListMain
    x:0; y:0
    width: 1280
    height:520
    focus:true
    MSystem.ImageInfo { id: imageInfo }
    MSystem.ColorInfo { id: colorInfo }
    //property alias diagProcessing : idDiagProcessing
    //property alias diagFin : idDiagProcessing.popupRequestFin
    property string lineIBOX2AMP : ""//imageInfo.imgFolderMostRBD + "rbd_01_g.png"
    property string lineAMP2HU :""//imageInfo.imgFolderMostRBD + "rbd_02_g.png"
    property string lineHU2IBOX : ""//imageInfo.imgFolderMostRBD + "rbd_03_g.png"

    property bool finPopUpFlag: true

    property alias backKey: mostRBDBand.backKeyButton
    property alias popupRequest: idDlgMostRequest.visible
    property alias popupRequestFin: idDlgMostRequestFin.visible
    //property alias popupMessage_1: idDlgMostRequest.messages1
    //property alias popupMessage_2: idDlgMostRequestFin.messages1
    onBackKeyPressed: {
        if(isMapCareMain)
        {
            mainViewState = "MapCareMain"
            setMapCareUIScreen("", true)
            mainViewState = "Diagnosis"
            setMapCareUIScreen("Diagnosis", false)
        }
        else
        {
            mainViewState="Main"
            setMainAppScreen("", true)
            mainViewState = "Diagnosis"
            setMainAppScreen("Diagnosis", false)
        }


    }
    function givePopupFocus(popupName)
    {
        if(popupRequest){
            idDlgMostRequest.focus = true
            idDlgMostRequest.forceActiveFocus()
        }
        else if(popupRequestFin){
            idDlgMostRequestFin.focus = true
            idDlgMostRequestFin.forceActiveFocus()
        }

    }
    Component.onCompleted:{
        idDlgMostRequest.visible =true
        UIListener.autoTest_athenaSendObject();

    }

    MComp.DimPopUp{
        id:idDlgMostRequest
        textLineCount: 1
        loadingFlag: true
        firstText: "Processing..."
        z:100
        visible:false

        onVisibleChanged:{
            if(visible) {
                idDlgMostRequest.forceActiveFocus()
                idTimerRequest.start()
                finPopUpFlag = true
            }
        }
    }
    Timer{
        id:idTimerRequest
        interval: 15000
        repeat:false
        onTriggered:
        {
            idDlgMostRequest.visible = false
            if(finPopUpFlag){
                    idDlgMostRequestFin.visible = true
                    idDlgMostRequestFin.focus = true
            }
            givePopupFocus()
            //idDlgMostRequestFin.givePopupFocus()

        }
    }

    MComp.DimPopUp{
        id:idDlgMostRequestFin
        textLineCount:1
        loadingFlag:false
        firstText: "Diagnostic Failed"
        z:100
        visible:  false

        onVisibleChanged: { if(visible) idTimerRequestFin.start() }
    }
    Timer{
        id:idTimerRequestFin
        interval: 1000
        repeat:  false
        onTriggered:
        {
            idDlgMostRequestFin.visible = false
            //bandSubButton.forceActiveFocus()
            backKey.forceActiveFocus()
            //idDiagProcessing.visible =false

        }
    }


    MComp.MBand{
        id:mostRBDBand
        titleText: isMapCareMain ? qsTr("Dealer Mode > MOST > MOST RBD") : qsTr("Engineering Mode > MOST > MOST RBD")
        subBtnFlag: true
        subKeyText:"Refresh"

        focus:true
        //KeyNavigation.left:bandSubButton
        //KeyNavigation.right:backKeyButton
        onBackKeyClicked: {
            if(isMapCareMain)
            {
                mainViewState = "MapCareMain"
                setMapCareUIScreen("", true)
                mainViewState = "Diagnosis"
                setMapCareUIScreen("Diagnosis", false)
            }
            else
            {
                mainViewState="Main"
                setMainAppScreen("", true)
                mainViewState = "Diagnosis"
                setMainAppScreen("Diagnosis", false)
            }


        }
        onSubKeyClicked: {

            DiagnosticReq.ReadRBD()
            lineAMP2HU = ""
            lineIBOX2AMP = ""
            lineHU2IBOX = ""
            idDlgMostRequest.visible =true
        }
        onWheelRightKeyPressed: {
            if(mostRBDBand.backKeyButton.focus == true)
                mostRBDBand.bandSubButton.forceActiveFocus()
            else
                mostRBDBand.backKeyButton.forceActiveFocus()
        }
        onWheelLeftKeyPressed: {
            if(mostRBDBand.backKeyButton.focus == true)
                mostRBDBand.bandSubButton.forceActiveFocus()
            else
                mostRBDBand.backKeyButton.forceActiveFocus()
        }
    }
    Image {
        id: bg_mostBRD
        x: 236
        y:135//y: 255
        width: 840
        height: 420
        source: imageInfo.imgFolderMostRBD + "car_bg.png"


        Image {
            x: 135+46
            y: 125

            source: lineIBOX2AMP
        }

        Image {
            x: 135+46+31
            y: 125+26

            source: lineAMP2HU
        }

        Image {
            x: 135
            y: 125+26

            source : lineHU2IBOX
        }
    }

    Image {
        id: box_ibox
        x: 358 - 29
        y: 238//329 + 29

        source: imageInfo.imgFolderMostRBD + "mark_bg.png"

        Text {
            font.family: UIListener.getFont(true)//"HDB"
            //            anchors.top: parent.top
            //            anchors.left: parent.left
            x: 6
            y: 25-14
            width:78
            text: "IBOX"
            font.pixelSize: 28
            color: colorInfo.brightGrey
            horizontalAlignment:"AlignHCenter"
        }
    }

    Image {
        id: box_amp
        x: 358 + 77 + 492 - 29
        y: 238//329 + 29

        source: imageInfo.imgFolderMostRBD + "mark_bg.png"

        Text {
            font.family: UIListener.getFont(true)//"HDB"
            //            anchors.top: parent.top
            //            anchors.left: parent.left
            x: 6
            y: 25-14
            width:78
            text: "AMP"
            font.pixelSize: 28
            color: colorInfo.brightGrey
            horizontalAlignment:"AlignHCenter"
        }
    }

    Image {
        id: box_hu
        x: 358 + 77 - 29
        y: 209+109 +13//329 + 109 + 13

        source: imageInfo.imgFolderMostRBD + "mark_bg.png"

        Text {
            font.family: UIListener.getFont(true)//"HDB"
            //            anchors.top: parent.top
            //            anchors.left: parent.left
            x: 6
            y: 25-14
            width:78
            text: "HU"
            font.pixelSize: 28
            color: colorInfo.brightGrey
            horizontalAlignment:"AlignHCenter"
        }
    }

    Connections {
        target : DiagnosticReq
        onConnectionStateChangedHUandAMP : {
            console.debug("Received MOST Connection State: HUandAMP");


            if( connection == 10 ){
                finPopUpFlag = false
                idTimerRequest.stop()
               idDlgMostRequest.visible  = false
                console.debug("Received MOST Connection State: HUandAMP : TRUE");
                lineAMP2HU = imageInfo.imgFolderMostRBD + "rbd_02_g.png"
            }
            else if (connection == 0){
                finPopUpFlag = false
                idTimerRequest.stop()
               idDlgMostRequest.visible  = false
                console.debug("Received MOST Connection State: HUandAMP : FALSE");
                lineAMP2HU = imageInfo.imgFolderMostRBD + "rbd_02_r.png"
            }
        }

        onConnectionStateChangedIBOXandAMP : {
            console.debug("Received MOST Connection State: IBOXandAMP" + connection);

                if( connection == 10 ){
                    finPopUpFlag = false
                   idTimerRequest.stop()
                   idDlgMostRequest.visible  = false
                    lineIBOX2AMP = imageInfo.imgFolderMostRBD + "rbd_01_g.png"
                    console.debug("Received MOST Connection State: IBOXandAMP : TRUE" );
                }
                else  if (connection == 0){
                    finPopUpFlag = false
                   idTimerRequest.stop()
                   idDlgMostRequest.visible  = false
                    lineIBOX2AMP = imageInfo.imgFolderMostRBD + "rbd_01_r.png"
                    console.debug("Received MOST Connection State: IBOXandAMP : FALSE" );
                }
            }

        onConnectionStateChangedHUandIBOX : {
            console.debug("Received MOST Connection State: HUandIBOX"+ connection);

            if( connection == 10 ){
                finPopUpFlag = false
               idTimerRequest.stop()
               idDlgMostRequest.visible  = false
                lineHU2IBOX = imageInfo.imgFolderMostRBD + "rbd_03_g.png"
                    console.debug("Received MOST Connection State: HUandIBOX : TRUE");
            }
            else if (connection == 0){
                finPopUpFlag = false
               idTimerRequest.stop()
               idDlgMostRequest.visible  = false
                lineHU2IBOX = imageInfo.imgFolderMostRBD + "rbd_03_r.png"
                     console.debug("Received MOST Connection State: HUandIBOX : FALSE");
            }
        }

        onDiagnosticFailed : {
            console.debug("Received MOST Connection State: Diagnostic Failed");
             finPopUpFlag = false
            idTimerRequest.stop()
             idDlgMostRequest.visible  = false
            idDlgMostRequestFin.visible = true
        }
    }

}
