/**
 * FileName: MListPopupListDelegate.qml
 * Author: jyjeon
 * Time: 2012-02-22
 *
 * - 2012-02-22 Initial Crated by jyjeon
 */
import QtQuick 1.0

MButton {
    id: idListPopupListDelegate
    x:10; y:0
    width: parent.width-(x*2); height: 84
    buttonWidth: width; buttonHeight: height
    focus: true

    //****************************** # Preperty #
    property string imgFolderPopup : imageInfo.imgFolderPopup

    bgImagePress: imgFolderPopup+"popup_c_list_p.png"
    bgImageFocusPress: imgFolderPopup+"popup_c_list_fp.png"
    bgImageFocus: imgFolderPopup+"popup_c_list_f.png"

    firstText: msgName
    firstTextX: 32; firstTextY: firstTextSize+(firstTextSize-firstTextSize/2)
    firstTextWidth: buttonWidth-(firstTextX*2)
    firstTextSize: 32
    firstTextStyle: "HDBa1"
    firstTextAlies: "Left"
    firstTextColor: colorInfo.brightGrey

    //****************************** # Line Image #
    Image{
        x: 0-x;
        source: imgFolderPopup+"popup_c_list_line.png"
        anchors.bottom: parent.bottom
    }

    onClickOrKeySelected: {
        idListPopupListDelegate.ListView.view.currentIndex = index
        listClicked(index)
    }
}
