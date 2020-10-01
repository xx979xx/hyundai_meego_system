import QtQuick 1.0
import "../System" as MSystem

MComponent
{
    id: container

    width: parent.width
    height: parent.height

    // PROPERTIES
    property bool parking: true
    property bool active: false
    property string buttonName: ""
    property bool playBeepOn: true
    property bool buttonFocus: (true == container.activeFocus /*&& false == systemPopupOn*/)

    /* bgImage: 버튼 초기 Background 이미지
     * bgImagePress: 터치나 Jog를 통하여 선택 시 표시되는 Background 이미지
     * bgImageActive: 버튼 액티브 Background 이미지
     * bgImageFocus: 버튼 포커스 Background 이미지
     * fgImage: 버튼 내부의 ICON 이미지
     */
    property string bgImage: ""
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""
    property string bgImageFocusPress: ""
    property int    bgImageX: 0                     // Background X
    property int    bgImageY: 0                     // Background Y
    property int    bgImageZ: 0                     // Background Y
    property int    bgImageWidth: container.width   // Background 넓이
    property int    bgImageHeight: container.height // Background 높이

    property string lineImage: ""                   // Line Image Source
    property int    lineImageX: 0                   // Line Image X좌표
    property int    lineImageY: 0                   // Line Image Y좌표
    property bool   lineVisible: true               // Line Image Visible

    property string fgImage:""
    property string fgImagePress: fgImage
    property string fgImageActive: fgImage
    property string fgImageFocus: fgImage
    property string fgImageFocusPress: fgImage
    property int    fgImageX: 0
    property int    fgImageY: 0
    property int    fgImageWidth: 0
    property int    fgImageHeight: 0
    property bool   fgImageVisible: true
    property bool   fgImageFocusVisible: true

    // First Text Info
    property string firstText: ""
    property int    firstTextSize: 1
    property int    firstTextX: 0
    property int    firstTextY: 0
    property int    firstTextWidth: 0
    property int    firstTextHeight: firstTextSize
    property string firstTextStyle: "HDR"/*stringInfo.fontFamilyRegular*/    //"HDR"
    property string firstTextAlies: "Left"
    property string firstTextElide: "Right"
    property bool   firstTextVisible: true
    property bool   firstTextEnabled: true
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor: firstTextColor
    property string firstTextFocusPressColor: firstTextPressColor
    property string firstTextFocusColor: colorInfo.brightGrey
    property string firstTextSelectedColor: "#7CBDFF"/*firstTextColor*/
    property string firstDimmedTextColor: colorInfo.dimmedGrey
    property string firstTextDisableColor: colorInfo.disableGrey
    property string firstTextWrap: "Text.WordWrap"
    property bool   firstTextClip: true
    property real   firstTextLineHeight: 1

    // Second Text Info
    property string secondText: ""
    property int    secondTextSize: 1
    property int    secondTextX: 0
    property int    secondTextY: 0
    property int    secondTextWidth: 0
    property int    secondTextHeight: secondTextSize
    property string secondTextStyle: "HDR"/*stringInfo.fontFamilyRegular*/    //"HDR"
    property string secondTextAlies: "Left"
    property string secondTextElide: "Right"
    property bool   secondTextVisible: true
    property bool   secondTextEnabled: true
    property string secondTextColor: colorInfo.subTextGrey
    property string secondTextPressColor : secondTextColor
    property string secondTextFocusPressColor: secondTextPressColor
    property string secondTextFocusColor: colorInfo.brightGrey
    property string secondTextSelectedColor: secondTextColor
    property string secondDimmedTextColor: colorInfo.dimmedGrey
    property string secondTextDisableColor: colorInfo.disableGrey
    property bool   secondTextFocusVisible: true
    property bool   secondTextClip: false
    property real   secondTextLineHeight: 1


    // opacity: mEnabled ? 1.0 : 0.5
    mPlayBeep: mEnabled ? true : false
    dimmed: !mEnabled

    /* Ticker Enable! */
    property bool tickerEnable: false

    Connections {
        target: idAppMain
        //        onMouseAreaExit: {
        //            container.state = "STATE_RELEASED"
        //        }

        //        onBtnReleased: {
        //            container.state = "STATE_RELEASED"
        //        }
    }

    onStateChanged: {
    }


    /* EVENT handlers */
    onPressed: {
    }

    //    onCancel: {
    //        if(!container.mEnabled) return;
    //        container.state = "keyRelease"
    //    }

    onSelectKeyPressed: {
        if(true == container.dimmed) {
            container.state = "STATE_DIMMED";
        } else if(true == container.mEnabled) {
            container.state = "STATE_PRESSED";
        } else {
            container.state = "STATE_DISABLED"
        }
    }

    onAnyKeyReleased: {
        if(true == container.dimmed) {
            container.state = "STATE_DIMMED"
        } else if(true == container.mEnabled) {
            if(true == container.active) {
                container.state = "STATE_ACTIVE"
            } else {
                container.state = "STATE_RELEASED";
            }
        } else {
            container.state = "STATE_DISABLED"
        }
    }

    onClickOrKeySelected: {
        if(true == container.dimmed) {
            container.state = "STATE_DIMMED"
        } else if(true == container.mEnabled) {
            if(true == container.active) {
                container.state = "STATE_ACTIVE"
            } else {
                container.state = "STATE_RELEASED";
            }
        } else {
            container.state = "STATE_DISABLED"
        }
    }

    Keys.onPressed: {
        if(event.modifiers == Qt.ShiftModifier){
            event.accepted = true
        }
    }


    /* WIDGETS */
    Image {
        // Line Image는 배경보다 아래에 위치해야함 Line의 1px은 배경보다 밑에 깔려야함
        source: lineImage
        x: lineImageX
        y: lineImageY
        visible: ("" == lineImage) ? false : lineVisible
    }

    Image {
        id: idBtnBackImage
        source: bgImage
        x: bgImageX
        y: bgImageY
        z: bgImageZ
        width: bgImageWidth
        height: bgImageHeight
        visible: !idBtnBackFocusImage.visible
    }

    Image {
        id: idBtnBackFocusImage
        source: bgImageFocus
        x: bgImageX
        y: bgImageY
        width: bgImageWidth
        height: bgImageHeight
        visible: buttonFocus
    }

    Image {
        id: idBtnForeImage
        x: fgImageX
        y: fgImageY
        width: fgImageWidth
        height: fgImageHeight
        source: fgImage
        visible: fgImageVisible
        enabled: mEnabled ? 1.0 : 0.5
    }

    Image {
        id: idBtnForeFocusImage
        x: fgImageX
        y: fgImageY
        z: 1
        width: fgImageWidth
        height: fgImageHeight
        source: fgImageFocus
        visible: buttonFocus && fgImageVisible && fgImageFocusVisible
        enabled: mEnabled ? 1.0 : 0.5
    }

    // First text
    Text {
        id: txtFirstText
        text: firstText
        x: firstTextX
        y: firstTextY
        z: bgImageZ + 1
        width: firstTextWidth
        height: firstTextHeight
        color: firstTextColor
        font.family: firstTextStyle
        font.pointSize: firstTextSize
        verticalAlignment: Text.AlignVCenter

        horizontalAlignment: {
            if(firstTextAlies == "Right") {
                Text.AlignRight
            } else if(firstTextAlies == "Left") {
                Text.AlignLeft
            } else {
                Text.AlignHCenter
            }
        }

        elide: {
            if(firstTextElide == "Right") {
                Text.ElideRight
            } else if(firstTextElide == "Left") {
                Text.ElideLeft
            } else if(firstTextElide == "Center") {
                Text.ElideMiddle
            } else {
                Text.ElideNone
            }
        }

        visible: !txtFocusFirstText.visible //firstTextVisible && false == txtFocusFirstText.visible
        clip: false
        wrapMode: firstTextWrap
        enabled: firstTextEnabled
        //lineHeight: firstTextLineHeight
    }

    // First Focus text
    Text {
        id: txtFocusFirstText
        text: firstText
        x: firstTextX
        y: firstTextY
        z: bgImageZ + 1
        width: firstTextWidth
        height: firstTextHeight
        color: firstTextFocusColor
        font.family: firstTextStyle
        font.pointSize: firstTextSize
        verticalAlignment: Text.AlignVCenter

        horizontalAlignment: {
            if(firstTextAlies == "Right") {
                Text.AlignRight
            } else if(firstTextAlies == "Left") {
                Text.AlignLeft
            } else {
                Text.AlignHCenter
            }
        }

        elide: {
            if(firstTextElide == "Right") {
                Text.ElideRight
            } else if(firstTextElide == "Left") {
                Text.ElideLeft
            } else if(firstTextElide == "Center") {
                Text.ElideMiddle
            } else {
                Text.ElideNone
            }
        }

        visible: firstTextVisible && buttonFocus && parking == true
        clip: false
        wrapMode: firstTextWrap
        enabled: firstTextEnabled
        //lineHeight: firstTextLineHeight
    }

    // Second text
    Text {
        id: txtSecondText
        text: secondText
        x: secondTextX
        y: secondTextY
        z: bgImageZ + 1
        width: secondTextWidth
        height: secondTextHeight
        color: secondTextColor
        font.family: secondTextStyle
        font.pointSize: secondTextSize
        verticalAlignment: Text.AlignVCenter

        horizontalAlignment: {
            if(secondTextAlies == "Right") {
                Text.AlignRight
            } else if(secondTextAlies == "Left") {
                Text.AlignLeft
            } else if(secondTextAlies == "Center") {
                Text.AlignHCenter
            } else {
                Text.AlignHCenter
            }
        }

        elide: {
            if(secondTextElide == "Right") {
                Text.ElideRight
            } else if(secondTextElide == "Left") {
                Text.ElideLeft
            } else if(secondTextElide == "Center") {
                Text.ElideMiddle
            } else /*if(secondTextElide=="None")*/ {
                Text.ElideNone
            }
        }

        visible: !txtFocusSecondText.visible//secondTextVisible && false == txtFocusSecondText.visible
        clip: secondTextClip
        wrapMode: Text.Wrap
        enabled: secondTextEnabled
        //lineHeight: secondTextLineHeight
    }

    // Second Foucs text
    Text {
        id: txtFocusSecondText
        text: secondText
        x: secondTextX
        y: secondTextY
        z: bgImageZ + 1
        width: secondTextWidth
        height: secondTextHeight
        color: secondTextFocusColor
        font.family: secondTextStyle
        font.pointSize: secondTextSize
        verticalAlignment: Text.AlignVCenter

        horizontalAlignment: {
            if(secondTextAlies == "Right") {
                Text.AlignRight
            } else if(secondTextAlies == "Left") {
                Text.AlignLeft
            } else if(secondTextAlies == "Center") {
                Text.AlignHCenter
            } else {
                Text.AlignHCenter
            }
        }

        elide: {
            if(secondTextElide == "Right") {
                Text.ElideRight
            } else if(secondTextElide == "Left") {
                Text.ElideLeft
            } else if(secondTextElide == "Center") {
                Text.ElideMiddle
            } else /*if(secondTextElide=="None")*/ {
                Text.ElideNone
            }
        }

        visible: secondTextVisible && buttonFocus && parking == true
        clip: secondTextClip
        wrapMode: Text.Wrap
        enabled: secondTextEnabled
        //lineHeight: secondTextLineHeight
    }

    /* STATES */
    states: [
        State {
            name: "STATE_PRESSED"
            when: isMousePressed()
            PropertyChanges { target: idBtnBackImage;       source: bgImagePress }
            PropertyChanges { target: idBtnForeImage;       source: fgImagePress }
            PropertyChanges { target: txtFirstText;         color: firstTextPressColor }
            PropertyChanges { target: txtSecondText;        color: secondTextPressColor }
            PropertyChanges { target: idBtnBackFocusImage;  visible: false }
            PropertyChanges { target: txtFocusFirstText;    visible: false }
        }
        , State {
            name: "STATE_ACTIVE"
            when: true == container.active
            PropertyChanges { target: idBtnBackImage;       source: bgImageActive }
            PropertyChanges { target: idBtnForeImage;       source: fgImageActive }
            PropertyChanges {
                target: txtFirstText;
                color: parking == true ? firstTextSelectedColor
                       : true == container.activeFocus ? firstTextFocusColor
                       : true == container.active ? firstTextSelectedColor
                       : firstTextColor
            }
            PropertyChanges { target: txtSecondText;
                color: parking == true ? secondTextSelectedColor
                       : true == container.activeFocus ? secondTextFocusColor
                       : true == container.active ? secondTextSelectedColor
                       : secondTextColor
            }
        }
        , State {
            name: "STATE_FOCUS"
            when: true == container.activeFocus
            //PropertyChanges { target: txtFocusFirstText;    visible: true }
            //PropertyChanges { target: txtFocusSecondText;   visible: true }
            PropertyChanges { target: txtFirstText;         color: firstTextFocusColor }
            PropertyChanges { target: txtSecondText;        color: secondTextFocusColor }
        }
        , State {
            name: "STATE_RELEASED"
            PropertyChanges { target: idBtnBackImage;
                source: true == container.active ? bgImageActive : bgImage
            }
            PropertyChanges { target: idBtnForeImage; source: fgImage  }
            PropertyChanges { target: txtFirstText;
                color: true == container.active ? firstTextSelectedColor : dimmed ? firstTextDisableColor :firstTextColor
            }
            PropertyChanges { target: txtSecondText;
                color: true == container.active ? secondTextSelectedColor : dimmed ? secondTextDisableColor : secondTextColor
            }
        }
        , State {
            name: "STATE_DIMMED"
            when: container.dimmed
            PropertyChanges { target: txtFirstText;         color: firstTextDisableColor }
            PropertyChanges { target: txtSecondText;        color: secondTextDisableColor }
        }
        , State {
            name: "STATE_DISABLED"
            when: !mEnabled
            PropertyChanges { target: idBtnBackImage;       source: bgImage }
            PropertyChanges { target: idBtnForeImage;       source: fgImage }
            PropertyChanges { target: txtFirstText;         color: firstTextDisableColor }
            PropertyChanges { target: txtSecondText;        color: secondTextDisableColor }
        }
    ]
}
/* EOF */

