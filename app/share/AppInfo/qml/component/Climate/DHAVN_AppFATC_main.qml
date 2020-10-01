import Qt 4.7
import QtQuick 1.0
import Qt.labs.gestures 2.0

//import QmlStatusBarWidget 1.0
//import QmlModeAreaWidget 1.0
import QmlBottomAreaWidget 1.0
import AppEngineQMLConstants 1.0
import QmlSimpleItems 1.0
import QmlStatusBar 1.0
import "."
import "../../component/QML/DH" as MComp
import "../../component/system/DH" as MSystem
import "DHAVN_AppFATC_Constant.js" as CONST
import "../../component/Info/JavaScript/InfoOperation.js" as MInfoOperation

//MComp.MAppMain {
   MComp.MComponent{
    id: idClimateAppMain
    width: 1280
    height: 720-93
    y : 0
//    focus: true
    property int tempUnit:0 // 0:driver 1:passenger
    property int drModeDisp:0
    property int psModeDisp:0
    property string driverTemp:""
    property string passengerTemp:""
    property int displayAUTO:0
    property int displayAC:0
    property int ionClean:0
    property int mainBlower:0
    property int datc_OpSts:0
    property int variant_VentDATC:0
    property int variant_FRControl:-1
    property int variant_Temp:-1
    property int variant_Mode:-1
    property int variant_RearControl:-1
    property int variant_RHD:-1
    property int variant_EU:-1
    property int dualDisp:0
    property int co2Warning:0
    property int diagMode:0
    property int selfDiagDisp:0
    property int rear_Offdisp:0
    property string option_menu_help:""
    property string option_menu_string:""
    property string option_menu_smartVent:""
    property string option_menu_ads:""
    property string menu_string:""
    property string fontName
    property int countryVariant:-1
    property bool isNAorEU: false
    property bool isEU: false
    property bool isNA: false
    property string fontFamily
    property int nCurIndex
    property int smartVentDisp:0
    property int smartVentStatus:0
    // AUTO_DEFOG
    property int autoDefSystemDisp:0
    property int autoDefSystemStatus:0
    property int autoDefSystemBlink:0
    // AUTO_DEFOG
    property bool bIGN_on:true
    property ListModel listmodel: ListModel {}
    property string menu_text
    property string driver1 // :qsTr("STR_HVAC_strDriver");
    property string rear1  // :qsTr("REAR");
    property string passenger1//   :qsTr("STR_HVAC_strPassenger");
    property int syncDisp:-1
    property int langID: UIListener.GetLanguageFromQML();

    property int  iii:0

    property string ambientTemp;

    property string outside // :qsTr("STR_OUTSIDE_TEMP");

    property int bg_bottom_left_margine:24

    property bool rearMonitor : false
    property bool isReverse : false
    property bool isDHPEOnly: false
    property bool isDHPESports: false
    property bool isHelpPageMode: false
    property int iTypeOfDHPEImage: 0

    property string imgFolderClimateDHPE : "/app/share/images/AppInfo/climate/DHPE/"

    Connections{
        target:UIListener
        onSignalShowSystemPopup:{
            //console.log("onSignalShowSystemPopup")
            //close local popup
            id_topButton_f.visible = false
        }
        onSignalHideSystemPopup:{
            //console.log("onSignalHideSystemPopup")
           //
            id_topButton_f.visible = true
        }
    }

    Connections{
        target: uiListener
        onRequestFG:{
            //if(uiListener.getTopApp()!=2)
            //    return;

            if (helpPageLoader.status!=Loader.NULL) {
                if (!isRestoreHelpPage) {
                    helpPageLoader.source = "";
                    isHelpPageMode = false;
                }
            }

            dataModel.updateScreen()

            if (isHelpPageMode) {
                helpPageLoader.forceActiveFocus();
                //console.log("==> onRequestFG(),  helpPageLoader.forceActiveFocus()");
            }
            else {
              //  id_option_list.
                if (idbg_option_menu.visible == true) {
                  //  id_option_list.focus=true;
                    id_option_list.forceActiveFocus();
                    //console.log("==> onRequestFG(),  id_option_list.forceActiveFocus()");
                } else {
                    id_option_list.focus=false;
                    id_topButton_rect.focus=true;
                    id_topButton_rect.forceActiveFocus();
                    //console.log("==> onRequestFG(),  id_topButton_rect.forceActiveFocus()");
                }
            }

           // id_topButton_rect.focus=true;
           // id_topButton_rect.forceActiveFocus();
           //console.log(" DATC QML State = "+states);
           //if( uiListener.getTopApp() !== 0)
           uiListener.clearOSD();
        }

        onRequestBG:{
            //console.log("################## HVAC QML BG ##################### " + Qt.formatDateTime(new Date(), "hh:mm:ss.zzz")); //currentTime().toString("hh:mm:ss.zz"));
        }

        onHandleDHPEOnly:{
            if (isDHPE) {
                isDHPEOnly = true;
                menu_text = qsTranslate("NonAV", "STR_HVAC_strMENUDHPE");
                //uiListener.logBgType(1, iTypeOfDHPEImage);
            }
            else {
                isDHPEOnly = false;
                menu_text = qsTranslate("NonAV", "STR_HVAC_strMENU");
                //uiListener.logBgType(2, iTypeOfDHPEImage);
            }
            countryVariant = uiListener.getVariant();
            rearMonitor = uiListener.getRearMonitor();
            updateBGImageNo();
        }

        onRetranslateUi:{
            //console.log("AppHvac: onRetranslateUi languID = "+languageId);
            dataModel.getTempStr(0)
            dataModel.getTempStr(1)
            dataModel.getTempStr(2)
            dataModel.updateQML()
            setText();
            langID = languageId;
            //dmchoi
            //fontFamily = (langID >= 3 && langID <=5) ? "CHINESS_HDB" : "NewHDB" //MInfoOperation.setFont(languageId);
            fontFamily = "DH_HDB";

            if (languageId==20) isReverse = true;
            else isReverse = false;

            LocTrigger.retrigger();
        }
        onEVTIGNCHANGED:{
            //console.log("AppHvac: onEVTIGNCHANGED " + ign);
            bIGN_on = ign
        }
        onEVTSETTINGCHANGED:{
            //console.log("AppHvac: onEVTSETTINGCHANGED");
            optionMenuDisable();
        }
        onPowerStatusChanged: {
            if (uiListener.isPowerOn() == true) {
                statusBar.homeType = "button";
            }
            else {
                statusBar.homeType = "";
            }
        }
    }// end connections

    Connections{
        target: canMethod
        onSignalForDHPESportModel: {
            if (isSports) {
                isDHPESports = true;
            }
            else {
                isDHPESports = false;
            }
        }
    }

    Connections{
        target: dataModel
        onDrTempChanged:{
            //console.log("   onChangeDrTemp:");
            driverTemp = args[0];
        }

        onPsTempChanged:{
            //console.log("   onChangePsTemp:");
            passengerTemp = args[0]
        }

        onAmbientTempChanged:{
            //console.log("   onAmbientTempChanged:");
            ambientTemp = args[0]
        }

        onUpdateData:{
            //console.log("*****   onUpdateData ***** "+Qt.formatDateTime(new Date(), "hh:mm:ss.zzz"));
            driverTemp = args[0];
            passengerTemp = args[1];
            drModeDisp = args[2];
            psModeDisp = args[3];
            displayAUTO = args[4];
            displayAC = args[5];
            ionClean = args[6];
            datc_OpSts = args[7];
            mainBlower = args[8];
            tempUnit = args[9];
            variant_VentDATC = args[10];
/* CANDB_12_12 start*/
            variant_FRControl = args[11];
            variant_Temp = args[12];
            variant_Mode = args[13];
            variant_RearControl = args[14];
            variant_RHD = args[15];
            variant_EU = args[16];
/* CANDB_12_12 END*/
            dualDisp = args[17];
            co2Warning = args[18];
            diagMode = args[19];
            selfDiagDisp = args[20];
            rear_Offdisp = args[21];

            // SMART_VENT START
            smartVentDisp = args[22];
            smartVentStatus = args[23];
            // SMART_VENT END
            syncDisp = args[24];
            //AUTO_DEFOG
            autoDefSystemBlink = args[25];
            autoDefSystemDisp = args[26];
            autoDefSystemStatus = args[27];

            ambientTemp = args[28];
            //console.log("*****   onUpdateData qml ambientTemp:"+ambientTemp);

            countryVariant = uiListener.getVariant();
            //console.log("AppInfo AppFATC_main.qml countryVariant:"+countryVariant);
            if (countryVariant==1 || countryVariant==6) { //NA
                isNAorEU = true;
                isEU = false;
                isNA = true;
            }
            else if (countryVariant==5 || countryVariant==7) { //EU
                isNAorEU = true;
                isEU = true;
                isNA = false;
            }
            else {
                isNAorEU = false;
                isEU = false;
                isNA = false;
            }

            rearMonitor = uiListener.getRearMonitor();
            //console.log("AppInfo AppFATC_main.qml getRearMonitor:"+rearMonitor);

            setText();

            id_option_list.loadingVisable = false; //dmchoi
            id_option_list.checkBoxVisable = true;

            updateBGImageNo();
        }

    }
    onRear_OffdispChanged: {
        setText();
    }
    onAutoDefSystemBlinkChanged: {
        if( autoDefSystemBlink == 1)
            aniAutoDef.running=true
    }

    states: [
        State {
            name: "DATC_OFF"; when: datc_OpSts!=1 && diagMode==0 && bIGN_on==true && isNAorEU==false && smartVentDisp==0
            PropertyChanges { target: id_topButton_rect; visible: true }
            PropertyChanges { target: bg_driver; visible: false }
            PropertyChanges { target: tempDriver; visible: false }
            PropertyChanges { target: inter_Psitems; visible: false }
            PropertyChanges { target: idContainer_Auto; visible: false }
            PropertyChanges { target: text_ac; visible: false }
            PropertyChanges { target: id_bg_blower; visible: false }
            PropertyChanges { target: id_blower; visible: false }
            PropertyChanges { target: id_ico_wind; visible: false }
            PropertyChanges { target: id_img_off; visible: true }
            PropertyChanges { target: id_txt_off; visible: true }
            PropertyChanges { target: id_cleanAir; visible: false }
            PropertyChanges { target: bottom_warning_osd; visible: false }
            PropertyChanges { target: text_sync; visible: false }
            PropertyChanges { target:  ambientTemp_item; visible: true }    // off 시 외부온도 표시 - ISV 93466
            PropertyChanges { target:  bg_devider_1; visible: false }
            PropertyChanges { target:  bg_devider_2; visible: false }
            PropertyChanges { target:  bg_devider_3; visible: false }
            PropertyChanges { target:  bg_devider_4; visible: false }
            //Off시 ModeDisp 바람 화살표 이미지 Disable
            PropertyChanges { target:  idDrVent_wind; visible: true }
            PropertyChanges { target:  idDrFloor_wind; visible: true }
            PropertyChanges { target:  idRear_wind; visible: false }
            PropertyChanges { target:  idPsVent_wind; visible: true }
            PropertyChanges { target:  idPsFloor_wind; visible: true }
        },
        State {
            name: "DATC_OFF_SAMRT_VENT"; when: datc_OpSts!=1 && diagMode==0 && bIGN_on==true && isNAorEU==false && smartVentDisp!=0
            PropertyChanges { target: id_topButton_rect; visible: true }
            PropertyChanges { target: bg_driver; visible: false }
            PropertyChanges { target: tempDriver; visible: false }
            PropertyChanges { target: inter_Psitems; visible: false }
            PropertyChanges { target: idContainer_Auto; visible: false }
            PropertyChanges { target: text_ac; visible: false }
            PropertyChanges { target: id_bg_blower; visible: true }
            PropertyChanges { target: id_blower; visible: true }
            PropertyChanges { target: id_ico_wind; visible: true }
            PropertyChanges { target: id_img_off; visible: false }
            PropertyChanges { target: id_txt_off; visible: false }
            PropertyChanges { target: id_cleanAir; visible: true }
            PropertyChanges { target: bottom_warning_osd; visible: false }
            PropertyChanges { target: text_sync; visible: false }
            PropertyChanges { target:  ambientTemp_item; visible: true }    // off 시 외부온도 표시 - ISV 93466
            PropertyChanges { target:  bg_devider_1; visible: false }
            PropertyChanges { target:  bg_devider_2; visible: false }
            PropertyChanges { target:  bg_devider_3; visible: false }
            PropertyChanges { target:  bg_devider_4; visible: false }
            //Off시 ModeDisp 바람 화살표 이미지 Disable
            PropertyChanges { target:  idDrVent_wind; visible: true }
            PropertyChanges { target:  idDrFloor_wind; visible: true }
            PropertyChanges { target:  idRear_wind; visible: false }
            PropertyChanges { target:  idPsVent_wind; visible: true }
            PropertyChanges { target:  idPsFloor_wind; visible: true }
        },
        State {
            name: "DATC_OFF_NA_EU"; when: datc_OpSts!=1 && diagMode==0 && bIGN_on==true && isNAorEU==true
            PropertyChanges { target: id_topButton_rect; visible: true }
            PropertyChanges { target: bg_driver; visible: false }
            PropertyChanges { target: tempDriver; visible: false }
            PropertyChanges { target: inter_Psitems; visible: false }
            PropertyChanges { target: idContainer_Auto; visible: false }
            PropertyChanges { target: text_ac; visible: false }
            PropertyChanges { target: id_bg_blower; visible: false }
            PropertyChanges { target: id_blower; visible: false }
            PropertyChanges { target: id_ico_wind; visible: false }
            PropertyChanges { target: id_img_off; visible: true }
            PropertyChanges { target: id_txt_off; visible: true }
            PropertyChanges { target: id_cleanAir; visible: false }
            PropertyChanges { target: bottom_warning_osd; visible: false }
            PropertyChanges { target: text_sync; visible: false }
            PropertyChanges { target:  ambientTemp_item; visible: true }    // off 시 외부온도 표시 - ISV 93466
            PropertyChanges { target:  bg_devider_1; visible: false }
            PropertyChanges { target:  bg_devider_2; visible: false }
            PropertyChanges { target:  bg_devider_3; visible: false }
            PropertyChanges { target:  bg_devider_4; visible: false }
            //Off시 ModeDisp 바람 화살표 이미지 Disable
            PropertyChanges { target:  idDrVent_wind; visible: false }
            PropertyChanges { target:  idDrFloor_wind; visible: false }
            PropertyChanges { target:  idRear_wind; visible: false }
            PropertyChanges { target:  idPsVent_wind; visible: false }
            PropertyChanges { target:  idPsFloor_wind; visible: false }
        },
        State {
            name: "DATC_NORMAL"; when: (datc_OpSts == 1) && (diagMode==0) &&bIGN_on==true
            PropertyChanges { target: id_topButton_rect; visible: true }
            PropertyChanges { target: bg_driver; visible: true }
            //PropertyChanges { target: text_driver; visible: true }
            PropertyChanges { target: tempDriver; visible: true }
            PropertyChanges { target: inter_Psitems; visible: true }
            PropertyChanges { target: idContainer_Auto; visible: true }
            PropertyChanges { target: text_ac; visible: true }
            PropertyChanges { target: id_bg_blower; visible: true }
            PropertyChanges { target: id_ico_wind; visible: true }
            PropertyChanges { target: id_blower; visible: true }
            PropertyChanges { target: driver_mode; visible: true }
            PropertyChanges { target: passenger_mode; visible: true }
            PropertyChanges { target: id_img_off; visible: false }
            PropertyChanges { target: id_txt_off; visible: false }
            PropertyChanges { target: id_cleanAir; visible: true }
            PropertyChanges { target: bottom_warning_osd; visible: true }
            //PropertyChanges { target: text_dual; visible: true }
            PropertyChanges { target: text_sync; visible: true }
            PropertyChanges { target:  ambientTemp_item; visible: true }
            PropertyChanges { target:  bg_devider_1; visible: true }
            PropertyChanges { target:  bg_devider_2; visible: true }
            PropertyChanges { target:  bg_devider_3; visible: true }
            PropertyChanges { target:  bg_devider_4; visible: true }
        },
        State {
            name: "DIAG_ON"; when: ( diagMode == 1 &&bIGN_on==true)
            PropertyChanges { target: diagDisp; visible: true }
            PropertyChanges { target: driver_mode; visible: false }
            PropertyChanges { target: passenger_mode; visible: false }
            PropertyChanges { target: id_topButton_rect; visible: false }
            PropertyChanges { target: bg_driver; visible: false }
            //PropertyChanges { target: text_driver; visible: false }
            PropertyChanges { target: tempDriver; visible: false }
            PropertyChanges { target: inter_Psitems; visible: false }
            PropertyChanges { target: idContainer_Auto; visible: false }
            PropertyChanges { target: text_ac; visible: false }
            PropertyChanges { target: id_bg_blower; visible: false }
            PropertyChanges { target: id_blower; visible: false }
            PropertyChanges { target: id_ico_wind; visible: false }
            PropertyChanges { target: id_img_off; visible: false }
            PropertyChanges { target: id_txt_off; visible: false }
            PropertyChanges { target: id_cleanAir; visible: false }
            PropertyChanges { target: bottom_warning_osd; visible: false }
            //PropertyChanges { target: text_dual; visible: false }
            PropertyChanges { target: text_sync; visible: false }
            PropertyChanges { target:  ambientTemp_item; visible: false }
            PropertyChanges { target:  bg_devider_1; visible: true }
            PropertyChanges { target:  bg_devider_2; visible: true }
            PropertyChanges { target:  bg_devider_3; visible: true }
            PropertyChanges { target:  bg_devider_4; visible: true }
        },
        State {
            name: "IGN_OFF"; when: ( bIGN_on == false )
            PropertyChanges { target: diagDisp; visible: false }
            PropertyChanges { target: driver_mode; visible: false }
            PropertyChanges { target: passenger_mode; visible: false }
            PropertyChanges { target: id_topButton_rect; visible: true }
            PropertyChanges { target: bg_driver; visible: false }
            //PropertyChanges { target: text_driver; visible: false }
            PropertyChanges { target: tempDriver; visible: false }
            PropertyChanges { target: inter_Psitems; visible: false }
            PropertyChanges { target: idContainer_Auto; visible: false }
            PropertyChanges { target: text_ac; visible: false }
            PropertyChanges { target: id_bg_blower; visible: false }
            PropertyChanges { target: id_ico_wind; visible: false }
            PropertyChanges { target: id_blower; visible: false }
            PropertyChanges { target: id_img_off; visible: false }
            PropertyChanges { target: id_txt_off; visible: false }
            PropertyChanges { target: id_cleanAir; visible: false }
            PropertyChanges { target: bottom_warning_osd; visible: false }
            //PropertyChanges { target: text_dual; visible: false }
            PropertyChanges { target: text_sync; visible: false }
            PropertyChanges { target:  ambientTemp_item; visible: false }
            PropertyChanges { target:  bg_devider_1; visible: true }
            PropertyChanges { target:  bg_devider_2; visible: true }
            PropertyChanges { target:  bg_devider_3; visible: true }
            PropertyChanges { target:  bg_devider_4; visible: true }
        }
    ]

    // Def. of Text Color 
    property color colorWhite:          Qt.rgba(255,255,255,1)
    property color colorBlack:          Qt.rgba(0,0,0,1)
    property color colorBrightGrey:     Qt.rgba(250/255,250/255,250/255,1)
    property color colorSubTextGrey:    Qt.rgba(212/255,212/255,212/255,1)
    property color colorGrey:           Qt.rgba(193/255,193/255,193/255,1)
    property color colorDimmedGrey:     Qt.rgba(158/255,158/255,158/255,1)
    property color colorDisableGrey:    Qt.rgba(91/255,91/255,91/255,1)
    property color colorFocusGrey:      Qt.rgba(72/255,72/255,72/255,1)
    property color colorButtonGrey:     Qt.rgba(47/255,47/255,47/255,1)
    property color colorProgressBlue:   Qt.rgba(0/255,135/255,239/255,1)
    property color colorDimmedBlue:     Qt.rgba(68/255,124/255,173/255,1)
    property color colorIndicatorOn:    Qt.rgba(124/255,189/255,255/255,1)
    property string transparent:        "transparent"
    property bool optionmenuVisible: false
    property string optionMenu_text: ""
    property bool focusVisible: true

Item{
    Image {
        id: background
        height: 627
        width: 1280
        y:93
        x:0
        z:5
        source: imgFolderClimate + "bg_interior_rear_no.png"; //default
        MouseArea{
            anchors.fill: parent
            beepEnabled: false
            onReleased: {
                //console.log("background : focusVisible = false");
                focusVisible=true
                //console.log("focusVisible=false");
                //id_topButton_f.visible=false

                if (idbg_option_menu.visible) {
                    optionMenuDisable()
                }

            }
        }//MouseArea
    }//background

}//Item

FocusScope{
    Rectangle{
        id:id_topButton_rect
//        x: /*countryVariant != 4 */langID != 20 ? CONST.topButton_RECT_X : CONST.topButton_reverse_RECT_X
//        y: /*countryVariant != 4*/langID != 20 ? CONST.topButton_RECT_Y : CONST.topButton_reverse_RECT_Y
            //dmchoi
            x: {
                if (langID != 20) {
                    1068
                } else {
                    24
                }
            }
        y:623
        width: 188
        height: 97
        color: "transparent"
        focus: true

        Image {
            id: id_topButton_n
            x:0
            y:0
            width: 188
            height: 97
            source:  imgFolderGeneral +  "btn_bottom_menu_n.png"
            visible: true
            onVisibleChanged: {
                if(focusVisible==true)
                    id_topButton_f.visible=true
                else if(focusVisible==false)
                    id_topButton_f.visible=false
            }
        }//id_topButton_n

        Image {
            id: id_topButton_fp
            x:0
            y:0
            width: id_topButton_n.width
            height: id_topButton_n.height
            source: imgFolderGeneral +  "btn_bottom_menu_p.png"
            visible: false
        }//id_topButton_fp
        Image {
            id: id_topButton_f
            x:0
            y:0
            width: id_topButton_n.width
            height: id_topButton_n.height
            source: imgFolderGeneral +  "btn_bottom_menu_f.png"
            visible: true
        }//id_topButton_f
        Image {
            id: id_topButton_p
            x:0
            y:0
            width: id_topButton_n.width
            height: id_topButton_n.height
            source:  imgFolderGeneral + "btn_bottom_menu_p.png"
            visible: false
        }//id_topButton_p
        Text {
            anchors.fill: parent
            x: anchors.left+20
            y: anchors.top
            width: 147 //103
            height: 49*2
            id: id_topButton_text
            font.pointSize:  40

            font.family:fontFamily
            color: colorBrightGrey
            anchors.horizontalCenter: id_topButton_rect.horizontalCenter
            anchors.verticalCenter: id_topButton_rect.verticalCenter
            horizontalAlignment: "AlignHCenter"
            verticalAlignment:"AlignVCenter"
            text: menu_text
            visible: true
        }//id_topButton_text

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onPressed: {
                //console.log("onPressed id_topButton_text : focusVisible = false");
                //focusVisible=false
                //id_topButton_f.visible=false
                id_topButton_p.visible=true
            }
            onReleased: {
                if((mouse.x>=0&&mouse.x<188)&&(mouse.y>=0&&mouse.y<97)){ //121*74
                    //console.log("onReleased valid release");
                    id_topButton_p.visible=false
                    idClimateAppMain.optionMenuEnable()
                }
                else{
                    //console.log("onReleased invalid release X : "+mouse.x + " Y: "+mouse.y);
                    id_topButton_p.visible=false
                }
            }
            onCanceled: {
                //console.log("onCanceled x: "+ mouse.x + " y: " + mouse.y)
            }
            onExited: {
                //console.log("onExited ")
            }


        }//MouseArea

        Keys.onPressed:{
            switch( event.key )
            {
                case Qt.Key_Enter :
                case Qt.Key_Return:
                case Qt.Key_I:
                {
                    focusVisible=true;
                    //console.log("keys.onPressed in HVAC");
                    id_topButton_f.visible=true
                    id_topButton_p.visible=true
                    event.accepted=true;
                    //uiListener.playAudioBeep();
                }break;
                case Qt.Key_Left :
                case Qt.Key_Right :
                case Qt.Key_Up :
                case Qt.Key_Down :
                case Qt.Key_Minus:
                case Qt.Key_Equal:
                {
                    event.accepted=true;
                }break;
            case Qt.Key_Backspace:
            {
                //console.log("DATC handlebackkey!!!!")
                uiListener.handleBackKey();
                event.accepted=true;
                //uiListener.playAudioBeep();
                break;
            }


            }
        }//onPressed
        Keys.onReleased:{
            switch( event.key )
            {
                case Qt.Key_Enter :
                case Qt.Key_Return:
                case Qt.Key_I:
                {
                    if( event.modifiers == Qt.ShiftModifier){  // SANGWOO_TEMP

                        if(focusVisible==true){
                            id_topButton_p.visible=false
                        }
                        event.accepted=true;

                    }else{
                        if(focusVisible==true){
                            id_topButton_p.visible=false
                        }
                        event.accepted=true;
                        idClimateAppMain.optionMenuEnable()
                    }



                }break;
                case Qt.Key_Left :
                case Qt.Key_Right :
                case Qt.Key_Up :
                case Qt.Key_Down :
                case Qt.Key_Minus:
                case Qt.Key_Equal:
                {
                    focusVisible=true;
                    //console.log("keys.onReleased in HVAC");
                    id_topButton_f.visible=true;
                    event.accepted=true;
                }break;

            }
        }//onReleased

    }//id_topButton_rect

} // id:bkFocusScope

