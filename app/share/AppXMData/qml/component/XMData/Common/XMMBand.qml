import QtQuick 1.1
//import Qt 4.7

import "../../system/DH" as MSystem
import "../../QML/DH" as MComp
import "../../XMData/Javascript/Definition.js" as MDefinition

Item{
    id: idContainer
    z: parent.z + 1

    property alias textTitle: txtTitle.text //idMBand.titleText //[user control] Title`s Label Text
    property alias textTitleForDeleteAll: txtTitleForDeleteAll.text
    property alias subTitleText: txtSubTitle.text //idMBand.subTitleText //[user control] Sub Title`s Label Text
    property alias subBtnText: idSubBtn.firstText //idMBand.subBtnText   //[user control] subBtn`s Text
    property bool subTitleFlag: false
    property bool subWSATitleFlag: false
    property bool locationBtnFlag: false
    property bool subBtnFlag: false//idMBand.subBtnFlag //[user control] Left button of backkey is On/Off (List button)
    property bool isWeekSubBtn: false
    property bool menuBtnFlag: true//idMBand.menuBtnFlag   //[user contral] menu button On/Off
    property bool enableMenuBtn: true
    property bool xmLogoFlag: false
    property bool titleFavoriteImg: false//idMBand.titleFavoriteImg   //[user control] star image
    property int foundItemCount: 0
    property bool sportFavText: false
    property bool checkDRSVisible: false// idAppMain.isDRSChange
    property bool checkKeypadShow: false
    property bool checkIsDownFocus: true;
    property bool subNoSignal: false;

    property alias visibleSearchTextInput: idSearchItem.visible
    property alias textSearchTextInput: idSearchTextInput.text
    property alias textSearchTextInputCursorPosition: idSearchTextInput.cursorPosition
    property alias imageSearchItemIcon: idSearchItemIcon.source

    property Item contentItem: null

    property alias idBandTop: idTopBand
    property alias idKeyPad: idLoaderQwertyKeypad

    property double intelliKey : 0xffffffff
    property int intelliUpdate: 0
    property int intelliDeleteUpdate: 0

    //*********************************** # Sports Score btn #
    property bool sportScoreBtnFlag: false
    property alias sportScroeBtnText: idSportScoreBtn.firstText

    property bool deleteAllNoFlag: txtTitleForDeleteAll.visible

    // 0000 0000 0000 0000 0000 0000 0000 0000  // true: disable, false: enable
    // 0000 00ZY XWVU TSRQ PONM LKJI HGFE DCBA

    onCheckDRSVisibleChanged:
    {
        if(visible)
        {
            if(checkDRSVisible)
            {
                idTopBand.KeyNavigation.down = null;

                if(idLoaderQwertyKeypad.item)
                {
                    if(idLoaderQwertyKeypad.item.isHide() == false)
                    {
                        checkKeypadShow = true;
                    }
                }
                if(idSearchPreText.visible == false && checkKeypadShow == false)
                {
                    qwertyKeypadOnOff(false);
                }
                idTopBand.forceActiveFocus();
                idMBand.focus = true;
                idContainer.focusDrsRight();
            }
            else
            {
                if(idSearchItem.visible == true)
                {
                    if(idSearchPreText.visible)
                    {
                        idTopBand.KeyNavigation.down = idKeyPad
                        checkKeypadShow = false;
                    }
                    else
                    {
                        idTopBand.KeyNavigation.down = idContainer.contentItem;
                        checkKeypadShow = false;
                    }
                }
                else
                {
                    if(contentItem != null && checkIsDownFocus)
                    {
                        idTopBand.KeyNavigation.down = idContainer.contentItem;
                    }
                }
            }
        }
    }

    function qwertyKeypadOnOff(isOn)
    {
        if(idLoaderQwertyKeypad.item)
        {
            if(idLoaderQwertyKeypad.item.isHide())
            {
                if(isOn == true)
                {
                    idLoaderQwertyKeypad.item.showQwertyKeypad();
                }
            }else
            {
                if(isOn == false && checkKeypadShow == false)
                {
                    idLoaderQwertyKeypad.item.hideQwertyKeypad();
                }
            }
        }
    }

    //for Navigation Down Exception
    onTextTitleChanged: {
        switch(textTitle)
        {
            case stringInfo.sSTR_XMDATA_WEATHER:
                idTopBand.KeyNavigation.down = null;
                break;
            default:
                idTopBand.KeyNavigation.down = contentItem;
                break;
        }
        if(checkDRSVisible)
        {
            idTopBand.KeyNavigation.down = null;
        }
        checkIsDownFocus = true;
    }

    Component.onCompleted: {
        if(contentItem != null)
        {
            contentItem.KeyNavigation.up = idTopBand;
        }
        focusPriority();
    }

    FocusScope{
        id: idTopBand
        focus: true

        //****************************** # Band Background Image #
        Image{
            x: 0; y: 0
            width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight
            source: imageInfo.imgFolderGeneral+"bg_title.png"
        }

        // for debug///////////////////////////////////////////////////
        MouseArea {
            x: 0; y: 0
            width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight
            onClicked: {
                if(isDebugMode())
                    printAllItems(idContainer.parent);
                mouse.accepted = false;
            }
            onPressAndHold: {
                if(isDebugVersion)
                    idAppMain.debugOnOff = (idAppMain.debugOnOff)?false:true;
                else
                    idAppMain.debugOnOff = false;
            }
        }


        //****************************** # star image of Title front #
        Image{
            source: (titleFavoriteImg==true)? imageInfo.imgFolderXMData+"ico_title_fav.png" : ""
            x: 25; y: 104-systemInfo.statusBarHeight
            width: 48; height: 48
            visible: (titleFavoriteImg==true)
        }

        Image{
            source: (xmLogoFlag==true)? imageInfo.imgFolderXMData+"logo_travellink.png" : ""
            x: 43; y: 4
            visible: (xmLogoFlag==true)
        }

        //****************************** # Title Text #
        MComp.DDScrollTicker{
            id: txtTitle
            text: (!sportFavText)? txtTitle.text :textTitle
            x: (titleFavoriteImg==true)? 25+58:(xmLogoFlag==true) ? 43+74 : 46;
            y: 129-systemInfo.statusBarHeight-50/2
            width: (idMenuBtn.visible ? idMenuBtn.x : idBackBtn.x ) - x - 10;
            height: 50
            fontSize: 40
            fontFamily: systemInfo.font_NewHDB
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.brightGrey
            tickerEnable: true
            tickerFocus: idTopBand.activeFocus
            visible: true
        }

        onActiveFocusChanged: {
            if(idSearchItem.visible == true)
            {
                if(activeFocus)
                {
                    idSearchTextImage.focus = true;
                    if(checkDRSVisible == false)
                    {
                        qwertyKeypadOnOff(true);
                    }
                }else
                {
                    qwertyKeypadOnOff(false);
                }
            }
        }

        Text{
            id: txtTitleForDeleteAll
            text: textTitleForDeleteAll
            x: txtTitle.textPaintedWidth + 23 + 15 + 17;
            y: 130-systemInfo.statusBarHeight-font.pixelSize/2
            width: 146
            height: 30
            font.pixelSize: 30
            font.family: systemInfo.font_NewHDB
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.bandBlue
            visible: deleteAllNoFlag ? true : false
        }

        //****************************** # Sub Title Text #
        MComp.DDScrollTicker{
            id: txtSubTitle
            x: (titleFavoriteImg==true)? 25+58+txtTitle.textPaintedWidth+23 : 45+txtTitle.textPaintedWidth+23;
            y: 129-systemInfo.statusBarHeight-50/2//[ITS 188440]
            width: locationBtnFlag ? idLocationBtn.x - 13 - txtSubTitle.x :
                                     subBtnFlag ? idSubBtn.x - 13 - txtSubTitle.x :
                                                  menuBtnFlag ? idMenuBtn.x - 13 - txtSubTitle.x :
                                                                idBackBtn.x - 13 - txtSubTitle.x
            height: 50//[ITS 188440]
            text: subTitleText
            fontFamily : systemInfo.font_NewHDR
            fontSize: 40
            color: colorInfo.dimmedGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            tickerEnable: true
            tickerFocus: idTopBand.activeFocus
            visible: subTitleFlag
        }

        Text{
            id: txtWSASubTitle
            text: subTitleText
            x: txtTitle.x + txtTitle.textPaintedWidth + 34
            y: 129-systemInfo.statusBarHeight-40/2
            height: 40
            font.pixelSize: 40
            font.family: systemInfo.font_NewHDR
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: colorInfo.dimmedGrey
            elide: Text.ElideRight
            visible: subWSATitleFlag
        }

        Text{
            id: txtNoSignal
            text: stringInfo.sSTR_XMDATA_LOSS_OF_SIGNAL
            x: 710
            y: 0
            width: 190
            height: systemInfo.titleAreaHeight
            font.pixelSize: 28
            font.family: systemInfo.font_NewHDR
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: "red"
            visible: (subNoSignal && idAppMain.isNoSignalStatus)
        }

        Item{
            id: idSearchItem
            anchors.fill: parent
            visible: false
            enabled: (checkDRSVisible == false)

            onVisibleChanged: {
                if( visible == true ){
                    menuBtnFlag = false;
                    idSearchTextInput.text = "";
                    foundItemCount = 0;
                    idContainer.z = idContainer.z + 2;
                    idLoaderQwertyKeypad.sourceComponent = idCompQwertyKeypad;
                    if(checkDRSVisible)
                    {
                        idTopBand.KeyNavigation.down = null;
                    }
                    else
                    {
                        contentItem.KeyNavigation.down = idKeyPad;
                        idKeyPad.forceActiveFocus();
                    }
                }else
                {
                    menuBtnFlag = true;
                    idLoaderQwertyKeypad.item.outputText = "";
                    idContainer.z = idContainer.z - 2;
                    idLoaderQwertyKeypad.sourceComponent = null;
                    contentItem.KeyNavigation.down = null;
                    checkKeypadShow = false;
                }
            }
            MouseArea{
                x: 0
                y: systemInfo.titleAreaHeight
                width: systemInfo.lcdWidth
                height: idLoaderQwertyKeypad.sourceComponent == null ? 0 : idLoaderQwertyKeypad.item.isHide() ? 0 : systemInfo.lcdHeight - (systemInfo.titleAreaHeight + idLoaderQwertyKeypad.item.height)
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton
                onPressed: {
                    mouse.accepted = false;
                    if(foundItemCount > 0)
                    {
                        qwertyKeypadOnOff(false);
                        contentItem.focus = true;
                    }
                }
            }

            MComp.MButton{
                property bool focusEnable: true
                property bool cursorNavi: true
                property Item leftItem: null
                property Item rightItem: null

                id: idSearchTextImage
                x:7; y:0; width: 990; height: 69

                bgImage: imageInfo.imgFolderKeypad + "bg_search_m.png"

                Text{
                    id:idSearchPreText
                    x: /*101*/38; y: 9
                    width: 693
                    height: parent.height
                    text: stringInfo.sSTR_XMDATA_SEARCH
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 32
                    color : colorInfo.dimmedGrey//colorInfo.disableGrey
                    horizontalAlignment: Text.AlignLeft
//                    verticalAlignment: Text.AlignVCenter
                    visible: !idSearchTextInput.text.length

                    //[ITS 217978]
                    onVisibleChanged: {
                        if(visible == true)
                            idTopBand.KeyNavigation.down = idKeyPad/*null*/;
                        else
                            idTopBand.KeyNavigation.down = idContainer.contentItem;
                    }
                }

                TextInput {
                    id: idSearchTextInput
                    x: /*101*/33; y: 9
                    width: 693;
                    height: parent.height
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 32
                    color : colorInfo.buttonGrey
                    cursorDelegate: idSearchTextImage.activeFocus ? idFocusCursorDelegate : idCursorDelegate
                    horizontalAlignment: TextInput.AlignLeft
                    activeFocusOnPress : false
                    text: ""
                    MouseArea{
                        anchors.fill: parent
                        onPressed: {
                            idSearchTextImage.forceActiveFocus();
                            qwertyKeypadOnOff(true);
                        }
                    }
                }
                Component{
                    id: idCursorDelegate
                    Item {
                        MSystem.ImageInfo {id: imageInfo }
                        Image {
                            id: idDelegateCursorImage
                            x: 0; y: 4
                            width: 4; height: 47
                            source: imageInfo.imgFolderKeypad + "cursor_n.png";

                            SequentialAnimation {
                                running: idDelegateCursorImage.visible
                                loops: Animation.Infinite;

                                NumberAnimation { target: idDelegateCursorImage; property: "opacity"; to: 1; duration: 100 }
                                PauseAnimation  { duration: 500 }
                                NumberAnimation { target: idDelegateCursorImage; property: "opacity"; to: 0; duration: 100 }
                            }
                        }
                    }

//                    Item{
//                        MSystem.ImageInfo {id: imageInfo }
//                        Image {
//                            id: idCursor
//                            x: 0; y: 5
//                            width: 4; height: 47
//                            source: imageInfo.imgFolderKeypad + "cursor.png"
//                        }
//                        Image {
//                            id: idMarker
//                            x: -19; y: 5+47
//                            source: imageInfo.imgFolderKeypad + "ico_marker.png"
//                            visible: false//[ITS 216957]
//                        }
//                        Timer{
//                            id: idCursorTimer
//                            interval: 500
//                            repeat: true
//                            running: idCursor.visible
//                            triggeredOnStart: false
//                            onTriggered: {
//                                if(idCursor.opacity == 0)
//                                    idCursor.opacity = 1.0;
//                                else
//                                    idCursor.opacity = 0;
//                            }
//                        }
//                        Timer{
//                            id: idMarkerTimer
//                            interval: 5000
//                            repeat: false
//                            running: idMarker.visible
//                            triggeredOnStart: false
//                            onTriggered: {
//                                idMarker.visible = false
//                            }
//                        }
//                        onXChanged: {
//                            idMarker.visible = true
//                            idMarkerTimer.restart();
//                        }
//                    }
                }
                Component{
                    id: idFocusCursorDelegate
                    Item {
                        MSystem.ImageInfo {id: imageInfo }
                        Image {
                            id: idDelegateCursorImage
                            x: 0; y: 4
                            width: 4; height: 47
                            source: imageInfo.imgFolderKeypad + "cursor_f.png";

                            SequentialAnimation {
                                running: idDelegateCursorImage.visible
                                loops: Animation.Infinite;

                                NumberAnimation { target: idDelegateCursorImage; property: "opacity"; to: 1; duration: 100 }
                                PauseAnimation  { duration: 500 }
                                NumberAnimation { target: idDelegateCursorImage; property: "opacity"; to: 0; duration: 100 }
                            }
                        }
                    }
                }

                Image {
                    id: idSearchItemIcon
                    anchors.verticalCenter: parent.verticalCenter
                    x: 101 + 624 + (idSearchItemCount.width - idSearchItemCount.paintedWidth); y: 0
                    fillMode: Image.PreserveAspectFit
                    source: imageSearchItemIcon
                    visible: foundItemCount && idSearchTextInput.text.length
                }
                Text{
                    id:idSearchItemCount
                    x: 101 + 662; y: 0
                    width: 214
                    height: parent.height
                    text: foundItemCount/* == 1 ? foundItemCount + " " + stringInfo.sSTR_XMDATA_ITEM : foundItemCount + " " + stringInfo.sSTR_XMDATA_ITEMS*/
                    font.family: systemInfo.font_NewHDB
                    font.pixelSize: 30
                    color : colorInfo.disableGrey
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    visible: foundItemCount && idSearchTextInput.text.length
                }

                onVisibleChanged: {
                    idContainer.focusPriority();
                }

                Keys.onLeftPressed: {
//                    console.log("===============[Keys.onLeftPressed]==============");
                    if(idSearchTextButton.enabled == false)
                    {
                        idBackBtn.focus = false;
                        if(idSearchTextImage.activeFocus)
                            leftItem = null;
                        else
                            leftItem = idSearchTextImage;
                    }
                    else
                        leftItem = null;

                    if(leftItem != null)
                        leftItem.forceActiveFocus();
                }

                Keys.onRightPressed: {
//                    console.log("===============[Keys.onRightPressed]==============");
                    if(idSearchTextButton.enabled == false)
                    {
                        idSearchTextButton.focus = false;
                        rightItem = idBackBtn;
                    }
                    else
                        rightItem = idSearchTextButton;

                    rightItem.forceActiveFocus();
                }

                onClickOrKeySelected: {
                    idLoaderQwertyKeypad.forceActiveFocus();
                }
            }

            MComp.MButton {
                property bool focusEnable: true
                property Item leftItem: null
                property Item rightItem: null

                id: idSearchTextButton
                focus: false
                x:7+990 ; y:1
                width: 141; height: 72
                bgImage: imageInfo.imgFolderGeneral + "btn_title_sub_n.png"
                bgImagePress: imageInfo.imgFolderGeneral+"btn_title_sub_p.png"
                bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_title_sub_fp.png"
                bgImageFocus: imageInfo.imgFolderGeneral+"btn_title_sub_f.png"

                fgImageX: 41
                fgImageY: 6
                fgImageWidth: 60
                fgImageHeight: 60
                fgImage: imageInfo.imgFolderKeypad+"icon_title_search_n.png"
                enabled: checkDRSVisible ? false : foundItemCount > 0 ? true : false

                onClickOrKeySelected: {
                    idTopBand.KeyNavigation.down.forceActiveFocus();
                }
                onClicked: {
                    UIListener.playAudioBeep();
                }
                onVisibleChanged: {
                    idContainer.focusPriority();
                }

                Keys.onLeftPressed: {
                    if(idSearchItem.visible == true)
                    {
                        idSearchTextButton.focus = false;
                        idSearchTextImage.focus = true;
                    }
                }

                onWheelRightKeyPressed: {
                    if(rightItem != null)
                        rightItem.forceActiveFocus();
                } //# End onWheelRightKeyPressed
            }
        }// idSearchItem

        Item{
            id: idMBand
            x: 0; y: 0
            width: systemInfo.lcdWidth; height: systemInfo.titleAreaHeight
            focus: true
            //****************************** # locationBtn button #
            MComp.MButton{
                property bool focusEnable: true
                property Item leftItem: null
                property Item rightItem: null

                id: idLocationBtn
                x: subBtnFlag ? idSubBtn.x - 138 :
                                menuBtnFlag ? idMenuBtn.x - 138 :
                                              idBackBtn.x - 138
                y: 1
                width: 141
                height: 72
                bgImage: imageInfo.imgFolderGeneral + "btn_title_sub_n.png"
                bgImagePress: imageInfo.imgFolderGeneral+"btn_title_sub_p.png"
                bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_title_sub_fp.png"
                bgImageFocus: imageInfo.imgFolderGeneral+"btn_title_sub_f.png"
                visible: (locationBtnFlag==true)
                onClickOrKeySelected: {
                    onLocationPressed();
                }

                fgImageX: (138-49)/2
                fgImageY: (72-56)/2
                fgImageWidth: 49
                fgImageHeight: 56
                fgImage: imageInfo.imgFolderXMData + "ico_title_location.png"
                fgImageVisible: true


                onWheelLeftKeyPressed: {
                    if(leftItem != null)
                        leftItem.forceActiveFocus();
                } //# End onWheelLeftkeyPressed
                onWheelRightKeyPressed: {
                    if(rightItem != null)
                        rightItem.forceActiveFocus();
                } //# End onWheelRightKeyPressed

                onVisibleChanged: {
                    focusPriority();
                }
            } //# End MButton(idSubBtn)
            //****************************** # subBtn button #
            MComp.MButton{
                property bool focusEnable: true
                property Item leftItem: null
                property Item rightItem: null

                id: idSubBtn
                y: 1
                x: 917//isWeekSubBtn && menuBtnFlag ? 920-72 : menuBtnFlag ? 920 : 779+18/*43+74+680+140-(121)*/; y: 0
                width: isWeekSubBtn ? 193:222; height: 72
                bgImage: isWeekSubBtn? imageInfo.imgFolderXMData+"btn_title_week_n.png":imageInfo.imgFolderXMData+"btn_sub_n.png"
                bgImagePress: isWeekSubBtn? imageInfo.imgFolderXMData+"btn_title_week_p.png":imageInfo.imgFolderXMData+"btn_sub_p.png"
                bgImageFocusPress: isWeekSubBtn? imageInfo.imgFolderXMData+"btn_title_week_fp.png":imageInfo.imgFolderXMData+"btn_sub_fp.png"
                bgImageFocus: isWeekSubBtn? imageInfo.imgFolderXMData+"btn_title_week_f.png":imageInfo.imgFolderXMData+"btn_sub_f.png"
                visible: (subBtnFlag==true)
                onClickOrKeySelected: {
                    onTitleOption();
                }

                firstText: subBtnText
                firstTextX: 9; //firstTextY: 37
                firstTextSize: 30
                firstTextStyle: systemInfo.font_NewHDB
                firstTextColor: colorInfo.brightGrey

                onWheelLeftKeyPressed: {
                    if(leftItem != null)
                        leftItem.forceActiveFocus();
                } //# End onWheelLeftkeyPressed
                onWheelRightKeyPressed: {
                    if(rightItem != null)
                        rightItem.forceActiveFocus();
                } //# End onWheelRightKeyPressed

                onVisibleChanged: {
                    focusPriority();
                }
            } //# End MButton(idSubBtn)

            //****************************** # sportScore button #
            MComp.MButton{
                property bool focusEnable: true
                property Item leftItem: null
                property Item rightItem: null

                id: idSportScoreBtn
                x: (menuBtnFlag)?idMenuBtn.x - width + 3:947; y: 1
                width: 193; height: 72
                bgImage: imageInfo.imgFolderXMData+"btn_title_week_n.png"
                bgImagePress: imageInfo.imgFolderXMData+"btn_title_week_p.png"
                bgImageFocusPress: imageInfo.imgFolderXMData+"btn_title_week_fp.png"
                bgImageFocus: imageInfo.imgFolderXMData+"btn_title_week_f.png"
                visible: (sportScoreBtnFlag==true)
                enabled: (checkDRSVisible == false)
                onClickOrKeySelected: {
                    onScoreScheduleToggle();
                }

                firstText: "Score"
                firstTextX: 5; //firstTextY: 37
                firstTextSize: 30
                firstTextStyle: systemInfo.font_NewHDB
                firstTextColor: colorInfo.brightGrey

                onWheelLeftKeyPressed: {
                    if(leftItem != null)
                        leftItem.forceActiveFocus();
                } //# End onWheelLeftkeyPressed
                onWheelRightKeyPressed: {
                    if(rightItem != null)
                        rightItem.forceActiveFocus();
                } //# End onWheelRightKeyPressed

                onVisibleChanged: {
                    focusPriority();
                }
            } //# End MButton(idSubBtn)

            //****************************** # Menu button #
            MComp.MButton{
                property bool focusEnable: true
                property Item leftItem: null
                property Item rightItem: null

                id: idMenuBtn
                x: 860+138; y: 1
                width: 141; height: 72
                bgImage: imageInfo.imgFolderGeneral+"btn_title_sub_n.png"
                bgImagePress: imageInfo.imgFolderGeneral+"btn_title_sub_p.png"
                bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_title_sub_fp.png"
                bgImageFocus: imageInfo.imgFolderGeneral+"btn_title_sub_f.png"
                visible: menuBtnFlag
                enabled: checkDRSVisible ? false : enableMenuBtn
                onClickOrKeySelected: {
                    onOptionOnOff();
                }

                firstText: parent.visibleSearchTextInput ? "": stringInfo.sSTR_XMDATA_MENU
                firstTextX: 9 + 10; //firstTextY: 37
                firstTextSize: 30
                firstTextStyle: systemInfo.font_NewHDB
                firstTextColor: colorInfo.brightGrey


                onWheelLeftKeyPressed: {
                    if(leftItem != null)
                        leftItem.forceActiveFocus();
                } //# End onWheelLeftkeyPressed
                onWheelRightKeyPressed: {
                    if(rightItem != null)
                        rightItem.forceActiveFocus();
                } //# End onWheelRightKeyPressed

                onVisibleChanged: {
                    focusPriority();
                }
                onEnabledChanged: {
                    focusEnable = enabled ? true : false;
                    focusPriority();
                }
            } //# End MButton(idMenuBtn)

            //****************************** # BackKey button #
            MComp.MButton{
                property bool focusEnable: true
                property Item leftItem: null
                property Item rightItem: null

                id: idBackBtn
                x: 860+138+138; y: 1
                width: 141; height: 72
                bgImage: imageInfo.imgFolderGeneral+"btn_title_back_n.png"
                bgImagePress: imageInfo.imgFolderGeneral+"btn_title_back_p.png"
                bgImageFocusPress: imageInfo.imgFolderGeneral+"btn_title_back_fp.png"
                bgImageFocus: imageInfo.imgFolderGeneral+"btn_title_back_f.png"

                onClickOrKeySelected: {
                    if(playBeepOn)
                        gotoBackScreen(true);//touch
                    else
                        gotoBackScreen(false);//CCP
                }

                Keys.onLeftPressed: {
                    if(idSearchItem.visible == true)
                    {
                        if(checkDRSVisible == false)
                        {
                            idBackBtn.focus = false;
                            idSearchTextImage.focus = true;
                        }
                    }
                }

                onWheelLeftKeyPressed: {
                    if(leftItem != null)
                        leftItem.forceActiveFocus();
                } //# End onWheelLeftkeyPressed
                onWheelRightKeyPressed: {
                    if(rightItem != null)
                        rightItem.forceActiveFocus();
                } //# End onWheelRightKeyPressed
                onVisibleChanged: {
                    focusPriority();
                }
            } //# End MButton(idBackBtn)

        }

    }

    Loader{id:idLoaderQwertyKeypad; /*sourceComponent:idCompQwertyKeypad*/
        onActiveFocusChanged: {
            qwertyKeypadOnOff(activeFocus);
        }
    }


    Component{
        id:idCompQwertyKeypad
        MComp.QwertyKeypad {
            id: idQwertyKeypad
            qX: 0
            qY: 320- systemInfo.headlineHeight+systemInfo.titleAreaHeight //268+66-166+systemInfo.titleAreaHeight
            visible: idSearchItem.visible
            focus: true
            currentCursor:idMenuBar.textSearchTextInputCursorPosition
            intelliKeyFlag: idMenuBar.intelliKey

            onOutputTextChanged: {
                textSearchTextInput = outputText;
            }
            onOutputCursorChanged: {
                textSearchTextInputCursorPosition = outputCursor;
            }

            onKeyNaviUp: {
                idSearchTextImage.forceActiveFocus();
            }
            onKeyNaviDown: {

            }

            onHomeKeyPressed: {
                gotoFirstScreen();
            }

            onBackKeyPressed: {
                gotoBackScreen(false);//CCP
            }

            onKeyOKClicked: {
                if(foundItemCount > 0)
                {
                    contentItem.forceActiveFocus();
                }else
                {
                    idSearchTextImage.forceActiveFocus();
                    idLoaderQwertyKeypad.item.hideQwertyKeypad();
                }
            }

            onKeyHideClicked: {
                if(0 < idSearchTextInput.text.length)
                    idTopBand.KeyNavigation.down.forceActiveFocus();
                else
                    idSearchTextImage.forceActiveFocus();

                idLoaderQwertyKeypad.item.hideQwertyKeypad();
            }

            onIntelliKeyboardUpdate: {
                intelliUpdate++;
            }
            onIntelliKeyboardDeleteUpdate: {
                if(state)
                {
                    intelliDeleteUpdate = intelliUpdate;
                    intelliUpdate = 0;
                }
                else
                {
                    intelliUpdate = intelliDeleteUpdate;
                    intelliDeleteUpdate = 0;
                }
            }
        }// idQwertyKeypad
    }

    function focusPriority()
    {
        var focusItems = new Array();
        var visiblecount = 0

        for(var i = 0; i < idTopBand.children.length; i++)
        {
            if(idTopBand.children[i].visible)
            {
                var mainChildItem = idTopBand.children[i];
                for(var j = 0; j < mainChildItem.children.length; j++)
                {
                    if(mainChildItem.children[j].focusEnable == true && mainChildItem.children[j].visible)
                    {
                        focusItems[visiblecount] = mainChildItem.children[j];
                        visiblecount++;
                    }
                }
            }
        }

        if(visiblecount != 0)
        {
            var hasFocus = false;
            for(var i = 0 ; i < visiblecount; i++)
            {
//                focusItems[i].leftItem = (i-1) < 0 ? focusItems[visiblecount-1] : focusItems[i-1];
//                focusItems[i].rightItem = (i+1) >= visiblecount ? focusItems[0] : focusItems[i+1];
                focusItems[i].leftItem = (i-1) < 0 ? null : focusItems[i-1];
                focusItems[i].rightItem = (i+1) >= visiblecount ? null : focusItems[i+1];

                if(focusItems[i].focus == true)
                    hasFocus = true;
            }
            if(hasFocus == false)
                focusItems[0].focus = true;
        }
    }

    function focusInitLeft()
    {
        var focusItems = new Array();
        var visiblecount = 0

        for(var i = 0; i < idTopBand.children.length; i++)
        {
            if(idTopBand.children[i].visible)
            {
                var mainChildItem = idTopBand.children[i];
                for(var j = 0; j < mainChildItem.children.length; j++)
                {
                    if(mainChildItem.children[j].focusEnable == true && mainChildItem.children[j].visible)
                    {
                        focusItems[visiblecount] = mainChildItem.children[j];
                        if(visiblecount == 0)
                        {
                            focusItems[0].focus = true;
                        }
                        else
                        {
                            focusItems[visiblecount].focus = false;
                        }
                        visiblecount++;
                    }
                }
            }
        }
    }

    function focusDrsRight()
    {
        var focusItems = new Array();
        var visiblecount = 0

        for(var i = 0; i < idTopBand.children.length; i++)
        {
            if(idTopBand.children[i].visible)
            {
                var mainChildItem = idTopBand.children[i];
                for(var j = 0; j < mainChildItem.children.length; j++)
                {
                    if(mainChildItem.children[j].focusEnable == true && mainChildItem.children[j].visible)
                    {
                        focusItems[visiblecount] = mainChildItem.children[j];
                        if(focusItems[visiblecount].rightItem == null)
                        {
                            focusItems[visiblecount].focus = true;
                        }
                        else
                        {
                            focusItems[visiblecount].focus = false;
                        }
                        visiblecount++;
                    }
                }
            }
        }
    }

    property int depth: 0
    function printAllItems(root)
    {
        depth++;
        console.debug("--------"+root.toString()+"------start---");
        for(var i = 0; i < root.children.length; i++)
        {
            var c = "";
            for(var j = 0; j < depth; j++)
                c  = c + ">";
            if(root.children[i].visible == true)
            {
                console.debug(c + " " + root.children[i].toString() + "[" + root.children[i].debugname + "]" +  "[f:" + root.children[i].focus + "]" + "[af:" + root.children[i].activeFocus + "]");
            }
            if(root.children[i].children.length > 0)
            {
                printAllItems(root.children[i]);
            }
        }
        console.debug("--------"+root.toString()+"------end---");
        depth--;
    }
    ///////////////////////////////////////////////////////////////
}
