import QtQuick 1.0

import "../Component" as MComp
import "../System" as MSystem
import "../Operation/operation.js" as MOp
import com.engineer.data 1.0
MComp.MComponent{
    id:idAutoTest
    x: 0; y: 0
    //x:-1; y:261-89-166+5
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    //clip:true
    focus: true

    MSystem.ImageInfo { id: imageInfo }
    MSystem.SystemInfo { id: systemInfo }
    property string imgFolderGeneral: imageInfo.imgFolderGeneral
    property string imgFolderNewGeneral: imageInfo.imgFolderNewGeneral
    property string imgFolderModeArea: imageInfo.imgFolderModeArea

    property int qeDebugMsgState: UIListener.getUDebugState() /*UIListener.LoadSystemConfig(EngineerData.DB_QEDEBUG_MSG_STATE)*/
    property int cursorState: UIListener.LoadSystemConfig(EngineerData.DB_CURSOR_STATE)
    property int fanControlState: UIListener.LoadSystemConfig(EngineerData.DB_FAN_CONTROL_STATE)
    property int accModeState: MPMode.GetMPModeInfo();/*UIListener.LoadSystemConfig(EngineerData.DB_ACCMODE_STATE)*/
    property int steerWheelModeState: MPMode.GetSteerWheelModeInfo();
    property int cpuWDTState: MPMode.GetCpuWDTInfo();

    property int biosWDTCount: SystemControl.GetBiosWDTCountInfo();
    property int cpuWDTCount: SystemControl.GetCpuWDTCountInfo();
    property int ssdWDTCount: SystemControl.GetSsdWDTCountInfo(); //added for SSD WDT

    property int consoleState: IPInfo.getCurrentConsoleState() //added for Console On_Off State

    onBackKeyPressed: {
        console.log("Enter AutoTest Main Back Key or Click==============")
        //added for BGFG structure
        if(isMapCareMain)
        {
            if(isMapCareEx)
            {
                mainViewState = "MapCareMainEx"
                setMapCareUIScreen("", true)
                idMapCareMainView.forceActiveFocus()
            }
            else
            {
                mainViewState = "MapCareMain"
                setMapCareUIScreen("", true)
                idMapCareMainView.forceActiveFocus()
            }
        }
        else
        {
            mainViewState="Main"
            setMainAppScreen("", true)

            if(flagState == 0){
                console.log("Enter Simple Main Software :::")
                //idMainView.visible = true
                idMainView.forceActiveFocus()

            }
            else if(flagState == 9){
                  console.log("Enter Full Main Software :::")

                    //idFullMainView.visible = true
                  idFullMainView.forceActiveFocus()
            }
        }
        //added for BGFG structure

    }

    MComp.MBand{
        id:autoTestBand
        titleText: qsTr("Engineering Mode > ETC")

        KeyNavigation.down:refreshMButton
        onWheelRightKeyPressed: {
            if(autoTestBand.backKeyButton.focus == true)
                autoTestBand.bandSubButton.forceActiveFocus()
            else
                autoTestBand.backKeyButton.forceActiveFocus()
        }
        onWheelLeftKeyPressed: {
            if(autoTestBand.backKeyButton.focus == true)
                autoTestBand.bandSubButton.forceActiveFocus()
            else
                autoTestBand.backKeyButton.forceActiveFocus()
        }

        subBtnFlag: true
        subKeyText: "Page2"
        onSubKeyClicked:
        {
            mainViewState = "AutoTestPage2"
            setMainAppScreen("AutoTestPage2", true)
        }

        onBackKeyClicked: {
            //added for BGFG structure
            if(isMapCareMain)
            {
                if(isMapCareEx)
                {
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
            }
            else
            {
                mainViewState="Main"
                setMainAppScreen("", true)

                if(flagState == 0){
                    console.log("Enter Simple Main Software :::")
                    //idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      console.log("Enter Full Main Software :::")

                        //idFullMainView.visible = true
                      idFullMainView.forceActiveFocus()
                }
            }
            //added for BGFG structure

        }
    }

        Text {
            id: lbl_agentState
            text: "Agent State :"
            //x: 38; y: 120;
            x:30; y:120
            //font.pixelSize: 32;
            font.pixelSize: 20;
            color: "#ffffff"
        }
        Text {
            id: txt_agentState
            text: ""
            x: 170; y: 120;
            //font.pixelSize: 32;
            font.pixelSize: 20;
            color: colorInfo.dimmedGrey
        }
        MComp.MButtonTouch {
            id : refreshMButton
            //x: 38; y: 180
            //width:140; height:80
            x: 30; y: 180
            width:140; height:80
            focus: true
            firstText: "REFRESH"
            firstTextX: 20
            firstTextY: 30
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""
            KeyNavigation.up:{
                autoTestBand.backKeyButton.forceActiveFocus()
                autoTestBand
            }

            onWheelLeftKeyPressed: idSteerModeOffBtn.forceActiveFocus()

            onWheelRightKeyPressed: idAgentONButton.forceActiveFocus()

          onClickOrKeySelected: {
                refreshMButton.forceActiveFocus()
                txt_agentState.text = "Searching..."
                refreshMButton.visible = "false"
                AutoTest.AgentRefresh()
            }
        }

        MComp.MButtonTouch {
            id:idAgentONButton
            //x: 190; y: 180
            //width:140; height:80
            x: 180; y: 180
            width:80; height:80
            firstText: "ON"
            firstTextX: 20
            firstTextY: 30
            firstTextWidth: 140
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""

            KeyNavigation.up:{
                autoTestBand.backKeyButton.forceActiveFocus()
                autoTestBand
            }
            KeyNavigation.left:refreshMButton
            KeyNavigation.right:idAgentOFFButton
            onWheelLeftKeyPressed: refreshMButton.forceActiveFocus()
            onWheelRightKeyPressed: idAgentOFFButton.forceActiveFocus()

            onClickOrKeySelected: {
                idAgentONButton.forceActiveFocus()
                AutoTest.AgentOn()
            }
        }

        MComp.MButtonTouch {
            id:idAgentOFFButton
            //x: 340; y: 180
            //width:140; height:80
            x: 270; y: 180
            width:80; height:80
            firstText: "OFF"
            firstTextX: 20
            firstTextY: 30
            firstTextWidth: 80
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""

            KeyNavigation.up:{
                autoTestBand.backKeyButton.forceActiveFocus()
                autoTestBand
            }

            onWheelLeftKeyPressed: idAgentONButton.forceActiveFocus()
            onWheelRightKeyPressed: idQeDebugMsgOn.forceActiveFocus()

            onClickOrKeySelected: {
                idAgentOFFButton.forceActiveFocus()
                AutoTest.AgentOff()
            }
        }

        Text {
            id: txt_QEDebugMsg
            text: "U-Debug : "
            //x: 520; y: 120;
            x: 420; y: 120;
            //font.pixelSize: 25;
            font.pixelSize: 20;
            color: "#ffffff"
        }
        Text {
            id: txt_QEDebugMsgState
            text: ""
            //x: 700; y: 120;
            x: 530; y: 120;
            //font.pixelSize: 25;
            font.pixelSize: 20;
            color: colorInfo.dimmedGrey
        }
        MComp.MButtonTouch {
            id:idQeDebugMsgOn
            //x: 520; y: 180
            //width:140; height:80
            x: 420; y: 180
            width:120; height:80
            firstText: "ENABLE"
            firstTextX: 20
            firstTextY: 30
            firstTextWidth: 120
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""

            KeyNavigation.up:{
                autoTestBand.backKeyButton.forceActiveFocus()
                autoTestBand
            }

            onWheelLeftKeyPressed: idAgentOFFButton.forceActiveFocus()
            onWheelRightKeyPressed: idQeDebugMsgOff.forceActiveFocus()

            onClickOrKeySelected: {
                idQeDebugMsgOn.forceActiveFocus()
                UIListener.uDebugEnDisable(true)
                txt_QEDebugMsgState.text = "ENABLE"
                UIListener.SaveSystemConfig(1 ,EngineerData.DB_QEDEBUG_MSG_STATE)
            }
        }
        MComp.MButtonTouch {
            id:idQeDebugMsgOff
            //x: 670; y: 180
            //width:140; height:80
            x: 550; y: 180
            width:120; height:80
            firstText: "DISABLE"
            firstTextX: 20
            firstTextY: 30
            firstTextWidth: 120
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""

            KeyNavigation.up:{
                autoTestBand.backKeyButton.forceActiveFocus()
                autoTestBand
            }

            onWheelLeftKeyPressed: idQeDebugMsgOn.forceActiveFocus()
            onWheelRightKeyPressed: idCusorEnableButton.forceActiveFocus()

            onClickOrKeySelected: {
                idQeDebugMsgOff.forceActiveFocus()
                UIListener.uDebugEnDisable(false)
                txt_QEDebugMsgState.text = "DISABLE"
                UIListener.SaveSystemConfig(0 ,EngineerData.DB_QEDEBUG_MSG_STATE)
            }
        }

        Text {
            id: txt_CusorEnDisable
            text: "Cursor Enable/Disable : "
            //x: 870; y: 120;
            x: 690; y: 120;
            font.pixelSize: 20; color: "#ffffff"
        }
        Text {
            id: txt_CusorEnDisableState
            text: ""
            //x: 1160; y: 120;
            x: 920; y: 120;
            font.pixelSize: 20; color: colorInfo.dimmedGrey
        }
        MComp.MButtonTouch {
            id:idCusorEnableButton
            //x: 870; y: 180
            //width:140; height:80
            x: 710; y: 180
            width:120; height:80
            firstText: "ENABLE"
            firstTextX: 20
            firstTextY: 30
            firstTextWidth: 120
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""

            KeyNavigation.up:{
                autoTestBand.backKeyButton.forceActiveFocus()
                autoTestBand
            }

            onWheelLeftKeyPressed: idQeDebugMsgOff.forceActiveFocus()
            onWheelRightKeyPressed: idCursorDisableButton.forceActiveFocus()

            onClickOrKeySelected: {
                idCusorEnableButton.forceActiveFocus()
                UIListener.mouseCursorEnDisable(true);
                txt_CusorEnDisableState.text = "ENABLE"
                UIListener.SaveSystemConfig(1 ,EngineerData.DB_CURSOR_STATE)
            }
        }
        MComp.MButtonTouch {
            id:idCursorDisableButton
            //x: 1020; y: 180
            //width:140; height:80
            x: 840; y: 180
            width:120; height:80
            firstText: "DISABLE"
            firstTextX: 20
            firstTextY: 30
            firstTextWidth: 120
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""

            KeyNavigation.up:{
                autoTestBand.backKeyButton.forceActiveFocus()
                autoTestBand
            }

            onWheelLeftKeyPressed: idCusorEnableButton.forceActiveFocus()
            onWheelRightKeyPressed: idWDTCountClearButton.forceActiveFocus()

            onClickOrKeySelected: {
                idCursorDisableButton.forceActiveFocus()
                UIListener.mouseCursorEnDisable(false);
                txt_CusorEnDisableState.text = "DISABLE"
                UIListener.SaveSystemConfig(0 ,EngineerData.DB_CURSOR_STATE)
            }
        }

        //added for SSD WDT
        Text {
            id: txt_WDTSsd
            text: "SSD WDT Count: "
            x: 1040; y: 69 + 10;
            font.pixelSize: 20//24;
            color: "#ffffff"
            font.family: UIListener.getFont(false)//"HDR"
        }
        Text {
            id: txt_WDTSsdCount
            text: ssdWDTCount
            x: 1210; y: 69 + 10;
            font.pixelSize: 20//24;
            color: colorInfo.dimmedGrey
            font.family: UIListener.getFont(false)//"HDR"
        }
        //added for SSD WDT

        Text {
            id: txt_WDTBios
            text: "BIOS WDT Count: "
            //x: 870; y: 120;
            x: 1040; y: 80 + 30 ;//added for SSD WDT
            font.pixelSize: 20; color: "#ffffff"
        }
        Text {
            id: txt_WDTBiosCount
            text: biosWDTCount
            //x: 1160; y: 120;
            x: 1210; y: 80 + 30 ;//added for SSD WDT
            font.pixelSize: 20; color: colorInfo.dimmedGrey
        }

        Text {
            id: txt_WDTCpu
            text: "CPU WDT Count: "
            //x: 870; y: 120;
            x: 1040; y: 140;//added for SSD WDT
            font.pixelSize: 20; color: "#ffffff"
        }
        Text {
            id: txt_WDTCpuCount
            text: cpuWDTCount
            //x: 1160; y: 120;
            x: 1210; y: 140;//added for SSD WDT
            font.pixelSize: 20; color: colorInfo.dimmedGrey
        }

        MComp.MButtonTouch {
            id:idWDTCountClearButton
            x: 1120; y: 180
            width:110; height:80

            firstText: "Clear"
            firstTextX: 20
            firstTextY: 30
            firstTextWidth: 110
            firstTextColor: colorInfo.brightGrey
            firstTextSelectedColor: colorInfo.brightGrey
            firstTextSize: 20
            firstTextStyle: "HDB"

            bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
            bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
            bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
            fgImage: ""
            fgImageActive: ""

            KeyNavigation.up:{
                autoTestBand.backKeyButton.forceActiveFocus()
                autoTestBand
            }

            onWheelLeftKeyPressed: idCursorDisableButton.forceActiveFocus()
            onWheelRightKeyPressed: idIpConfigButton.forceActiveFocus()

            onClickOrKeySelected: {
                idWDTCountClearButton.forceActiveFocus()
                SystemControl.RequestWDTClearToMicom()
                SystemControl.RequestWDTCountFromQml()

            }
        }
    Image{
        x:38
        y:280
        width: 1100
        source: imgFolderGeneral+"line_menu_list.png"
    }
    Text {
        id: idIpConfig
        text: "IP Config"
        x: 38; y: 320;
        font.pixelSize: 25; color: "#ffffff"
    }
    MComp.MButtonTouch {
        id:idIpConfigButton
        x: 190; y: 310
        width:130; height:69
        firstText: "Enter"
        firstTextX: 30
        firstTextY: 20
        firstTextWidth: 130
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        KeyNavigation.up:{
            autoTestBand.backKeyButton.forceActiveFocus()
            autoTestBand
        }


        onWheelLeftKeyPressed: idWDTCountClearButton.forceActiveFocus()
        onWheelRightKeyPressed: idVerCompareButton.forceActiveFocus()

        onClickOrKeySelected: {
            idIpConfigButton.forceActiveFocus()
            mainViewState = "IpConfig"
            setMainAppScreen("IpConfig", true)
        }
    }


    Text {
        id: idVerVersion
        text: "Version"
        x: 30+173+184; y: 310//320;
        font.pixelSize: 24; color: "#ffffff"
        font.family: UIListener.getFont(false)//"HDR"
    }
    Text {
        id: idVerCompare
        text: "Compare"
        x: 30+173+184; y: 310 + 30//320 + 30;
        font.pixelSize: 24; color: "#ffffff"
        font.family: UIListener.getFont(false)//"HDR"
    }
    MComp.MButtonTouch {
        id:idVerCompareButton
        x: 215+307; y: 310
        width:130; height:69
        firstText: "Enter"
        firstTextX: 30
        firstTextY: 20
        firstTextWidth: 130
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        KeyNavigation.up:{
            autoTestBand.backKeyButton.forceActiveFocus()
            autoTestBand
        }
        onWheelLeftKeyPressed: idIpConfigButton.forceActiveFocus()
        onWheelRightKeyPressed: idLogSettingButton.forceActiveFocus()

        onClickOrKeySelected: {
            idVerCompareButton.forceActiveFocus()
            mainViewState = "VerCompare"
            setMainAppScreen("VerCompare", true)
        }
    }


    Text {
        id: idLogSetting
        text: "Auto Test"
        x: 30+173+184+123+184; y: 310//320;
        font.pixelSize: 25; color: "#ffffff"
    }
    MComp.MButtonTouch {
        id:idLogSettingButton
        x: 215+307+307; y: 310
        width:130; height:69
        firstText: "Enter"
        firstTextX: 30
        firstTextY: 20
        firstTextWidth: 140
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 25
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        KeyNavigation.up:{
            autoTestBand.backKeyButton.forceActiveFocus()
            autoTestBand
        }

        onWheelLeftKeyPressed: idVerCompareButton.forceActiveFocus()
        onWheelRightKeyPressed: idFanOffButton.forceActiveFocus()

        onClickOrKeySelected: {
            idLogSettingButton.forceActiveFocus()
            //mainViewState = "LogSetting"
            //setMainAppScreen("LogSetting", true)
            UIListener.executeAutoTest()
        }
    }

    //added for Console On_Off State
    Text {
        id: idConsoleOnOff
        text: "Console On/Off"
        x: 30+315+42+265+42+265+42; y: 310
        font.pixelSize: 24; color: "#ffffff"
        font.family: UIListener.getFont(false)//"HDR"
    }
    Text {
        id: idConsoleOnOffState
        text:""
        x: 30+315+42+265+42+265+42; y: 310 + 30
        font.pixelSize: 24; color: colorInfo.dimmedGrey
        font.family: UIListener.getFont(false)//"HDR"
    }
    //added for Console On_Off State


    Image{
        x:38
        y:400
        width: 1100
        source: imgFolderGeneral+"line_menu_list.png"
    }
    Text {
        id: idFanControl
        text: "FAN ON/OFF: "
        x: 38; y: 450;
        font.pixelSize: 25; color: "#ffffff"
    }
    Text {
        id: idFanControlState
        text: ""
        x: 190; y: 450;
        font.pixelSize: 25; color: colorInfo.dimmedGrey
    }
    MComp.MButtonTouch {
        id:idFanOffButton
        x: 250; y: 420
        width:120; height:80
        firstText: "OFF"
        firstTextX: 40
        firstTextY: 30
        firstTextWidth: 120
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        KeyNavigation.up:{
            autoTestBand.backKeyButton.forceActiveFocus()
            autoTestBand
        }

        onWheelLeftKeyPressed: idLogSettingButton.forceActiveFocus()
        onWheelRightKeyPressed: idFanRowOnButton.forceActiveFocus()

        onClickOrKeySelected: {
            idFanOffButton.forceActiveFocus()
            SystemControl.fanControl(0)
            idFanControlState.text = "OFF"
            UIListener.SaveSystemConfig(0 ,EngineerData.DB_FAN_CONTROL_STATE)
        }
    }
    MComp.MButtonTouch {
        id:idFanRowOnButton
        x: 390; y: 420
        width:120; height:80
        firstText: "ROW ON"
        firstTextX: 20
        firstTextY: 30
        firstTextWidth: 120
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        KeyNavigation.up:{
            autoTestBand.backKeyButton.forceActiveFocus()
            autoTestBand
        }

        onWheelLeftKeyPressed: idFanOffButton.forceActiveFocus()
        onWheelRightKeyPressed: idFanHighOnButton.forceActiveFocus()

        onClickOrKeySelected: {
            idFanRowOnButton.forceActiveFocus()
            SystemControl.fanControl(1)
            idFanControlState.text = "ROW ON"
            UIListener.SaveSystemConfig(1 ,EngineerData.DB_FAN_CONTROL_STATE)
        }
    }
    MComp.MButtonTouch {
        id:idFanHighOnButton
        x: 530; y: 420
        width:120; height:80
        firstText: "HIGH ON"
        firstTextX: 20
        firstTextY: 30
        firstTextWidth: 120
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        KeyNavigation.up:{
            autoTestBand.backKeyButton.forceActiveFocus()
            autoTestBand
        }

        onWheelLeftKeyPressed: idFanRowOnButton.forceActiveFocus()
        onWheelRightKeyPressed: idAccOnButton.forceActiveFocus()

        onClickOrKeySelected: {
               idFanHighOnButton.forceActiveFocus()
               SystemControl.fanControl(2)
               idFanControlState.text = "HIGH ON"
               UIListener.SaveSystemConfig(2 ,EngineerData.DB_FAN_CONTROL_STATE)
        }
    }
    Text {
        id: idAccModeSet
        text: "ACC Mode Set : "
        x: 670; y: 450;
        font.pixelSize: 25; color: "#ffffff"
    }
    Text {
        id: idAccModeSetState
        text: ""
        x: 870; y: 450;
        font.pixelSize: 25; color: colorInfo.dimmedGrey
    }
    MComp.MButtonTouch {
        id:idAccOnButton
        x: 970; y: 420
        width:120; height:80
        firstText: "ON"
        firstTextX: 40
        firstTextY: 30
        firstTextWidth: 120
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        KeyNavigation.up:{
            autoTestBand.backKeyButton.forceActiveFocus()
            autoTestBand
        }
        onWheelLeftKeyPressed: idFanHighOnButton.forceActiveFocus()
        onWheelRightKeyPressed: idAccOffButton.forceActiveFocus()

        onClickOrKeySelected: {
            idAccOnButton.forceActiveFocus()
            MPMode.setMPMode( 1 )
            idAccModeSetState.text = "ON"
            UIListener.SaveSystemConfig(1 ,EngineerData.DB_ACCMODE_STATE)
        }
    }
    MComp.MButtonTouch {
        id:idAccOffButton
        x: 1110; y: 420
        width:120; height:80
        firstText: "OFF"
        firstTextX: 40
        firstTextY: 30
        firstTextWidth: 120
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        KeyNavigation.up:{
            autoTestBand.backKeyButton.forceActiveFocus()
            autoTestBand
        }

        onWheelLeftKeyPressed: idAccOnButton.forceActiveFocus()
        onWheelRightKeyPressed: idCpuWDTOnButton.forceActiveFocus()

        onClickOrKeySelected: {
            idAccOffButton.forceActiveFocus()
            MPMode.setMPMode( 0 )
            idAccModeSetState.text = "OFF"
            UIListener.SaveSystemConfig(0 ,EngineerData.DB_ACCMODE_STATE)
        }
    }
    Image{
        x:38
        y:520
        width: 1100
        source: imgFolderGeneral+"line_menu_list.png"
    }
    Text {
        id: idCpuWDT
        text: "CPU WDT : "
        x: 38; y: 560;
        font.pixelSize: 25; color: "#ffffff"
    }
    Text {
        id: idCpuWDTState
        text: ""
        x: 190; y: 560;
        font.pixelSize: 25; color: colorInfo.dimmedGrey
    }
    MComp.MButtonTouch {
        id:idCpuWDTOnButton
        x: 250; y: 530
        width:120; height:80
        firstText: "ON"
        firstTextX: 40
        firstTextY: 30
        firstTextWidth: 120
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        KeyNavigation.up:{
            autoTestBand.backKeyButton.forceActiveFocus()
            autoTestBand
        }

        onWheelLeftKeyPressed: idAccOffButton.forceActiveFocus()
        onWheelRightKeyPressed: idCpuWDTOffButton.forceActiveFocus()

        onClickOrKeySelected: {
            idCpuWDTOnButton.forceActiveFocus()
            MPMode.setCpuWDTMode(1)
            idCpuWDTState.text = "ON";
        }
    }
    MComp.MButtonTouch {
        id:idCpuWDTOffButton
        x: 390; y: 530
        width:120; height:80
        firstText: "OFF"
        firstTextX: 40
        firstTextY: 30
        firstTextWidth: 120
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        KeyNavigation.up:{
            autoTestBand.backKeyButton.forceActiveFocus()
            autoTestBand
        }

        onWheelLeftKeyPressed: idCpuWDTOnButton.forceActiveFocus()
        onWheelRightKeyPressed: idSteerModeOnBtn.forceActiveFocus()

        onClickOrKeySelected: {
            idCpuWDTOffButton.forceActiveFocus()
            MPMode.setCpuWDTMode(0)
            idCpuWDTState.text = "OFF";
        }
    }
    Text{
        id:idSteerModeSet
        text: "SteerMode Set:"
        x:640; y:560;
        font.pixelSize: 25
        color: "#ffffff";
    }
    Text{
        id:idSteerModeSetState
        text: ""
        x:870; y:560;
        font.pixelSize: 25; color: colorInfo.dimmedGrey
    }
    MComp.MButtonTouch{
        id:idSteerModeOnBtn
        x:970; y:530;
        width:120; height:80
        firstText: "ON"
        firstTextX: 40
        firstTextY: 30
        firstTextWidth: 120
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""

        KeyNavigation.up:{
            autoTestBand.backKeyButton.forceActiveFocus()
            autoTestBand
        }

        onWheelLeftKeyPressed: idCpuWDTOffButton.forceActiveFocus()
        onWheelRightKeyPressed: idSteerModeOffBtn.forceActiveFocus()

        onClickOrKeySelected: {
            idSteerModeOnBtn.forceActiveFocus()
            MPMode.setSteerWheelMode( 1 )
            idSteerModeSetState.text = "ON"

        }
    }
    MComp.MButtonTouch{
        id:idSteerModeOffBtn
        x: 1110; y: 530
        width:120; height:80
        firstText: "OFF"
        firstTextX: 40
        firstTextY: 30
        firstTextWidth: 120
        firstTextColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextSize: 20
        firstTextStyle: "HDB"

        bgImage: imgFolderNewGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderNewGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderNewGeneral+"btn_title_sub_f.png"
        fgImage: ""
        fgImageActive: ""


        KeyNavigation.up:{
            autoTestBand.backKeyButton.forceActiveFocus()
            autoTestBand
        }

        onWheelLeftKeyPressed: idSteerModeOnBtn.forceActiveFocus()
        onWheelRightKeyPressed: refreshMButton.forceActiveFocus()

        onClickOrKeySelected: {
            idSteerModeOffBtn.forceActiveFocus()
            MPMode.setSteerWheelMode( 0 )
            idSteerModeSetState.text = "OFF"

        }
    }



    Component.onCompleted: {
        //VariantSetting.reqGPSVersion();
        //SendDeckSignal.sendDeckSignal();
        //SystemInfo.releaseVersionRead();
        //SystemInfo.CompareVersion();
        //state check : QE Debug Message
        //Case : On State

        //added for Console On_Off State
        if(consoleState > 0)
        {
            idConsoleOnOffState.text = ": ON";
        }
        else
        {
            idConsoleOnOffState.text = ": OFF"
        }
        //added for Console On_Off State

        if(qeDebugMsgState > 0){
            txt_QEDebugMsgState.text = "ENABLE"
        }//Case : OFF State
        else{
            txt_QEDebugMsgState.text = "DISABLE"
        }
        //Case : Cursor Enable State
        if(cursorState > 0){
            txt_CusorEnDisableState.text = "ENABLE"
        }//Case : Cursor Disable State
        else{
            txt_CusorEnDisableState.text = "DISABLE"
        }

        //Case : Fan Control Off State
        if(fanControlState == 0){
            idFanControlState.text = "OFF"
        }//Case : Fan Control Row On State
        else if(fanControlState == 1){
            idFanControlState.text = "ROW ON"
        }//Case : Fan Control High On State
        else if(fanControlState == 2){
            idFanControlState.text = "HIGH ON"
        }

        //Case : Acc Mode Set State - Off
        if(accModeState == 0){
           idAccModeSetState.text = "OFF";
        }//case : Acc Mode Set - On
        else{
            idAccModeSetState.text = "ON";
        }

        if(cpuWDTState == 0){
            idCpuWDTState.text = "OFF";
        }
        else{
            idCpuWDTState.text = "ON";
        }

        if(steerWheelModeState == 0){
            idSteerModeSetState.text = "OFF";
        }
        else{
            idSteerModeSetState.text = "ON";
        }


        refreshMButton.focus = true;
        refreshMButton.forceActiveFocus()
        AutoTest.QMLCompleted()
        UIListener.autoTest_athenaSendObject();

    }

    //added for Console On_Off State
    Connections {
        target: IPInfo
        onConsoleStateChanged:
        {
            if(isOn)
            {
                idConsoleOnOffState.text = ": ON"
            }
            else
            {
                idConsoleOnOffState.text = ": OFF"
            }
        }
    }
    //added for Console On_Off State

    Connections{
        target: SystemControl

        onRefreshWDTCountInfo:{
            if(isOk == false)
            {
                console.log("[QML] Fail WDT Count Clear to Micom -----")
                txt_WDTBiosCount.text = "0"
                txt_WDTCpuCount.text = "0"
                txt_WDTSsdCount.text = "0"//added for SSD WDT

            }

            else if(isOk == true)
            {
                console.log("[QML] Succes WDT Count Clear to Micom -----")
                txt_WDTBiosCount.text = "0"
                txt_WDTCpuCount.text = "0"
                txt_WDTSsdCount.text = "0"//added for SSD WDT
            }
        }
    }

    Connections {
        target: AutoTest

        onSignalWaiting: {
            refreshMButton.visible = "true"
        }

        onSignalGetState: {
            if(state == true)
                txt_agentState.text = "ON"
            else
                txt_agentState.text = "OFF"
        }
    }
    Connections{
        target:UIListener

        onShowMainGUI:{
            if(isMapCareMain)
            {
                //added for BGFG structure
                if(isMapCareEx)
                {
                    console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                else
                {
                    console.log("[QML] Software  : isMapCareMain: onShowMainGUI -----------")
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                    idMapCareMainView.forceActiveFocus()
                }
                //added for BGFG structure
            }
            else
            {
                console.log("Enter Software Main Back Key or Click==============")
                mainViewState="Main"
                setMainAppScreen("", true)
                if(flagState == 0){
                    console.log("Enter Simple Main Software :::")
                  //  idMainView.visible = true
                    idMainView.forceActiveFocus()

                }
                else if(flagState == 9){
                      console.log("Enter Full Main Software :::")
                      //idFullMainView.visible = true
                      idFullMainView.forceActiveFocus()
                }
            }


        }
        //added for BGFG structure
        onHideGUI:{
            if(isMapCareMain)
            {
                if(isMapCareEx)
                {
                    //console.log("[QML] SoftwareMain : isMapCareMain: onHideGUI --");
                    mainViewState = "MapCareMainEx"
                    setMapCareUIScreen("", true)
                }
                else
                {
                    //console.log("[QML] SoftwareMain : isMapCareMain: onHideGUI --");
                    mainViewState = "MapCareMain"
                    setMapCareUIScreen("", true)
                }


            }

            //console.log("[QML] SoftwareMain : onHideGUI --");
            isMapCareMain = false
            mainViewState="Main"
            setMainAppScreen("", true)
        }
        //added for BGFG structure
    }
}
