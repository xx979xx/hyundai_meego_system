import QtQuick 1.1
import "../system" as MSystem

Text {

    MSystem.StringInfo { id: stringInfo }
    MSystem.ColorInfo { id: colorInfo }

    id: container

    color: colorInfo.brightGrey
    font.family: stringInfo.fontNameSetting
    clip: true
    horizontalAlignment: {
        if (cppToqml.IsArab) {Text.AlignRight}
        else {Text.AlignLeft}
    }
    //elide: Text.ElideRight
    wrapMode: Text.WordWrap
}
