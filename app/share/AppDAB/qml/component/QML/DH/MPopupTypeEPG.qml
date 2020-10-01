/**
 * FileName: idMPopupTypeEPG.qml
 * Author: HYANG
 * Time: 2013-1
 *
 * - 2013-1-02 Initial Created by HYANG
 */

import QtQuick 1.1
import "../../system/DH" as MSystem
import "../../QML/DH" as MComp

MComponent{
    id: idMPopupTypeEPG
    x: 0; y: 0
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight
    focus: true

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string imgFolderSettings: imageInfo.imgFolderSettings

    property string popupBgImage: imgFolderPopup+"bg_type_b.png"
    property string contentsFocusImage: imgFolderPopup+"bg_type_b_f.png"

    property int contentsFocusImageX: popupBgImageX + popupTopMargin
    property int contentsFocusImageY: popupBgImageY + popupTopMargin
    property int contentsFocusImageWidth: 797
    property int contentsFocusImageHeight: 343

    property int popupBgImageX: 93
    property int popupBgImageY: 171-systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: 379

    property int popupTopMargin: 18
    property int popupTextX: popupBgImageX + 69
    property int popupTextSpacing: 44
    property string popupFirstText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""
    property int viewHeight: 28 + 28 + 80 + popupTextSpacing + popupTextSpacing + 30
    property int contentsHeight: 114 + idSecondText.paintedHeight + idThirdText.paintedHeight - 22
    property int moveSize: 44  //not fix

    property string popupFirstBtnText: ""
    property string popupSecondBtnText: ""

    property int popupBtnCnt: 2    //# 1 or 2
    property int overContentCount: 0
    signal popupClicked();
    signal popupBgClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    //****************************** # Background mask click #
    onClickOrKeySelected: {
        popupBgClicked()
    }

    //****************************** # StatusBar Dim #
    Rectangle{
        x: 0; y: -systemInfo.statusBarHeight
        height: systemInfo.statusBarHeight;
        width: systemInfo.lcdWidth
        color: colorInfo.black
        opacity: 0.6
        MouseArea{
            anchors.fill: parent;
        }
    }

    //****************************** # Background mask #
    Rectangle{
        width: parent.width; height: parent.height
        color: colorInfo.black
        opacity: 0.6
    }

    //****************************** # Popup image click #
    Image{
        x: popupBgImageX; y: popupBgImageY
        width: popupBgImageWidth; height: popupBgImageHeight
        source: popupBgImage
    }

    //****************************** # Popup left Focus Image #
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
        x: popupTextX; y: popupBgImageY + 87 - 32/2
        width: 107 + 570; height: viewHeight
        clip: true
        // focus: true
        KeyNavigation.right: idButton
        Flickable{
            id: idFlickable
            contentX: 0; contentY: idFirstText.y
            contentWidth: idText.width;
            contentHeight: contentsHeight      
            boundsBehavior: Flickable.DragAndOvershootBounds
            interactive: (viewHeight < contentsHeight)? true : false;
            anchors.fill: parent;
            clip: true
            //****************************** # Text (firstText, secondText, thirdText, fourthText) #
            Text{
                id: idFirstText
                text: popupFirstText //"Today`s Hits"
                x: 0; y: 0
                width: 107 + 570; height: 32
                font.pixelSize: 32
                font.family: idAppMain.fonts_HDR
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.subTextGrey
            }

            Text{
                id: idSecondText
                text: popupSecondText //"12 : 10 ~ 14 : 00"
                x: 0; y: 52
                width: 570; height: idSecondText.paintedHeight
                font.pixelSize: 32
                font.family: idAppMain.fonts_HDR
                horizontalAlignment: Text.AlignLeft           
                color: colorInfo.subTextGrey
                wrapMode : Text.Wrap
                lineHeight : 1.1
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

            Text{
                id : idThirdText
                x: 0; y: 52 + 94 + idSecondText.paintedHeight - 32 - 22 // 52+94
                width: idFlickable.width; height: idThirdText.paintedHeight
                text : popupThirdText
                font.pixelSize : 32
                font.family : idAppMain.fonts_HDR
                color : colorInfo.subTextGrey
                wrapMode : Text.Wrap
                lineHeight : 1.1
            }
            MouseArea{
                anchors.fill: parent
                onReleased: {
                    if(viewHeight < contentsHeight)
                    idText.focus = true
                }
            }
            onMovementEnded: {
                if(viewHeight < contentsHeight)
                idText.focus = true
            }
        }
        Keys.onUpPressed: {
            if(viewHeight >= contentsHeight) return;
            if(idFlickable.contentY > moveSize)
            {
                idFlickable.contentY -= moveSize;
            }else
            {
                idFlickable.contentY = 0;
            }
        }
        onWheelLeftKeyPressed: {
            if(viewHeight >= contentsHeight) return;
            if(idFlickable.contentY > moveSize)
            {
                idFlickable.contentY -= moveSize;
            }else
            {
                idFlickable.contentY = 0;
            }
        }
        Keys.onDownPressed: {
            if(viewHeight >= contentsHeight) return;
            if(idFlickable.contentY < (idFlickable.contentHeight - idFlickable.height) - moveSize)
            {
                idFlickable.contentY += moveSize;
            }else
            {
                idFlickable.contentY = idFlickable.contentHeight - idFlickable.height;
            }
        }

        onWheelRightKeyPressed: {
            if(viewHeight >= contentsHeight) return;
            if(idFlickable.contentY < (idFlickable.contentHeight - idFlickable.height) - moveSize)
            {
                idFlickable.contentY += moveSize;
            }else
            {
                idFlickable.contentY = idFlickable.contentHeight - idFlickable.height;
            }
        }
    }

    MComp.MRoundScroll{
        id: idRoundScroll
        x: popupBgImageX + 760; y: popupBgImageY + 35
        scrollWidth: 39; scrollHeight: 306
        scrollBgImage: imgFolderPopup + "scroll_bg.png"
        scrollBarImage :  imgFolderPopup + "scroll.png"

        moveBarHeight: height / (idFlickable.contentHeight / idFlickable.height)
        listCountOfScreen:  (viewHeight)
        listCount: contentsHeight

        Connections{
            target:idFlickable.visibleArea
            onYPositionChanged :{
                idRoundScroll.moveBarPosition = idFlickable.visibleArea.yPosition * idRoundScroll.height
                idRoundScroll.moveBarHeight =  idFlickable.visibleArea.heightRatio * idRoundScroll.height
            }
        }
        visible: viewHeight < contentsHeight
        onVisibleChanged: {
            if(visible){
                idFlickable.contentY = 0;
                idRoundScroll.moveBarHeight = height / (idFlickable.contentHeight / idFlickable.height)
            }
        }
    }
    onVisibleChanged: {
        if(visible){
            if(viewHeight >= contentsHeight){
                idButton.focus = true;
                idButton1.focus = true;
            }
            else{
                idText.focus = true;
            }
        }
    }

    //****************************** # Popup Button #
    FocusScope{
        id: idButton
        focus: true
        MButton{
            id: idButton1
            x: popupBgImageX + 780
            y: popupBgImageY + popupTopMargin
            width: 288;
            height: popupBtnCnt == 1 ? 329 : 171
           // bgImage: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_n.png" : imgFolderPopup+"btn_type_b_02_n.png"
            bgImagePress: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_p.png" : imgFolderPopup+"btn_type_b_02_p.png"
            bgImageFocus: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_f.png" : imgFolderPopup+"btn_type_b_02_f.png"
            bgImageTop: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_n.png" : imgFolderPopup+"btn_type_b_02_n.png"
            visible: popupBtnCnt == 1 || popupBtnCnt == 2
            focus: true

            fgImageX: popupBtnCnt == 1 ? 778 - 780 : 773 - 780
            fgImageY: popupBtnCnt == 1 ? 154 - popupTopMargin : 72 - popupTopMargin

            fgImageWidth: 69
            fgImageHeight: 69
            fgImage: imgFolderPopup+"light.png"
            fgImageVisible: idButton1.activeFocus == true;
            KeyNavigation.left: (viewHeight >= contentsHeight) ? idButton1 : idText
            KeyNavigation.down: popupBtnCnt == 1 ? idButton1 : idButton2
          //  onWheelLeftKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true
            onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true

            firstText: popupFirstBtnText
            firstTextX: 832 - 780
            firstTextY: popupBtnCnt == 1 ? 189 - popupTopMargin : 107 - popupTopMargin
            firstTextWidth: 210
            firstTextSize: idButton1.firstTextPaintedHeight < 72 ? 36 : 32
            firstTextStyle: idAppMain.fonts_HDB
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            firstTextWrapMode: true

            onClickOrKeySelected: {
                popupFirstBtnClicked()
            }
        }

        MButton{
            id: idButton2
            x: popupBgImageX + 780
            y: popupBgImageY + popupTopMargin + 171
            width: 288;
            height: 171
           // bgImage: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_n.png" : ""
            bgImagePress: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_p.png" : ""
            bgImageFocus: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_f.png" : ""
            bgImageTop: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_n.png" : ""
            visible: popupBtnCnt == 2

            fgImageX: 773 - 780
            fgImageY: 72 + 171 - popupTopMargin - 171

            fgImageWidth: 69
            fgImageHeight: 69
            fgImage: popupBtnCnt == 2 ? imgFolderPopup+"light.png" : ""
            fgImageVisible: idButton2.activeFocus == true;
            KeyNavigation.up: idButton1
            KeyNavigation.left:  (viewHeight >= contentsHeight) ? idButton2 : idText
            onWheelLeftKeyPressed: idButton1.focus = true
          //  onWheelRightKeyPressed: idButton1.focus = true

            firstText: popupSecondBtnText
            firstTextX: 832 - 780
            firstTextY: 107 + 171 - popupTopMargin - 171
            firstTextWidth: 210
            firstTextSize: idButton2.firstTextPaintedHeight < 72 ? 36 : 32
            firstTextStyle: idAppMain.fonts_HDB
            firstTextAlies: "Center"
            firstTextColor: colorInfo.brightGrey
            firstTextWrapMode: true

            onClickOrKeySelected: {
                popupSecondBtnClicked()
            }
        }
    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        hardBackKeyClicked()
    }

    //************************ Function ***//
    function giveFocus(focusPosition){
        if(focusPosition == 1) idButton1.focus = true
        else if(focusPosition == 2) idButton2.focus = true
        else if(focusPosition == "contents") idText.focus = true
    }
}
