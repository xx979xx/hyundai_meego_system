import QtQuick 1.0
import "../../system/DH" as MSystem

Item {
    id : idMText

    MSystem.ColorInfo{ id: colorInfo }
    MSystem.ImageInfo{ id: imageInfo }
    MSystem.SystemInfo{ id: systemInfo }

    property string mText: ""
    property int mTextX: 0
    property int mTextY: 0
    property int mTextSize: 0
    property int mTextWidth: 0
    property int mTextHeight: mTextSize+4
    property string mTextStyle: systemInfo.hdr//"HDR"
    property string mTextAlies: "Left"
    property string mTextElide: "None"      // ex) "Right" >> ABCDEFG..
    property bool mTextVisible: true
    property bool mTextEnabled: true
    property string mTextColor: colorInfo.subTextGrey
    property string mTextPressColor : mTextColor

    Text {
        id: idText
        text: mText
        x: mTextX
        y: mTextY-(mTextSize/2)
        width: mTextWidth
        height: mTextHeight
        color: mTextColor
        font.family: mTextStyle
        font.pixelSize: mTextSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: {
            if(mTextAlies=="Right"){Text.AlignRight}
            else if(mTextAlies=="Left"){Text.AlignLeft}
            else if(mTextAlies=="Center"){Text.AlignHCenter}
            else {Text.AlignHCenter}
        }
        elide: {
            if(mTextElide=="Right"){Text.ElideRight}
            else if(mTextElide=="Left"){Text.ElideLeft}
            else if(mTextElide=="Center"){Text.ElideMiddle}
            else /*if(mTextElide=="None")*/{Text.ElideNone}
        }
        visible: mTextVisible
        clip: true
        enabled: mTextEnabled
    } // End Text

    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: idText; color: mTextPressColor;}
        }
    ]
} // End MText
