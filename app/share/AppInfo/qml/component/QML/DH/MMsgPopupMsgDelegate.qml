/**
 * FileName: MMsgPopupMsgDelegate.qml
 * Author: WSH
 * Time: 2012-02-13
 *
 * - 2012-02-13 Initial Crated by WSH
 */
import QtQuick 1.0

Text {
    id: idMsgPopupMsgDelegate
    text: msgName
    //x: 0; y: titleY
    width: parent.width; height: titleTextSize+(titleTextSize-titleTextSize/2)
    color: colorInfo.brightGrey
    font.family: titleTextName
    font.pixelSize: titleTextSize
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: {
        if(msgTextAlies=="Right"){Text.AlignRight}
        else if(msgTextAlies=="Left"){Text.AlignLeft}
        else if(msgTextAlies=="Center"){Text.AlignHCenter}
        else {Text.AlignHCenter}
    } //jyjon_20120302
} // End Text