property int tempfc: 0

Item {
    id:ambientTemp_item
    width: parent.width

    Text {
        id: ambientTempStr
//        x: 935+159+10
        anchors.right: parent.right
        anchors.rightMargin: 26
        y:95
//        width: 150
        height: 48*2
        font.pointSize: 40
        font.family: fontFamily
        color: colorBrightGrey
        horizontalAlignment: "AlignRight"
        verticalAlignment:"AlignVCenter"
        text:ambientTemp
        visible : {
            if (ambientTemp == "false" || ambientTemp.length < 1) {
                false
            }
            else {
                true
            }
        }

    }

    Text {
        id: ambientTempTitle
//        x:935
        anchors.right: ambientTempStr.left
        anchors.rightMargin: 20
        y:95
//        width: 159
        height: 48*2
        font.pointSize: 32
        font.family: fontFamily
        color: colorDimmedGrey
        horizontalAlignment: "AlignRight"
        verticalAlignment:"AlignVCenter"
        text: outside
        visible : {
            if (ambientTemp == "false" || ambientTemp.length < 1) {
                false
            }
            else {
                true
            }
        }

    }

}

Item {
    id:driver_mode
    Image{ // Defog Icon
        id:idDefog
        source: imgFolderClimate +  "ico_defog.png"
        x: /*countryVariant != 4*/langID != 20 ? CONST.icon_DEF_X : CONST.icon_DEF_reverse_X
        y: /*countryVariant != 4*/langID != 20 ? CONST.icon_DEF_Y : CONST.icon_DEF_reverse_Y
        visible: if( drModeDisp==4 || drModeDisp==5 || psModeDisp==4|| psModeDisp==5)
                        true
                    else
                        false
    }//idDefog
    Image{ // Auto Defog Icon
        id:idDefogAuto
        source: imgFolderClimate +  "ico_ads_l.png"
        x:/*countryVariant != 4*/langID != 20 ? CONST.icon_DEF_X : CONST.icon_DEF_reverse_X
        y:/*countryVariant != 4*/langID != 20 ? CONST.icon_DEF_Y : CONST.icon_DEF_reverse_Y
        visible:if(drModeDisp==6|| psModeDisp==0x06) true
                    else false
        SequentialAnimation{
            id:aniAutoDef
                  //  running: autoDefSystemBlink == 1 ? true : false
//                        if(drModeDisp== 0x06|| psModeDisp==0x06){
//                            true
//                        } else {
//                            false
//                        }

                    NumberAnimation{ target: idDefogAuto; property: "opacity"; to: 0.0; duration: 300}
                    NumberAnimation{ target: idDefogAuto; property: "opacity"; to: 1.0; duration: 300}
                    NumberAnimation{ target: idDefogAuto; property: "opacity"; to: 0.0; duration: 300}
                    NumberAnimation{ target: idDefogAuto; property: "opacity"; to: 1.0; duration: 300}
                    NumberAnimation{ target: idDefogAuto; property: "opacity"; to: 0.0; duration: 300}
                    NumberAnimation{ target: idDefogAuto; property: "opacity"; to: 1.0; duration: 300}
                }//aniAutoDef
    }//idDefogAuto

    //Driver
    Item {
        id: idDriver
        Image {
            id:idDrVent_wind
            x:
                    if(variant_RHD == 0){        // LHD Left Handle Drive
                        CONST.LHD_left_VENT_X // 114
                    }else{
                        CONST.RHD_right_VENT_X //386 //342 RHD
                    }
            y:
                    if(variant_RHD == 0){        // LHD
                        CONST.LHD_left_VENT_Y //224+78+136
                    }else{
                        CONST.RHD_right_VENT_Y //224 // RHD
                    }
            source: imgFolderClimate +  "arrow_01.png"
            visible:
                if (isNAorEU&&displayAUTO==1) {
                    false
                }
                else if (drModeDisp==0x01||drModeDisp==0x02){
                    true
                } else //if(drModeDisp==0||drModeDisp>2){
                    false
                //}

        }//idDrVent_wind
        Image{
            source: idDrVent_wind.source
            x:
                if(variant_RHD == 0)
                   idDrVent_wind.x + CONST.LHD_left_VENT_X_margin
                else
                    idDrVent_wind.x + CONST.RHD_right_VENT_X_margin
            y:
                if(variant_RHD == 0)
                    idDrVent_wind.y + CONST.LHD_left_VENT_Y_margin
            else
                    idDrVent_wind.y + CONST.RHD_right_VENT_Y_margin
            visible:idDrVent_wind.visible
        }
        Image{
            id:idDrFloor_wind
            x:
                    if(variant_RHD == 0){        // LHD Left Handle Drive
                        CONST.LHD_left_FLOOR_X //114+49
                    }else{
                        CONST.RHD_right_FLOOR_X //405
                    } //114+49+223 //342 RHD
            y:
                    if(variant_RHD == 0){        // LHD
                        CONST.LHD_left_FLOOR_Y //224+78+136+69
                    }else{
                        CONST.RHD_right_FLOOR_Y //224+78
                    }//RHD
            source: (isDHPEOnly)? imgFolderClimateDHPE + "arrow_04.png": imgFolderClimate + "arrow_04.png"
            visible:
                if(isNAorEU&&displayAUTO==1) {
                    false
                }
                else if(drModeDisp>1&&drModeDisp<5){
                    true
                } else //if(drModeDisp<2||drModeDisp==5||drModeDisp==6) {
                    false
                //}

        }//idDrFloor_wind

        Image{
            id:idRear_wind
            x: CONST.rear_X
            y: CONST.rear_Y
            source: (isDHPEOnly)? imgFolderClimateDHPE + "arrow_06.png" : imgFolderClimate +  "arrow_05.png"
            visible:
                if(isNAorEU&&displayAUTO==1)
                    false
                else if(rear_Offdisp==0x1 && variant_Mode!=0x0){
                    true
//                } else if(rear_Offdisp==0x2 || rear_Offdisp == 0x0) {
//                    false
                } else false

        }//idRear_wind

    }//idDriver
} //driver_mode
//Passenger
Item {
    id: passenger_mode
    Image {
        id:idPsVent_wind
        x:
//            if(variant_Mode >= 1){    // Dual
                if(variant_RHD == 0 ){        // LHD Left Handle Drive
                    CONST.LHD_right_VENT_X //114+49+223
                }else{
                    CONST.RHD_left_VENT_X //114 // RHD
                }
//            }else{ //single
//                -300 //invisible
//            }

        y:
//            if(variant_Mode >= 1){    // Dual
                if(variant_RHD == 0){        // LHD
                    CONST.LHD_right_VENT_Y //224
                }else{
                    CONST.RHD_left_VENT_Y //224+78+136 //RHD
                }
//            }else { //single
//                -300
//            }

        source: (isDHPEOnly)? imgFolderClimateDHPE + "arrow_03.png": imgFolderClimate + "arrow_03.png"
        visible:
            if(variant_Mode >= 1){ // Dual
                if(isNAorEU&&displayAUTO==1) {
                    false
                }
                else if(psModeDisp==0x01||psModeDisp==0x02){
                    true
                } else// if(psModeDisp==0||psModeDisp>2&&psModeDisp<7){
                    false
                //}
            }else{
                //Single clone driver mode
                idDrVent_wind.visible
            }
    }//idPsVent_wind
    Image{
        source: (isDHPEOnly)? imgFolderClimateDHPE + "arrow_02.png": imgFolderClimate + "arrow_02.png"
        visible:idPsVent_wind.visible
        x:
            if(variant_RHD == 0)
               idPsVent_wind.x + CONST.LHD_right_VENT_X_margin + 5
            else
                idPsVent_wind.x + CONST.RHD_left_VENT_X_margin
        y:
            if(variant_RHD == 0)
                idPsVent_wind.y + CONST.LHD_right_VENT_Y_margin - 16
        else
                idPsVent_wind.y + CONST.RHD_left_VENT_Y_margin
    }
    Image{
        id:idPsFloor_wind
        x:
//            if(variant_Mode >= 1){    // Dual
                if(variant_RHD == 0){        // LHD Left Handle Drive
                    (isDHPEOnly)? CONST.LHD_right_FLOOR_X + 2 : CONST.LHD_right_FLOOR_X + 11 //114+49+223+19
                }else{
                    CONST.RHD_left_FLOOR_X //113+49
                } //114+49+223 //342 RHD
//            }else { // single
//                -500 //invisible
//            }
        y:
//            if(variant_Mode >= 1){    // Dual
                if(variant_RHD == 0 ){        // LHD
                    (isDHPEOnly)? CONST.LHD_right_FLOOR_Y : CONST.LHD_right_FLOOR_Y - 1//224+78
                }else{
                    CONST.RHD_left_FLOOR_Y //224+78+136+69 //RHD
                }
//            }else { // single
//                -500 //invisible
//            }

        source: (isDHPEOnly)? imgFolderClimateDHPE + "arrow_05.png": imgFolderClimate + "arrow_04.png"
        visible:
            if(variant_Mode >= 1){ // Dual
                if (isNAorEU&&displayAUTO==1) {
                    false
                }
                else if (psModeDisp>1&&psModeDisp<5){
                    true
                } else// if(psModeDisp==0 || psModeDisp==1|| psModeDisp==5|| psModeDisp==6) {
                    false
                //}
            }else{
                //Single clone Driver mode
               idDrFloor_wind.visible
            }
    }//idPsFloor_wind
}//passenger_mode

