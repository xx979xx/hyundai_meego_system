/**
 * /QML/DH/MDimCheck.qml
 *
 */
import QtQuick 1.1
import "../../BT/Common/System/DH/ImageInfo.js" as ImagePath


MComponent
{
    id: idDimCheck
    x: iconX; y: iconY
    width: 45; height: 45
    anchors.verticalCenter: parent.verticalCenter
    state: "off"

    // PROPERTIES
    property bool flagToggle: (state == "on")? true : false

    property int iconX: 0
    property int iconY: 0
    property string bgImage: ImagePath.imgFolderGeneral + "ico_check_n.png"
    property string bgImageSelected: ImagePath.imgFolderGeneral + "ico_check_s.png"

    // SIGNALS
    signal dimUnchecked()
    signal dimChecked()


    function toggle() {
        if (idDimCheck.state == "on"){
            idDimCheck.state = "off";
            dimUnchecked();
        } else {
            idDimCheck.state = "on";
            dimChecked();
        }
    }


    /* EVENT handlers */
    onVisibleChanged: {
        idDimCheck.state = "off"
    }

    onClickOrKeySelected: { 
        if(!idDimCheck.dimmed) {
            toggle();
        }
    }


    /* WIDGETS */
    Image {
        id: imgDimCheckOff
        source: bgImage
    }

    Image {
        id: imgDimCheckOn
        source: bgImageSelected
        visible: false
    }


    /* STATES */
    states: [
        State { name: "on" ; PropertyChanges { target: imgDimCheckOn; visible: true } },
        State { name: "off"; PropertyChanges { target: imgDimCheckOn; visible: false } }
    ]
}
/* EOF */