//MComponent {
//    id: container

//    //****************************** # For active(button select) by HYANG #
//    property bool active: false
//    property string buttonName: ""
//    property bool buttonEnabled: true
//    mEnabled: buttonEnabled
//    //****************************** # End #

//    //Button Image // by WSH
//    property int buttonWidth//: parent.width - problem Kang
//    property int buttonHeight//: parent.height - problem Kang
//    property string defaultImage: ""
//    property string bgImage: ""
//    property string bgImagePress: ""
//    property string bgImageActive: ""
//    property string bgImageFocus: ""
//    property string bgImageFocusPress: ""

//    //Image inside Button // by WSH
//    property int fgImageX: 0
//    property int fgImageY: 0
//    property int fgImageWidth: 0
//    property int fgImageHeight: 0
//    property bool fgImageVisible: true
//    property string fgImage:""
//    property string fgImagePress: fgImage
//    property string fgImageActive: fgImage
//    property string fgImageFocus: fgImage
//    property string fgImageFocusPress: fgImage


//    //first Text Info
//    property string firstText: ""
//    property int firstTextSize: 0
//    property int firstTextX: 0
//    property int firstTextY: 0
//    property int firstTextWidth: 0
//    property int firstTextHeight: firstTextSize//+10 // # because text position wrong by HYANG(120522)
//    property string firstTextStyle: "HDR"
//    property string firstTextAlies: "Left"
//    property string firstTextVerticalAlies: "Center"
//    //****************************** # For text (elide, visible) by HYANG #
//    property string firstTextElide: "None"          //# Elide ("Left","Right","Center","None")  ex) "Right" >> ABCDEFG..
//    property bool firstTextVisible: true            //# Visible (true, false)
//    property bool firstTextScrollEnable: false      //# Scroll Enable (true, false)
//    property int firstTextScrollInterval: 0         //# Scroll Move Interval (number high-slow, number low-fast)
//    property bool firstTextScrollOnewayMode: true   //# Scroll OndewayModeFlag (true-one side, false-both side)
//    //****************************** # End #
//    property bool firstTextEnabled: true // true(enabled), false(disabled) <<-- Modified by WSH (130103)
//    property string firstTextColor: colorInfo.subTextGrey
//    property string firstTextPressColor : firstTextColor
//    property string firstTextFocusPressColor : firstTextPressColor
//    property string firstTextSelectedColor: "Black"
//    property string firstTextDisableColor: colorInfo.disableGrey // <<--------- Modified by WSH (130103)
//    property string firstTextFocusColor : firstTextColor  //# HYANG (121122)



