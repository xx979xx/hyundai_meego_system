/**
 * FileName: idMPopupTypeEPG.qml
 * Author: HYANG
 * Time: 2013-1
 *
 * - 2013-1-02 Initial Created by HYANG
 */

import QtQuick 1.1
import "../../QML/DH" as MComp

MComponent{
    id: idMPopupTypeEPG
    x: 0; y: -systemInfo.statusBarHeight
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight+systemInfo.statusBarHeight
    focus: true

    property bool   active : false
    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string imgFolderSettings: imageInfo.imgFolderSettings

    property string popupBgImage: imgFolderPopup+"bg_type_b.png"
    property string bgImageFocus: imgFolderPopup+"bg_type_b_f.png"
    property int popupBgImageX: 93
    property int popupBgImageY: 171
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: 379

    property int popupTextX: popupBgImageX + 69
    property int popupTextSpacing: 52
    property string popupFirstText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""
    property string popupFourthText: ""

    property string popupFirstBtnText: ""
    property string popupFirstBtnText2Line: ""
    property string popupSecondBtnText: ""
    property string popupSecondBtnText2Line: ""
    property string popupThirdBtnText: ""
    property string popupThirdBtnText2Line: ""

    property int popupBtnCnt: 2    //# 1 or 2
    property int overPopupEPGContentCount: 0
    property bool popupfirstTextWrapMode: false
    property bool popupOverViewContents: (idText.height < idFlickable.contentHeight)

    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    //****************************** # Popup image click #
    Image{
        id: backGround
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        source: popupBgImage
    }

    Image {
        id: idFocusImage
        x: popupBgImageX + 18
        y: popupBgImageY + 18
        width: 797
        height: 343
        source: bgImageFocus
        visible: showFocus && idText.activeFocus
    }

    MComponent {
        id: idText
        x: popupTextX; y: popupBgImageY+87-30
        width: 213+30+420; height: 260
        clip: true

        Flickable {
            id: idFlickable
            contentX: 0; contentY: idFirstText.y
            contentWidth: idFourthText.paintedWidth;
            contentHeight: 52+104+idFourthText.paintedHeight
            flickableDirection: Flickable.VerticalFlick;
            boundsBehavior : Flickable.DragOverBounds;
            interactive: (idMPopupTypeEPG.popupOverViewContents == true) ? true : false


            anchors.fill: parent;
            clip: true

            //****************************** # Text (firstText, secondText, thirdText, fourthText) #
            Text{
                id: idFirstText
                text: popupFirstText //"12 : 10 ~ 14 : 00"
                x: 0; y: 0
                width: 213; height: 32
                font.pixelSize: 32
                font.family: systemInfo.font_NewHDR
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.brightGrey
            }
            Text{
                id: idSecondText
                text: popupSecondText //"POP"
                x: idFirstText.width+30; y: 0
                width: 420; height: 32
                font.pixelSize: 32
                font.family: systemInfo.font_NewHDR
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.subTextGrey
            }
            Text{
                id: idThirdText
                text: popupThirdText //"CH Name"
                x: 0; y: 52
                width: 213+30+420; height: 32
                font.pixelSize: 32
                font.family: systemInfo.font_NewHDR
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.subTextGrey
            }
            Text{
                id : idFourthText
                x: 0; y: 52+104
                width: idFlickable.width; //height: idFlickable.height
                text : popupFourthText
                font.pixelSize : 32
                font.family : systemInfo.font_NewHDR
                color : colorInfo.brightGrey
                wrapMode : TextEdit.WordWrap
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (idMPopupTypeEPG.popupOverViewContents == true){
                        idText.focus = true;
                    }
                }
            }
        }

        KeyNavigation.right: idButton1
        onWheelLeftKeyPressed: {
            if(idRoundScroll.visible == false) retrun;

            if(idFlickable.contentY > 48)
                idFlickable.contentY -= 48;
            else
                idFlickable.contentY = 0;
        }
        onWheelRightKeyPressed: {
            if(idRoundScroll.visible == false) retrun;

            if(idFlickable.contentY < (idFlickable.contentHeight - idFlickable.height) - 48)
                idFlickable.contentY += 48;
            else
                idFlickable.contentY = idFlickable.contentHeight - idFlickable.height;
        }
    }

    MComp.MRoundScroll {
        id: idRoundScroll
        x: popupBgImageX + 760; y: popupBgImageY + 35; z: 0
        scrollWidth: 39; scrollHeight: 306
        scrollBgImage: imgFolderPopup + "scroll_bg.png"
        scrollBarImage : imgFolderPopup + "scroll.png"

        moveBarHeight: height/(idFlickable.contentHeight/idFlickable.height)
        listCountOfScreen:  260
        listCount: 52+104+idFourthText.paintedHeight
        visible: (listCount > listCountOfScreen)? true : false

        Connections{
            target:idFlickable.visibleArea
            onYPositionChanged : { scrollMoveBarChange(); }
        }
    }

    function scrollMoveBarChange()
    {
        if(idFlickable.contentY <= 0) // up
        {
            idRoundScroll.moveBarPosition = 0;
            idRoundScroll.moveBarHeight = (idRoundScroll.height / (idFlickable.contentHeight / idFlickable.height)) + (idFlickable.visibleArea.yPosition * idRoundScroll.height);
        }
        else if(idFlickable.contentY >= (idFlickable.contentHeight - idFlickable.height))
        {
            idRoundScroll.moveBarPosition = idFlickable.visibleArea.yPosition * idRoundScroll.height;
            idRoundScroll.moveBarHeight = height / (idFlickable.contentHeight / idFlickable.height)
        }
        else
        {
            idRoundScroll.moveBarPosition = idFlickable.visibleArea.yPosition * idRoundScroll.height;
            idRoundScroll.moveBarHeight = idRoundScroll.height / (idFlickable.contentHeight / idFlickable.height);
        }

        idText.focus = true;
    }

    onVisibleChanged: {
        if(idMPopupTypeEPG.visible)
        {
            idFlickable.contentY = 0;
            scrollMoveBarChange();

            // ITS #191329 Focus initialization
            if(idMPopupTypeEPG.popupOverViewContents == true){  idText.focus = true; }
            else{ idButton1.focus = true; }
        }
    }

    //****************************** # Popup Button #
    MButton{
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + 18
        width: 295
        height: 171
        bgImageZ: 1
        backGroundtopVisible: true
        bgImage: idText.activeFocus ? imgFolderPopup+"btn_type_b_02_n.png" : (idButton2.activeFocus ? imgFolderPopup+"btn_type_b_02_n.png" : imgFolderPopup+"btn_type_b_02_n.png")
        bgImagePress: imgFolderPopup+"btn_type_b_02_p.png"
        bgImageFocus: imgFolderPopup+"btn_type_b_02_f.png"
        visible: popupBtnCnt == 2
        focus: true;

        fgImageX: 773 - 780
        fgImageY: 54
        fgImageZ: 2
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible

        firstText: popupFirstBtnText
        firstTextX: 832 - 785
        firstTextY: (buttonfirsttextCount.lineCount == 2) ? 84 - 18 : 107 - 18
	firstTextZ: 3
        firstTextWidth: 230
        firstTextSize:  (popupfirstTextWrapMode == true) ? 32 : 36
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey
        firstTextWrapMode: (popupfirstTextWrapMode == true) ? true : false

        KeyNavigation.left: (idMPopupTypeEPG.popupOverViewContents == true) ? idText : idButton1
        onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true
        onClickOrKeySelected: {
            popupFirstBtnClicked()
        }
    }

    MButton{
        id: idButton2
        x: popupBgImageX + 780
        y: popupBgImageY + 18 + 171
        width: 295
        height: 171
        bgImageZ: 1
        backGroundtopVisible: true
        bgImage: idText.activeFocus ?  imgFolderPopup+"btn_type_b_03_n.png" : (idButton1.activeFocus ? imgFolderPopup+"btn_type_b_03_n.png" : imgFolderPopup+"btn_type_b_03_n.png")
        bgImagePress: imgFolderPopup+"btn_type_b_03_p.png"
        bgImageFocus: imgFolderPopup+"btn_type_b_03_f.png"
        visible: popupBtnCnt == 2

        fgImageX: 773 - 780
        fgImageY: 50
        fgImageZ: 2
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible

        firstText: popupSecondBtnText
        firstTextX: 832 - 785
        firstTextY: 107 + 164 - 171 - 18
	firstTextZ: 3
        firstTextWidth: 230
        firstTextSize: 36
        firstTextStyle: systemInfo.font_NewHDB
        firstTextAlies: "Center"
        firstTextColor: colorInfo.brightGrey

        KeyNavigation.left: (idMPopupTypeEPG.popupOverViewContents == true) ? idText : idButton2
        onWheelLeftKeyPressed: idButton1.focus = true
        onClickOrKeySelected: {
            popupSecondBtnClicked()
        }
    }

    onBackKeyPressed: {
        hardBackKeyClicked()
    }
}
