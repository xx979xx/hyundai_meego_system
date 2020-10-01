import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idMostMain
    x:0
    y:0
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-166
    clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral
    property string imgFolderModeArea: imageInfo.imgFolderModeArea

    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
    }

    Text{
        width: 300
        height: 80
        x:0
        y:0
        text: "Start RBD"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }

    MComp.MButtonTouch{
        id:idStartRBDButton
        x:300
        y:10
        width:150
        height:80
        focus: true
        firstText: "Start"
        firstTextX: 40
        firstTextY: 30/*40*/
        firstTextWidth: 150
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""
        onWheelLeftKeyPressed: idResetMostButton.forceActiveFocus()
        onWheelRightKeyPressed: idResetMostButton.forceActiveFocus()
        KeyNavigation.up:{
            backFocus.forceActiveFocus()
            diagnosisBand
        }
        //KeyNavigation.left:idDiagnosisLeftList
        //KeyNavigation.right:idActiveDTCSecondButton
        KeyNavigation.down:idResetMostButton


        onClickOrKeySelected: {
            if(isMapCareMain)
            {
                DiagnosticReq.ReadRBD()
                mainViewState = "MostRBD"
                setMapCareUIScreen("MostRBD", true)
                idDlgMostRequest.visible =true
            }
            else
            {
                DiagnosticReq.ReadRBD()
                mainViewState = "MostRBD"
                setMainAppScreen("MostRBD", true)
                idDlgMostRequest.visible =true
            }


        }
    }
    Image{
        x:20
        y:100
        source: imgFolderGeneral+"line_menu_list.png"
    }

    Text{
        width: 300
        height: 80
        x:0
        y:100
        text: "MOST Reset"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }

    MComp.MButtonTouch{
        id:idResetMostButton
        x:300
        y:110
        width:150
        height:80
        //focus: true
        firstText: "Reset"
        firstTextX: 40
        firstTextY: 30/*40*/
        firstTextWidth: 150
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""
        onWheelLeftKeyPressed: idStartRBDButton.forceActiveFocus()
        onWheelRightKeyPressed: idStartRBDButton.forceActiveFocus()
        KeyNavigation.up:{
            idStartRBDButton
        }
        //        KeyNavigation.left:idDiagnosisLeftList
        //        KeyNavigation.right:idActiveDTCSecondButton
        //        KeyNavigation.down:idAllDTCFirstButton


        onClickOrKeySelected: {
            idResetMostButton.forceActiveFocus()
            DiagnosticReq.ResetMOST()
            idENGMostResetPopUp.visible = true
            idENGMostResetPopUp.popupDeleting = true
        }
    }
    Image{
        x:20
        y:200
        source: imgFolderGeneral+"line_menu_list.png"
    }

}

