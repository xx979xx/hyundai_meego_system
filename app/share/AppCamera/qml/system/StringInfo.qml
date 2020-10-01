import QtQuick 1.1

Item {
    id:stringInfo

    property string originalFontName: "DH_HDB"
    property string originalFontNameSetting: "DH_HDR"

    property string fontName: originalFontName
    property string fontNameSetting: originalFontNameSetting

    property int langID_Ko: 2
    property int langID_Pt: 6

    // Main
    property string alert0txt : qsTr("STR_CAMERA_ALERT0")
    property string alert2txt : qsTr("STR_CAMERA_ALERT2")

    //Abnormal stopping alert Popup
    property string stopText1: qsTr("STR_CAMERA_ABEND1")
    property string stopText2: qsTr("STR_CAMERA_ABEND2")

    //AVMSetting
    property string setModeAreaTxt : qsTr("STR_CAMERA_SETTING")

    //AVMSetting - tap menu list
    property string tapName1 : qsTr("STR_CAMERA_SETTAP1")
    property string tapName2 : qsTr("STR_CAMERA_SETTAP2")
    property string tapName3 : qsTr("STR_CAMERA_SETTAP3")

    //AVMSetting - general settings
    property string general_op1Text : qsTr("STR_CAMERA_SETMENU1")
    property string general_op2Text : qsTr("STR_CAMERA_SETMENU2")

    //AVMSetting - front default view init
    property string frontInit_op1Text : qsTr("STR_CAMERA_SETFVIEW1")
    property string frontInit_op2Text : qsTr("STR_CAMERA_SETFVIEW2")
    property string frontInit_op3Text : qsTr("STR_CAMERA_SETFVIEW3")
    property string frontInit_op4Text : qsTr("STR_CAMERA_SETFVIEW4")

    //AVMSetting - rear default view init
    property string rearInit_op1Text : qsTr("STR_CAMERA_SETRVIEW5")
    property string rearInit_op2Text : qsTr("STR_CAMERA_SETRVIEW6")
    property string rearInit_op3Text : qsTr("STR_CAMERA_SETRVIEW7")
    property string rearInit_op4Text : qsTr("STR_CAMERA_SETRVIEW8")

    //PGS Main menu
    property string pgsBtn1txt : qsTr("STR_CAMERA_BTN3")
    property string pgsBtn2txt : qsTr("STR_CAMERA_BTN4")

    //PGS Setting
    property string pgsMenuTxt1 : qsTr("STR_CAMERA_PGSSETMENU1")
    property string pgsMenuTxt2 : qsTr("STR_CAMERA_PGSSETMENU2")
    property string pgsMenuTxt3 : qsTr("STR_CAMERA_PGSSETMENU3")

    //AVM Calibration Manual mode
    property string calibInitMenuTxt1 : qsTr("STR_CAMERA_CALIB1")
    property string calibInitMenuTxt2 : qsTr("STR_CAMERA_CALIB2")
    property string calibInitMenuTxt3 : qsTr("STR_CAMERA_CALIB3")
    property string calibInitMenuTxt4 : qsTr("STR_CAMERA_CALIB4")
    property string calibInitMenuTxt5 : qsTr("STR_CAMERA_CALIB5")
    property string calibCmdBtnTxt1 : qsTr("STR_CAMERA_CALIB_CMD1")
    property string calibCmdBtnTxt2 : qsTr("STR_CAMERA_CALIB_CMD2")

    //PGS Step Msg
    property string pgsStepTxt1 : qsTr("STR_CAMERA_PGS_STEP1")
    property string pgsStepTxt2 : qsTr("STR_CAMERA_PGS_STEP2")
    property string pgsStepTxt3 : qsTr("STR_CAMERA_PGS_COMPLETE")

    property string cameraLoadingTxt : qsTr("STR_CAMERA_LOADING")

    function retranslateUi(languageId) {
        frontInit_op1Text = qsTr("STR_CAMERA_SETFVIEW1")
        frontInit_op2Text = qsTr("STR_CAMERA_SETFVIEW2")
        frontInit_op3Text = qsTr("STR_CAMERA_SETFVIEW3")
        frontInit_op4Text = qsTr("STR_CAMERA_SETFVIEW4")
        general_op1Text = qsTr("STR_CAMERA_SETMENU1")
        general_op2Text = qsTr("STR_CAMERA_SETMENU2")
        rearInit_op1Text = qsTr("STR_CAMERA_SETRVIEW5")
        rearInit_op2Text = qsTr("STR_CAMERA_SETRVIEW6")
        rearInit_op3Text = qsTr("STR_CAMERA_SETRVIEW7")
        rearInit_op4Text = qsTr("STR_CAMERA_SETRVIEW8")
        tapName1 = qsTr("STR_CAMERA_SETTAP1");
        tapName2 = qsTr("STR_CAMERA_SETTAP2");
        tapName3 = qsTr("STR_CAMERA_SETTAP3");
        stopText1 = qsTr("STR_CAMERA_ABEND1")
        stopText2 = qsTr("STR_CAMERA_ABEND2")
        alert0txt = qsTr("STR_CAMERA_ALERT0");
        alert2txt = qsTr("STR_CAMERA_ALERT2");
        setModeAreaTxt = qsTr("STR_CAMERA_SETTING");
        pgsBtn1txt = qsTr("STR_CAMERA_BTN3");
        pgsBtn2txt = qsTr("STR_CAMERA_BTN4");
        pgsMenuTxt1 = qsTr("STR_CAMERA_PGSSETMENU1");
        pgsMenuTxt2 = qsTr("STR_CAMERA_PGSSETMENU2");
        pgsMenuTxt3 = qsTr("STR_CAMERA_PGSSETMENU3");

        calibInitMenuTxt1 = qsTr("STR_CAMERA_CALIB1")
        calibInitMenuTxt2 = qsTr("STR_CAMERA_CALIB2")
        calibInitMenuTxt3 = qsTr("STR_CAMERA_CALIB3")
        calibInitMenuTxt4 = qsTr("STR_CAMERA_CALIB4")
        calibInitMenuTxt5 = qsTr("STR_CAMERA_CALIB5")
        calibCmdBtnTxt1 = qsTr("STR_CAMERA_CALIB_CMD1")
        calibCmdBtnTxt2 = qsTr("STR_CAMERA_CALIB_CMD2")

        pgsStepTxt1 = qsTr("STR_CAMERA_PGS_STEP1")
        pgsStepTxt2 = qsTr("STR_CAMERA_PGS_STEP2")
        pgsStepTxt3 = qsTr("STR_CAMERA_PGS_COMPLETE")
        cameraLoadingTxt = qsTr("STR_CAMERA_LOADING")
    }

    Connections{
        target: UIListener
        onRetranslateUi:{
            //console.log("onRetranslateUi-languageId:" + languageId);
//            if (languageId>langID_Ko && languageId<langID_Pt) {
//                //languageId 3,4,5 -> LANGUAGE_ZH_CN, LANGUAGE_ZH_CMN, LANGUAGE_ZH_YUE
//                fontName = "CHINESS_HDB";
//                fontNameSetting = "CHINESS_HDR";
//            }
//            else {
//                fontName = originalFontName;
//                fontNameSetting = originalFontNameSetting;
//            }

            stringInfo.retranslateUi(languageId);
            LocTrigger.retrigger();
        }
    }

}