// driver 표기
Item { // Driver Temp
    id: inter_items
    Rectangle {
        x: if(variant_Temp >= 1){ //DATC
               if(variant_RHD == 0)    // LHD
                   CONST.left_BOX_X //405 // LHD
                else
                   CONST.right_BOX_X //405 + 249 // RHD
           }else { //FATC
               CONST.single_BOX_X //602
           }
        y: if(variant_Temp >= 1){ // DATC
               if(variant_RHD == 0)    // LHD
                    CONST.left_BOX_Y //167+272 //LHD
               else
                   CONST.right_BOX_Y //167 // RHD
           }else { //FATC
            CONST.single_BOX_Y //321
           }

        id: bg_driver
//        source: imgFolderClimate + "bg_seat_info.png"
        visible:true
        width: CONST.left_BOX_TEXT_WIDTH
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -26
            width: CONST.left_BOX_TEXT_WIDTH
            height: 31*2
            id: text_driver
            font.pointSize: 32
            font.family: fontFamily
            color: colorDimmedGrey
            horizontalAlignment: "AlignHCenter"
            verticalAlignment:"AlignVCenter"

            text: driver1
            visible:variant_Temp == 0 ? false : true

        }//text_driver
        Text { // Driver Temp
            id: tempDriver

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: variant_Temp == 0 ? 0 : 22
            width:  CONST.left_BOX_TEXT_WIDTH
            height: parent.height/*if(variant_Temp == 0) //FATC
                            47*2
                        else
                            47*2*/

            font.pointSize: 40
            font.family: fontFamily
            color: colorBrightGrey
            horizontalAlignment: "AlignHCenter"
            verticalAlignment:"AlignVCenter"
            text:driverTemp
            visible: true

        }//tempDriver

    }//bg_driver
    Text {
        id: diagDisp
            anchors.left: bg_driver.left
            anchors.leftMargin: 13 + 38
            anchors.verticalCenter: bg_driver.verticalCenter
        font.pointSize: 50
        font.family: fontFamily
        color: "white"
        text: {
            if(selfDiagDisp > 0 && selfDiagDisp < 101){
                if(selfDiagDisp<11){
                    "0"+(selfDiagDisp-1)
                    //qsTr("0"+(canDB.SelfDiagDisp-1))
                }else {
                    selfDiagDisp-1
                }
            } else if (selfDiagDisp==0){
                ""
            }
        }
        visible: false
    }//diagDisp

}//inter_items
// passenger 표기
Item { // Passenger Temp
    id: inter_Psitems
    Rectangle {
        x: if(variant_Temp >= 1){ //DATC
               if(variant_RHD == 0)
                   CONST.right_BOX_X //405+249 //LHD
               else
                   CONST.left_BOX_X //405 //RHD
           }else { //FATC
                   -500 // invisible point
               }

          y: if(variant_Temp >= 1){ //DATC
                 if(variant_RHD ==0)
                    CONST.right_BOX_Y //167 //LHD
                 else
                    CONST.left_BOX_Y //167+272 //RHD
            }else {
                       -500 // invisible point
           }
        width:CONST.left_BOX_TEXT_WIDTH
        id: bg_passenger
//        source: imgFolderClimate + "bg_seat_info.png"
        visible:
               if(variant_Temp == 0){ //FATC
                   false
               } else {
                   true
               }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -26
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 32
            font.family: fontFamily
            color: colorDimmedGrey
            text:passenger1
            visible:
                if(variant_Temp == 0){ //FATC
                    false
                } else {
                    true
                }
        }
        Text { // Passenger Temp
            id: tempPassenger
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 22

            width:  CONST.left_BOX_TEXT_WIDTH
            height: if((variant_Temp == 0)) //FATC
                            58*2
                        else
                            32*2
            font.pointSize: 40
            font.family: fontFamily
            color: colorBrightGrey
            horizontalAlignment: "AlignHCenter"
            verticalAlignment:"AlignVCenter"
            text:passengerTemp
            visible:
                if(variant_Temp == 0){ //FATC
                    false
                } else {
                    true
                }
        }//tempPassenger
    }
}

