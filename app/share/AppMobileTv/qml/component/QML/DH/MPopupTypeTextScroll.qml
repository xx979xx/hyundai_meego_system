/**
 * FileName: PopupTypeTextScroll.qml
 * Author: HYANG
 * Time: 2013-02-02
 *
 * - 2013-02-02 Initial Created by HYANG
 */

import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComponent{
    id: idMPopupTypeTextScroll
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    property string imgFolderPopup: imageInfo.imgFolderPopup

    // # Popup Info
    property string popupBgImage: imgFolderPopup+"bg_type_b.png"
    property int popupBgImageX: 93
    property int popupBgImageY: 171-systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: 379
    property int popupBgImageLeftMargine: 18
    property int popupBgImageTopMargine: 18
    
    // # Content Focus Info
    property string contentsFocusImage: imgFolderPopup+"bg_type_b_f.png"
    property int contentsFocusImageX: popupBgImageX + popupBgImageLeftMargine
    property int contentsFocusImageY: popupBgImageY + popupBgImageTopMargine
    property int contentsFocusImageWidth: 797
    property int contentsFocusImageHeight: 343

    //property int itemHeight: 76 + (popupTextSpacing*4) - popupFirstTextSize/2
    property int itemHeight: (popupFirstTextSpacing*6) //+ (popupFirstTextSpacing/2)

    // # Text Info
    property int popupTextX: popupBgImageX + 78
    property int popupTextSpacing: 52
    property string popupFirstText: ""
    property int popupFirstTextWdith: popupFlickableTextWdith
    property int popupFlickableTextWdith: 654
    property int popupFirstTextSize: 32
    property string popupFirstTextStyle: idAppMain.fontsR
    property string popupFirstTextColor: colorInfo.brightGrey
    property int popupFirstTextSpacing: 48//44

    // # Button Info
    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""
    property int popupButtonX: popupBgImageX + 780
    property int popupButton1Y: popupBgImageY + popupBgImageTopMargine
    property int popupButton2Y: popupBgImageY + popupBgImageTopMargine + popupButtonHeight
    property int popupButtonWidth: 295
    property int popupButtonHeight: 171
    property int popupButtonTextX: 832 - 780
    property int popupButtonText1Y: 107 - popupButtonTextSize/2
    property int popupButtonText2Y: popupButtonText1Y//164 - popupButtonText1Y
    property int popupButtonTextWidth: 210
    property int popupButtonTextHeight: 36
    property int popupButtonTextSize: 36
    property string popupButtonTextStyle: idAppMain.fontsB
    property string popupButtonTextHorizontalAlies: "Center"
    property string popupButtonTextColor: colorInfo.brightGrey

    // # Icon Image Info
    property int popupIconX: 773 - 780
    property int popupIcon1Y: 72 - popupBgImageTopMargine
    property int popupIcon2Y: popupIcon1Y//164 - popupIcon1Y
    property int popupIconWidth: 69
    property int popupIconHeight: 69
    property string popupIconImage: imgFolderPopup+"light.png"


    property int popupBtnCnt: 2    //# 1 or 2
    property int overContentCount: 0

    signal popupClicked();
    signal popupBgClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    property alias buttonFocus1: idButton1.focus;
    property alias buttonFocus2: idButton2.focus;

    function focusTextArea(){
        idText.focus = true;
        idFlickable.contentY = 0
    }

    function focusButton1(){
        idButtonGroup.focus = true;
        idButton1.focus = true;
    }

    function unFocusButtonGroup(){
        idButtonGroup.focus = false;
        idButton1.focus = false;
        idButton2.focus = false;
        EngineListener.updateFocusQML();
        //idText.focus = true;
    }

    Component.onCompleted:{ focusButton1() }
    onActiveFocusChanged: {
//        if(idMPopupTypeTextScroll.activeFocus == true) focusButton1()
//        else unFocusButtonGroup()
    }

    onVisibleChanged: {
        if( visible == true)
            focusButton1();
    }

    // # Background mask click #
//    onClickOrKeySelected: {
//        if(pressAndHoldFlag == false){
//            popupBgClicked()
//        }
//    }
//    onClickReleased: {
//        if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
//    }

    // # Background mask #
    Rectangle{
        width: parent.width; height: parent.height+systemInfo.statusBarHeight
        y:0-systemInfo.statusBarHeight
        color: colorInfo.black
        opacity: 0.6

        MouseArea{
            anchors.fill: parent
        }
    }

    Image{
        id: bgImgae
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        source: popupBgImage
    }

    // # Popup image click #
    MButton{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        bgImage: popupBgImage
//        onClickOrKeySelected: {
//            if(pressAndHoldFlag == false){
//                popupClicked();
//            }
//        }
//        onClickReleased: {
//            if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
//        }
    }

    // # Popup left Focus Image
    Image {
        id: idFocusImage
        x: contentsFocusImageX
        y: contentsFocusImageY
        width: contentsFocusImageWidth
        height: contentsFocusImageHeight
        source: contentsFocusImage
        visible: showFocus && idText.activeFocus
    }

    MComponent{
        id: idText
        x: popupTextX; y: popupBgImageY + ((popupBgImageHeight-itemHeight-1) / 2) //76 - 32/2
        width: 213 + 30 + 420; height: itemHeight
        KeyNavigation.right: idButtonGroup

        Flickable{
            id: idFlickable
            contentX: 0; contentY: 0
            contentWidth: popupFlickableTextWdith;
            contentHeight: idFirstText.paintedHeight
            flickableDirection: Flickable.VerticalFlick;
            boundsBehavior :  (itemHeight < idFirstText.paintedHeight)? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds//Flickable.DragOverBounds//Flickable.StopAtBounds
            anchors.fill: parent;
            clip: true

            // # Text (firstText, secondText, thirdText, fourthText) #
            TextEdit{
                id: idFirstText
                text: popupFirstText
                x: 0; y: 0
                width: popupFirstTextWdith; height: idFlickable.height
                font.pixelSize: popupFirstTextSize
                font.family: popupFirstTextStyle
                horizontalAlignment: Text.AlignLeft            
                color: popupFirstTextColor
                wrapMode : TextEdit.Wrap
                onCursorRectangleChanged : idFlickable.ensureVisible(cursorRectangle)
                readOnly: true
                cursorVisible: false
            }            

            onContentYChanged:{                
                //overContentCount = contentY/(contentHeight/flickableDirection)
                overContentCount = contentY / (contentHeight / idRoundScroll.listCount)
            }

            function ensureVisible(r)
            {
                if (contentX >= r.x)
                    contentX = r.x;
                else if (contentX+width <= r.x+r.width)
                    contentX = r.x+r.width-width;
                if (contentY >= r.y)
                    contentY = r.y;
                else if (contentY+height <= r.y+r.height)
                    contentY = r.y+r.height-height;
            }
        }

        onActiveFocusChanged: { if(idText.focus == true) idFlickable.contentY = 0 }
    }

    MComp.MRoundScroll{
        id: idRoundScroll
        x: popupBgImageX + 760  //popupBgImageX + 760 - popupBgImageLeftMargine;
        y: popupBgImageY + 35
        scrollWidth: 39; scrollHeight: 306
        scrollBgImage: imgFolderPopup + "scroll_bg.png"
        scrollBarImage :  imgFolderPopup + "scroll.png"
        listCount: idFlickable.contentHeight / popupFirstTextSpacing
        listCountOfScreen: itemHeight / popupFirstTextSpacing
        moveBarHeight: (scrollHeight / listCount) * listCountOfScreen
        moveBarPosition: scrollHeight / listCount * overContentCount

        //moveBarHeight: itemHeight / (idFlickable.contentHeight / idFlickable.height) + popupFirstTextSize
        //moveBarPosition: moveBarHeight / idFlickable.flickableDirection * overContentCount
        //listCountOfScreen: itemHeight
        //listCount: idFirstText.paintedHeight
        visible: (itemHeight < idFirstText.paintedHeight)
    }

    // # Popup Button #
    MComponent{
        id: idButtonGroup
        focus: true
        KeyNavigation.left: idText

        MButton{
            id: idButton1
            x: popupBgImageX + 780
            y: popupBgImageY + popupBgImageTopMargine
            width: popupButtonWidth
            height: popupButtonHeight
            //width: 288;
            //height: popupBtnCnt == 1 ? 329 : 164
            defaultImage: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_n.png" : imgFolderPopup+"btn_type_b_02_n.png"
            //bgImage: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_n.png" : imgFolderPopup+"btn_type_b_02_n.png"
            bgImagePress: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_p.png" : imgFolderPopup+"btn_type_b_02_p.png"
            bgImageFocus: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_f.png" : imgFolderPopup+"btn_type_b_02_f.png"
            visible: popupBtnCnt == 1 || popupBtnCnt == 2
            focus: true

            fgImageX: popupIconX
            fgImageY: popupIcon1Y
            fgImageWidth: popupIconWidth
            fgImageHeight: popupIconHeight
            fgImage: popupIconImage
            fgImageVisible:  (showFocus && idButton1.activeFocus) ? true : false

            //KeyNavigation.down: popupBtnCnt == 1 ? idButton1 : idButton2
            onWheelLeftKeyPressed: idButton1.focus = true
            onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true

            firstText: popupFirstBtnText
            firstTextX: popupButtonTextX
            firstTextY: popupButtonText1Y
            firstTextWidth: popupButtonTextWidth
            firstTextHeight: popupButtonTextHeight
            firstTextSize: popupButtonTextSize
            firstTextStyle: popupButtonTextStyle
            firstTextHorizontalAlies: popupButtonTextHorizontalAlies
            firstTextColor: popupButtonTextColor

            onClickOrKeySelected: {
                if(pressAndHoldFlag == false){
                    popupFirstBtnClicked()
                }
            }
            onClickReleased: {
                if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
            }
        }

        MButton{
            id: idButton2
            x: popupBgImageX + 780
            y: idButton1.y + popupButtonHeight
            width: popupButtonWidth
            height: popupButtonHeight
            //width: 288;
            //height: 165
            defaultImage: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_n.png" : ""
            //bgImage: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_n.png" : ""
            bgImagePress: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_p.png" : ""
            bgImageFocus: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_f.png" : ""
            visible: popupBtnCnt == 2

            fgImageX: popupIconX
            fgImageY: popupIcon2Y
            fgImageWidth: popupIconWidth
            fgImageHeight: popupIconHeight
            fgImage: popupIconImage
            fgImageVisible:  (showFocus && idButton2.activeFocus) ? true : false

            //KeyNavigation.up: idButton1
            onWheelLeftKeyPressed: idButton1.focus = true
            onWheelRightKeyPressed: idButton2.focus = true

            firstText: popupSecondBtnText
            firstTextX: popupButtonTextX
            firstTextY: popupButtonText2Y
            firstTextWidth: popupButtonTextWidth
            firstTextHeight: popupButtonTextHeight
            firstTextSize: popupButtonTextSize
            firstTextStyle: popupButtonTextStyle
            firstTextHorizontalAlies: popupButtonTextHorizontalAlies
            firstTextColor: popupButtonTextColor

            onClickOrKeySelected: {
                if(pressAndHoldFlag == false){
                    popupSecondBtnClicked()
                }
            }
            onClickReleased: {
                if(playBeepOn && idAppMain.inputModeDMB == "touch" && pressAndHoldFlagDMB == false) idAppMain.playBeep();
            }
        }

        onActiveFocusChanged: {
            if(idButtonGroup.focus == false)
                unFocusButtonGroup()
        }
    }

    // # Hard Key (BackButton)
    onBackKeyPressed: {
        hardBackKeyClicked()
    }

    Connections{
        target: EngineListener

        onSetWheelKeyPressed:{
            if(wheelType == 0 /* Left */)
            {
                if(idText.focus == true)
                {
                    if(itemHeight >= idFlickable.contentHeight) return;
                    if(idFlickable.contentY > popupFirstTextSpacing)
                    {
                        idFlickable.contentY -= popupFirstTextSpacing;
                    }else
                    {
                        idFlickable.contentY = 0;
                    }
                }
                else if(idButtonGroup.focus == true)
                {
                    if(popupBtnCnt == 2)
                    {
                        if(buttonFocus1 == false) buttonFocus1 = true;
                        else return;
                    }
                }
            }
            else /* Right */
            {
                if(idText.focus == true)
                {
                    if(itemHeight >= idFlickable.contentHeight) return;
                    if(idFlickable.contentY < (idFlickable.contentHeight - idFlickable.height) - popupFirstTextSpacing)
                    {
                        idFlickable.contentY += popupFirstTextSpacing;
                    }else
                    {
                        idFlickable.contentY = idFlickable.contentHeight - idFlickable.height;
                    }
                }
                else if(idButtonGroup.focus == true)
                {
                    if(popupBtnCnt == 2)
                    {
                        if(buttonFocus2 == false) buttonFocus2 = true;
                        else return;
                    }
                }
            }
        }

        onSetJogKeyPressed:{
            if(jogType == 0 /* Left */)
            {
                focusTextArea();
            }
            else if(jogType == 1 /* Right */)
            {
                focusButton1()
            }
        }

        onSetUpdateFocusQML:{
            focusTextArea();
        }

//        onModeDRSChanged:{ focusTextArea(); }
    }

    onTuneEnterKeyPressed: {
        if(EngineListener.isFrontRearBG() == true || (EngineListener.isFrontRearBG() == true && EngineListener.m_ScreentSettingMode == true))
        {
            EngineListener.SetExternal()
            return;
        }
    }
}
