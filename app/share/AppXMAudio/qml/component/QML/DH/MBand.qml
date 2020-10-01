/**
 * FileName: MBand.qml
 * Author: HYANG
 * Time: 2012-07
 *
 * - 2012-07 Initial Created by HYANG
 * - (Tab count max 5, focus added, wheel added)
 * - 2012-07-26 apply jog key, dialing principle
 * - 2012-07-27 add BT image in tab, add text visible flag
 * - 2012-07-30 add reserve button
 * - 2012-07-31 focus condition modify, tabBtnBtFlag delete, tabBtn`s focus start number add
 * - 2012-08-24 add list Icon Image
 * - 2012-10-24 add signalText`s property
 * - 2013-01-12 add Give force focus for focus & active sync (isv issue)
 * - 2013-02-23 change band gui (document 130222)
 */

import QtQuick 1.1

MComponent {
    id: idMBand
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight

    //****************************** # Preperty #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderXMData : imageInfo.imgFolderXMData
    property string imgFolderRadio_SXM : imageInfo.imgFolderRadio_SXM

    property alias menuButton: idMenuBtn
    property alias idTabBtn3Alias: idTabBtn3
    property alias idSubBtnAlias: idSubBtn
    property alias idBackBtnAlias: idBackBtn
    property string tabBtnText: ""    //[user control] Text in band button
    property string tabBtnText2: ""
    property string tabBtnText3: ""

    property string selectedBand: ""
    property string titleText: "" //[user control] Title`s Label Text
    property string subTitleText: "" //[user control] Sub Title`s Label Text
    property string subTitleTextColor: colorInfo.dimmedGrey //colorInfo.dimmedGrey
    property int subTitleTextSize: 40
    property bool subTitleTextFlag : (tabBtnFlag==false)
    property string subBtnText: ""   //[user control] subBtn`s Text
    property string menuBtnText: ""  //[user contral] menuKey`s Text
    property string signalText: ""  //[user control]
    property int signalTextSize: 30
    property int signalTextX: 672
    property int signalTextY: 129-systemInfo.statusBarHeight-(signalTextSize/2)
    property int signalTextWidth: 350
    property string signalTextColor: "#7CBDFF"
    property string signalTextAlies: "Right"
    property bool signalText2Line: false
    property string signalImg: ""
    property int signalImgX
    property int signalImgY
    property string reserveBtnText: ""

    property int tabBtnCount: 0
    property int listNumberCurrent: 0  //[user control] current item number of list
    property int listNumberTotal: 0  //[user control] total item number of list

    property bool tabBtnFlag: false  //[user control] BandTab button On/Off
    property bool signalTextFlag: false   //[user control] signal Text On/OffT
    property bool signalImgFlag: false
    property bool listNumberFlag: false   //[user control] list number On/Off
    property bool menuBtnFlag: false   //[user contral] menu button On/Off
    property bool subBtnFlag: false //[user control] Left button of backkey is On/Off (List button)
    property bool reserveBtnFlag: false
    property bool alertBtnFlag: false
    property bool subtitleEPGFlag: false

    property string subBtnFgImage: ""
    property string subBtnFgImageActive: ""
    property string subBtnFgImageFocus: ""
    property string subBtnFgImageFocusPress: ""
    property string subBtnFgImagePress: ""
    property int subBtnFgImageX: 41
    property int subBtnFgImageY: 6
    property int subBtnFgImageWidth: 60
    property int subBtnFgImageHeight: 60
    property int subBtnWidth: 138
    property string subBtnBgImage: imgFolderGeneral+"btn_title_sub_n.png"
    property string subBtnBgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
    property string subBtnBgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"

    property string reserveBtnFgImage: ""    //imgFolderRadio_SXM+"ico_sxm_info.png"
    property string reserveBtnFgImageActive: ""
    property string reserveBtnFgImageFocus: ""
    property string reserveBtnFgImageFocusPress: ""
    property string reserveBtnFgImagePress: ""   //imgFolderRadio_SXM+"ico_sxm_info.png"


    //****************************** # Sub Skip Title Info
    property string subSkipTitleText: "" //[user control] Sub Title`s Label Text
    property string subSkipTitleTextColor: colorInfo.dimmedGrey //colorInfo.dimmedGrey
    property int subSkipTitleTextSize: 40
    property int subSkipTitleTextX: 45 + txtTitle.paintedWidth + 23;
    property bool subSkipTitleTextFlag : (tabBtnFlag == false)


    //****************************** # Text Visible in Tab(120727) #
    property bool tabBtnTextVisible1: true
    property bool tabBtnTextVisible2: true
    property bool tabBtnTextVisible3: true

    //****************************** # Button Enabled/Disable On/Off (130128) #
    property bool tabBtnEnabledFlag1: true
    property bool tabBtnEnabledFlag2: true
    property bool tabBtnEnabledFlag3: true
    property bool reserveBtnEnabledFlag: true
    property bool subBtnEnabledFlag: true
    property bool menuBtnEnabledFlag: true

    //****************************** # Tab button selected Image (120712) #
    property string tabLine1: /*(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? imgFolderGeneral+"line_tab_01_d.png":*/imgFolderGeneral+"line_tab_01_s.png"
    property string tabLine2: /*(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? imgFolderGeneral+"line_tab_02_d.png":*/imgFolderGeneral+"line_tab_02_s.png"
    property string tabLine3: /*(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? imgFolderGeneral+"line_tab_03_d.png":*/imgFolderGeneral+"line_tab_03_s.png"

    //****************************** # Tab button n/p/fp/f Image (120712) #
    //property string tabBtnNormal: ""//(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? imgFolderGeneral+"btn_title_normal_d.png" : imgFolderGeneral+"btn_title_normal_n.png"
    property string tabBtnPress: imgFolderGeneral+"btn_title_normal_p.png"
    property string tabBtnFocusPress: imgFolderGeneral+"btn_title_normal_fp.png"
    property string tabBtnFocus: imgFolderGeneral+"btn_title_normal_f.png"

    //****************************** # fgImage in Tab(120727) #
    property string tabFgImage1: ""
    property string tabFgImage2: ""
    property string tabFgImage3: ""

    //****************************** # Signal (when button clicked) #
    signal reserveBtnClicked()
    signal reserveBtnPressAndHold()
    signal subBtnClicked();
    signal menuBtnClicked();
    signal backBtnClicked(bool bTouchBack);
    signal tabBtn1Clicked();
    signal tabBtn2Clicked();
    signal tabBtn3Clicked();

    //****************************** # at first, tap not click #
    Component.onCompleted: {
        if(idTabBtn1.activeFocus)
            idTabBtn1.bgImagePress = ""
        else if(idTabBtn2.activeFocus)
            idTabBtn2.bgImagePress = ""
        else if(idTabBtn3.activeFocus)
            idTabBtn3.bgImagePress = ""
    }

    //****************************** # Give force focus for focus & active sync (130112) #
    function giveForceFocus(focusPosition){
        if(focusPosition == 1) idTabBtn1.focus = true
        else if(focusPosition == 2) idTabBtn2.focus = true
        else if(focusPosition == 3) idTabBtn3.focus = true
        else if(focusPosition == "reserveBtm") idReserveBtn.focus = true;
        else if(focusPosition == "subBtn") idSubBtn.focus = true;
        else if(focusPosition == "menuBtn") idMenuBtn.focus = true;
        else if(focusPosition == "backBtn") idBackBtn.focus = true;
    }

    //****************************** # Band Background Image #
    Image{
        x: 0; y: 0
        source: imgFolderGeneral+"bg_title.png"
    }

    //****************************** # Tab Button1~5 (2~4 120712)#
    MButton{
        id: idTabBtn1
        x: 5; y: 0
        buttonName: tabBtnText
        width: 170;
        height: systemInfo.titleAreaHeight

        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus

        bgImageActive: (idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? imgFolderGeneral+"btn_title_normal_d.png" : imgFolderGeneral+"btn_title_normal_s.png"
        visible: (tabBtnFlag==true) && (tabBtnCount==1 || tabBtnCount==2 || tabBtnCount==3)
        active: buttonName == selectedBand

        firstText: tabBtnText
        firstTextX: 18-5;
        firstTextY: 129-systemInfo.statusBarHeight-1
        firstTextWidth: 143
        firstTextSize: 36
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.normalTabGrey
        firstTextPressColor: colorInfo.brightGrey
        //  firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible1
        firstTextElide: "Right"
        buttonEnabled:(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE")?false:true

        fgImage: tabFgImage1
        fgImageActive: tabFgImage1
        fgImageX: 55-5
        fgImageY: 105-systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50

        Image{
            x: 167;
            source: imageInfo.imgFolderGeneral+"line_title.png"
            visible: idTabBtn3.active
        }

        onClickOrKeySelected: {

            tabBtn1Clicked()
        }

        // Wraparound
        //        onWheelLeftKeyPressed: {
        //            idBackBtn.focus = true
        //            idBackBtn.forceActiveFocus()
        //        } //# End onWheelLeftKeyPressed

        onWheelRightKeyPressed: {
            if(tabBtnCount>1){
                idTabBtn2.focus = true
                idTabBtn2.forceActiveFocus()
            }
            else{
                if(idReserveBtn.visible){
                    idReserveBtn.focus = true
                    idReserveBtn.forceActiveFocus()
                }
                else if(idSubBtn.visible){
                    idSubBtn.focus = true
                    idSubBtn.forceActiveFocus()
                }
                else if(idMenuBtn.visible){
                    idMenuBtn.focus = true
                    idMenuBtn.forceActiveFocus()
                }
                else{
                    idBackBtn.focus = true
                    idBackBtn.forceActiveFocus()
                }
            }
        } //# End onWheelRightKeyPressed
    } //# End MButton(Tab1)

    MButton{
        id: idTabBtn2
        x: 5+170;
        y: 0
        buttonName: tabBtnText2
        width: 170;
        height: systemInfo.titleAreaHeight
        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus
        bgImageActive: (idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? imgFolderGeneral+"btn_title_normal_d.png" : imgFolderGeneral+"btn_title_normal_s.png"
        visible: (tabBtnFlag==true) && (tabBtnCount==2 || tabBtnCount==3)
        active: buttonName == selectedBand

        firstText: tabBtnText2
        firstTextX: 18-5;
        firstTextY: 129-systemInfo.statusBarHeight-1
        firstTextWidth: 143
        firstTextSize: 36
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.normalTabGrey
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible2
        firstTextElide: "Right"
        buttonEnabled:(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE")?false:true

        fgImage: tabFgImage2
        fgImageActive: tabFgImage2
        fgImageX: 55-5
        fgImageY: 105-systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50

        Image{
            x: 167;
            source: imageInfo.imgFolderGeneral+"line_title.png"
            visible: idTabBtn1.active
        }

        onClickOrKeySelected: {
            idTabBtn2.focus = true
            tabBtn2Clicked()
        }

        onWheelLeftKeyPressed: { idTabBtn1.focus = true }
        onWheelRightKeyPressed: {
            if(tabBtnCount>2){idTabBtn3.focus = true }
            else{
                if(idReserveBtn.visible){ idReserveBtn.focus = true }
                else if(idSubBtn.visible){ idSubBtn.focus = true }
                else if(idMenuBtn.visible){ idMenuBtn.focus = true }
                else{ idBackBtn.focus = true }
            }
        } //# End onWheelRightKeyPressed
    } //# End MButton(Tab2)

    MButton{
        id: idTabBtn3
        x: 5+170+170;
        y: 0
        buttonName: tabBtnText3
        width: 170;
        height: systemInfo.titleAreaHeight
        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus
        bgImageActive: /*(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? imgFolderGeneral+"btn_title_normal_d.png" :*/ imgFolderGeneral+"btn_title_normal_s.png"
        visible: (tabBtnFlag==true) && (tabBtnCount==3)
        active: buttonName == selectedBand
        focus: true

        firstText: tabBtnText3
        firstTextX: 8-5/*18-5*/;
        firstTextY: 129-systemInfo.statusBarHeight-1
        firstTextWidth: 163/*143*/
        firstTextSize: 32
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.normalTabGrey
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible3
        firstTextElide: "Right"
        buttonEnabled:(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE")?false:true

        fgImage: tabFgImage3
        fgImageActive: tabFgImage3
        fgImageX: 55-5
        fgImageY: 105-systemInfo.statusBarHeight
        fgImageWidth: 70
        fgImageHeight: 50

        onClickOrKeySelected: {
            idTabBtn3.focus = true
            tabBtn3Clicked()
        }

        Image{
            x: 167;
            source: imageInfo.imgFolderGeneral+"line_title.png"
            visible: idTabBtn1.active || idTabBtn2.active
        }

        onWheelLeftKeyPressed: { idTabBtn2.focus = true }
        onWheelRightKeyPressed: {
            if(idReserveBtn.visible && PLAYInfo.EnableTagging){ idReserveBtn.focus = true }
            else if(idSubBtn.visible && idSubBtn.buttonEnabled == true){ idSubBtn.focus = true }
            else if(idMenuBtn.visible){ idMenuBtn.focus = true }
            else{ idBackBtn.focus = true }
        } //# End onWheelRightKeyPressed
    } //# End MButton(Tab3)

    //****************************** # Tab Button selected One tab (120712) #
    Image{
        id: idTabCover
        x: 0; y: 0;
        width: systemInfo.lcdWidth; height: 72
        source: idTabBtn1.active? tabLine1 : idTabBtn2.active? tabLine2 : tabLine3
        visible: (tabBtnFlag==true)
    }

    //****************************** # Title Text #
    Text{
        id: txtTitle
        text: titleText
        x: /*(titleFavoriteImg==true)? 25+58 :*/ 46;
        y: 129-systemInfo.statusBarHeight-40/2
        width: txtTitle.paintedWidth//770;
        height: 40
        font.pixelSize: 40
        font.family: systemInfo.font_NewHDB
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        visible: (tabBtnFlag==false)
    }

    //****************************** # Sub Skip Title Text #
    Text{
        id: txtSkipSubTitle
        text: subSkipTitleText
        x: subSkipTitleTextX
        //        y: tabBtnTextY - subSkipTitleTextSize/2
        y: 129 - systemInfo.statusBarHeight - subSkipTitleTextSize/2
        width: 830 - txtTitle.paintedWidth - 23; height: subSkipTitleTextSize
        font.pixelSize: subSkipTitleTextSize
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: subSkipTitleTextColor //colorInfo.dimmedGrey
        elide: Text.ElideRight
        visible: subSkipTitleTextFlag
    }

    //****************************** # Sub Title Text #
    DDScrollTicker{
        id: txtSubTitle
        text: subTitleText
        x: subtitleEPGFlag ? 46+txtTitle.paintedWidth+38 : 45+txtTitle.paintedWidth+23;
        y: 129-systemInfo.statusBarHeight-subTitleTextSize/2
        width: subtitleEPGFlag ? 1280-626-46-38-txtTitle.paintedWidth : 830-txtTitle.paintedWidth-23; height: subTitleTextSize
        fontSize: subTitleTextSize
        fontFamily: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: subTitleTextColor //colorInfo.dimmedGrey
        visible: subTitleTextFlag
        tickerFocus: (true && idAppMain.focusOn)
    }

    onVisibleChanged: {
        if(visible && (subtitleEPGFlag == true))
        {
            txtSubTitle.tickerEnable = false;
            txtSubTitle.doCheckAndStartAnimation();
            txtSubTitle.tickerEnable = true;
            txtSubTitle.doCheckAndStartAnimation();
        }
    }

    //****************************** # List Number Text #
    Text{
        id: txtListNumber
        text: listNumberCurrent+"/" + listNumberTotal
        x: (menuBtnFlag==true)? (subBtnFlag==true)? (reserveBtnFlag==true)? 998-(subBtnWidth)-138-146 : 998-(subBtnWidth)-146 : 998-146 : (subBtnFlag==true)? (reserveBtnFlag==true)? 1136-(subBtnWidth)-138-146 : 1136-(subBtnWidth)-146 : 1136-146
        y: 129-systemInfo.statusBarHeight-30/2
        width: 146; height: 30
        font.pixelSize: 30
        font.family: systemInfo.font_NewHDB
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color:  "#7CBDFF" //RGB(124,189,255)
        visible: (listNumberFlag==true)
    }

    //****************************** # anything image #
    Image{
        source: signalImg
        x: signalImgX; y: signalImgY
        visible: (signalImgFlag==true)
    }

    //****************************** # Signal Text #
    Text{
        id: txtSignal
        text: signalText
        x: signalTextX
        y: signalTextY
        width: signalTextWidth ; height: signalTextSize
        font.pixelSize: signalTextSize  //30
        font.family: signalText2Line == true ? systemInfo.font_NewHDR : systemInfo.font_NewHDB
        horizontalAlignment: {
            if(signalTextAlies=="Right"){Text.AlignRight}
            else if(signalTextAlies=="Left"){Text.AlignLeft}
            else if(signalTextAlies=="Center"){Text.AlignHCenter}
            else {Text.AlignRight}
        }
        verticalAlignment: Text.AlignVCenter
        elide: signalText2Line == true ? Text.ElideNone : Text.ElideRight
        wrapMode: signalText2Line == true ? Text.WordWrap : Text.NoWrap
        color: signalTextColor   //"#7CBDFF" //RGB(124,189,255)
        lineHeight: 0.75
        visible: (signalTextFlag==true)
    }

    //****************************** # ReseveBtn button #
    MButton{
        id: idReserveBtn
        x: (menuBtnFlag==true)? (subBtnFlag==true)? 1004-(subBtnWidth)-144 : 1004-144 : (subBtnFlag==true)? 1136-(subBtnWidth)-144 : alertBtnFlag ? 937 : 1136-144
        width: alertBtnFlag ? 200 : 138; height: 72
        focus: (tabBtnFlag==false) && (reserveBtnFlag==true) ? true : false
        bgImage: alertBtnFlag ? imgFolderRadio_SXM+"btn_gamezone_alert_n.png" : imgFolderGeneral+"btn_title_sub_n.png"
        bgImageActive: alertBtnFlag ? imgFolderRadio_SXM+"btn_gamezone_alert_n.png" : imgFolderGeneral+"btn_title_sub_n.png"
        bgImagePress: alertBtnFlag ? imgFolderRadio_SXM+"btn_gamezone_alert_p.png" : imgFolderGeneral+"btn_title_sub_p.png"
        bgImageFocus: alertBtnFlag ? imgFolderRadio_SXM+"btn_gamezone_alert_f.png" : imgFolderGeneral+"btn_title_sub_f.png"
        visible: (reserveBtnFlag==true)

        onClickOrKeySelected: {
            idReserveBtn.focus = true
            reserveBtnClicked()
        }
        onPressAndHold: {
            reserveBtnPressAndHold()
        }

        firstText: reserveBtnText
        firstTextX: alertBtnFlag ? 30 : 9
        firstTextY: 129-systemInfo.statusBarHeight
        firstTextWidth: alertBtnFlag ? 86 : 123
        firstTextSize: 30
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextElide: "Right"
        buttonEnabled:alertBtnFlag ? true : (idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE" || (!PLAYInfo.EnableTagging))? false : true

        fgImageX: alertBtnFlag ? 126 : 16
        fgImageY: alertBtnFlag ? 15 : 11
        fgImageWidth: alertBtnFlag ? 44 : 88
        fgImageHeight: alertBtnFlag ? 44 : 48
        fgImage: reserveBtnFgImage
        fgImageActive: reserveBtnFgImageActive
        fgImageFocus: reserveBtnFgImageFocus
        fgImageFocusPress: reserveBtnFgImageFocusPress
        fgImagePress: reserveBtnFgImagePress

        onButtonEnabledChanged: {
            if (idAppMain.preMainScreen == "AppRadioMain") {
                if(!PLAYInfo.EnableTagging)
                    idSubBtn.focus = true;
            }
        }
        onActiveFocusChanged: {
            if(idReserveBtn.activeFocus && !PLAYInfo.EnableTagging)
            {
                idReserveBtn.focus = true;
            }
        }

        onWheelLeftKeyPressed: {
            if(tabBtnCount==0){ /*idBackBtn.focus = true*/ }
            else if(tabBtnCount==1){ idTabBtn1.focus = true }
            else if(tabBtnCount==2){ idTabBtn2.focus = true }
            else if(tabBtnCount==3){ idTabBtn3.focus = true }
        }
        onWheelRightKeyPressed: {
            if(idSubBtn.visible){ idSubBtn.focus = true }
            else if(idMenuBtn.visible){ idMenuBtn.focus = true }
            else{ idBackBtn.focus = true }
        } //# End onWheelRightKeyPressed
    }

    //****************************** # subBtn button #
    MButton{
        id: idSubBtn
        x: (menuBtnFlag==true)? 998 - (subBtnWidth) : 1136 - (subBtnWidth)
        y: 0
        width: subBtnWidth; height: 72
        focus: (tabBtnFlag==false) && (reserveBtnFlag==false) && (subBtnFlag==true) ? true : false
        bgImage: subBtnBgImage
        bgImagePress: subBtnBgImagePress
        bgImageFocus: subBtnBgImageFocus
        visible: (subBtnFlag==true)
        onClickOrKeySelected: {
            idSubBtn.focus = true
            subBtnClicked()
        }

        firstText: subBtnText
        firstTextX: 10
        firstTextY: 129-systemInfo.statusBarHeight
        firstTextWidth: subBtnWidth - 15
        firstTextSize: 30
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextElide: "Right"
        buttonEnabled:(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE"
                       || (idAppMain.preMainScreen == "AppRadioMain" && PLAYInfo.Advisory == "STR_XMRADIO_PREPAIRING_MESSAGE"))?false:true

        fgImageX: subBtnFgImageX
        fgImageY: subBtnFgImageY
        fgImageWidth: subBtnFgImageWidth
        fgImageHeight: subBtnFgImageHeight
        fgImage: subBtnFgImage
        fgImageActive: subBtnFgImageActive
        fgImageFocus: subBtnFgImageFocus
        fgImageFocusPress: subBtnFgImageFocusPress
        fgImagePress: subBtnFgImagePress

        onWheelLeftKeyPressed: {
            if(idReserveBtn.visible && PLAYInfo.EnableTagging){ idReserveBtn.focus = true }
            else if(tabBtnCount==0){ /*idBackBtn.focus = true*/ }
            else if(tabBtnCount==1){ idTabBtn1.focus = true }
            else if(tabBtnCount==2){ idTabBtn2.focus = true }
            else if(tabBtnCount==3){ idTabBtn3.focus = true }
        }
        onWheelRightKeyPressed: {
            if(idMenuBtn.visible){ idMenuBtn.focus = true }
            else{ idBackBtn.focus = true }
        } //# End onWheelRightKeyPressed
    } //# End MButton(idSubBtn)

    //****************************** # Menu button #
    MButton{
        id: idMenuBtn
        x: 998; y: 0
        width: 141; height: 72
        focus: (tabBtnFlag==false) && (reserveBtnFlag==false) && (subBtnFlag==false) && (menuBtnFlag==true && menuBtnEnabledFlag) ? true : false
        bgImage: imgFolderGeneral+"btn_title_sub_n.png"
        bgImagePress: imgFolderGeneral+"btn_title_sub_p.png"
        bgImageFocus: imgFolderGeneral+"btn_title_sub_f.png"
        visible: (menuBtnFlag==true)
        onClickOrKeySelected: {
            idMenuBtn.focus = true
            menuBtnClicked()
        }

        firstText: menuBtnText
        firstTextX: 9
        firstTextY: 129-systemInfo.statusBarHeight
        firstTextWidth: 123
        firstTextSize: 30
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextElide: "Right"
        buttonEnabled: ((idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") || !menuBtnEnabledFlag)? false : true

        onWheelLeftKeyPressed: {
            if((idSubBtn.visible) && (idSubBtn.buttonEnabled == true)){ idSubBtn.focus = true }
            else if(idReserveBtn.visible && PLAYInfo.EnableTagging){ idReserveBtn.focus = true }
            else{
                if(tabBtnCount==0){ /*idBackBtn.focus = true*/ }
                else if(tabBtnCount==1){ idTabBtn1.focus = true }
                else if(tabBtnCount==2){ idTabBtn2.focus = true }
                else if(tabBtnCount==3){ idTabBtn3.focus = true }
            }
        } //# End onWheelLeftkeyPressed
        onWheelRightKeyPressed: {
            idBackBtn.focus = true
        } //# End onWheelRightKeyPressed
    } //# End MButton(idMenuBtn)

    //****************************** # BackKey button #
    MButton{
        id: idBackBtn
        x: 1136; y: 0
        width: 141; height: 72
        focus: (tabBtnFlag==false) && (reserveBtnFlag==false) && (subBtnFlag==false) && (menuBtnFlag==false || (menuBtnFlag==true && !menuBtnEnabledFlag)) ? true : false
        bgImage: imgFolderGeneral+"btn_title_back_n.png"
        bgImagePress: imgFolderGeneral+"btn_title_back_p.png"
        bgImageFocus: imgFolderGeneral+"btn_title_back_f.png"

        onClickOrKeySelected: {
            idBackBtn.focus = true
            if(idAppMain.playBeepOn && idAppMain.inputModeXM == "touch" /*&& container.state != "disabled"*/) //Touch Back Pressed
                backBtnClicked(true);
            else //Jog Back Pressed
                backBtnClicked(false);
        }

        onWheelLeftKeyPressed: {
            //Not used Wheel Left Key Press in SiriusXM Radio, as Save as preset and reorder preset
            if(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE")
                return;

            if(idMenuBtn.visible && menuBtnEnabledFlag){ idMenuBtn.focus = true }
            else if(idSubBtn.visible){ idSubBtn.focus = true }
            else if(idReserveBtn.visible){ idReserveBtn.focus = true }
            else{
                if(tabBtnCount==1){ idTabBtn1.focus = true }
                else if(tabBtnCount==2){ idTabBtn2.focus = true }
                else if(tabBtnCount==3){ idTabBtn3.focus = true }
            }
        } //# End onWheelLeftkeyPressed
        //        onWheelRightKeyPressed: {
        //            //Not used Wheel Left Key Press in SiriusXM Radio, as Save as preset and reorder preset
        //            if(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE")
        //                return;

        //            if(tabBtnFlag==true){ idTabBtn1.focus = true  }
        //            else{
        //                if(idReserveBtn.visible){ idReserveBtn.focus = true }
        //                else if(idSubBtn.visible){ idSubBtn.focus = true }
        //                else if(idMenuBtn.visible && menuBtnEnabledFlag){ idMenuBtn.focus = true }
        //            }
        //        } //# End onWheelRightkeyPressed
    } //# End MButton(idBackBtn)
}