Item {
    id :indicator
    Image {
            //x: 24 // 121
            //dmchoi
            x: {
                if (langID != 20) {
                    24
                } else {
                    217
                }
            }
        y: 623
        id: bg_bottom
        visible: true
        width: 1038
        height: 97
        source: imgFolderClimate + "bg_bottom.png"
        Item{ // AUTO
            id:idContainer_Auto
            anchors.fill: parent
            Text {
                id: text_auto
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 56 - bg_bottom_left_margine //153 - 121
//                x: 153
//                y: 642+9+1
                width:  146
                //height:  20*2
                font.pointSize: 40
                font.family: fontFamily
                color:
                    if(displayAUTO == 0){
                        "transparent"
                    }else if(displayAUTO == 1){
                        colorIndicatorOn
                    }
                horizontalAlignment: "AlignHCenter"
                //verticalAlignment:"AlignVCenter"
                text: "AUTO"
                visible:true
            }//text_auto
        }//idContainer_Auto
        Image {
            anchors.top: parent.top
            anchors.left:parent.left
            anchors.leftMargin: 228-bg_bottom_left_margine
//            x: 325
//            y: 623
            id: bg_devider_1
            visible: true
            height: 97
            source: imgFolderClimate + "line_devider.png"
        }
        Item{ // A/C
            anchors.fill: parent
            Text {
//                x: 153+146+43
//                y: 642+9+1
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 56 - bg_bottom_left_margine + 146 + 43//153 - 121 + 146 + 43
                width: 137
//                height: 18*2
                id: text_ac
                font.pointSize: 40
                font.family: fontFamily
                color:
                    if (isNA&&displayAUTO==1) {
                        "transparent"
                    }
                    else if( displayAC == 0 ){
                        "transparent"
                    } else if( displayAC == 1){
                        colorIndicatorOn
                    }
                    else "transparent"

                horizontalAlignment: "AlignHCenter"
                verticalAlignment:"AlignVCenter"
                text: "A/C"
                visible:true
            }//text_ac
        }//Item
        Image {
//            x: 325+170
//            y: 623
            anchors.top: parent.top
            anchors.left: bg_devider_1.left
            anchors.leftMargin: 170
            id: bg_devider_2
            visible: true
            height: 97
            source: imgFolderClimate + "line_devider.png"
        }
        Image {
            anchors.top: parent.top
            anchors.left: bg_devider_2.left
            anchors.leftMargin: 288
//            x: 325+170+288
//            y: 623
            id: bg_devider_3
            visible: true
            height: 97
            source: imgFolderClimate + "line_devider.png"
        }
        Text {
//            x: 153+146+43+137+56+53+153+63
//            y: 642+9+1
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 56 - bg_bottom_left_margine + 146 + 43 + 137 + 56 + 53 + 153 + 63
            width: 147
//            height: 20*2
            id: text_dual
            font.pointSize:40
            font.family: fontFamily
            color:
                if(dualDisp==1){
                    colorIndicatorOn
                }else if(dualDisp==0){
                    "transparent"//colorDisableGrey
                }
            horizontalAlignment: "AlignHCenter"
            verticalAlignment:"AlignVCenter"
            text: "DUAL"
            visible:false//true
        }//text_dual
        Image {
//            x: 325+170+288+187
//            y: 623
            anchors.top: parent.top
            anchors.left: bg_devider_3.left
            anchors.leftMargin: 187
            id: bg_devider_4
            visible: true
            height: 97
            source: imgFolderClimate + "line_devider.png"
        }
    }//bg_bottom

}//indicator

