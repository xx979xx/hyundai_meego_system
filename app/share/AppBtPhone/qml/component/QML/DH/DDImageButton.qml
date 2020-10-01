/**
 * /QML/DH/DDDialButton.qml
 *
 */
import QtQuick 1.1


MComponent
{
    id: container

    width: parent.width
    height: parent.height

    // PROPERTIES
    property bool active: false

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

    opacity: mEnabled ? 1.0 : 0.5


    /* EVENT handlers */
    onSelectKeyPressed: {
        if(true == container.dimmed) {
            container.state = "dimmed";
        } else if(true == container.mEnabled) {
            container.state = "pressed";
        } else {
            container.state = "disabled"
        }
    }

    onSelectKeyReleased: {
        if(true == container.dimmed) {
            container.state = "dimmed"
        } else if(true == container.mEnabled) {
            if(true == container.active) {
                container.state = "active"
            } else {
                container.state = "keyReless";
            }
        } else {
            container.state = "disabled"
        }
    }


    onActiveFocusChanged: {
        if(false == container.activeFocus) {
            container.state = "keyReless"
        }

        if(true == container.active) {
            container.state = "active"
        }
    }

    onCancel: {
        if(!container.mEnabled) return;
        container.state = "keyRelease"
    }

    onReleased: {
        if(false == container.dimmed){
        console.log("## ~ Play Beep Sound(DDImageButton) ~ ##")
        UIListener.ManualBeep();
        }
    }

    /* WIDGETS */
    Image {
        id: idBtnBackImage
        source: bgImage
    }

    Image {
        id: idBtnBackFocusImage
        source: bgImageFocus
        visible: (true == container.activeFocus) && systemPopupOn == false
    }

    Image {
        id: idBtnForeImage
        x: fgImageX
        y: fgImageY
        source: fgImage
        enabled: mEnabled ? 1.0 : 0.5
    }

    Image {
        id: idBtnForeFocusImage
        x: fgImageX
        y: fgImageY
        source: fgImageFocus
        visible: true == container.activeFocus && systemPopupOn == false
        enabled: mEnabled ? 1.0 : 0.5
    }


    /* States
     */
    states: [
        State {
            name: 'pressed'
            when: isMousePressed();
            PropertyChanges { target: idBtnBackImage;       source: bgImagePress; }
            PropertyChanges { target: idBtnForeImage;       source: fgImagePress; }
            PropertyChanges { target: idBtnBackFocusImage;  visible: false; }
        }
        , State {
            name: 'active'
            when: container.active
            PropertyChanges { target: idBtnBackImage;       source: bgImageActive; }
            PropertyChanges { target: idBtnForeImage;       source: fgImageActive; }
        }
        , State {
            name: 'keyReless'
            PropertyChanges { target: idBtnBackImage;       source: bgImage; }
            PropertyChanges { target: idBtnForeImage;       source: fgImage; }
        }
        , State {
            name: 'dimmed'
            when: container.dimmed
        }
        , State {
            name: 'disabled'
            when: !mEnabled
            PropertyChanges { target: idBtnBackImage;       source: bgImage; }
            PropertyChanges { target: idBtnForeImage;       source: fgImage; }
        }
    ]
}
/* EOF */
