import QtQuick 1.0
import "../../system/DH" as MSystem
import "../../Dmb/JavaScript/DmbOperation.js" as MDmbOperation

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
    property string mTextStyle: idAppMain.fontsR
    property string mTextVerticalAlies: "Center"
    property string mTextHorizontalAlies: "Left"
    property string mTextElide: "None"      // ex) "Right" >> ABCDEFG..
    property bool mTextVisible: true
    property bool mTextEnabled: true
    property string mTextColor: colorInfo.subTextGrey
    property string mTextPressColor : mTextColor
    property string mTextWrapMode : "None" // "None", "WordWrap"

    Text {
        id: idText
        text: mText
        x: mTextX
        y: mTextY-(mTextSize/2)
        width: mTextWidth
        height: idText.paintedHeight//mTextHeight
        color: mTextColor
        font.family: mTextStyle
        font.pixelSize: mTextSize
	verticalAlignment: { MDmbOperation.getVerticalAlignment(mTextVerticalAlies) }
        horizontalAlignment: { MDmbOperation.getHorizontalAlignment(mTextHorizontalAlies) }
        elide: { MDmbOperation.getTextElide(mTextElide) }
        visible: mTextVisible
        clip: true
        enabled: mTextEnabled
	wrapMode: {
            if(mTextWrapMode == "WordWrap") { Text.WordWrap }
            else if(mTextWrapMode == "None"){ "" }
        }
    } // End Text

    states: [
        State {
            name: 'pressed'; when: isMousePressed()
            PropertyChanges {target: idText; color: mTextPressColor;}
        }
    ]
} // End MText