//    property bool focusImageVisible: idFocusImage.visible  //# for FocusText - HYANG (121122)
//    opacity: enabled ? 1.0 : 0.5

////    // # Bg Image
////        Image{
////            id: idBgImg
////            source: bgImage
////        }

////        // # Button Focus Image
////        Image {
////            id: idFocusImage
////            source: (showFocus && container.activeFocus) ? bgImageFocus : ""
////            visible: (showFocus && container.activeFocus) ? true : false
////        }

////        // # Default Image
////        Image{
////            id: idDefaultImg
////            x: idBgImg.x - 1
////            source: defaultImage
////        }

////        // # Inside Image
////        Image {
////            id: imgFgImage
////            x: fgImageX
////            y: fgImageY
////            width: fgImageWidth
////            height: fgImageHeight
////            source: fgImage
////            visible: fgImageVisible
////        }

//    //Button Image // by WSH
//    Image{
//        id:backGround
//        source: bgImage
//        anchors.fill: parent
//    }

//    //*****# Focus Image - position move by HYANG (121029)
//    Image {
//        anchors.fill: backGround
//        id: idFocusImage
//        source: bgImageFocus
//        visible: showFocus && container.activeFocus
//    }

//    //Image inside Button // by WSH
//    Image {
//        id: imgFgImage
//        x: fgImageX
//        y: fgImageY
//        width: fgImageWidth
//        height: fgImageHeight
//        source: fgImage
//        visible: fgImageVisible
//    }



