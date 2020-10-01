/**
 * /QML/DH/DDDialButton.qml
 *
 */
import QtQuick 1.1


MComponentAddLongPress
{
    id: container

    width: parent.width
    height: parent.height

    // PROPERTIES
    property bool   active: false

    property string bgImage: ""
    property string bgImagePress: ""
    property string bgImageActive: ""
    property string bgImageFocus: ""

    property string fgImage: ""
    property int fgImageX: 0
    property int fgImageY: 0
    property string fgImagePress: fgImage
    property string fgImageActive: fgImage
    property string fgImageFocus: ""

    // First Text Info
    property string firstText: ""
    property int    firstTextSize: 1
    property int    firstTextX: 0
    property int    firstTextY: 0
    property int    firstTextWidth: 0
    property int    firstTextHeight: firstTextSize
    property string firstTextStyle: stringInfo.fontFamilyRegular    //"HDR"
    property string firstTextAlies: "Left"
    property string firstTextElide: "Right"
    property bool   firstTextVisible: true
    property bool   firstTextEnabled: true
    property string firstTextColor: colorInfo.subTextGrey
    property string firstTextPressColor: firstTextColor
    property string firstTextFocusPressColor: firstTextPressColor
    property string firstTextFocusColor: colorInfo.brightGrey
    property string firstTextSelectedColor: firstTextColor
    property string firstDimmedTextColor: colorInfo.dimmedGrey
    property string firstTextDisableColor: colorInfo.disableGrey
    property string firstTextWrap: "Text.WordWrap"
    property bool   firstTextClip: true

    //opacity: mEnabled ? 1.0 : 0.5
    dimmed: !mEnabled

    onCancel: {
        if(!container.mEnabled) return;
        container.state = "STATE_RELEASED"
    }

    Connections {
        target: idAppMain
        onMouseAreaExit: {
            container.state = "STATE_RELEASED"
        }

        onBtnReleased: {
            container.state = "STATE_RELEASED"
        }
    }

    /* EVENT handlers */
    onSelectKeyPressed: {
        if(true == container.dimmed) {
            container.state = "STATE_DIMMED";
        } else if(true == container.mEnabled) {
            container.state = "STATE_PRESSED";
        } else {
            container.state = "STATE_DISABLE"
        }
    }

    onSelectKeyReleased: {
        if(true == container.dimmed) {
            container.state = "STATE_DIMMED"
        } else if(true == container.mEnabled) {
            if(true == container.active) {
                container.state = "STATE_ACTIVE"
            } else {
                container.state = "STATE_RELEASED";
            }
        } else {
            container.state = "STATE_DISABLE"
        }
    }

    onActiveFocusChanged: {
        if(false == container.activeFocus) {
            container.state = "STATE_RELEASED"
        }

        if(true == container.active) {
            container.state = "STATE_ACTIVE"
        }
    }

    onSigReleaseLongPressed: {
        if(true == container.dimmed) {
            container.state = "STATE_DIMMED"
        } else if(true == container.mEnabled) {
            if(true == container.active) {
                container.state = "STATE_ACTIVE"
            } else {
                container.state = "STATE_RELEASED";
            }
        } else {
            container.state = "STATE_DISABLE"
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
            container.state = "STATE_DISABLE"
        }
    }

    Keys.onPressed: {
        if(event.modifiers == Qt.ShiftModifier){
            event.accepted = true
        }
    }


    /* WIDGETS */
    Image {
        id: idBtnBackImage
        source: bgImage
        width: container.width
        height: container.height
    }

    Image {
        id: idBtnBackFocusImage
        source: bgImageFocus
        width: container.width
        height: container.height
        visible: true == container.activeFocus && false == systemPopupOn
    }

    Image {
        id: idBtnForeImage
        x: fgImageX
        y: fgImageY
        source: fgImage
    }

    Image {
        id: idBtnForeFocusImage
        x: fgImageX
        y: fgImageY
        source: fgImageFocus
        visible: true == container.activeFocus
    }

    // First text
    Text {
        id: txtFirstText
        text: firstText
        x:firstTextX
        y:firstTextY
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
            } else if(firstTextAlies == "Center") {
                Text.AlignHCenter
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

        visible: !txtFocusFirstText.visible && firstTextVisible
        clip: false
        wrapMode: firstTextWrap
        enabled: firstTextEnabled
    }

    // First focus text
    Text {
        id: txtFocusFirstText
        text: firstText
        x:firstTextX
        y:firstTextY
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
            } else if(firstTextAlies == "Center") {
                Text.AlignHCenter
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

        visible: true == container.activeFocus && firstTextVisible
        clip: firstTextClip
        wrapMode: firstTextWrap
        enabled: firstTextEnabled
    }

    /* STATES */
    states: [
        State {
            name: 'STATE_PRESSED'
            when: isMousePressed();
            PropertyChanges { target: idBtnBackImage;       source: bgImagePress; }
            PropertyChanges { target: idBtnForeImage;       source: fgImagePress; }
            PropertyChanges { target: txtFirstText;         color: firstTextPressColor; }
            PropertyChanges { target: idBtnBackFocusImage;  visible: false; }
        }
        , State {
            name: 'STATE_ACTIVE'
            when: container.active
            PropertyChanges { target: idBtnBackImage;       source: bgImageActive; }
            PropertyChanges { target: idBtnForeImage;       source: fgImageActive; }
            PropertyChanges { target: txtFirstText;         color: firstTextSelectedColor; }
        }
        , State {
            name: 'STATE_RELEASED'
            PropertyChanges { target: idBtnBackImage;       source: bgImage; }
            PropertyChanges { target: idBtnForeImage;       source: fgImage; }
            PropertyChanges { target: txtFirstText;
                color: true == container.active ? firstTextSelectedColor : dimmed ? firstTextDisableColor :firstTextColor
            }
        }
        , State {
            name: "STATE_DIMMED"
            when: container.dimmed
            PropertyChanges { target: txtFirstText;         color: container.dimmed ? firstTextDisableColor : firstTextColor; }
        }
        , State {
            name: 'STATE_DISABLE'
            when: !mEnabled
            PropertyChanges { target: idBtnBackImage;       source: bgImage; }
            PropertyChanges { target: idBtnForeImage;       source: fgImage; }
            PropertyChanges { target: txtFirstText;         color: container.dimmed ? firstTextDisableColor : firstTextColor; }
        }
    ]
}
/* EOF */
