import Qt 4.7
import "../../QML/DH" as MComp

MComp.MComponent {
    id:idRadioEngineeringQml
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    state : (gSXMENGMode == "ENGNORMAL") ? "ENGNORMAL" : "ENGDATA"

    property string selectEdit : ""      //"Latitude" "Longitude"
    property string selectNumLat : UIListener.HandleGetLatitude()
    property string selectNumLon : UIListener.HandleGetLongitude()

    property bool bResetSatrt : false

    property string m_sSettingHardwareTestMode : (UIListener.HandleGetHardwareTestMode() == true) ? "on" : "off"
    property string m_sSettingTATestMode : (UIListener.HandleGetTATestMode() == true) ? "on" : "off"

    //****************************** # Engineering Mode Title #
    MComp.MBand {
        id: idRadioEngineeringBand
        x: 0; y: 0
        focus: true

        titleText: "Engineering Mode > Dynamics > XM"
        tabBtnFlag: false
        reserveBtnFlag: false
        subBtnFlag: (gSXMENGMode == "ENGDATA") ? false : true
        subBtnText: stringInfo.sSTR_XMRADIO_DATA
        menuBtnFlag: false

        //****************************** # button clicked or key selected #
        onSubBtnClicked: {
            console.log("### Engineering Mode - SubKey Clicked ###")
            setENGDataMode();
        }
        onBackBtnClicked: {
            console.log("### Engineering Mode - BackKey Clicked ###")
            if(gSXMENGMode == "ENGDATA")
                setENGNormalMode();
            else
            {
                setNoEngMode();
                setEngineeringClose();
                setAppMainScreen("AppRadioMain", false);
                UIListener.HandleBackKey(bTouchBack);
            }
        }
    }

    //****************************** # SXM Radio - Display Area #
    MComp.MComponent{
        id:idRadioEngineeringListDisplay

        EngineeringListList {
            id : xm_engineeringlist_listview
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
            height: systemInfo.lcdHeight - y - 55
        }

        Image{
            id: idButtons
            x: 0; y: xm_engineeringlist_listview.y + xm_engineeringlist_listview.height
            source: imageInfo.imgFolderGeneral+"bg_title.png"

            //Button
            MComp.MButton{
                id: idBtnClearNVM
                x: 10;
                y: 2; width: 200; height: 50; fgImageWidth : 200; fgImageHeight : 50
                fgImage: imageInfo.imgFolderRadio_SXM+"btn_ins_l_n.png"
                fgImagePress: imageInfo.imgFolderRadio_SXM+"btn_ins_l_p.png"
                onClickOrKeySelected: {
                    bResetSatrt = true;
                    UIListener.HandleClearNVM();
                }
                firstText: "Clear NVM"
                firstTextX: 10; firstTextY: 25
                firstTextWidth: 180
                firstTextSize: 20
                firstTextStyle: systemInfo.font_NewHDB
                firstTextAlies: "Center"
                firstTextColor: colorInfo.brightGrey
                firstTextPressColor: colorInfo.brightGrey
                visible: true
            }

            //Button
            MComp.MButton{
                id: idBtnClearCgs
                x: idBtnClearNVM.x + idBtnClearNVM.width;
                y: 2; width: 200; height: 50; fgImageWidth : 200; fgImageHeight : 50
                fgImage: imageInfo.imgFolderRadio_SXM+"btn_ins_l_n.png"
                fgImagePress: imageInfo.imgFolderRadio_SXM+"btn_ins_l_p.png"
                onClickOrKeySelected: {
                    bResetSatrt = true;
                    UIListener.HandleClearCGS();
                }
                firstText: "Clear CGS"
                firstTextX: 10; firstTextY: 25
                firstTextWidth: 180
                firstTextSize: 20
                firstTextStyle: systemInfo.font_NewHDB
                firstTextAlies: "Center"
                firstTextColor: colorInfo.brightGrey
                firstTextPressColor: colorInfo.brightGrey
                visible: true
            }

            //Button
            MComp.MButton{
                id: idBtnClearFuel
                x: idBtnClearCgs.x + idBtnClearCgs.width;
                y: 2; width: 200; height: 50; fgImageWidth : 200; fgImageHeight : 50
                fgImage: imageInfo.imgFolderRadio_SXM+"btn_ins_l_n.png"
                fgImagePress: imageInfo.imgFolderRadio_SXM+"btn_ins_l_p.png"
                onClickOrKeySelected: {
                    bResetSatrt = true;
                    UIListener.HandleClearFuel();
                }
                firstText: "Clear Fuel"
                firstTextX: 10; firstTextY: 25
                firstTextWidth: 180
                firstTextSize: 20
                firstTextStyle: systemInfo.font_NewHDB
                firstTextAlies: "Center"
                firstTextColor: colorInfo.brightGrey
                firstTextPressColor: colorInfo.brightGrey
                visible: true
            }
        }

        Text {
            id: idSouthernCrossOnOff
            x:620
            y:575
            width:100; height: 50
            text: "Southern Cross"
            font.pixelSize: 18
            font.family: systemInfo.font_NewHDB
            visible: true
            color: colorInfo.brightGrey
            style: Text.Raised
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }

        MComp.SettingsSwitchButton {
            id:idSouthernCrossSwitchButton
            x: 780
            y: 575
            state: m_sSettingHardwareTestMode
            knobX:1 ; knobY: -1
            fontSize : 20
            textfontHeight : 50
            imgWidthOffset : 100
            imgHeightOffset: 20
            textYPostion : 63
            onStateChanged: {
                console.log("Hardware Test Switch Button State: "+state)
                if(state == "on")
                    UIListener.HandleSetHardwareTestMode(true)
                else
                    UIListener.HandleSetHardwareTestMode(false)
            }
        }

        Text {
            id: idSXMTATestOnOff
            x:idSouthernCrossSwitchButton.x + idSouthernCrossSwitchButton.imgWidthOffset + 70
            y:575
            width:100; height: 50
            text: "TA Test"
            font.pixelSize: 18
            font.family: systemInfo.font_NewHDB
            visible: true
            color: colorInfo.brightGrey
            style: Text.Raised
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }

        MComp.SettingsSwitchButton {
            id:idSXMTATestSwitchButton
            x: idSXMTATestOnOff.x + 80
            y: 575
            state: m_sSettingTATestMode
            knobX:1 ; knobY: -1
            fontSize : 20
            textfontHeight : 50
            imgWidthOffset : 100
            imgHeightOffset: 20
            textYPostion : 63
            onStateChanged: {
                console.log("TA Test Switch Button State: "+state)
                if(state == "on")
                    UIListener.HandleSetTATestMode(true)
                else
                    UIListener.HandleSetTATestMode(false)
            }
        }
    }

    //****************************** # SXM Radio - Display Area #
    MComp.MComponent{
        id:idRadioEngineeringDataDisplay

        EngineeringListDATA {
            id : xm_engineeringlist_gps
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
        }
        EngineeringListKeypad {
            id: xm_engineeringlist_keypad
            x: 736; y: systemInfo.headlineHeight-systemInfo.statusBarHeight+5
        }
    }

    MComp.MComponent {
        id: idRadioPopupDim1LineQml
        width: systemInfo.lcdWidth
        height: systemInfo.subMainHeight
        visible: bResetSatrt

        Rectangle{
            width: parent.width; height: parent.height
            color: colorInfo.black
            opacity: 0.6
        }

        Image {
            id: idLoadingImage
            width: 76; height: 76
            x: (systemInfo.lcdWidth - idLoadingImage.width)/2
            y: (systemInfo.subMainHeight - idLoadingImage.height)/2
            source: imageInfo.imgFolderPopup + "loading/loading_01.png";
            property bool on: parent.visible && PLAYInfo.Advisory != "MODULE STOP"
            NumberAnimation on rotation { running: idLoadingImage.on; from: 0; to: 360; loops: Animation.Infinite; duration: 2400 }
        }

        Text{
            x:0
            y:idLoadingImage.y + idLoadingImage.height + 30
            width: systemInfo.lcdWidth; height: 66
            text: "Complete\nPlease reboot"
            color:colorInfo.brightGrey
            font { family: systemInfo.font_NewHDR; pixelSize: 36}
            verticalAlignment:Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            visible: PLAYInfo.Advisory == "MODULE STOP"
        }
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        console.log("EngineeringListMain - BackKey Clicked")
        if(gSXMENGMode == "ENGDATA")
            setENGNormalMode();
        else
        {
            setNoEngMode();
            setEngineeringClose();
            setAppMainScreen("AppRadioMain", false);
            UIListener.HandleBackKey(false);
        }
    }
    /* CCP Home Key */
    onHomeKeyPressed: {
        console.log("EngineeringListMain - HomeKey Clicked");
        UIListener.HandleHomeKey();
    }

    onVisibleChanged: {
        console.log("[QML] EngineeringModeListMain.qml ::  onVisibleChanged :: visible = " + visible)

        if(!visible)
        {
            idSXMRadioEngSwitchButton.state = false;
            UIListener.HandleSetHardwareTestMode(false)
        }
        else
        {
            if(gSXMENGMode == "ENGNORMAL")
            {
                idRadioEngineeringBand.giveForceFocus("subBtn");
                idRadioEngineeringBand.focus = true;
            }
        }
    }

    onStateChanged: {
        if(gSXMENGMode == "ENGDATA")
        {
            idRadioEngineeringBand.giveForceFocus("backBtn");
            idRadioEngineeringBand.focus = true;
        }
    }

    function setEngineeringClose()
    {
        idRadioEngineering.visible = false;
    }

    function setENGNormalMode()
    {
        gSXMENGMode = "ENGNORMAL";
        setEngMode();
    }

    function setENGDataMode()
    {
        gSXMENGMode = "ENGDATA";
        setNoEngMode();
    }

    states: [
        State{
            name: "ENGNORMAL"
            PropertyChanges {target: idRadioEngineeringListDisplay; opacity: 1;}
            PropertyChanges {target: idRadioEngineeringDataDisplay; opacity: 0;}
        },
        State{
            name: "ENGDATA"
            PropertyChanges {target: idRadioEngineeringListDisplay; opacity: 0;}
            PropertyChanges {target: idRadioEngineeringDataDisplay; opacity: 1;}
        }
    ]

    transitions: [
        Transition{
            ParallelAnimation{ PropertyAnimation{properties: "opacity"; duration: 0; easing.type: "InCubic"} }
        }
    ]

    /////////////////////////////////////////////////////////////
    // Engineering Mode Timer
    /////////////////////////////////////////////////////////////
    property string engMode : "noeng"// "eng"//
    property int countEng : 1
    property int max_waiting_second_Eng : 5

    Timer {
        id:idEngineeringModeTimer
        interval: 100
        repeat: true

        onTriggered: {
            if(countEng == max_waiting_second_Eng)
            {
                UIListener.HandleEngineeringListView();
                resetTimer();
            }
            countEng++;
        }
        function startTimer()
        {
            countEng = 1;
            running = true;
        }
        function stopTimer()
        {
            countEng = 1;
            running = false;
        }
        function resetTimer()
        {
            countEng = 1;
        }
    }

    function setEngMode()
    {
        if(engMode == "noeng")
        {
            engMode = "eng";
            UIListener.settEngineeringMode(true);
            idEngineeringModeTimer.startTimer();

            return true;
        }

        return false;
    }

    function setNoEngMode()
    {
        if(engMode == "eng")
        {
            engMode = "noeng";
            idEngineeringModeTimer.stopTimer();
            countEng = 1;
            return true;
        }

        return false;
    }
}