// 바람 세기 표기
Item {
    id: idcontainer_bottom_bar
    Item {
//        visible:(countryVariant == 1 || countryVariant == 5)&& displayAUTO == 1 ? false  : true //!(displayAUTO.visible)
        visible: (isNAorEU&&displayAUTO==1) ? false : true
        Image {
                //dmchoi
                // x: 56+146+43+137+56//153+146+43+137+56
                x: {
                    if (langID != 20) {
                        56+146+43+137+56//153+146+43+137+56
                    } else {
                        193 + 56+146+43+137+56 //153+146+43+137+56
                    }
                }
            y: 642+9
            id: id_ico_wind
            source: imgFolderClimate + "ico_wind.png"
            visible:true
        }//id_ico_wind
        Image {
                //dmchoi
                // x: 56+146+43+137+56+53
                x: {
                    if (langID != 20) {
                        56+146+43+137+56+53
                    } else {
                        193 + 56+146+43+137+56+53
                    }
                }
            y: 642+9+1+17+3
            id: id_bg_blower
            width:153
            //source: if()
            source: imgFolderClimate +  "bg_wind_level_bottom.png" // 0x1 not used
            visible:true
        } //id_bg_blower
        Image {
                //dmchoi
                // x: 56+146+43+137+56+53
                x: {
                    if (langID != 20) {
                        56+146+43+137+56+53
                    } else {
                        193 + 56+146+43+137+56+53
                    }
                }
            y: 642+9+1+17+3
            id: id_blower
            width:153
            //source: if()
            source: {
                if(mainBlower == 0 ) imgFolderClimate +  "bg_wind_level_bottom.png" // 0x1 not used
                    else if( mainBlower  == 2) imgFolderClimate + "wind_level_cool_1.png"
                    else if( mainBlower  == 3) imgFolderClimate + "wind_level_cool_2.png"
                    else if( mainBlower  == 4) imgFolderClimate + "wind_level_cool_3.png"
                    else if( mainBlower  == 5) imgFolderClimate + "wind_level_cool_4.png"
                    else if( mainBlower  == 6) imgFolderClimate + "wind_level_cool_5.png"
                    else if( mainBlower  == 7) imgFolderClimate + "wind_level_cool_6.png"
                    else if( mainBlower  == 8) imgFolderClimate + "wind_level_cool_7.png"
                    else if( mainBlower  == 9) imgFolderClimate + "wind_level_cool_8.png"
            }
                visible:true
         }//id_blower

        Item {
            id: rect_text_off
            width:  id_img_off.width + 7 + id_txt_off.width
            parent: bg_bottom
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
                anchors.left: /*countryVariant != 4*/langID != 20 ? parent.left : id_txt_off.right
                anchors.leftMargin: /*countryVariant != 4*/langID != 20 ? 0 : 7
                anchors.verticalCenter: parent.verticalCenter
                id: id_img_off
                visible:false
                height: 61
                source: imgFolderClimate + "ico_wind.png"
            }

            Text {
                id: id_txt_off
                anchors.left: /*countryVariant != 4*/langID != 20 ? id_img_off.right : parent.left
                anchors.leftMargin:  /*countryVariant != 4*/langID != 20 ? 7 : 0
                anchors.verticalCenter: parent.verticalCenter
                height:40
                font.pointSize: 40
                font.family: fontFamily
                color: colorBrightGrey
                text:"OFF"
                horizontalAlignment: "AlignHCenter"
                verticalAlignment:"AlignVCenter"
                visible:
//                    if( datc_OpSts==0x0||datc_OpSts==0x2){
//                        true
//                    }else if(datc_OpSts==0x1){
//                        false
//                    }
                    false

            }//id_txt_off
        }//rect_text_off
        // clean air
        Text {
                //dmchoi
                // x: 56+146+43+137+56+53
                x: {
                    if (langID != 20) {
                        56+146+43+137+56+53
                    } else {
                        193 + 56+146+43+137+56+53
                    }
                }
            y: 642
            id: id_cleanAir
            width:153
            height:17
            font.pointSize: 24
            font.family: fontFamily
            color: colorGrey
            horizontalAlignment: "AlignLeft"
            text: {
                if( smartVentDisp == 1|| smartVentDisp == 2)
                {
                    "SMART VENT"
                }
                else if (autoDefSystemStatus==0) {
                    "ADS OFF"
                }
                else {
                    ""
                }
            }
            visible:true
        }//Text
    }//Item
}//idcontainer_bottom_bar

