import QtQuick 1.0
import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0
MComp.MComponent
{
    id:idLogList2
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
        idCurrentAppVal_text.text = "AppPhoto"
        //idPhotoButton.focus = true
        //idPhotoButton.forceActiveFocus()
    }

    Text{
        id:appPhoto_text
        height:50
        x: 0 ; y:0
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("AppPhoto")
        verticalAlignment: Text.AlignVCenter
    }
    Text
    {
        x:400; y: 0
        id:mostManager_text
        height:50
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("MOST Manager")
        verticalAlignment: Text.AlignVCenter

    }
    MComp.MButtonTouch {
        id:idPhotoButton
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
        onWheelRightKeyPressed: idMostManagerButton.forceActiveFocus()

        onClickOrKeySelected: {
            idPhotoButton.forceActiveFocus()
            idCurrentAppVal_text.text = "AppPhoto"
            stateLogListModel = 0
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppPhoto)
        }
    }
    MComp.MButtonTouch {
        id:idMostManagerButton
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

        onWheelLeftKeyPressed: idPhotoButton.forceActiveFocus()
        onWheelRightKeyPressed: idSettingButton.forceActiveFocus()
        onClickOrKeySelected: {
            idMostManagerButton.forceActiveFocus()
            idCurrentAppVal_text.text = "MOST Manager"
            stateLogListModel = 1
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.DHAVN_MOSTManager)
        }
    }
    MComp.Spinner{
        x: 400; y:460
        id:main_spinner
        visible: true
        aSpinControlTextModel: main_textModel
        currentIndexVal:  LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppPhoto)
        onWheelLeftKeyPressed: idBtPhoneButton.forceActiveFocus()
        onWheelRightKeyPressed: idPhotoButton.forceActiveFocus()
        onSpinControlValueChanged: {
            if(curVal == 0){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppPhoto )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_MOSTManager )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppSettings )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppStandBy )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppVideoPlayer )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(0, EngineerData.AppBtPhone )
                }
            }
            else if(curVal == 1){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(1, EngineerData.DHAVN_AppPhoto )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(1, EngineerData.DHAVN_MOSTManager )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(1, EngineerData.DHAVN_AppSettings )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(1, EngineerData.DHAVN_AppStandBy )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(1, EngineerData.DHAVN_AppVideoPlayer )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(1, EngineerData.AppBtPhone )
                }
            }
            else if(curVal == 2){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(2, EngineerData.DHAVN_AppPhoto )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(2, EngineerData.DHAVN_MOSTManager )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(2, EngineerData.DHAVN_AppSettings )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(2, EngineerData.DHAVN_AppStandBy )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(2, EngineerData.DHAVN_AppVideoPlayer )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(2, EngineerData.AppBtPhone )
                }
            }
            else if(curVal == 3){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(3, EngineerData.DHAVN_AppPhoto )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(3, EngineerData.DHAVN_MOSTManager )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(3, EngineerData.DHAVN_AppSettings )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(3, EngineerData.DHAVN_AppStandBy )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(3, EngineerData.DHAVN_AppVideoPlayer )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(3, EngineerData.AppBtPhone )
                }
            }
            else if(curVal == 4){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(4, EngineerData.DHAVN_AppPhoto )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(4, EngineerData.DHAVN_MOSTManager )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(4, EngineerData.DHAVN_AppSettings )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(4, EngineerData.DHAVN_AppStandBy )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(4, EngineerData.DHAVN_AppVideoPlayer )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(4, EngineerData.AppBtPhone )
                }
            }
            else if(curVal == 5){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(5, EngineerData.DHAVN_AppPhoto )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(5, EngineerData.DHAVN_MOSTManager )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(5, EngineerData.DHAVN_AppSettings )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(5, EngineerData.DHAVN_AppStandBy )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(5, EngineerData.DHAVN_AppVideoPlayer )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(5, EngineerData.AppBtPhone )
                }
            }
            else if(curVal == 6){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(6, EngineerData.DHAVN_AppPhoto )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(6, EngineerData.DHAVN_MOSTManager )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(6, EngineerData.DHAVN_AppSettings )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(6, EngineerData.DHAVN_AppStandBy )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(6, EngineerData.DHAVN_AppVideoPlayer )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(6, EngineerData.AppBtPhone )
                }
            }
            else if(curVal == 7){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(7, EngineerData.DHAVN_AppPhoto )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(7, EngineerData.DHAVN_MOSTManager )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(7, EngineerData.DHAVN_AppSettings )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(7, EngineerData.DHAVN_AppStandBy )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(7, EngineerData.DHAVN_AppVideoPlayer )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(7, EngineerData.AppBtPhone )
                }
            }
            else if(curVal == 8){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(8, EngineerData.DHAVN_AppPhoto )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(8, EngineerData.DHAVN_MOSTManager )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(8, EngineerData.DHAVN_AppSettings )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(8, EngineerData.DHAVN_AppStandBy )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(8, EngineerData.DHAVN_AppVideoPlayer )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(8, EngineerData.AppBtPhone )
                }
            }
            else if(curVal == 9){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(9, EngineerData.DHAVN_AppPhoto )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(9, EngineerData.DHAVN_MOSTManager )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(9, EngineerData.DHAVN_AppSettings )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(9, EngineerData.DHAVN_AppStandBy )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(9, EngineerData.DHAVN_AppVideoPlayer )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(9, EngineerData.AppBtPhone )
                }
            }
            else if(curVal == 10){
                if(stateLogListModel == 0){
                    LogSettingData.SaveLogSetting(10, EngineerData.DHAVN_AppPhoto )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(10, EngineerData.DHAVN_MOSTManager )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(10, EngineerData.DHAVN_AppSettings )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(10, EngineerData.DHAVN_AppStandBy )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(10, EngineerData.DHAVN_AppVideoPlayer )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(10, EngineerData.AppBtPhone )
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
        id:appSettings_text
        height:50
        x: 0 ; y:135
        font.family: UIListener.getFont(false)//"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("Settings")
        verticalAlignment: Text.AlignVCenter
    }
    Text
    {
        x:400; y: 135
        id:standby_text
        height:50
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("AppStandBy")
        verticalAlignment: Text.AlignVCenter
    }
    MComp.MButtonTouch {
        id:idSettingButton
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

        onWheelLeftKeyPressed: idMostManagerButton.forceActiveFocus()
        onWheelRightKeyPressed: idStandByButton.forceActiveFocus()
        onClickOrKeySelected: {
            idSettingButton.forceActiveFocus()
            idCurrentAppVal_text.text = "Settings"
            stateLogListModel = 2
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppSettings)
        }
    }
    MComp.MButtonTouch {
        id:idStandByButton
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

        onWheelLeftKeyPressed: idSettingButton.forceActiveFocus()
        onWheelRightKeyPressed: idVidoePlayerButton.forceActiveFocus()
        onClickOrKeySelected: {
            idStandByButton.forceActiveFocus()
            idCurrentAppVal_text.text = "StandBy"
            stateLogListModel = 3
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppStandBy)
        }
    }

    Image{
        x:20
        y:265
        width:1280 - 430
        source: imgFolderGeneral+"line_menu_list.png"
    }

    Text{
        id:videoPlayer_text
        height:50
        x: 0 ; y:270
        font.family: UIListener.getFont(false)//"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("Video Player")
        verticalAlignment: Text.AlignVCenter
    }
    Text
    {
        x:400; y: 270
        id:btPhone_text
        height:50
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("BT Phone")
        verticalAlignment: Text.AlignVCenter
    }
    MComp.MButtonTouch {
        id:idVidoePlayerButton
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

        onWheelLeftKeyPressed: idStandByButton.forceActiveFocus()
        onWheelRightKeyPressed: idBtPhoneButton.forceActiveFocus()
        onClickOrKeySelected: {
            idVidoePlayerButton.forceActiveFocus()
            idCurrentAppVal_text.text = "Video Player"
            stateLogListModel = 4
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppVideoPlayer)
        }
    }
    MComp.MButtonTouch {
        id:idBtPhoneButton
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

        onWheelLeftKeyPressed: idVidoePlayerButton.forceActiveFocus()
        onWheelRightKeyPressed: main_spinner.forceActiveFocus()
        onClickOrKeySelected: {
            idBtPhoneButton.forceActiveFocus()
            idCurrentAppVal_text.text = "Bt Phone"
            stateLogListModel = 5
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.AppBtPhone)
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
        font.family: UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:"blue"
        text: ""
        verticalAlignment: Text.AlignVCenter
    }
}