//    //First Text
//    Text {   //# change from "Text" to "MScrollText" by HYANG
//        id: txtFirstText
//        text: firstText
//        x:firstTextX
//        y:firstTextY-(firstTextSize/2) - (firstTextSize/8) //# - (firstTextSize/8) Text(Alphabet "g") truncation problem by HYANG (0620)
//        width: firstTextWidth
//        height: firstTextHeight + (firstTextSize/4)  //# + (firstTextSize/4) - Text(Alphabet "g") truncation problem by HYANG (0620)
//        color: firstTextColor
//        font.family:UIListener.getFont(false)// firstTextStyle
//        font.pixelSize: firstTextSize
//        verticalAlignment:{ //jyjon_2012-08-02
//            if(firstTextVerticalAlies == "Top"){Text.AlignTop}
//            else if(firstTextVerticalAlies == "Bottom"){Text.AlignBottom}
//            else if(firstTextVerticalAlies == "Center"){Text.AlignVCenter}
//            else {Text.AlignVCenter}
//        }
//        horizontalAlignment: {
//            if(firstTextAlies=="Right"){Text.AlignRight}
//            else if(firstTextAlies=="Left"){Text.AlignLeft}
//            else if(firstTextAlies=="Center"){Text.AlignHCenter}
//            else {Text.AlignHCenter}
//        }

