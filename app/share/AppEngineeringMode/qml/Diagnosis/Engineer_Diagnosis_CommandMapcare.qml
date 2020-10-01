import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp

MComp.MComponent{
    id:idCommandLoaderMain
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
        text: "Factory Reset"
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
        firstTextY: 20/*30*/
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

        //        onWheelLeftKeyPressed: idDeleteNaviButton.forceActiveFocus()
        //        onWheelRightKeyPressed: idResetComponentButton.forceActiveFocus()
        KeyNavigation.up:{
            backFocus.forceActiveFocus()
            diagnosisBand
        }

        //        KeyNavigation.down:idResetComponentButton


        onClickOrKeySelected: {
            idENGSetDelPopUp.visible = true
            idENGSetDelPopUp.setDeliveryPopup = true
            idENGSetDelPopUp.focus = true
            idENGSetDelPopUp.forceActiveFocus()

        }
    }
    Image{
        x:20
        y:80
        source: imgFolderGeneral+"line_menu_list.png"
    }



}