Item{  // Co2 warning
    Image {
            //dmchoi
            // x: 56+146+43+137+56+53+153+63+147+57
            x: {
                if (langID != 20) {
                    56+146+43+137+56+53+153+63+147+57
                } else {
                    193 + 56+146+43+137+56+53+153+63+147+57
                }
            }
        y: 642
        id: bottom_warning_osd
        visible:true
        source:
            if(co2Warning==0 && smartVentDisp !=2){
                ""//imgFolderClimate + "ico_co2_off.png"
            }else if( co2Warning==1 || smartVentDisp ==2) {
                imgFolderClimate + "ico_co2_on.png"
            }
    }//bottom_warning_osd

}//Item

// DUAL 표기


// SYNC 표기
Text {
        //dmchoi
        // x: 56+146+43+137+56+53+153+63
    x: {
        if (langID != 20) {
            56+146+43+137+56+53+153+63
        } else {
            193 + 56+146+43+137+56+53+153+63
        }
    }
    y: 642+9+1
    width: 147
    height: 20*2
    id: text_sync
    font.pointSize:40
    font.family: fontFamily
    color:
        if (isNAorEU&&displayAUTO==1) {
            "transparent"
        }
        else if (syncDisp==1) {
            colorIndicatorOn
        } else //if(syncDisp== 2 || syncDisp == 0){
            "transparent"//colorDisableGrey
        //}
    horizontalAlignment: "AlignHCenter"
    verticalAlignment:"AlignVCenter"
    text: "SYNC"
    visible: true
}//text_sync

