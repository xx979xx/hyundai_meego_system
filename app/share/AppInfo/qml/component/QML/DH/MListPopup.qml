/**
 * FileName: MListPopup.qml
 * Author: jyjeon
 * Time: 2012-02-22
 *
 * - 2012-02-22 Initial Crated by jyjeon
 */
import QtQuick 1.0

MComponent {
    id: idListPopup
    x: 0; y: systemInfo.statusBarHeight
    width: parent.width; height: parent.height
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    //--------------------- List Click Event #
    signal listClicked(int listIndex)

    //--------------------- Button Click Event #
    signal btn0Click()
    signal btn1Click()
    signal btn2Click()
    signal btn3Click()

    //--------------------- Model Info #
    property QtObject btnModel
    property QtObject listModel

    //--------------------- Popup Info #
    property int popupX: 204
    property int popupY: 190-systemInfo.statusBarHeight // 97
    property int popupWidth: 872
    property int popupHeight: titleTextY + titleTextHeight + msgTextHeight + btnAreaHeight + 5

    //--------------------- Title Info #
    property string titleText : "Tilte"
    property int titleTextWdith: 798
    property int titleTextHeight: titleTextSize
    property int titleTextX: 32
    property int titleTextY: 55
    property int titleTextSize: 44
    property string titleTextName: "HDBa1"
    property string titleTextAlies: "Left"

    //--------------------- Message Info #
    property int msgTextWidth: 783
    property int msgTextHeight: 84*(listModel.count)
    property int msgTextX: 0
    property int msgTextY: titleTextY + titleTextHeight
    property int msgTextSize: 21
    property string msgTextName: "HDBa1"
    property string msgTextAlies: "Center"

    //--------------------- Button Info #
    //--------------------- Button Area Info ##
    property int btnAreaX: 0                                  // Set function
    property int btnAreaY: msgTextY + msgTextHeight + 5
    property int btnAreaWidth: 0                              // Set function
    property int btnAreaHeight: 113*(!(btnModel.count==0))
    //--------------------- Button Image Info ##
    property int btnWidth: 206
    property int btnHeight: 70
    //--------------------- Button Text Info ##
    property int btnTextX: 0
    property int btnTextY: 36
    property int btnTextSize: 30
    property string btnTextName: "HDBa1"
    property string btnTextAlies: "Center"

    //--------------------- Image Path Info #
    property string imgFolderPopup : imageInfo.imgFolderPopup

    //--------------------- Set action of Button
    function btnClickEvent(index){
        switch(index){
        case 0:{
            idListPopup.btn0Click();
            break;
        } // End case
        case 1:{
            idListPopup.btn1Click();
            break;
        } // End case
        case 2:{
            idListPopup.btn2Click();
            break;
        } // End case
        case 3:{
            idListPopup.btn3Click();
            break;
        } // End case
        default:
            console.log(" # Can't have ClickEvent !")
            break;
        } // End switch
    } // End function


    //--------------------- Set Wdith of button area
    function setBtnAreaWidth(){
        btnAreaWidth = btnWidth*listBtnPopup.count
        console.log(" # Exec function setBtnAreaWidth(), btnAreaWidth : ",btnAreaWidth)
        setBtnAreaX(btnAreaWidth)
    } // End function

    //--------------------- Set X of button area
    function setBtnAreaX(btnAreaWidth){
        btnAreaX = (popupWidth-btnAreaWidth)/2
        console.log(" # Exec function setBtnAreaX(), btnAreaX : ",btnAreaX)
    } // End function

    //--------------------- Under Screen Disable
    MouseArea{ anchors.fill: parent }
    //--------------------- Background Black 70%
    Rectangle{
        id:bgDim
        x: 0; y:0//systemInfo.statusBarHeight
        width: systemInfo.lcdWidth
        height: systemInfo.lcdHeight-systemInfo.statusBarHeight
        color: colorInfo.black
        opacity: 0.7
    }

    //--------------------- visible/focus change #
    onVisibleChanged: { if(visible) idListPopup.focus = true }
    onFocusChanged: { console.log(" ==>idListPopup focus: "+ idListPopup.focus) }

    //--------------------- MsgPopup #
    Item {
        id: idPopup
        x: popupX; y: popupY; z:1
        width: popupWidth; height: popupHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        //--------------------- Background Image ##
        Image{
            id: imgBg
            width: popupWidth ; height: popupHeight
            source: (listModel.count < 3)? imgFolderPopup + "popup_c_01_bg.png" : imgFolderPopup + "popup_c_02_bg.png"
        } // End Image

        //--------------------- Title Text ##
        Text{
            id: txtTitle
            text: titleText
            x: titleTextX; y: titleTextY-(titleTextSize/2)
            width: titleTextWdith; height: titleTextHeight
            color: colorInfo.subTextGrey
            font.family: titleTextName
            font.pixelSize: titleTextSize
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: {
                if(titleTextAlies=="Right"){Text.AlignRight}
                else if(titleTextAlies=="Left"){Text.AlignLeft}
                else if(titleTextAlies=="Center"){Text.AlignHCenter}
                else {Text.AlignHCenter}
            } //jyjon_20120302
        } // End Text

        //--------------------- Message ListView ##
        FocusScope{
            id: idListMsgPopup
            x: msgTextX; y: msgTextY
            width: msgTextWidth; height: msgTextHeight
            focus: true
            KeyNavigation.down : idBtnPopup

            ListView {
                id: listMsgPopup
                width: msgTextWidth;
                anchors.fill: parent;
                focus: true
                model: listModel
                delegate: MListPopupListDelegate{}
                orientation : ListView.Vertical
                snapMode: ListView.SnapToItem
                boundsBehavior: Flickable.StopAtBounds
                anchors.verticalCenter: parent.verticalCenter
            }

        } // End Item

        //--------------------- Button ListView ##
        FocusScope{
            id: idBtnPopup
            x: btnAreaX; y: btnAreaY
            width: btnAreaWidth; height: btnAreaHeight
            KeyNavigation.up : idListMsgPopup

            ListView {
                id: listBtnPopup
                width: btnWidth ; height: btnAreaHeight
                focus: true
                anchors.fill: parent;
                model: btnModel
                delegate: MMsgPopupBtnDelegate{}
                orientation : ListView.Horizontal
                snapMode: ListView.SnapToItem
                boundsBehavior: Flickable.StopAtBounds

                Component.onCompleted: {
                    setBtnAreaWidth()
                    //console.log(" # listBtnPopup.count : "+listBtnPopup.count)
                }
            } // End ListView
        } // End Item
    } // End Item
} // End FocusScope
