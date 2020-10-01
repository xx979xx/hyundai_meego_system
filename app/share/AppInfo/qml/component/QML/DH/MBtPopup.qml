/**
 * FileName: MMsgPopup.qml
 * Author: problem Kang
 * Time: 2012-02-13
 *
 * - 2012-03-13 Initial Crated by problem Kang

 */
import QtQuick 1.0

MComponent { //jyjeon_20120221
    id: idMMsgPopup
    x: 0; y: systemInfo.statusBarHeight
    width: parent.width; height: parent.height
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    property string popupName: ""

    //--------------------- Button Click Event #
    signal btn0Click()
    signal btn1Click()

    //--------------------- Image Path Info #
    property string imgFolderPopup : imageInfo.imgFolderPopup

    //--------------------- Set action of Button
    function btnClickEvent(index){
        switch(index){
        case 0:{
            idMMsgPopup.btn0Click();
            break;
        } // End case
        case 1:{
            idMMsgPopup.btn1Click();
            break;
        } // End case
        default:
            console.log(" # Can't have ClickEvent !")
            break;
        } // End switch
    } // End function

    //--------------------- Under Screen Disable
    MouseArea{ anchors.fill: parent }
    //--------------------- Background Black 70%
    Rectangle{
        id:bgDim
        x: 0; y:0//systemInfo.statusBarHeight //jyjeon_20120221
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight-systemInfo.statusBarHeight
        color: colorInfo.black
        opacity: 0.7
    }
        Image{
            id: imgBg
            width: popupWidth ; height: popupHeight
            source: imgFolderPopup + "popup_d_bg.png"
//            Text{
//                text:
//            }


        } // End Image
    }
//} // End FocusScope
