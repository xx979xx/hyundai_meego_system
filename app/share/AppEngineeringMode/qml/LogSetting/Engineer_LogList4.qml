

////////////////////////////////////////////////////////////////////////////////////////////
import QtQuick 1.0
import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0
MComp.MComponent
{
    id:idLogList4
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
        idCurrentAppVal_text.text = "DAB"
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
        text: qsTr("DAB")
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
        text: qsTr("MMUS")
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
            idCurrentAppVal_text.text = "DAB"
            stateLogListModel = 0
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.AppDAB)
        }
    }
    MComp.MButtonTouch {
        id:idButton2
        x:400; y:55
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

        onWheelLeftKeyPressed: idButton1.forceActiveFocus()
        onWheelRightKeyPressed: idButton3.forceActiveFocus()
        onClickOrKeySelected: {
            idButton2.forceActiveFocus()
            idCurrentAppVal_text.text = "MMUS"
            stateLogListModel = 1
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.DaemonMMus)
        }
    }
    MComp.Spinner{
        x: 400; y:460
        id:main_spinner
        visible: true
        aSpinControlTextModel: main_textModel
        currentIndexVal:  LogSettingData.LoadLogSetting(EngineerData.AppDAB)
        onWheelLeftKeyPressed: idButton6.forceActiveFocus()
        onWheelRightKeyPressed: idButton1.forceActiveFocus()
        onSpinControlValueChanged: {
            if(curVal == 0){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(0, EngineerData.AppDAB )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(0, EngineerData.DaemonMMus )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(0, EngineerData.App_NONE )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(0, EngineerData.AppPANDORA )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(0, EngineerData.DaemonXM )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(0, EngineerData.Media_PlayerEngine )
                }
            }
            else if(curVal == 1){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(1, EngineerData.AppDAB )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(1, EngineerData.DaemonMMus )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(1, EngineerData.App_NONE )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(1, EngineerData.AppPANDORA )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(1, EngineerData.DaemonXM )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(1, EngineerData.Media_PlayerEngine )
                }
            }
            else if(curVal == 2){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(2, EngineerData.AppDAB )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(2, EngineerData.DaemonMMus )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(2, EngineerData.App_NONE )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(2, EngineerData.AppPANDORA )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(2, EngineerData.DaemonXM )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(2, EngineerData.Media_PlayerEngine )
                }
            }
            else if(curVal == 3){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(3, EngineerData.AppDAB )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(3, EngineerData.DaemonMMus )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(3, EngineerData.App_NONE )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(3, EngineerData.AppPANDORA )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(3, EngineerData.DaemonXM )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(3, EngineerData.Media_PlayerEngine )
                }
            }
            else if(curVal == 4){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(4, EngineerData.AppDAB )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(4, EngineerData.DaemonMMus )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(4, EngineerData.App_NONE )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(4, EngineerData.AppPANDORA )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(4, EngineerData.DaemonXM )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(4, EngineerData.Media_PlayerEngine )
                }
            }
            else if(curVal == 5){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(5, EngineerData.AppDAB )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(5, EngineerData.DaemonMMus )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(5, EngineerData.App_NONE )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(5, EngineerData.AppPANDORA )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(5, EngineerData.DaemonXM )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(5, EngineerData.Media_PlayerEngine )
                }
            }
            else if(curVal == 6){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(6, EngineerData.AppDAB )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(6, EngineerData.DaemonMMus )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(6, EngineerData.App_NONE )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(6, EngineerData.AppPANDORA )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(6, EngineerData.DaemonXM )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(6, EngineerData.Media_PlayerEngine )
                }
            }
            else if(curVal == 7){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(7, EngineerData.AppDAB )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(7, EngineerData.DaemonMMus )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(7, EngineerData.App_NONE )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(7, EngineerData.AppPANDORA )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(7, EngineerData.DaemonXM )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(7, EngineerData.Media_PlayerEngine )
                }
            }
            else if(curVal == 8){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(8, EngineerData.AppDAB )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(8, EngineerData.DaemonMMus )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(8, EngineerData.App_NONE )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(8, EngineerData.AppPANDORA )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(8, EngineerData.DaemonXM )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(8, EngineerData.Media_PlayerEngine )
                }
            }
            else if(curVal == 9){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(9, EngineerData.AppDAB )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(9, EngineerData.DaemonMMus )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(9, EngineerData.App_NONE )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(9, EngineerData.AppPANDORA )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(9, EngineerData.DaemonXM )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(9, EngineerData.Media_PlayerEngine )
                }
            }
            else if(curVal == 10){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(10, EngineerData.AppDAB )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(10, EngineerData.DaemonMMus )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(10, EngineerData.App_NONE )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(10, EngineerData.AppPANDORA )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(10, EngineerData.DaemonXM )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(10, EngineerData.Media_PlayerEngine )
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
        font.family: UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("APP_NONE")
        verticalAlignment: Text.AlignVCenter
    }
    Text
    {
        x:400; y: 135
        id:idTxt4
        height:50
        font.family: UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("Pandora")
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
            idCurrentAppVal_text.text = "APP_NONE"
            stateLogListModel = 2
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.App_NONE)
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
            idCurrentAppVal_text.text = "Pandora"
            stateLogListModel = 3
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.AppPANDORA)
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
        font.family: UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("Daemon XM")
        verticalAlignment: Text.AlignVCenter
    }
    Text
    {
        x:400; y: 270
        id:idTxt6
        height:50
        font.family: UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("Media_PlayerEngine")
        verticalAlignment: Text.AlignVCenter
    }
    MComp.MButtonTouch {
        id:idButton5
        x:0; y:325
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

        onWheelLeftKeyPressed: idButton4.forceActiveFocus()
        onWheelRightKeyPressed: idButton6.forceActiveFocus()
        onClickOrKeySelected: {
            idButton5.forceActiveFocus()
            idCurrentAppVal_text.text = "Daemon XM"
            stateLogListModel = 4
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.DaemonXM)
        }
    }
    MComp.MButtonTouch {
        id:idButton6
        x:400; y:325
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

        onWheelLeftKeyPressed: idButton5.forceActiveFocus()
        onWheelRightKeyPressed: main_spinner.forceActiveFocus()
        onClickOrKeySelected: {
            idButton6.forceActiveFocus()
            idCurrentAppVal_text.text = "Media_PlayerEngine"
            stateLogListModel = 5
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.Media_PlayerEngine)
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
        font.family: UIListener.getFont(false) //"Calibri"
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
        font.family: UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:"blue"
        text: ""
        verticalAlignment: Text.AlignVCenter
    }
}