function optionMenuEnable(){
    //console.log("optionMenuEnable: started")
    uiListener.autoTest_athenaSendObject();
    id_topButton_rect.visible=false
    id_topButton_n.visible=false
    id_topButton_text.visible=false

    setText()
    idbg_option_dim.visible=true
    idbg_option_menu.visible=true

    id_option_menu_open.running=true    // menu open ani start

    if(focusVisible==true) {
        id_option_list.focus_visible=true;
    }
    else {
        id_option_list.focus_visible=false;
    }
    id_option_list.forceActiveFocus()
    console.log("==> optionMenuEnable(),  id_option_list.forceActiveFocus()");
    id_option_list.currentIndex = (rear_Offdisp==0x0)? 1 : 0;
    id_option_list.focus_index = (rear_Offdisp==0x0)? 1 : 0;

    id_TimerOptionMenu.start()

}//optionMenuEnable

function optionMenuDisable(){
    //console.log("optionMenuDisable: started")

    id_option_list.loadingVisable = false; //dmchoi

    uiListener.autoTest_athenaSendObject();

    id_TimerOptionMenu.stop()
    idbg_option_dim.visible=false
    //idbg_option_menu.visible=false
    id_option_menu_close.running=true
    id_topButton_rect.visible=true
    id_topButton_n.visible=true
    id_topButton_text.visible=true
    id_topButton_rect.focus=true
    id_topButton_rect.forceActiveFocus()
    console.log("==> optionMenuDisable(),  id_topButton_rect.forceActiveFocus()");
}//optionMenuDisable

function optionMenuDisableForHelpPage() {
    id_option_list.loadingVisable = false;

    uiListener.autoTest_athenaSendObject();

    id_TimerOptionMenu.stop()
    idbg_option_dim.visible=false
    id_option_menu_close.running=true
    id_topButton_rect.visible=true
    id_topButton_n.visible=true
    id_topButton_text.visible=true
}

function reqRearOnOff(){
    console.log("reqRearOnOff: started")
    if(rear_Offdisp==0x1)
    {
        console.log("reqRearOnOff:  OFF")
        canMethod.cQCANController_sendReqRearOnOff(0) //rear off
    }
    else
    {
        console.log("reqRearOnOff:  ON")
        canMethod.cQCANController_sendReqRearOnOff(1) // rear on
    }
   setText()
}//reqRearOnOff

function reqSmartVentOnOff()
{
    console.log("reqSmartVentOnOff: started")
    if(smartVentStatus==0x1)
    {
        console.log("reqSmartVentOnOff:  OFF")
        canMethod.cQCANController_sendReqSmartVentOnOffSet(0) //rear off
    }
    else
    {
        console.log("reqSmartVentOnOff:  ON")
        canMethod.cQCANController_sendReqSmartVentOnOffSet(1)
    }
   setText()
}

function reqADSOnOFF()
{
    if(autoDefSystemStatus == 0x0)
        canMethod.cQCANController_sendReqADSOnOffSet(1)
    else
        canMethod.cQCANController_sendReqADSOnOffSet(0)
    setText()
}

function setText(){
    //console.log("id_option_menu_txt->setText: started    "+ rear_Offdisp)
    driver1       = qsTranslate("NonAV", "STR_HVAC_strDriver")
    rear1         = qsTranslate("NonAV", "REAR")
    passenger1    = qsTranslate("NonAV", "STR_HVAC_strPassenger")
    if (isDHPEOnly) {
        menu_text = qsTranslate("NonAV", "STR_HVAC_strMENUDHPE")
    }
    else {
        menu_text = qsTranslate("NonAV", "STR_HVAC_strMENU")
    }

    option_menu_smartVent  = qsTranslate("NonAV", "STR_HVAC_strSmartVent")
    option_menu_ads = qsTranslate("NonAV", "STR_HVAC_strADS")
    option_menu_string = qsTranslate("NonAV", "STR_HVAC_strRear")
    option_menu_help = qsTranslate("NonAV", "STR_HVAC_HELP")

    outside = qsTranslate("NonAV", "STR_OUTSIDE_TEMP")

} //setText


