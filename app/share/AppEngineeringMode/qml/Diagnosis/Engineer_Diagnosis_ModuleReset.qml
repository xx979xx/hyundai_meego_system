import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0

MComp.MComponent{
    id:idModuleResetMain
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
    property int variantValue: VariantSetting.variantInfo
    Component.onCompleted:{
        UIListener.autoTest_athenaSendObject();
        idXMResetButton.forceActiveFocus()
    }

    Text{
        width: 320
        height: 70
        x:10
        y:0
        text: "Reset Module List"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
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
        text: "XM Module"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.MButtonTouch{
        id:idXMResetButton
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
        onWheelLeftKeyPressed: idDeckModuleButton.forceActiveFocus()
        onWheelRightKeyPressed: idDMBModuleButton.forceActiveFocus()
        KeyNavigation.up:{
                        backFocus.forceActiveFocus()
                        diagnosisBand
        }
        //KeyNavigation.left:idDiagnosisLeftList
        KeyNavigation.down:idDMBModuleButton

        onClickOrKeySelected: {
            idXMResetButton.forceActiveFocus()
            if(variantValue == 1){
                DiagnosticReq.resetModule(0);
                reqVersion.sendReqModuleReset(EngineerData.App_XM)
            }

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
        text: "DMB Module"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.MButtonTouch{
        id:idDMBModuleButton
        x:330
        y:180
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
        onWheelLeftKeyPressed: idXMResetButton.forceActiveFocus()
        onWheelRightKeyPressed: idGPSModuleButton.forceActiveFocus()
        KeyNavigation.up:{
            idXMResetButton
        }
        //KeyNavigation.left:idDiagnosisLeftList
        KeyNavigation.down:idGPSModuleButton


        onClickOrKeySelected: {
            idDMBModuleButton.forceActiveFocus()
            DiagnosticReq.resetModule(1);
            reqVersion.sendReqModuleReset(EngineerData.App_DMB)
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
        text: "GPS Module"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.MButtonTouch{
        id:idGPSModuleButton
        x:330
        y:260
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
        onWheelLeftKeyPressed: idDMBModuleButton.forceActiveFocus()
        onWheelRightKeyPressed: idBluetoothModuleButton.forceActiveFocus()
        KeyNavigation.up:{
            idDMBModuleButton
        }
        //KeyNavigation.left:idDiagnosisLeftList
        KeyNavigation.down:idBluetoothModuleButton

        onClickOrKeySelected: {
            idGPSModuleButton.forceActiveFocus()
            DiagnosticReq.resetModule(2);
            reqVersion.sendReqModuleReset(EngineerData.App_Navi)

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
        text: "Bluetooth Module"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.MButtonTouch{
        id:idBluetoothModuleButton
        x:330
        y:340
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
        onWheelLeftKeyPressed: idGPSModuleButton.forceActiveFocus()
        onWheelRightKeyPressed: idDeckModuleButton.forceActiveFocus()
        KeyNavigation.up:{
            idGPSModuleButton
        }
        //KeyNavigation.left:idDiagnosisLeftList
        KeyNavigation.down:idDeckModuleButton


        onClickOrKeySelected: {
            idBluetoothModuleButton.forceActiveFocus()
            DiagnosticReq.resetModule(4);
            reqVersion.sendReqModuleReset(EngineerData.App_Bluetooth)

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
        text: "DECK Module"
        font.pixelSize: 25
        color:colorInfo.brightGrey
        //horizontalAlignment: "AlignHCenter"
        verticalAlignment: "AlignVCenter"
    }
    MComp.MButtonTouch{
        id:idDeckModuleButton
        x:330
        y:420
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
        onWheelLeftKeyPressed: idBluetoothModuleButton.forceActiveFocus()
        onWheelRightKeyPressed: idXMResetButton.forceActiveFocus()
        KeyNavigation.up:{
            idBluetoothModuleButton
        }
        //KeyNavigation.left:idDiagnosisLeftList
        KeyNavigation.down:idXMResetButton


        onClickOrKeySelected: {
            idDeckModuleButton.forceActiveFocus()
            DiagnosticReq.resetModule(4);
            reqVersion.sendReqModuleReset(EngineerData.App_DECK)

        }
    }
    Image{
        x:20
        y:490
        source: imgFolderGeneral+"line_menu_list.png"
    }

}
