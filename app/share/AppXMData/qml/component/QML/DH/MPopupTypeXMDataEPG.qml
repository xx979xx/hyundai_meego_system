/**
 * FileName: idMPopupTypeEPG.qml
 * Author: HYANG
 * Time: 2013-1
 *
 * - 2013-1-02 Initial Created by HYANG
 */

import QtQuick 1.0
import "../../QML/DH" as MComp
import "../../XMData" as MXData

MComponent{
    id: idMPopupTypeEPG
    x: 0; y: -systemInfo.statusBarHeight
    z: idMenuBar.z + 999
    width: systemInfo.lcdWidth; height: systemInfo.lcdHeight+systemInfo.statusBarHeight
    focus: true

    property bool active: false

    property string imgFolderPopup: imageInfo.imgFolderPopup
    property string imgFolderSettings: imageInfo.imgFolderSettings

    property string popupBgImage: imgFolderPopup+"bg_type_b.png"
    property string bgImageFocus: imgFolderPopup+"bg_type_b_f.png"
    property int popupBgImageX: 93
    property int popupBgImageY: 171//-systemInfo.statusBarHeight
    property int popupBgImageWidth: 1093
    property int popupBgImageHeight: 379

    property int popupTextX: popupBgImageX + 69
    property int popupTextSpacing: 44
    property string popupFirstText: ""
    property string imgPath: ""
    property string gradeText: ""
    property string popupSecondText: ""
    property string popupThirdText: ""
    property string popupFourthText: ""//for Actors Name

    property string popupFirstBtnText: ""
    property string popupFirstBtnText2Line: ""
    property string popupSecondBtnText: ""
    property string popupSecondBtnText2Line: ""

    property int popupBtnCnt: 2    //# 1 or 2
    property int overContentCount: 0

    property bool checkAntSig: idAppMain.statusAntSig

    signal popupClicked();
    signal popupBgClicked();
    signal popupFirstBtnClicked();
    signal popupSecondBtnClicked();
    signal hardBackKeyClicked();

    //****************************** # Background mask click #
    onClickOrKeySelected: {
        popupBgClicked()
    }

    onCheckAntSigChanged:{
        if(checkAntSig == false)
        {
            if(idMPopupTypeEPG.visible == true)
                idMPopupTypeEPG.x = 0;
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
        visible: idText.activeFocus
    }

    MComponent{
        id: idText
        x: popupTextX; y: popupBgImageY + 77 - 32/2
        width: 107 + 570; height: /*77 + */28 + 28 + 80 + popupTextSpacing + popupTextSpacing + 32
        clip: true
        focus: true
        KeyNavigation.right: idButton1

        Flickable{
            id: idFlickable
            contentX: 0; contentY: idFirstText.y
            contentWidth: idText.width/*idThirdText.paintedWidth*/;
            contentHeight: 28 + 28 + 80 + idFourthText.paintedHeight + idThirdText.paintedHeight - 25//for Actors Name
            flickableDirection: Flickable.VerticalFlick;
            boundsBehavior : Flickable.DragAndOvershootBounds
            interactive: (idText.height < contentHeight)? true : false;
            anchors.fill: parent;
            clip: true
            //****************************** # Text (firstText, secondText, thirdText, fourthText) #

            MComp.DDScrollTicker{
                id: idFirstText
                x: 0; y: 0
                width: 107 + 570; height: 32
                fontSize: 32
                text: popupFirstText
                fontFamily : systemInfo.font_NewHDR
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.brightGrey
                tickerEnable: true
                tickerFocus: idText.activeFocus
            }
//            Text{
//                id: idFirstText
//                text: popupFirstText
//                x: 0; y: 0
//                width: 107 + 570; height: 32
//                font.pixelSize: 32
//                font.family: systemInfo.font_NewHDR
//                horizontalAlignment: Text.AlignLeft
//                verticalAlignment: Text.AlignVCenter
//                color: colorInfo.brightGrey
//            }

            Image{
                id: idGradeImg
                x: 0; y: 28 + 32/2
                width: 100; height: 54
                source: imgPath
            }

            Text{
                id:idGradeText
                text: gradeText
                x: 0; y: 28 + 28 + 3
                width: 100; height: 25
                font.pixelSize: (gradeText === "Unrated") ? 20 : 25
                font.family: systemInfo.font_NewHDB
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.brightGrey
            }

            Text{
                id: idSecondText
                text: popupSecondText //"12 : 10 ~ 14 : 00"
                x: 107; y: 28 + 28
                width: 570; height: 32
                font.pixelSize: 32
                font.family: systemInfo.font_NewHDR
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: colorInfo.subTextGrey
                MXData.XMRectangleForDebug{border.color:"red"}
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

            Text{//for Actors Name
                id : idFourthText
                x: 0; y: 28 + 28 + 45
                width: idFlickable.width; height: idFourthText.paintedHeight
                text : "Actors : " + popupFourthText
                font.pixelSize : 32
                font.family : systemInfo.font_NewHDR
                color : colorInfo.brightGrey
                wrapMode : Text.WrapAnywhere

                MXData.XMRectangleForDebug{border.color:"red"}
            }

            Text{
                id : idThirdText
                x: 0; y: popupFourthText == "" ? 28 + 28 + 55 + 30 : 28 + 28 + 55 + idFourthText.paintedHeight//[ITS 217987]
                width: idFlickable.width; height: idThirdText.paintedHeight
                text : "Synopsis : " + popupThirdText
                font.pixelSize : 32
                font.family : systemInfo.font_NewHDR
                color : colorInfo.brightGrey
                wrapMode : Text.WordWrap

                MXData.XMRectangleForDebug{border.color:"red"}
            }
            onMovementEnded: {
                console.log("[QML] MPopupTypeXMDataEPG.qml onMovementEnded. = " + idText.focus);
                if(idText.focus == false)
                    idText.focus = true;
            }
        }


        //EVENT

        onWheelLeftKeyPressed: {
            if(!idFlickable.interactive)
                return;
            if(idFlickable.contentY > 36)
            {
                idFlickable.contentY -= 36;
            }else
            {
                idFlickable.contentY = 0;
            }
        }

        onWheelRightKeyPressed: {
            if(!idFlickable.interactive)
                return;
            if(idFlickable.contentY < (idFlickable.contentHeight - idFlickable.height) - 36)
            {
                idFlickable.contentY += 36;
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
        listCountOfScreen:  (28 + 28 + 80 + popupTextSpacing + popupTextSpacing + 32)
        listCount: 32/2 + 28 + 28 + 80 + idFourthText.paintedHeight + idThirdText.paintedHeight//for Actors Name

        Connections{
            target:idFlickable.visibleArea
            onYPositionChanged :{
                if(idFlickable.contentY <= 0) // up
                {
                    idRoundScroll.moveBarPosition = 0;
                    idRoundScroll.moveBarHeight = (idRoundScroll.height / (idFlickable.contentHeight / idFlickable.height)) + (idFlickable.visibleArea.yPosition * idRoundScroll.height);
                }else if(idFlickable.contentY >= (idFlickable.contentHeight - idFlickable.height))
                {
                    idRoundScroll.moveBarPosition = idFlickable.visibleArea.yPosition * idRoundScroll.height;
                    idRoundScroll.moveBarHeight = height / (idFlickable.contentHeight / idFlickable.height)
                }else
                {
                    idRoundScroll.moveBarPosition = idFlickable.visibleArea.yPosition * idRoundScroll.height;
                    idRoundScroll.moveBarHeight = idRoundScroll.height / (idFlickable.contentHeight / idFlickable.height);
                }
            }
        }

        visible: (idFlickable.interactive) ? true : false//(idListView.count > 4)
    }

    //****************************** # Popup Button #
    MButton{
        id: idButton1
        x: popupBgImageX + 780
        y: popupBgImageY + 25 - 7
        width: 295/*288*/;
        height: popupBtnCnt == 1 ? 343 : 171/*329 : 164*/
        bgImageButtonLine: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_n.png" : imgFolderPopup+"btn_type_b_02_n.png"
        bgImagePress: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_p.png" : imgFolderPopup+"btn_type_b_02_p.png"
        bgImageFocus: popupBtnCnt == 1 ? imgFolderPopup+"btn_type_b_01_f.png" : imgFolderPopup+"btn_type_b_02_f.png"
        visible: popupBtnCnt == 1 || popupBtnCnt == 2
//        focus: true

        fgImageX: popupBtnCnt == 1 ? 778 - 780 : 773 - 780
        fgImageY: popupBtnCnt == 1 ? 154 - 18 : 72 - 18
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: imgFolderPopup+"light.png"
        fgImageVisible: focusImageVisible
        KeyNavigation.left: idText
        KeyNavigation.down: popupBtnCnt == 1 ? idButton1 : idButton2
        onWheelLeftKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true
        onWheelRightKeyPressed: popupBtnCnt == 1 ? idButton1.focus = true : idButton2.focus = true

        DDScrollTicker{
            x: 832 - 780
            y: 0//popupBtnCnt == 1 ? popupFirstBtnText2Line != "" ? 170 - 25 : 189 - 25 : popupFirstBtnText2Line != "" ? 88 - 25 : 107 - 25
            width: 210
            height: parent.height//popupFirstBtnText2Line != "" ? 32 : 36
            text: popupFirstBtnText + " " + popupFirstBtnText2Line
            fontSize: popupFirstBtnText2Line != "" ? 32 : 36
            fontFamily: systemInfo.font_NewHDB
            color: colorInfo.brightGrey
            tickerEnable: true
            tickerFocus: idButton1.activeFocus
        }

        onClickOrKeySelected: {
            popupFirstBtnClicked()
        }
    }

    MButton{
        id: idButton2
        x: popupBgImageX + 780
        y: popupBgImageY + 25 + 164 - 7
        width: 295/*288*/;
        height: 172/*164*/
        bgImageButtonLine: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_n.png" : ""
        bgImagePress: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_p.png" : ""
        bgImageFocus: popupBtnCnt == 2 ? imgFolderPopup+"btn_type_b_03_f.png" : ""
        visible: popupBtnCnt == 2

        fgImageX: 773 - 780
        fgImageY: 72 + 164 - 18 - 164
        fgImageWidth: 69
        fgImageHeight: 69
        fgImage: popupBtnCnt == 2 ? imgFolderPopup+"light.png" : ""
        fgImageVisible: focusImageVisible
        KeyNavigation.up: idButton1
        onWheelLeftKeyPressed: idButton1.focus = true
        onWheelRightKeyPressed: idButton1.focus = true

        DDScrollTicker{
            x: 832 - 780
            y: 0//popupSecondBtnText2Line != "" ? 88 + 40 + 124 - 25 - 164 : 107 + 164 - 25 - 164
            width: 210
            height: parent.height//popupSecondBtnText2Line != "" ? 32 : 36
            text: popupSecondBtnText + " " + popupSecondBtnText2Line
            fontSize: popupSecondBtnText2Line != "" ? 32 : 36
            fontFamily: systemInfo.font_NewHDB
            color: colorInfo.brightGrey
            tickerEnable: true
            tickerFocus: idButton2.activeFocus
        }

        onClickOrKeySelected: {
            popupSecondBtnClicked()
        }
    }

    onSelectKeyPressed: {
        console.log("[QML] MButton onSelectKeyPressed. state:"+ idText.state);
        idText.state="keyPress";
    }

    onSelectKeyReleased: {
        if(active==true){
            idText.state="active"
        }else{
            idText.state="keyReless";
        }
    }

    //************************ Hard Key (BackButton) ***//
    onBackKeyPressed: {
        hardBackKeyClicked()
    }

    states: [
        State {
            name: 'active'; when: idText.active
            PropertyChanges {target: idFocusImage; source: /*popupBgImage*/bgImageFocus;}
        },
        State {
            name: 'keyPress'; when: idText.state=="keyPress" // problem Kang
            PropertyChanges {target: idFocusImage; source: bgImageFocus;}
        },
        State {
            name: 'keyReless';
            PropertyChanges {target: idFocusImage; source: popupBgImage;}
        }
    ]

    Connections {
        target: interfaceManager

        onAdvisoryMessage: {
            console.log("advisoryMessage - emit receive");
            switch(m_status)
            {
                case 1:
                {
                    if(idMPopupTypeEPG.visible == true)
                        idMPopupTypeEPG.x = +1280;
                    break;
                }
                default:
                {
                    //do nothing.
                }
            }
        }
    }
}
