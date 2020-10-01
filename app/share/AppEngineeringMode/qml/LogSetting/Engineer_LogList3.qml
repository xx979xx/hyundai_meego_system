

////////////////////////////////////////////////////////////////////////////////////////////
import QtQuick 1.0
import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0
MComp.MComponent
{
    id:idLogList3
    x:20
    y:10
    width:1280 - 480
    height:550
    clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral
    property string imgFolderModeArea: imageInfo.imgFolderModeArea
    property int stateLogListModel : 0
    Component.onCompleted:{

        UIListener.autoTest_athenaSendObject();
        idCurrentAppVal_text.text = "HVAC"
        //idButton1.focus = true
        //idButton1.forceActiveFocus()
    }

    Text{
        id:idTxt1
        height:50
        x: 0 ; y:0
        font.family: UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("HVAC")
        verticalAlignment: Text.AlignVCenter
    }
    Text
    {
        x:400; y: 0
        id:idTxt2
        height:50
        font.family: UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("VR")
        verticalAlignment: Text.AlignVCenter

    }
    MComp.MButtonTouch {
        id:idButton1
        x:0; y:55
        width: 250; height:80
        firstText: "Load Log Level"
        firstTextX: 30
        firstTextY: 20//40
        firstTextWidth: 250
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        onWheelLeftKeyPressed: main_spinner.forceActiveFocus()
        onWheelRightKeyPressed: idButton2.forceActiveFocus()
        onClickOrKeySelected: {
            idButton1.forceActiveFocus()
            idCurrentAppVal_text.text = "HVAC"
            stateLogListModel = 0
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.AppHvac)
        }
    }
    MComp.MButtonTouch {
        id:idButton2
        x:400; y:55
        width: 250; height:80
        firstText: "Load Log Level"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 250
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        onWheelLeftKeyPressed: idButton1.forceActiveFocus()
        onWheelRightKeyPressed: idButton3.forceActiveFocus()
        onClickOrKeySelected: {
            idButton2.forceActiveFocus()
            idCurrentAppVal_text.text = "VR"
            stateLogListModel = 1
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.AppVR)
        }
    }
    MComp.Spinner{
        x: 400; y:460
        id:main_spinner
        visible: true
        aSpinControlTextModel: main_textModel
        currentIndexVal:  LogSettingData.LoadLogSetting(EngineerData.AppHvac)
        onWheelLeftKeyPressed: idButton6.forceActiveFocus()
        onWheelRightKeyPressed: idButton1.forceActiveFocus()
        onSpinControlValueChanged: {
            if(curVal == 0){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(0, EngineerData.AppHvac )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(0, EngineerData.AppVR )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(0, EngineerData.AppSettingsBt )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(0, EngineerData.AppIBOX )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(0, EngineerData.AppUpgrade )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(0, EngineerData.AppCamera )
                }
            }
            else if(curVal == 1){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(1, EngineerData.AppHvac )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(1, EngineerData.AppVR )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(1, EngineerData.AppSettingsBt )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(1, EngineerData.AppIBOX )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(1, EngineerData.AppUpgrade )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(1, EngineerData.AppCamera )
                }
            }
            else if(curVal == 2){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(2, EngineerData.AppHvac )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(2, EngineerData.AppVR )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(2, EngineerData.AppSettingsBt )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(2, EngineerData.AppIBOX )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(2, EngineerData.AppUpgrade )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(2, EngineerData.AppCamera )
                }
            }
            else if(curVal == 3){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(3, EngineerData.AppHvac )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(3, EngineerData.AppVR )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(3, EngineerData.AppSettingsBt )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(3, EngineerData.AppIBOX )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(3, EngineerData.AppUpgrade )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(3, EngineerData.AppCamera )
                }
            }
            else if(curVal == 4){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(4, EngineerData.AppHvac )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(4, EngineerData.AppVR )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(4, EngineerData.AppSettingsBt )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(4, EngineerData.AppIBOX )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(4, EngineerData.AppUpgrade )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(4, EngineerData.AppCamera )
                }
            }
            else if(curVal == 5){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(5, EngineerData.AppHvac )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(5, EngineerData.AppVR )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(5, EngineerData.AppSettingsBt )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(5, EngineerData.AppIBOX )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(5, EngineerData.AppUpgrade )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(5, EngineerData.AppCamera )
                }
            }
            else if(curVal == 6){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(6, EngineerData.AppHvac )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(6, EngineerData.AppVR )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(6, EngineerData.AppSettingsBt )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(6, EngineerData.AppIBOX )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(6, EngineerData.AppUpgrade )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(6, EngineerData.AppCamera )
                }
            }
            else if(curVal == 7){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(7, EngineerData.AppHvac )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(7, EngineerData.AppVR )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(7, EngineerData.AppSettingsBt )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(7, EngineerData.AppIBOX )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(7, EngineerData.AppUpgrade )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(7, EngineerData.AppCamera )
                }
            }
            else if(curVal == 8){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(8, EngineerData.AppHvac )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(8, EngineerData.AppVR )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(8, EngineerData.AppSettingsBt )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(8, EngineerData.AppIBOX )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(8, EngineerData.AppUpgrade )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(8, EngineerData.AppCamera )
                }
            }
            else if(curVal == 9){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(9, EngineerData.AppHvac )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(9, EngineerData.AppVR )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(9, EngineerData.AppSettingsBt )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(9, EngineerData.AppIBOX )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(9, EngineerData.AppUpgrade )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(9, EngineerData.AppCamera )
                }
            }
            else if(curVal == 10){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(10, EngineerData.AppHvac )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(10, EngineerData.AppVR )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(10, EngineerData.AppSettingsBt )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(10, EngineerData.AppIBOX )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(10, EngineerData.AppUpgrade )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(10, EngineerData.AppCamera )
                }
            }


        }

    }

    ListModel{
        id: main_textModel
        property int count: 11
        ListElement {name: "ASSERT"; elementId: 0 }
        ListElement {name: "LOW"; elementId: 1 }
        ListElement {name: "TRACE";  elementId: 2 }
        ListElement {name: "MEDIUM";  elementId: 3 }
        ListElement {name: "INFO";  elementId: 4 }
        ListElement {name: "HIGH";  elementId: 5 }
        ListElement {name: "SIGNAL"; elementId: 6 }
        ListElement {name: "SLOT"; elementId: 7 }
        ListElement {name: "TRANSITION"; elementId: 8 }
        ListElement {name: "CRITICAL";  elementId: 9 }
        ListElement {name: "Disable";  elementId: 10 }

    }

    Image{
        x:20
        y:130
        width:1280 - 430
        source: imgFolderGeneral+"line_menu_list.png"
    }
    Text{
        id:idTxt3
        height:50
        x: 0 ; y:135
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("Settings")
        verticalAlignment: Text.AlignVCenter
    }
    Text
    {
        x:400; y: 135
        id:idTxt4
        height:50
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("AppStandBy")
        verticalAlignment: Text.AlignVCenter
    }
    MComp.MButtonTouch {
        id:idButton3
        x:0; y:190
        width: 250; height:80
        firstText: "Load Log Level"
        firstTextX: 30
        firstTextY: 20//40
        firstTextWidth: 250
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        onWheelLeftKeyPressed: idButton2.forceActiveFocus()
        onWheelRightKeyPressed: idButton4.forceActiveFocus()
        onClickOrKeySelected: {
            idButton3.forceActiveFocus()
            idCurrentAppVal_text.text = "Settings"
            stateLogListModel = 2
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.AppSettingsBt)
        }
    }
    MComp.MButtonTouch {
        id:idButton4
        x:400; y:190
        width: 250; height:80
        firstText: "Load Log Level"
        firstTextX: 30
        firstTextY: 20//40
        firstTextWidth: 250
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        onWheelLeftKeyPressed: idButton3.forceActiveFocus()
        onWheelRightKeyPressed: idButton5.forceActiveFocus()
        onClickOrKeySelected: {
            idButton4.forceActiveFocus()
            idCurrentAppVal_text.text = "iBox"
            stateLogListModel = 3
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.AppIBOX)
        }
    }

    Image{
        x:20
        y:265
        width:1280 - 430
        source: imgFolderGeneral+"line_menu_list.png"
    }

    Text{
        id:idTxt5
        height:50
        x: 0 ; y:270
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("Upgrade")
        verticalAlignment: Text.AlignVCenter
    }
    Text
    {
        x:400; y: 270
        id:idTxt6
        height:50
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("AppCamera")
        verticalAlignment: Text.AlignVCenter
    }
    MComp.MButtonTouch {
        id:idButton5
        x:0; y:325
        width: 250; height:80
        firstText: "Load Log Level"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 250
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        onWheelLeftKeyPressed: idButton4.forceActiveFocus()
        onWheelRightKeyPressed: idButton6.forceActiveFocus()
        onClickOrKeySelected: {
            idButton5.forceActiveFocus()
            idCurrentAppVal_text.text = "Upgrade"
            stateLogListModel = 4
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.AppUpgrade)
        }
    }
    MComp.MButtonTouch {
        id:idButton6
        x:400; y:325
        width: 250; height:80
        firstText: "Load Log Level"
        firstTextX: 30
        firstTextY: 40
        firstTextWidth: 250
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        onWheelLeftKeyPressed: idButton5.forceActiveFocus()
        onWheelRightKeyPressed: main_spinner.forceActiveFocus()
        onClickOrKeySelected: {
            idButton6.forceActiveFocus()
            idCurrentAppVal_text.text = "AppCamera"
            stateLogListModel = 5
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.AppCamera)
        }
    }

    Image{
        x:20
        y:400
        width:1280 - 430
        source: imgFolderGeneral+"line_menu_list.png"
    }
    Text{
        id:idCurrentApp_text
        height:50
        x: 0 ; y:405
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("Current Setting App : ")
        verticalAlignment: Text.AlignVCenter
    }
    Text
    {
        x:50; y: 450
        id:idCurrentAppVal_text
        height:50
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:"blue"
        text: ""
        verticalAlignment: Text.AlignVCenter
    }
}