//        visible: firstTextVisible
//        clip: true //jyjeon_20120221
//        //****************************** # End #
//        enabled: firstTextEnabled // <<---------- Added by WSH (Enabled)
//    }


//    onSelectKeyPressed: {
//        if(container.mEnabled){
//            console.log("[QML] MButton onSelectKeyPressed. state:"+ container.state);

//            container.state="keyPress";
//        }else{
//            container.state="disabled"
//        }
//    }

//    onSelectKeyReleased: {
//        if(container.mEnabled){
//            if(container.active==true){
//                container.state="active"
//            }else{

//                container.state="keyReless";
//            }
//        }else{
//            container.state = "disabled"
//        }
//    }

//    //jyjeon_20120723 : move from MComponent [[
//    onClickOrKeySelected: {
//        console.debug("------ [MButton] [onClickOrKeySelected] ")
//        if(playBeepOn && container.state!="disabled") idAppMain.playBeep();
//        //event.accepted = true; //jyjeon_20120606
//    }

//    onPressAndHold: {
//        console.debug("------ [MButton] [onPressAndHold] ")
//        if(playBeepOn && container.state!="disabled") idAppMain.playBeep();
//        //event.accepted = true; //jyjeon_20120606
//    }


//    states: [
//        State {
//            name: 'pressed'; when: isMousePressed()
//            PropertyChanges {target: backGround; source: bgImagePress;}
//            PropertyChanges {target: imgFgImage; source: fgImagePress;}
//            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
//            PropertyChanges{target: idFocusImage; visible: false;}

