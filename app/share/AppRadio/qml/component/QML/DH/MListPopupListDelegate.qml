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
    x:17; y:0
    width: 875-(x*2)-5; height: 84
    buttonWidth: width; buttonHeight: height
    focus: true
    dimmed: getDimmed()

    function getDimmed(){
        switch(index){
        case 0: return menu0Dimmed;
        case 1: return menu1Dimmed;
        case 2: return menu2Dimmed;
        case 3: return menu3Dimmed;
        case 4: return menu4Dimmed;
        case 5: return menu5Dimmed;
        case 6: return menu6Dimmed;
        case 7: return menu7Dimmed;
        case 8: return menu8Dimmed;
        case 9: return menu9Dimmed;
        case 10: return menu10Dimmed;

        default: return false;
        }
    } // End function

    onDimmedChanged: { console.log(" [MOptionMenuDelegate]["+index+"]: "+!getDimmed()) }

    //****************************** # Preperty #
    property string imgFolderPopup : imageInfo.imgFolderPopup

    //****************************** # Button Image Info # by WSH
    bgImagePress: imgFolderPopup+"bg_etc_list_p.png"
    bgImageFocusPress: imgFolderPopup+"bg_etc_list_fp.png"
    bgImageFocus: imgFolderPopup+"bg_etc_list_f.png"

    //****************************** # Text Info # by WSH
    firstText: msgName
    firstTextX: 42; firstTextY: 42
    firstTextWidth: idListPopupListDelegate.width
    firstTextHeight: firstTextSize
    firstTextSize: 32
    firstTextStyle: systemInfo.hdb
    firstTextAlies: "Left"
    firstTextColor: colorInfo.brightGrey
    //firstTextElide: "Right"

    //****************************** # Line Image #
    Image{
        source: imgFolderPopup+"popup_c_list_line.png"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    onWheelLeftKeyPressed: {
        if( idListPopupListDelegate.ListView.view.currentIndex ){
            idListPopupListDelegate.ListView.view.decrementCurrentIndex();
        }
        else{
            idListPopupListDelegate.ListView.view.positionViewAtIndex(idListPopupListDelegate.ListView.view.count-1, idListPopupListDelegate.ListView.view.Visible);
            idListPopupListDelegate.ListView.view.currentIndex = idListPopupListDelegate.ListView.view.count-1;
        }
    }
    onWheelRightKeyPressed: {
        if( idListPopupListDelegate.ListView.view.count-1 != idListPopupListDelegate.ListView.view.currentIndex ){
            idListPopupListDelegate.ListView.view.incrementCurrentIndex();
        }
        else{
            idListPopupListDelegate.ListView.view.positionViewAtIndex(0, ListView.Visible);
            idListPopupListDelegate.ListView.view.currentIndex = 0;
        }
    }

    onClickOrKeySelected: {
        idListPopupListDelegate.ListView.view.currentIndex = index
        if(!idListPopupListDelegate.dimmed){
            listClicked(index)
        } // End If
    }
}
