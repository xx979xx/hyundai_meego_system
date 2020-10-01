/**
 * FileName: MBigBand.qml
 */

import QtQuick 1.1

MComponent {
    id: idMBigBand
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight

    //****************************** # Preperty #
    property string imgFolderGeneral : imageInfo.imgFolderGeneral
    property string imgFolderXMData : imageInfo.imgFolderXMData
    property string imgFolderRadio_SXM : imageInfo.imgFolderRadio_SXM

    //****************************** # Tab Text Info
    property string tabBtnText: ""    //[user control] Text in band button
    property string tabBtnText2: ""
    property string tabBtnText3: ""
    property int tabBtnX : 5;
    property int tabBtnWidth : 270;
    property int tabBtnTextLeftMargine : 18
    property int tabBtnTextX : tabBtnTextLeftMargine - tabBtnX
    property int tabBtnTextY : 129 - systemInfo.statusBarHeight
    property int tabBtnTextWidth: 243
    property int tabBtnTextSize : 36
    property int tabBtnSendTextSize : 36

    //****************************** # Title Info
    property string titleText: "" //[user control] Title`s Label Text
    property int titleTextX: 45;
    //property int titleTextY: 130 - systemInfo.statusBarHeight - (titleTextSize/2)
    property int titleTextWidth: (titleTextFlag == true) ? txtTitle.paintedWidth/*830*/ : 0
    property int titleTextHeight: 40
    property int titleTextSize: 40
    property string titleTextStyle: systemInfo.font_NewHDB
    property string titleTextVerticalAlies: Text.AlignVCenter
    property string titleTextHorizontalAlies: Text.AlignLeft
    property string titleTextColor: colorInfo.brightGrey
    property bool titleTextFlag: (tabBtnFlag == false)//true

    //****************************** # Sub Title Info
    property string subTitleText: "" //[user control] Sub Title`s Label Text
    property string subTitleTextColor: colorInfo.dimmedGrey //colorInfo.dimmedGrey
    property int subTitleTextSize: 40
    property int subTitleTextX: 45 + txtTitle.paintedWidth + 23;
    property bool subTitleTextFlag : (tabBtnFlag == false)

    property string selectedBand: ""
    property string subBtnText: ""   //[user control] subBtn`s Text
    property string menuBtnText: ""  //[user contral] menuKey`s Text
    property string signalText: ""  //[user control]
    property int signalTextSize: 30
    property int signalTextX: 672
    property int signalTextY: tabBtnTextY - (signalTextSize/2)
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
    property bool refreshLoadingFlag: false;

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
    property int subBtnHeight: 72
    property string subBtnBgImage: imgFolderGeneral + "btn_title_sub_n.png"
    property string subBtnBgImagePress: imgFolderGeneral + "btn_title_sub_p.png"
    property string subBtnBgImageFocus: imgFolderGeneral + "btn_title_sub_f.png"

    property string reserveBtnFgImage: ""    //imgFolderRadio_SXM + "ico_sxm_info.png"
    property string reserveBtnFgImageActive: ""
    property string reserveBtnFgImageFocus: ""
    property string reserveBtnFgImageFocusPress: ""
    property string reserveBtnFgImagePress: ""   //imgFolderRadio_SXM + "ico_sxm_info.png"

    //****************************** # Menu Button Info #
    property int menuBtnX : 998
    property int menuBtnY : 0
    property int menuBtnWidth: 141
    property int menuBtnHeight: subBtnHeight

    //****************************** # Back Button Info #
    property int backBtnX : 1136
    property int backBtnY : 0
    property int backBtnWidth: menuBtnWidth
    property int backBtnHeight: subBtnHeight

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
    property string tabBtnSelectedSXM1: (idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? imgFolderRadio_SXM + "line_tab_sxm_01_d.png" : imgFolderRadio_SXM + "line_tab_sxm_01_s.png"
    property string tabBtnSelectedSXM2: (idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? imgFolderRadio_SXM + "line_tab_sxm_02_d.png" : imgFolderRadio_SXM + "line_tab_sxm_02_s.png"
    property string tabBtnSelectedSXM3: (idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? imgFolderRadio_SXM + "line_tab_sxm_03_d.png" : imgFolderRadio_SXM + "line_tab_sxm_03_s.png"

    //****************************** # Tab button n/p/fp/f Image (120712) #
    //property string tabBtnNormal: ""//(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? imgFolderRadio_SXM + "btn_title_normal_02_d.png" : imgFolderRadio_SXM + "btn_title_normal_02_n.png"
    property string tabBtnPress: imgFolderRadio_SXM + "btn_title_normal_02_p.png"
    property string tabBtnFocusPress:  imgFolderRadio_SXM + "btn_title_normal_02_fp.png"
    property string tabBtnFocus: imgFolderRadio_SXM + "btn_title_normal_02_f.png"
    property string tabBtnActive: imgFolderRadio_SXM + "btn_title_normal_02_s.png"

    //****************************** # fgImage in Tab(120727) #
    property string tabFgImage1: ""
    property string tabFgImage2: ""
    property string tabFgImage3: ""
    property int tabFgImageX: 55 - 5
    property int tabFgImageY: 105 - systemInfo.statusBarHeight
    property int tabFgImageWidth: 70
    property int tabFgImageHeight: 50

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
        else if(focusPosition == 4) idReserveBtn.focus = true;
        else if(focusPosition == 5) idSubBtn.focus = true;
        else if(focusPosition == 6) idMenuBtn.focus = true;
        else if(focusPosition == 7) idBackBtn.focus = true;
    }

    //****************************** # Band Background Image #
    Image{
        x: 0; y: 0
        source: imgFolderGeneral + "bg_title.png"
    }

    //****************************** # Tab Button1~5 (2~4 120712)#
    MButton{
        id: idTabBtn1
        x: tabBtnX; y: 0
        buttonName: tabBtnText
        width: tabBtnWidth
        height: systemInfo.titleAreaHeight
        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnActive
        visible: (tabBtnFlag == true) && (tabBtnCount == 1 || tabBtnCount == 2 || tabBtnCount == 3)
        active: buttonName == selectedBand

        firstText: tabBtnText
        firstTextX: tabBtnTextX
        firstTextY: 129-systemInfo.statusBarHeight-1
        firstTextWidth: tabBtnTextWidth
        firstTextSize: tabBtnTextSize
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.normalTabGrey
        firstTextPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible1
        firstTextElide: "Right"
        buttonEnabled:(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? false : true

        fgImage: tabFgImage1
        fgImageActive: tabFgImage1
        fgImageX: tabFgImageX
        fgImageY: tabFgImageY
        fgImageWidth: tabFgImageWidth
        fgImageHeight: tabFgImageHeight

        Image{
            x: tabBtnWidth
            source: imageInfo.imgFolderGeneral + "line_title.png"
            visible: idTabBtn3.active
        }

        onClickOrKeySelected: {
            tabBtn1Clicked()
        }

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
                else if(idMenuBtn.visible && menuBtnEnabledFlag){
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
        x: tabBtnX + tabBtnWidth;
        y: 0
        buttonName: tabBtnText2
        width: tabBtnWidth;
        height: systemInfo.titleAreaHeight
        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnActive
        visible: (tabBtnFlag == true) && (tabBtnCount == 2 || tabBtnCount == 3)
        active: buttonName  ==  selectedBand

        firstText: tabBtnText2
        firstTextX: tabBtnTextX-10
        firstTextY: 129-systemInfo.statusBarHeight-1
        firstTextWidth: tabBtnTextWidth+20
        firstTextSize: tabBtnSendTextSize
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.normalTabGrey
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible2
        firstTextElide: "Right"
        buttonEnabled:(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? false : true

        fgImage: tabFgImage2
        fgImageActive: tabFgImage2
        fgImageX: tabFgImageX
        fgImageY: tabFgImageY
        fgImageWidth: tabFgImageWidth
        fgImageHeight: tabFgImageHeight

        Image{
            x: tabBtnWidth
            source: imageInfo.imgFolderGeneral + "line_title.png"
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
                else if(idMenuBtn.visible  && menuBtnEnabledFlag ){ idMenuBtn.focus = true }
                else{ idBackBtn.focus = true }
            }
        } //# End onWheelRightKeyPressed
    } //# End MButton(Tab2)

    MButton{
        id: idTabBtn3
        x: tabBtnX + tabBtnWidth + tabBtnWidth; // 5+170+170;
        y: 0
        buttonName: tabBtnText3
        width: tabBtnWidth
        height: systemInfo.titleAreaHeight
        bgImagePress: tabBtnPress
        bgImageFocus: tabBtnFocus
        bgImageActive: tabBtnActive
        visible: (tabBtnFlag == true) && (tabBtnCount == 3)
        active: buttonName  ==  selectedBand
        focus: true

        firstText: tabBtnText3
        firstTextX: tabBtnTextX
        firstTextY: 129-systemInfo.statusBarHeight-1
        firstTextWidth: tabBtnTextWidth
        firstTextSize: tabBtnTextSize
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.normalTabGrey
        firstTextPressColor: colorInfo.brightGrey
        firstTextFocusPressColor: colorInfo.brightGrey
        firstTextSelectedColor: colorInfo.brightGrey
        firstTextFocusColor: colorInfo.brightGrey
        firstTextVisible: tabBtnTextVisible3
        firstTextElide: "Right"
        buttonEnabled:(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? false : true

        fgImage: tabFgImage3
        fgImageActive: tabFgImage3
        fgImageX: tabFgImageX
        fgImageY: tabFgImageY
        fgImageWidth: tabFgImageWidth
        fgImageHeight: tabFgImageHeight

        onClickOrKeySelected: {
            idTabBtn3.focus = true
            tabBtn3Clicked()
        }

        Image{
            x: tabBtnWidth
            source: imageInfo.imgFolderGeneral + "line_title.png"
            visible: idTabBtn1.active || idTabBtn2.active
        }

        onWheelLeftKeyPressed: { idTabBtn2.focus = true }
        onWheelRightKeyPressed: {
            if(idReserveBtn.visible/* && PLAYInfo.EnableTagging*/){ idReserveBtn.focus = true }
            else if(idSubBtn.visible){ idSubBtn.focus = true }
            else if(idMenuBtn.visible){ idMenuBtn.focus = true }
            else{ idBackBtn.focus = true }
        } //# End onWheelRightKeyPressed
    } //# End MButton(Tab3)

    //****************************** # Tab Button selected One tab (120712) #
    Image{
        id: idTabCover
        x: 0; y: 0;
        width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight - 1
        source: idTabBtn1.active ? tabBtnSelectedSXM1 : idTabBtn2.active ? tabBtnSelectedSXM2 : tabBtnSelectedSXM3
        visible: (tabBtnFlag == true)
    }

    //****************************** # Title Text #
    Text{
        id: txtTitle
        text: titleText
        x: titleTextX;
        //y: titleTextY
        width: titleTextWidth
        height: titleTextHeight
        font.pixelSize: titleTextSize
        font.family: titleTextStyle
        horizontalAlignment: titleTextHorizontalAlies
        verticalAlignment: titleTextVerticalAlies
        color: titleTextColor
        visible: titleTextFlag
    }

    //****************************** # Sub Title Text #
    Text{
        id: txtSubTitle
        text: subTitleText
        x: subTitleTextX
        y: tabBtnTextY - subTitleTextSize/2
        width: 830 - txtTitle.paintedWidth - 23; height: subTitleTextSize
        font.pixelSize: subTitleTextSize
        font.family: systemInfo.font_NewHDR
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        color: subTitleTextColor //colorInfo.dimmedGrey
        elide: Text.ElideRight
        visible: subTitleTextFlag
    }

    //****************************** # List Number Text #
    Text{
        id: txtListNumber
        text: listNumberCurrent + "/" + listNumberTotal
        x: (menuBtnFlag == true) ? (subBtnFlag == true) ? (reserveBtnFlag == true) ? menuBtnX - (subBtnWidth) - 138 - 146 : menuBtnX - (subBtnWidth) - 146 : menuBtnX - 146 : (subBtnFlag == true) ? (reserveBtnFlag == true) ? backBtnX - (subBtnWidth) - 138 - 146 : backBtnX - (subBtnWidth) - 146 : backBtnX - 146
        y: tabBtnTextY - 30/2
        width: 146; height: 30
        font.pixelSize: 30
        font.family: systemInfo.font_NewHDB
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color:  "#7CBDFF" //RGB(124,189,255)
        visible: (listNumberFlag == true)
    }

    //****************************** # anything image #
    Image{
        source: signalImg
        x: signalImgX; y: signalImgY
        visible: (signalImgFlag == true)
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
            if(signalTextAlies == "Right"){Text.AlignRight}
            else if(signalTextAlies == "Left"){Text.AlignLeft}
            else if(signalTextAlies == "Center"){Text.AlignHCenter}
            else {Text.AlignRight}
        }
        verticalAlignment: Text.AlignVCenter
        elide: signalText2Line == true ? Text.ElideNone : Text.ElideRight
        wrapMode: signalText2Line == true ? Text.WordWrap : Text.NoWrap
        color: signalTextColor   //"#7CBDFF" //RGB(124,189,255)
        lineHeight: 0.75
        visible: (signalTextFlag == true)
    }

    //****************************** # Refresh Loading Image #
    Image {
        x: idRefreshLoading.x - 20 - 44  //1280 - 165 - txtSignal.paintedWidth - 20 - 44
        y: 108 - 93
        width: 44; height: 44
        source: imgFolderRadio_SXM + "loading/loading_01.png";
        visible: refreshLoadingFlag;
        NumberAnimation on rotation { running: idRefreshLoading.visible; from: 360; to: 0; loops: Animation.Infinite; duration: 2400 }
    }

    Text{
        id: idRefreshLoading
        text: stringInfo.sSTR_XMRADIO_REFRESH
        anchors.right: idBackBtn.left
        anchors.rightMargin: 165 - 141
        y: 108 - 93 + 5
        height: font.pixelSize
        font.pixelSize: 30
        font.family: systemInfo.font_NewHDR
        verticalAlignment: Text.AlignVCenter
        color: colorInfo.brightGrey
        visible: refreshLoadingFlag
    }

    //****************************** # ReseveBtn button #
    MButton{
        id: idReserveBtn
        x: (menuBtnFlag == true) ? (subBtnFlag == true) ? menuBtnX - (subBtnWidth) - 138 : menuBtnX - 138 : (subBtnFlag == true) ? backBtnX - (subBtnWidth) - 138 : alertBtnFlag ? 937 : backBtnX - 138
        width: alertBtnFlag ? 200 : 138; height: 72
        focus: (tabBtnFlag == false) && (reserveBtnFlag == true) ? true : false
        bgImage: alertBtnFlag ? imgFolderRadio_SXM + "btn_gamezone_alert_n.png" : imgFolderGeneral + "btn_title_sub_n.png"
        bgImageActive: alertBtnFlag ? imgFolderRadio_SXM + "btn_gamezone_alert_n.png" : imgFolderGeneral + "btn_title_sub_n.png"
        bgImagePress: alertBtnFlag ? imgFolderRadio_SXM + "btn_gamezone_alert_p.png" : imgFolderGeneral + "btn_title_sub_p.png"
        bgImageFocus: alertBtnFlag ? imgFolderRadio_SXM + "btn_gamezone_alert_f.png" : imgFolderGeneral + "btn_title_sub_f.png"
        visible: (reserveBtnFlag == true)

        onClickOrKeySelected: {
            idReserveBtn.focus = true
            reserveBtnClicked()
        }
        onPressAndHold: {
            reserveBtnPressAndHold()
        }

        firstText: reserveBtnText
        firstTextX: alertBtnFlag ? 20 : 9
        firstTextY: 129-systemInfo.statusBarHeight
        firstTextWidth: alertBtnFlag ? 100 : 123
        firstTextSize: 30
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextElide: "Right"
        buttonEnabled:alertBtnFlag ? true : (idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE" /*|| (!PLAYInfo.EnableTagging)*/) ? false : true

        fgImageX: alertBtnFlag ? 126 : 16
        fgImageY: alertBtnFlag ? 15 : 11
        fgImageWidth: alertBtnFlag ? 44 : 88
        fgImageHeight: alertBtnFlag ? 44 : 48
        fgImage: reserveBtnFgImage
        fgImageActive: reserveBtnFgImageActive
        fgImageFocus: reserveBtnFgImageFocus
        fgImageFocusPress: reserveBtnFgImageFocusPress
        fgImagePress: reserveBtnFgImagePress

        onWheelLeftKeyPressed: {
            if(tabBtnCount == 0){ /*idBackBtn.focus = true*/ } //jdh : Not used wraparound
            else if(tabBtnCount == 1){ idTabBtn1.focus = true }
            else if(tabBtnCount == 2){ idTabBtn2.focus = true }
            else if(tabBtnCount == 3){ idTabBtn3.focus = true }
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
        x: (menuBtnFlag == true) ? menuBtnX - (subBtnWidth) : backBtnX - (subBtnWidth)
        y: 0
        width: subBtnWidth; height: subBtnHeight
        focus: (tabBtnFlag == false) && (reserveBtnFlag == false) && (subBtnFlag == true) ? true : false
        bgImage: subBtnBgImage
        bgImagePress: subBtnBgImagePress
        bgImageFocus: subBtnBgImageFocus
        visible: (subBtnFlag == true)
        onClickOrKeySelected: {
            idSubBtn.focus = true
            subBtnClicked()
        }

        firstText: subBtnText
        firstTextX: 9;
        firstTextY: 129-systemInfo.statusBarHeight
        firstTextWidth: subBtnWidth - 15
        firstTextSize: 30
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextElide: "Right"
        buttonEnabled:(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") ? false:true

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
            if(idReserveBtn.visible /*&& PLAYInfo.EnableTagging*/){ idReserveBtn.focus = true }
            else if(tabBtnCount == 0){ /*idBackBtn.focus = true*/ } //jdh : Not used wraparound
            else if(tabBtnCount == 1){ idTabBtn1.focus = true }
            else if(tabBtnCount == 2){ idTabBtn2.focus = true }
            else if(tabBtnCount == 3){ idTabBtn3.focus = true }
        }
        onWheelRightKeyPressed: {
            if(idMenuBtn.visible){ idMenuBtn.focus = true }
            else{ idBackBtn.focus = true }
        } //# End onWheelRightKeyPressed
    } //# End MButton(idSubBtn)

    //****************************** # Menu button #
    MButton{
        id: idMenuBtn
        x: menuBtnX; y: menuBtnY
        width: menuBtnWidth; height: menuBtnHeight
        focus: (tabBtnFlag == false) && (reserveBtnFlag == false) && (subBtnFlag == false) && (menuBtnFlag == true && menuBtnEnabledFlag) ? true : false
        bgImage: imgFolderGeneral + "btn_title_sub_n.png"
        bgImagePress: imgFolderGeneral + "btn_title_sub_p.png"
        bgImageFocus: imgFolderGeneral + "btn_title_sub_f.png"
        visible: (menuBtnFlag == true)
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
        buttonEnabled: ((idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE") || !menuBtnEnabledFlag) ? false : true

        onWheelLeftKeyPressed: {
            if(idSubBtn.visible){ idSubBtn.focus = true }
            else if(idReserveBtn.visible){ idReserveBtn.focus = true }
            else{
                if(tabBtnFlag  ==  false){ idMenuBtn.focus = true }
                else if(tabBtnCount == 1){ idTabBtn1.focus = true }
                else if(tabBtnCount == 2){ idTabBtn2.focus = true }
                else if(tabBtnCount == 3){ idTabBtn3.focus = true }
            }
        } //# End onWheelLeftkeyPressed
        onWheelRightKeyPressed: {
            idBackBtn.focus = true
        } //# End onWheelRightKeyPressed
    } //# End MButton(idMenuBtn)

    //****************************** # BackKey button #
    MButton{
        id: idBackBtn
        x: backBtnX; y: backBtnY
        width: backBtnWidth; height: backBtnHeight
        focus: (tabBtnFlag == false) && (reserveBtnFlag == false) && (subBtnFlag == false) && (menuBtnFlag == false || (menuBtnFlag == true && !menuBtnEnabledFlag)) ? true : false
        bgImage: imgFolderGeneral + "btn_title_back_n.png"
        bgImagePress: imgFolderGeneral + "btn_title_back_p.png"
        bgImageFocus: imgFolderGeneral + "btn_title_back_f.png"

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
                if(tabBtnCount == 1){ idTabBtn1.focus = true }
                else if(tabBtnCount == 2){ idTabBtn2.focus = true }
                else if(tabBtnCount == 3){ idTabBtn3.focus = true }
            }
        } //# End onWheelLeftkeyPressed
        //        onWheelRightKeyPressed: {
        //            //Not used Wheel Left Key Press in SiriusXM Radio, as Save as preset and reorder preset
        //            if(idAppMain.gSXMEditPresetOrder == "TRUE" || idAppMain.gSXMSaveAsPreset == "TRUE")
        //                return;

        //            if(tabBtnFlag == true){ idTabBtn1.focus = true  }
        //            else{
        //                if(idReserveBtn.visible){ idReserveBtn.focus = true }
        //                else if(idSubBtn.visible){ idSubBtn.focus = true }
        //                else if(idMenuBtn.visible && menuBtnEnabledFlag){ idMenuBtn.focus = true }
        //            }
        //        } //# End onWheelRightkeyPressed
    } //# End MButton(idBackBtn)
}
