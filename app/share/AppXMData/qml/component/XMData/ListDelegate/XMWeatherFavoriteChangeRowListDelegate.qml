/**
 * FileName: XMFuelPricesFavoriteChangeRowListDelegate.qml
 * Author: David.Bae
 * Time: 2012-04-26 16:46
 *
 * - 2012-04-26 Initial Created by David
 */
import Qt 4.7

// System Import
import "../../QML/DH" as MComp

XMDataChangeRowListDelegate {
    id:idListItem

    x:0
    y:0
    height:92

    MComp.DDScrollTicker{
        id: idText
        x: 101; y: 0;
        width: 996
        height: parent.height
        text: toolTip
        fontFamily : systemInfo.font_NewHDR
        fontSize: 40
        //color: colorInfo.brightGrey
        color: idListView.isDragStarted ? idListItem.isDragItem ? colorInfo.brightGrey : colorInfo.disableGrey : colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }
}
