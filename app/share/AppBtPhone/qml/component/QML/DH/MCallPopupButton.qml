/**
 * /QML/DH/MButton.qml
 *
 */
import QtQuick 1.1


MComponent
{
    id: container

    // PROPERTIES
    property bool   active: false
    property string buttonName: ""

    property string bgImage: ""
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""
    property int    bgImageWidth: container.width
    property int    bgImageHeight: container.height

    property int    fgImageX: 0
    property int    fgImageY: 0
    property int    fgImageWidth: 0
    property int    fgImageHeight: 0
    property bool   fgImageVisible: true
    property string fgImage:""
    property string fgImagePress: fgImage
    property string fgImageActive: fgImage
    property string fgImageFocus: fgImage
    property string fgImageFocusPress: fgImage

    // First Text Info
    property string firstText: ""
    property int    firstTextSize: 1
    property int    firstTextX: 0
    property int    firstTextY: 0
    property int    firstTextWidth: 0
    property int    firstTextHeight: firstTextSize//+10 // # because text position wrong by HYANG(120522)
    property string firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    property string firstTextAlies: "Left"
    property bool   firstTextVisible: true
    property bool   firstTextEnabled: true // <<---------- Added by WSH (Enabled)
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor: firstTextColor
    property string firstTextFocusPressColor: firstTextPressColor
    property string firstTextFocusColor: colorInfo.brightGrey
    property string firstTextSelectedColor: firstTextColor
    property string firstDimmedTextColor: colorInfo.dimmedGrey
    property string firstTextDisableColor: colorInfo.disableGrey

    property bool firstTextClip: true

    // Second Text Info
    property string secondText: ""
    property int    secondTextSize: 1
    property int    secondTextX: 0
    property int    secondTextY: 0
    property int    secondTextWidth: 0
    property int    secondTextHeight: secondTextSize//+10
    property string secondTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    property string secondTextAlies: "Left"
    property string secondTextElide: "Right"
    property bool   secondTextVisible: true
    property bool   secondTextFocusVisible: true
    property bool   secondTextEnabled: true // <<---------- Added by WSH (Enabled)
    property string secondTextColor: colorInfo.subTextGrey
    property string secondTextPressColor : secondTextColor
    property string secondTextFocusPressColor: secondTextPressColor
    property string secondTextFocusColor: colorInfo.brightGrey
    property string secondTextSelectedColor: secondTextColor
    property bool   secondTextClip: false

    property string buttonFocus : (true == container.activeFocus && false == systemPopupOn)
    property bool fgImageFocusVisible: true

    opacity: mEnabled ? 1.0 : 0.5

    onStateChanged: {
    }


    /* EVENT handlers */
    onPressed: {
    }

    onCancel: {
        if(!container.mEnabled) return;
        container.state = "keyRelease"
    }

    onReleased: {
        if(false == container.dimmed){
        console.log("## ~ Play Beep Sound(MCallPopupButton) ~ ##")
        UIListener.ManualBeep();
        }
    }

    onSelectKeyPressed: {
        if(true == container.dimmed) {
            container.state = "STATE_DIMMED";
        } else if(true == container.mEnabled) {
            container.state = "STATE_PRESSED";
        } else {
            container.state = "STATE_DISABLED"
        }
    }

    onSelectKeyReleased: {
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

    Image {
        id: backGround
        source: bgImage
        anchors.fill: parent
        width: bgImageWidth
        height: bgImageHeight
        visible: !idFocusImage.visible
    }

    Image {
        id: idFocusImage
        anchors.fill: backGround
        source: bgImageFocus
        width: bgImageWidth
        height: bgImageHeight
        visible: buttonFocus
    }

    Image {
        id: imgFgImage
        x: fgImageX
        y: fgImageY
        width: fgImageWidth
        height: fgImageHeight
        source: fgImage
        visible: fgImageVisible
        enabled: mEnabled ? 1.0 : 0.5
    }

    /* First text
     */
    Text {
        id: txtFirstText
        text: firstText
        x:firstTextX
        y:firstTextY// - ( firstTextSize / 2 )//# - (firstTextSize/8) Text(Alphabet "g") truncation problem by HYANG (0620)
        width: firstTextWidth
        height: firstTextHeight
        color: firstTextColor
        font.family: firstTextStyle
        font.pointSize: firstTextSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        lineHeight: 0.75
        visible: firstTextVisible
        clip: false
        wrapMode: Text.Wrap
        enabled: firstTextEnabled
    }

    /* First focus text
     */
    Text {
        id: txtFocusFirstText
        text: firstText
        x:firstTextX
        y:firstTextY// - ( firstTextSize / 2 )//# - (firstTextSize/8) Text(Alphabet "g") truncation problem by HYANG (0620)
        width: firstTextWidth
        height: firstTextHeight
        color: firstTextFocusColor
        font.family: firstTextStyle
        font.pointSize: firstTextSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        lineHeight: 0.75
        visible: firstTextVisible && buttonFocus
        clip: firstTextClip
        wrapMode: Text.Wrap
        enabled: firstTextEnabled
    }

    /* States
     */
    states: [
        State {
            name: "STATE_PRESSED"
            when: isMousePressed()
            PropertyChanges { target: backGround;           source: bgImagePress }
            PropertyChanges { target: txtFirstText;         color: firstTextPressColor }
            PropertyChanges { target: idFocusImage;         visible: false }
            PropertyChanges { target: txtFocusFirstText;    visible: false }
        }
        , State {
            name: "STATE_ACTIVE"
            when: true == container.active
            PropertyChanges { target: backGround;       source: bgImageActive }
            PropertyChanges {
                target: txtFirstText;
                color: parking == true ? firstTextSelectedColor
                       : true == container.activeFocus ? firstTextFocusColor
                       : true == container.active ? firstTextSelectedColor
                       : firstTextColor
            }
        }
        , State {
            name: "STATE_FOCUS"
            when: true == container.activeFocus
            PropertyChanges { target: txtFirstText;         color: firstTextFocusColor }
        }
        , State {
            name: "STATE_RELEASED"
            PropertyChanges { target: backGround;
                source: true == container.active ? bgImageActive : bgImage
            }
            PropertyChanges { target: txtFirstText;
                color: true == container.active ? firstTextSelectedColor : dimmed ? firstTextDisableColor :firstTextColor
            }
        }
        , State {
            name: "STATE_DIMMED"
            when: container.dimmed
            PropertyChanges { target: txtFirstText;         color: firstTextDisableColor }
        }
        , State {
            name: "STATE_DISABLED"
            when: !mEnabled
            PropertyChanges { target: backGround;       source: bgImage }
            PropertyChanges { target: txtFirstText;         color: firstTextDisableColor }
        }
    ]
}
/* EOF */
