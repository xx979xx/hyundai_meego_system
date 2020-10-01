import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idDTCLoaderMain
    x:0
    y:0
    width:systemInfo.lcdWidth-708
    height:systemInfo.lcdHeight-100
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
        width: 320
        height: 70
        x:10
        y:0
        text: "Reset System"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.MButtonTouch{
        id:idResetSystemButton
        x:330
        y:0
        width:150
        height:70
        focus: true
        firstText: "Reset"
        firstTextX: 40
        firstTextY: 30
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

        onWheelLeftKeyPressed: idDeleteNaviButton.forceActiveFocus()
        onWheelRightKeyPressed: idResetComponentButton.forceActiveFocus()
        KeyNavigation.up:{
            backFocus.forceActiveFocus()
            diagnosisBand
        }
        //KeyNavigation.left:idDiagnosisLeftList

        KeyNavigation.down:idResetComponentButton


        onClickOrKeySelected: {
            idResetSystemButton.forceActiveFocus()
            SystemControl.resetSystem()
            console.log("invoked resetSystem")

        }
    }
    Image{
        x:20
        y:80
        source: imgFolderGeneral+"line_menu_list.png"
    }

    Text{
        width: 320
        height: 70
        x:10
        y:90
        text: "Reset Component"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.MButtonTouch{
        id:idResetComponentButton
        x:330
        y:90
        width:150
        height:70

        firstText: "Reset"
        firstTextX: 40
        firstTextY: 30
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

        onWheelLeftKeyPressed: idResetSystemButton.forceActiveFocus()
        onWheelRightKeyPressed: idSetDeliveryButton.forceActiveFocus()
        KeyNavigation.up:{
            backFocus.forceActiveFocus()
            diagnosisBand
        }

        onClickOrKeySelected: {
            idResetComponentButton.forceActiveFocus()
            setRightMenuScreen(4, true)
            isLeftBgArrow = false
            idDiagnosisRightList.focus = true
            idDiagnosisRightList.forceActiveFocus()

        }
    }
    Image{
        x:20
        y:170
        source: imgFolderGeneral+"line_menu_list.png"
    }
    Text{
        width: 320
        height: 70
        x:10
        y:180
        text: "Factory Reset"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.MButtonTouch{
        id:idSetDeliveryButton
        x:330
        y:180
        width:150
        height:70

        firstText: "Set"
        firstTextX: 40
        firstTextY: 30
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

        onWheelLeftKeyPressed: idResetComponentButton.forceActiveFocus()
        onWheelRightKeyPressed: idEjectButton.forceActiveFocus()
        KeyNavigation.up:{
            backFocus.forceActiveFocus()
            diagnosisBand
        }


        onClickOrKeySelected: {
            idSetDeliveryButton.forceActiveFocus()
            idENGSetDelPopUp.visible = true
            idENGSetDelPopUp.setDeliveryPopup = true
            idENGSetDelPopUp.focus = true
            idENGSetDelPopUp.forceActiveFocus()
        }
    }
    Image{
        x:20
        y:250
        source: imgFolderGeneral+"line_menu_list.png"
    }
    Text{
        width: 320
        height: 70
        x:10
        y:260
        text: "Eject All Disc"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.MButtonTouch{
        id:idEjectButton
        x:330
        y:260
        width:150
        height:70

        firstText: "Eject"
        firstTextX: 40
        firstTextY: 30
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

        onWheelLeftKeyPressed: idSetDeliveryButton.forceActiveFocus()
        onWheelRightKeyPressed: idLoadDiscButton.forceActiveFocus()
        KeyNavigation.up:{
            backFocus.forceActiveFocus()
            diagnosisBand
        }

        onClickOrKeySelected: {
            idEjectButton.forceActiveFocus()
            SendDeckSignal.ejectDeck()
            console.log("invoked ejectDisk")

        }
    }
    Image{
        x:20
        y:330
        source: imgFolderGeneral+"line_menu_list.png"
    }
    Text{
        width: 320
        height: 70
        x:0
        y:340
        text: "Load Disc"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.MButtonTouch{
        id:idLoadDiscButton
        x:330
        y:340
        width:150
        height:70

        firstText: "Load"
        firstTextX: 40
        firstTextY: 30
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

        onWheelLeftKeyPressed: idEjectButton.forceActiveFocus()
        onWheelRightKeyPressed: idDeleteNaviButton.forceActiveFocus()
        KeyNavigation.up:{
            backFocus.forceActiveFocus()
            diagnosisBand
        }


        onClickOrKeySelected: {
            idLoadDiscButton.forceActiveFocus()
            SendDeckSignal.loadDeck()
            console.log("invoked loadDisk")

        }
    }
    Image{
        x:20
        y:410
        source: imgFolderGeneral+"line_menu_list.png"
    }
    Text{
        width: 320
        height: 70
        x:10
        y:420
        text: "Delete Navi Persistence"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.MButtonTouch{
        id:idDeleteNaviButton
        x:330
        y:420
        width:150
        height:70

        firstText: "Delete"
        firstTextX: 40
        firstTextY: 30
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

        onWheelLeftKeyPressed: idLoadDiscButton.forceActiveFocus()
        onWheelRightKeyPressed: idResetSystemButton.forceActiveFocus()
        KeyNavigation.up:{
            backFocus.forceActiveFocus()
            diagnosisBand
        }


        onClickOrKeySelected: {
            idDeleteNaviButton.forceActiveFocus()
            idENGDelNaviPopUp.visible = true
            idENGDelNaviPopUp.deleteNaviPopup = true
            idENGDelNaviPopUp.focus = true
            idENGDelNaviPopUp.forceActiveFocus()

        }
    }
    Image{
        x:20
        y:490
        source: imgFolderGeneral+"line_menu_list.png"
    }

}
