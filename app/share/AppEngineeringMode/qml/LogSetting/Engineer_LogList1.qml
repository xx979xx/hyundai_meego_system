import QtQuick 1.0
import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0
MComp.MComponent{
    id:idLogList1
    x:20
    y:10
    width:1280 - 480
    height:550
    clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    MSystem.ColorInfo{ id : colorInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral
    property string imgFolderModeArea: imageInfo.imgFolderModeArea

    property int biosWDTCount: SystemControl.GetBiosWDTCountInfo();
    property int cpuWDTCount: SystemControl.GetCpuWDTCountInfo();
    property int ssdWDTCount: SystemControl.GetSsdWDTCountInfo();

    Component.onCompleted:{

        UIListener.autoTest_athenaSendObject();
        idCurrentAppVal_text.text = "QCANController"
        idQCanCtrlButton.focus = true
        idQCanCtrlButton.forceActiveFocus()

    }
    property int stateLogListModel : 0

    Text{
        id:qcancontroller_text
        height:50
        x: 0 ; y:0
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("QCANController")
        verticalAlignment: Text.AlignVCenter
    }
    Text
    {
        x:400 -100;
        y: 0
        id:engineerMode_text
        height:50
        font.family: UIListener.getFont(false)//"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("Engineer Mode")
        verticalAlignment: Text.AlignVCenter

    }
    MComp.MButtonTouch {
        id:idQCanCtrlButton
         x:0; y:55
        width: 250; height:80
        focus: true
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
       onWheelRightKeyPressed: idEngineerModeButton.forceActiveFocus()

        onClickOrKeySelected: {
            idQCanCtrlButton.forceActiveFocus()
            idCurrentAppVal_text.text = "QCANController"
            stateLogListModel = 0
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.DHAVN_QCANController)

        }
    }
    MComp.MButtonTouch {
        id:idEngineerModeButton
        x:400-100; y:55
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

        onWheelLeftKeyPressed: idQCanCtrlButton.forceActiveFocus()
        onWheelRightKeyPressed: idRadioButton.forceActiveFocus()
        onClickOrKeySelected: {
            idEngineerModeButton.forceActiveFocus()
            idCurrentAppVal_text.text = "Engineer Mode"
            stateLogListModel = 1
            //main_spinner.currentIndexVal = LogSettingData.LoadLogSetting(EngineerData.AppEngineering)
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.AppEngineering)
        }
    }


    //added for SSD WDT
    Text {
        id: txt_WDTSsd
        text: "SSD WDT Count: "
        x: 600//1040;
        y: 0//69 + 10;
        font.pixelSize: 16//24;
        color: "#ffffff"
        font.family: UIListener.getFont(false)//"HDR"
    }
    Text {
        id: txt_WDTSsdCount
        text: ssdWDTCount
        x: 750//1210;
        y: 0//69 + 10;
        font.pixelSize: 16//24;
        color: colorInfo.dimmedGrey
        font.family: UIListener.getFont(false)//"HDR"
    }
    //added for SSD WDT

    Text {
        id: txt_WDTBios
        text: "BIOS WDT Count: "
        x: 600//1040;
        y: 20//80 + 30 ;//added for SSD WDT
        font.pixelSize: 16; color: "#ffffff"
    }
    Text {
        id: txt_WDTBiosCount
        text: biosWDTCount
        x: 750//1210;
        y: 20//80 + 30 ;//added for SSD WDT
        font.pixelSize: 16; color: colorInfo.dimmedGrey
        font.family: UIListener.getFont(false)//"HDR"
    }

    Text {
        id: txt_WDTCpu
        text: "CPU WDT Count: "
        x: 600//1040;
        y: 40//140;//added for SSD WDT
        font.pixelSize: 16; color: "#ffffff"
    }
    Text {
        id: txt_WDTCpuCount
        text: cpuWDTCount
        x: 750//1210;
        y: 40//140;//added for SSD WDT
        font.pixelSize: 16; color: colorInfo.dimmedGrey
        font.family: UIListener.getFont(false)//"HDR"
    }

    MComp.MButtonTouch {
        id:idWDTCountClearButton
        x: 600//1120;
        y: 70//180
        width:120; height:60

        firstText: "Clear"
        firstTextX: 40
        firstTextY: 20
        firstTextWidth: 120
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 17
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        KeyNavigation.up:{
            //autoTestBand.backKeyButton.forceActiveFocus()
            //autoTestBand
        }

        //onWheelLeftKeyPressed: idCursorDisableButton.forceActiveFocus()
        //onWheelRightKeyPressed: idIpConfigButton.forceActiveFocus()

        onClickOrKeySelected: {
            idWDTCountClearButton.forceActiveFocus()
            SystemControl.RequestWDTClearToMicom()
            SystemControl.RequestWDTCountFromQml()

        }
    }







    MComp.Spinner{
        x: 400; y:460
        id:main_spinner
        visible: true
        aSpinControlTextModel: main_textModel
        currentIndexVal:  LogSettingData.LoadLogSetting(EngineerData.DHAVN_QCANController)//EngineerData.DHAVN_QCANController)).text
        onWheelLeftKeyPressed: idHomeScreenButton.forceActiveFocus()
        onWheelRightKeyPressed: idQCanCtrlButton.forceActiveFocus()
        onSpinControlValueChanged: {
            if(curVal == 0){
                if(stateLogListModel == 0){
                    console.debug(" ====== LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController ) ========")
                     LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(0, EngineerData.AppEngineering )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(0, EngineerData.AppRadio )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(0, EngineerData.UISH )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppFileManager )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_AppHomeScreen )
                }
            }
            else if(curVal == 1){
                if(stateLogListModel == 0){
                    console.debug(" ====== LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController ) ========")
                     LogSettingData.SaveLogSetting(1, EngineerData.DHAVN_QCANController )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(1, EngineerData.AppEngineering )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(1, EngineerData.AppRadio )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(1, EngineerData.UISH )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(1, EngineerData.DHAVN_AppFileManager )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(1, EngineerData.DHAVN_AppHomeScreen )
                }
            }
            else if(curVal == 2){
                if(stateLogListModel == 0){
                    console.debug(" ====== LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController ) ========")
                     LogSettingData.SaveLogSetting(2, EngineerData.DHAVN_QCANController )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(2, EngineerData.AppEngineering )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(2, EngineerData.AppRadio )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(2, EngineerData.UISH )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(2, EngineerData.DHAVN_AppFileManager )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(2, EngineerData.DHAVN_AppHomeScreen )
                }
            }
            else if(curVal == 3){
                if(stateLogListModel == 0){
                    console.debug(" ====== LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController ) ========")
                     LogSettingData.SaveLogSetting(3, EngineerData.DHAVN_QCANController )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(3, EngineerData.AppEngineering )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(3, EngineerData.AppRadio )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(3, EngineerData.UISH )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(3, EngineerData.DHAVN_AppFileManager )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(3, EngineerData.DHAVN_AppHomeScreen )
                }
            }
            else if(curVal == 4){
                if(stateLogListModel == 0){
                    console.debug(" ====== LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController ) ========")
                     LogSettingData.SaveLogSetting(4, EngineerData.DHAVN_QCANController )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(4, EngineerData.AppEngineering )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(4, EngineerData.AppRadio )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(4, EngineerData.UISH )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(4, EngineerData.DHAVN_AppFileManager )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(4, EngineerData.DHAVN_AppHomeScreen )
                }
            }
            else if(curVal == 5){
                if(stateLogListModel == 0){
                    console.debug(" ====== LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController ) ========")
                     LogSettingData.SaveLogSetting(5, EngineerData.DHAVN_QCANController )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(5, EngineerData.AppEngineering )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(5, EngineerData.AppRadio )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(5, EngineerData.UISH )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(5, EngineerData.DHAVN_AppFileManager )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(5, EngineerData.DHAVN_AppHomeScreen )
                }
            }
            else if(curVal == 6){
                if(stateLogListModel == 0){
                    console.debug(" ====== LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController ) ========")
                     LogSettingData.SaveLogSetting(6, EngineerData.DHAVN_QCANController )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(6, EngineerData.AppEngineering )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(6, EngineerData.AppRadio )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(6, EngineerData.UISH )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(6, EngineerData.DHAVN_AppFileManager )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(6, EngineerData.DHAVN_AppHomeScreen )
                }
            }
            else if(curVal == 7){
                if(stateLogListModel == 0){
                    console.debug(" ====== LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController ) ========")
                     LogSettingData.SaveLogSetting(7, EngineerData.DHAVN_QCANController )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(7, EngineerData.AppEngineering )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(7, EngineerData.AppRadio )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(7, EngineerData.UISH )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(7, EngineerData.DHAVN_AppFileManager )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(7, EngineerData.DHAVN_AppHomeScreen )
                }
            }
            else if(curVal == 8){
                if(stateLogListModel == 0){
                    console.debug(" ====== LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController ) ========")
                     LogSettingData.SaveLogSetting(8, EngineerData.DHAVN_QCANController )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(8, EngineerData.AppEngineering )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(8, EngineerData.AppRadio )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(8, EngineerData.UISH )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(8, EngineerData.DHAVN_AppFileManager )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(8, EngineerData.DHAVN_AppHomeScreen )
                }
            }
            else if(curVal == 9){
                if(stateLogListModel == 0){
                    console.debug(" ====== LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController ) ========")
                     LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(9, EngineerData.AppEngineering )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(9, EngineerData.AppRadio )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(9, EngineerData.UISH )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(9, EngineerData.DHAVN_AppFileManager )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(9, EngineerData.DHAVN_AppHomeScreen )
                }
            }
            else if(curVal == 10){
                if(stateLogListModel == 0){
                    console.debug(" ====== LogSettingData.SaveLogSetting(0, EngineerData.DHAVN_QCANController ) ========")
                     LogSettingData.SaveLogSetting(10, EngineerData.DHAVN_QCANController )
                }
                else if(stateLogListModel == 1){
                    LogSettingData.SaveLogSetting(10, EngineerData.AppEngineering )
                }
                else if(stateLogListModel == 2){
                    LogSettingData.SaveLogSetting(10, EngineerData.AppRadio )
                }
                else if(stateLogListModel == 3){
                    LogSettingData.SaveLogSetting(10, EngineerData.UISH )
                }
                else if(stateLogListModel == 4){
                    LogSettingData.SaveLogSetting(10, EngineerData.DHAVN_AppFileManager )
                }
                else if(stateLogListModel == 5){
                    LogSettingData.SaveLogSetting(10, EngineerData.DHAVN_AppHomeScreen )
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
        width:1280 - 540
        source: imgFolderGeneral+"line_menu_list.png"
    }
    Text{
        id:radio_text
        height:50
        x: 0 ; y:135
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("Radio")
        verticalAlignment: Text.AlignVCenter
    }
    Text
    {
        x:400; y: 135
        id:uish_text
        height:50
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("UISH")
        verticalAlignment: Text.AlignVCenter
    }
    MComp.MButtonTouch {
        id:idRadioButton
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

        onWheelLeftKeyPressed: idEngineerModeButton.forceActiveFocus()
        onWheelRightKeyPressed: idUISHButton.forceActiveFocus()
        onClickOrKeySelected: {
            idRadioButton.forceActiveFocus()
            idCurrentAppVal_text.text = "RADIO"
            stateLogListModel = 2
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.AppRadio)
        }
    }
    MComp.MButtonTouch {
        id:idUISHButton
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

        onWheelLeftKeyPressed: idRadioButton.forceActiveFocus()
        onWheelRightKeyPressed: idFileManagerButton.forceActiveFocus()
        onClickOrKeySelected: {
            idUISHButton.forceActiveFocus()
            idCurrentAppVal_text.text = "UISH"

            stateLogListModel = 3
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.UISH)
        }

    }

    Image{
        x:20
        y:265
        width:1280 - 540
        source: imgFolderGeneral+"line_menu_list.png"
    }

    Text{
        id:fileManager_text
        height:50
        x: 0 ; y:270
        font.family:UIListener.getFont(false)//"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("File Manager")
        verticalAlignment: Text.AlignVCenter
    }
    Text
    {
        x:400; y: 270
        id:homeScreen_text
        height:50
        font.family:UIListener.getFont(false) //"Calibri"
        font.pixelSize: 20
        color:colorInfo.brightGrey
        text: qsTr("Home Screen")
        verticalAlignment: Text.AlignVCenter
    }
    MComp.MButtonTouch {
        id:idFileManagerButton
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

        onWheelLeftKeyPressed: idUISHButton.forceActiveFocus()
        onWheelRightKeyPressed: idHomeScreenButton.forceActiveFocus()
        onClickOrKeySelected: {
            idFileManagerButton.forceActiveFocus()
            idCurrentAppVal_text.text = "File Manager"

            stateLogListModel = 4
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppFileManager)
        }
    }
    MComp.MButtonTouch {
        id:idHomeScreenButton
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

        onWheelLeftKeyPressed: idFileManagerButton.forceActiveFocus()
        onWheelRightKeyPressed: main_spinner.forceActiveFocus()
        onClickOrKeySelected: {
            idHomeScreenButton.forceActiveFocus()
            idCurrentAppVal_text.text = "HOME Screen"

            stateLogListModel = 5
            main_spinner.curVal = LogSettingData.LoadLogSetting(EngineerData.DHAVN_AppHomeScreen)
        }
    }

    Image{
        x:20
        y:400
        width:1280 - 540
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


