import QtQuick 1.1
import "../system" as MSystem

FocusScope {
    id: container

    width: 533
    height: 90
    z:3

    MSystem.SystemInfo{ id: systemInfo }
    MSystem.ColorInfo { id: colorInfo }

    property bool isChecked : false
    property int txtLeftMargin : 25
    property int txtAreaWidth : container.width-8-leftMarginItem.width
    property string txt: ""

    property string nImagePathOrigin: systemInfo.imageInternal + "checkbox_uncheck.png"
    property string sImagePathOrigin: systemInfo.imageInternal + "checkbox_check.png"

    property string nImagePath: nImagePathOrigin
    property string sImagePath: sImagePathOrigin
    property string dImagePath: systemInfo.imageInternal + "checkbox_dim_uncheck.png"
    property string dsImagePath: systemInfo.imageInternal + "checkbox_dim_check.png"
    property int txtFontSize : systemInfo.normalFontSize//normalFontSize

    state: "normal"

    Column {
        spacing: 0
        Row {
            spacing: 0
            layoutDirection: (cppToqml.IsArab)? Qt.RightToLeft : Qt.LeftToRight

            Item {
                id: leftMarginItem
                height: container.height
                width: txtLeftMargin
            }

            MText {
                id: idOptionText
                height: container.height-3
                width: txtAreaWidth
                text: txt
                font.pointSize : txtFontSize
                verticalAlignment: Text.AlignVCenter;
            }

            Image {
                id: idCheckImage
                anchors.verticalCenter: parent.verticalCenter
                width: 44; height: 44
                source: isChecked ? sImagePath : nImagePath
            }

            Item {
                height: container.height
                width: container.width - (txtLeftMargin+txtAreaWidth+idCheckImage.width)
            }

        }

    } //ENd Coloum

    states: [
        State {
            name: "normal";
            PropertyChanges {target: container; sImagePath: sImagePathOrigin;}
            PropertyChanges {target: container; nImagePath: nImagePathOrigin;}
            PropertyChanges {target: idOptionText; color: colorInfo.brightGrey;}
            PropertyChanges {target: container; MouseArea.enabled: true;}
        },
        State {
            name: "dimmed";
            PropertyChanges {target: container; sImagePath: dsImagePath;}
            PropertyChanges {target: container; nImagePath: dImagePath;}
            PropertyChanges {target: idOptionText; color: colorInfo.dimmedGrey;}
            PropertyChanges {target: container; MouseArea.enabled: false;}
        }

    ]
}