//        },
//        State {
//            name: 'active'; /*when: container.active*/
//            PropertyChanges {target: backGround; source: bgImagePress;}
//            PropertyChanges {target: imgFgImage; source: fgImagePress;}
//            PropertyChanges {target: txtFirstText; color: firstTextSelectedColor;}
//            PropertyChanges {target: idFocusImage; visible: (showFocus && container.activeFocus) ? true : false;}
//        },
//        State {
//            name: 'keyPress'; /*when: container.state=="keyPress"*/ // problem Kang
//            PropertyChanges {target: backGround; source: bgImagePress;}
//            PropertyChanges {target: imgFgImage; source: fgImagePress;}
//            PropertyChanges{target: idFocusImage; visible: false;}
////            PropertyChanges {target: bgImageFocus; source: bgImageFocusPress;}
//            PropertyChanges {target: txtFirstText; color: firstTextFocusPressColor;}

//        },
//        State {
//            name: 'keyReless';
//            PropertyChanges {target: backGround; source: bgImage;}
//            //PropertyChanges {target: bgImageFocus; source: fgImage;}
//            PropertyChanges {target: txtFirstText; color: focusImageVisible? firstTextFocusColor : firstTextColor;}
//            PropertyChanges {target: idFocusImage; visible: (showFocus && container.activeFocus) ? true : false;}
//        },
//        State {
//            name: 'disabled'; when: !mEnabled; // Modified by WSH(130103)
//            PropertyChanges {target: backGround; source: bgImage;}
//            PropertyChanges {target: imgFgImage; source: fgImage;}
//            PropertyChanges {target: txtFirstText; color: firstTextEnabled? firstTextColor : firstTextDisableColor;}
//            PropertyChanges{target: idFocusImage; visible: false;}
//        }
//    ]

//}


