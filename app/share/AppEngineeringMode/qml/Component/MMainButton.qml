
import Qt 4.7
import "../System" as MSystem



MComponent
{
    id: container

    width:210/*187*/
    height:220/*185*/

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
    property int    fgImageWidth: 210
    property int    fgImageHeight: 220
    property bool   fgImageVisible: true
    property bool   fgImageFocusVisible: true

    // First Text Info
    property string firstText: ""
    property int    firstTextSize: 24
    property int    firstTextX: 0
    property int    firstTextY: 30
    property int    firstTextWidth: 210
    property int    firstTextHeight: firstTextSize + 10
    property string firstTextStyle: "HDB"/*stringInfo.fontFamilyRegular*/    //"HDR"
    property string firstTextAlies: "Center"
    property string firstTextElide: "Right"
    property bool   firstTextVisible: true
    property bool   firstTextEnabled: true
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor: "#7CBDFF"/*firstTextColor*/
    property string firstTextFocusPressColor: "#7CBDFF"/*firstTextPressColor*/
    property string firstTextFocusColor: "#7CBDFF"//colorInfo.brightGrey
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
        y: firstTextY-(firstTextSize/2)
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
        y: firstTextY-(firstTextSize/2)
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

//MComponent {
//    id: container

//    width:210/*187*/
//    height:220/*185*/

//    property bool active: false
//    property string buttonName: ""

//    property string bgImageFocusPress:""/*"/app/share/images/home/ico_home_f.png"*/

//    //Image Info
//    property int fgImageX: 0
//    property int fgImageY: 0
//    property int fgImageWidth: 210/*185*/
//    property int fgImageHeight: 220/*184*/
//    property string buttonImage:""
//    property string buttonImagePress: ""
//    property string buttonImageActive: ""
//    property string buttonImageFocus: ""
//    property string buttonImageFocusPress: ""

//    property int textLine: 1

//    //first Text Info
//    property string firstText: ""
//    property int firstTextSize: 24
//    property int firstTextX: 0
//    property int firstTextY: textLine==1?30:27
//    property int firstTextWidth: 210/*185*/
//    property int firstTextHeight: firstTextSize+10
//    property string firstTextStyle: "HDB"
//    property string firstTextAlies: "Center"
//    property string firstTextColor: colorInfo.brightGrey
//    property string firstTextPressColor : colorInfo.bandBlue
//    property string firstTextFocusPressColor : firstTextPressColor

//    opacity: enabled ? 1.0 : 0.5

//    Image {
//        id: imgFgImage
//        x: fgImageX
//        y: fgImageY
//        width: fgImageWidth
//        height: fgImageHeight
//        source: buttonImage
//    }

//    //First Text
//    Text {
//        id: txtFirstText
//        text: firstText
//        x:firstTextX
//        y:firstTextY-(firstTextSize/2)
//        width: firstTextWidth
//        height: firstTextHeight
//        color: firstTextColor
//        font.family: UIListener.getFont(true)//firstTextStyle
//        font.pixelSize: firstTextSize
//        verticalAlignment: Text.AlignVCenter
//        horizontalAlignment: {
//            if(firstTextAlies=="Right"){Text.AlignRight}
//            else if(firstTextAlies=="Left"){Text.AlignLeft}
//            else if(firstTextAlies=="Center"){Text.AlignHCenter}
//            else {Text.AlignHCenter}
//        }
//        clip: true //jyjeon_20120221
//        //****************************** # End #
//    }

//    //Focus Image
//    Image {
//        //anchors.fill: parent
//        id: idFocusImage
//        x: fgImageX
//        y: fgImageY
//        width: fgImageWidth
//        height: fgImageHeight
//        source: bgImageFocusPress
//        visible: showFocus && container.activeFocus
//    }

//    onSelectKeyPressed: container.state="keyPress"
//    onSelectKeyReleased:container.state="keyReless"
//    //onClickOrKeySelected: container.state="keyPress"

//    states: [
//        State {
//            name: 'pressed'; when: isMousePressed()
//            PropertyChanges {target: imgFgImage; source: buttonImagePress;}
//            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
//        },
//        State {
//            name: 'active'; when: container.active
//            PropertyChanges {target: imgFgImage; source: buttonImagePress;}
//            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
//        },
//        State {
//            name: 'keyPress';
//            PropertyChanges {target: imgFgImage; source: buttonImagePress;}
//            PropertyChanges {target: txtFirstText; color: firstTextPressColor;}
//        },
//        State {
//            name: 'keyReless';
//            PropertyChanges {target: imgFgImage; source: buttonImage;}
//            PropertyChanges {target: txtFirstText; color: firstTextColor;}
//        },
//        State {
//            name: 'dimmed'; when: container.dimmed
//            PropertyChanges {target: txtFirstText; color: firstDimmedTextColor;}
//        }
//    ]
//}