Timer {
    id: id_TimerOptionMenu
    interval: 10000
    repeat: false
    onTriggered:
    {
        //--------------------- Disable Focuse ##
        console.log(" # Disable : Optionmenu  # ")
        optionMenuDisable()
        //touch clear
        uiListener.clearTouch();
    }
} // End Timer


    FocusScope{
        // add empty area for (beepEnabled: false)
//        Rectangle {
//            x:0
//            y:0
//            width: 1280
//            height: 93
//            MouseArea{
//                anchors.fill: parent
//                beepEnabled: false
//            }
//        }

        Rectangle {
            id: idbg_option_dim;
            x:0
            y:93
            width: 1280
            height: 627
            color:  "transparent"
//            opacity: 0.8
            visible: false
            MouseArea{
                anchors.fill: parent
                beepEnabled: true
                onReleased:  {
                    //focusVisible=false
                    console.log("focusVisible=false");
                    optionMenuDisable()
                }
            }//MouseArea
        }//idbg_option_dim

        Image {
            id: idbg_option_menu
//            x: /*countryVariant != 4*/langID != 20 ?  1280 : CONST.bg_option_menu_reverse_X - idbg_option_menu.width
            x: {
                if (langID != 20) {
                    //1280
                    767
                }  else {
                    0
                    //CONST.bg_option_menu_reverse_X - idbg_option_menu.width
                }
            }
            y: /*countryVariant != 4*/langID != 20 ?  CONST.bg_option_menu_Y : CONST.bg_option_menu_reverse_Y
            width:513
            height:627
            source:  /*countryVariant != 4*/langID != 20 ?  imgFolderGeneral + "bg_optionmenu.png" : imgFolderGeneral + "arab/bg_optionmenu.png"
            visible: false
            MouseArea{
                anchors.fill: parent
                beepEnabled: false
                onReleased:  {
                     console.log("focusVisible=false");
                }
            }//MouseArea
            NumberAnimation on x {
                id: id_option_menu_open;
//                running: idbg_option_menu.visible;
                from:/*countryVariant != 4*/langID!= 20 ?  1280 : CONST.bg_option_menu_reverse_X - idbg_option_menu.width;
                to: /*countryVariant != 4*/langID != 20 ? CONST.bg_option_menu_X: 0;
                duration: 100
            }
            NumberAnimation on x {
                id: id_option_menu_close;
                from: /*countryVariant != 4*/langID != 20 ? CONST.bg_option_menu_X: 0;
                to: /*countryVariant != 4*/langID != 20 ? 1280 : CONST.bg_option_menu_reverse_X - idbg_option_menu.width;
                duration: 100;
                onCompleted: idbg_option_menu.visible=false
            }

            NonAV_Item_List {
                id: id_option_list
                width:parent.width
                height: parent.height
                __fontfamily:fontFamily
                list: {
                    list.set(0, {"name":option_menu_string, "disableItem":(rear_Offdisp==0x0)? true:false, "isCheckNA": true, "isChekedState": ((rear_Offdisp==0x0 || rear_Offdisp==0x2 ) ? false:true)});
                    list.set(1, {"name":option_menu_smartVent, "disableItem":false, "isCheckNA": true , "isChekedState": ((smartVentStatus == 0x1 ) ? true:false)});
                    list.set(2, {"name":option_menu_ads, "disableItem":false, "isCheckNA": true , "isChekedState": ((autoDefSystemStatus == 0x1 ) ? true:false)});
                    list.set(3, {"name":option_menu_help, "disableItem":false, "isCheckNA": false , "isChekedState": false});
                }
                //anchors.left: idbg_option_menu.left
                itemHeight: 78
                separatorPath: imgFolderGeneral + "line_optionmenu.png"
//                                currentIndex: nCurIndex
                onLostFocus: parent.lostFocus( arrow, focusID )
                onFocusChanged: id_TimerOptionMenu.restart()
                onVisibleChanged: {
                    if (visible) id_TimerOptionMenu.restart()
                }

                cv: /*countryVariant*/langID
                onItemClicked:
                {
                   idClimateAppMain.selected( itemId )
                }

                onCanceledTouch:
                {
                    id_TimerOptionMenu.restart()
                }

                onItemPressed:  {
                    idClimateAppMain.pressed(bpress)
                }

                onCloseMenu: idClimateAppMain.optionMenuDisable()
                states: [State{
                    name: "normal" ; when: cv != 20
                    AnchorChanges{ target: id_option_list; anchors.left: idbg_option_menu.left}
                    PropertyChanges{ target: id_option_list; _elide: Text.ElideRight}
               //     PropertyChanges{ target: id_option_list; anchors.leftMargin:120}
                },
                State{
                    name: "reverse"; when: cv == 20
                    AnchorChanges{ target: id_option_list; anchors.right: idbg_option_menu.right}
                    PropertyChanges{ target: id_option_list; _elide: Text.ElideLeft}
//                                 PropertyChanges{ target: id_option_list; anchors.rightMargin:120}
                }]

                MouseArea{
                    anchors.fill: parent
                    anchors.topMargin: 400//260
                    beepEnabled: false
                    property int startX : 0
                    onPressed: {
                        startX = mouseX;
                    }
                    onReleased:  {
                          if(mouseX - startX > 100) {
                            idClimateAppMain.optionMenuDisable()
                          }
                         //console.log("NonAV_Item_List MouseArea");
                    }
                }//MouseArea
            }
        }//idbg_option_menu
    }//FocusScope

    function pressed(bpress)
    {
       if(bpress == true) {
            id_TimerOptionMenu.stop()
       } else {
            id_TimerOptionMenu.restart()
       }
    }

    function selected( itemId)
    {
        switch(itemId)
        {
        case 0:
            reqRearOnOff();
            //console.log("send reqRearOnOff SIG");
            break;
        case 1:
            reqSmartVentOnOff();
            break;
        case 2:
            reqADSOnOFF();
            break;
        case 3:
            if (helpPageLoader.status==Loader.Null) {
                helpPageLoader.source = "../../component/Climate/DHAVN_AppFATC_Help.qml"
                optionMenuDisableForHelpPage()
                helpPageLoader.forceActiveFocus()
                isHelpPageMode = true
                console.log("==> selected(3),  helpPageLoader.forceActiveFocus()");
            }

            break;
        default:
            //console.log(itemId + " th button selected")
            break;
        }
//        optionMenuDisable();
    }

    function updateBGImageDHPE(thisNo) {
        //uiListener.logBgType(thisNo+30, iTypeOfDHPEImage);
        //console.log("Before background.source:" + background.source)
        if (thisNo!=iTypeOfDHPEImage) {
            iTypeOfDHPEImage = thisNo;
            //console.log("[thisNo!=iTypeOfDHPEImage] thisNo:" + thisNo + ", iTypeOfDHPEImage:" + iTypeOfDHPEImage)
            switch(thisNo)
            {
            case 1:
                //rearCenterHeadRest X, rear monitor O, DHPE Normal Model
                background.source = imgFolderClimateDHPE + "bg_interior_storage.png";
                uiListener.logBgType(3, 1);
                break;
            case 2:
                //rearCenterHeadRest X, rear monitor X, DHPE Normal Model
                background.source = imgFolderClimateDHPE + "bg_interior_no.png";
                uiListener.logBgType(4, 2);
                break;
            case 3:
                //rearCenterHeadRest O, rear monitor O, DHPE Sports Model
                background.source = imgFolderClimateDHPE + "bg_interior.png";
                uiListener.logBgType(5, 3);
                break;
            case 4:
                //rearCenterHeadRest O, rear monitor O, DHPE Normal Model
                background.source = imgFolderClimateDHPE + "bg_interior.png";
                uiListener.logBgType(6, 4);
                break;
            case 5:
                //rearCenterHeadRest O, rear monitor X, DHPE Sports Model
                background.source = imgFolderClimateDHPE + "bg_interior_rear.png";
                uiListener.logBgType(7, 5);
                break;
            case 6:
                //rearCenterHeadRest O, rear monitor X, DHPE Normal Model
                background.source = imgFolderClimateDHPE + "bg_interior_rear.png";
                uiListener.logBgType(8, 6);
                break;
            }
        }
        //console.log("thisNo:" + thisNo + ", iTypeOfDHPEImage:" + iTypeOfDHPEImage)
        //console.log("After background.source:" + background.source)
    }

    function updateBGImageNo() {
        //uiListener.logBgType(13, 0); //print updateBGImageNo
        if (isDHPEOnly==true) {
            if (countryVariant == 2) { //China market -> rearCenterHeadRest X
                if (rearMonitor) {
                    //rearCenterHeadRest X, rear monitor O, DHPE Normal Model
                    updateBGImageDHPE(1);
                    //uiListener.logBgType(3, iTypeOfDHPEImage);
                }
                else {
                    //rearCenterHeadRest X, rear monitor X, DHPE Normal Model
                    updateBGImageDHPE(2);
                    //uiListener.logBgType(4, iTypeOfDHPEImage);
                }
            }
            else { //rearCenterHeadRest O
                if (rearMonitor) {
                    if (isDHPESports) {
                        //rearCenterHeadRest O, rear monitor O, DHPE Sports Model
                        updateBGImageDHPE(3);
                        //uiListener.logBgType(5, iTypeOfDHPEImage);
                    }
                    else {
                        //rearCenterHeadRest O, rear monitor O, DHPE Normal Model
                        updateBGImageDHPE(4);
                        //uiListener.logBgType(6, iTypeOfDHPEImage);
                    }
                } // no rear monitor
                else {
                    if (isDHPESports) {
                        //rearCenterHeadRest O, rear monitor X, DHPE Sports Model
                        updateBGImageDHPE(5);
                        //uiListener.logBgType(7, iTypeOfDHPEImage);
                    }
                    else {
                        //rearCenterHeadRest O, rear monitor X, DHPE Normal Model
                        updateBGImageDHPE(6);
                        //uiListener.logBgType(8, iTypeOfDHPEImage);
                    }
                }
            }
        }
        else { //DH
            if (countryVariant == 1) {
                background.source = imgFolderClimate + "bg_interior_rear_no.png"
                uiListener.logBgType(9, iTypeOfDHPEImage);
            }
            else {
                if(variant_RHD == 0){        // LHD Left Handle Drive // 0x40
                    if (rearMonitor == true) {
                        background.source = imgFolderClimate + "bg_interior_rear.png"
                        uiListener.logBgType(10, iTypeOfDHPEImage);
                    }
                    else {
                        background.source = imgFolderClimate + "bg_interior.png"
                        uiListener.logBgType(11, iTypeOfDHPEImage);
                    }
                }
                else{
                    background.source = imgFolderClimate + "bg_interior_r.png"
                    uiListener.logBgType(12, iTypeOfDHPEImage);
                }
            }
        }
    }

    Component.onCompleted: {
        //console.log("Hvac Component.onCompleted");
        uiListener.RetranslateUi();
    }

    QmlStatusBar {
         id: statusBar
         x: 0; y: 0; z:10; width: 1280; height: 93
         homeType: "button"
         visible:true
         middleEast: /*countryVariant == 4*/langID == 20 ? true : false
    }

    Loader {
        id: helpPageLoader
        x:0; y:93
        source: ""
    }

}
