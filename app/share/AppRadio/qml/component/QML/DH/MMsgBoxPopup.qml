/**
 * FileName: MMsgBoxPopup.qml
 * Author: jyjeon
 * Time: 2012-02-23
 *
 * - 2012-02-23 Initial Crated by jyjeon
 */
import QtQuick 1.0

MComponent {
    id: idMMsgBoxPopup
    x: 0; y: systemInfo.statusBarHeight
    width: parent.width; height: parent.height
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    //--------------------- Button Click Event #
    signal btn0Click()
    signal btn1Click()
    signal btn2Click()
    signal btn3Click()

    //--------------------- Model Info #
    property string msgString
    property QtObject btnModel

    //--------------------- Popup Info #
    property int popupX: 110
    property int popupY: 130-systemInfo.statusBarHeight // 37
    property int popupWidth: 1086
    property int popupHeight: 505

    //--------------------- Title Info #
    property string titleText : "Tilte"
    property int titleTextWdith: 986
    property int titleTextHeight: titleTextSize
    property int titleTextX: 55
    property int titleTextY: 55
    property int titleTextSize: 44
    property string titleTextName: systemInfo.hdb
    property string titleTextAlies: "Left"
    property string titleTextColor : colorInfo.subTextGrey

    //--------------------- MessageBox Info #
    property int msgBoxWidth:  996
    property int msgBoxHeight: 70*3 -1  //3 line
    property int msgBoxX: 45
    property int msgBoxY: 173-msgBoxSize/2
    property int msgBoxSize: 50
    property string msgBoxName: systemInfo.hdb
    property string msgBoxAlies: "Center"

    //--------------------- Scroll Info(Property) ##
    property int scrollWidth: 13
    property int scrollY: 5

    //--------------------- Button Info #
    //--------------------- Button Area Info ##
    property int btnAreaX: 0                                  // Set function
    property int btnAreaY: 392
    property int btnAreaWidth: 0                              // Set function
    property int btnAreaHeight: btnHeight                     // 70
    //--------------------- Button Image Info ##
    property int btnWidth: 206
    property int btnHeight: 70
    //--------------------- Button Text Info ##
    property int btnTextX: 0
    property int btnTextY: 36
    property int btnTextSize: 30
    property string btnTextName: systemInfo.hdb
    property string btnTextAlies: "Center"

    //--------------------- Image Path Info #
    property string imgFolderPopup : imageInfo.imgFolderPopup

    //--------------------- Set action of Button
    function btnClickEvent(index){
        switch(index){
        case 0:{
            idMMsgBoxPopup.btn0Click();
            break;
        } // End case
        case 1:{
            idMMsgBoxPopup.btn1Click();
            break;
        } // End case
        case 2:{
            idMMsgBoxPopup.btn2Click();
            break;
        } // End case
        case 3:{
            idMMsgBoxPopup.btn3Click();
            break;
        } // End case
        default:{
            console.log(" # Can't have ClickEvent !")
            break;
        } // End default
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
        x: 0; y: parent.y
        width: systemInfo.lcdWidth
        height: parent.height
        color: colorInfo.black
        opacity: 0.6
    } // End Rectangle

    //--------------------- visible/focus change #
    onVisibleChanged: { if(visible) idMMsgBoxPopup.focus = true }
    onFocusChanged: { console.log(" ==>idMMsgBoxPopup focus: "+ idMMsgBoxPopup.focus) }

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
            source: imgFolderPopup + "popup_d_bg.png"
        } // End Image

        //--------------------- Title Text ##
        Text{
            id: txtTitle
            text: titleText
            x: titleTextX; y: titleTextY-(titleTextSize/2)
            width: titleTextWdith; height: titleTextHeight
            color: titleTextColor
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


        //--------------------- Message TextEditBox ##
        Item{
            id:textBox
            x: msgBoxX; y: msgBoxY
            width: msgBoxWidth; height: msgBoxHeight
            clip: true

            Flickable {
                id: flick
                contentX:textEditBox.x; contentY: textEditBox.y
                contentWidth: textEditBox.paintedWidth
                contentHeight: textEditBox.paintedHeight
                flickableDirection: Flickable.VerticalFlick;
                boundsBehavior : Flickable.DragOverBounds//Flickable.StopAtBounds
                anchors.fill: parent;
                clip: true

                function ensureVisible(r)
                {
                    if (contentX >= r.x)
                        contentX = r.x;
                    else if (contentX+width <= r.x+r.width)
                        contentX = r.x+r.width-width;
                    if (contentY >= r.y)
                        contentY = r.y;
                    else if (contentY+height <= r.y+r.height)
                        contentY = r.y+r.height-height;
                }

                TextEdit{
                    id:textEditBox
                    width: msgBoxWidth-scrollWidth; height: msgBoxHeight
                    text: msgString
                    font.pixelSize: msgBoxSize
                    font.family: msgBoxName
                    horizontalAlignment: {
                        if(msgBoxAlies=="Right"){TextEdit.AlignRight}
                        else if(msgBoxAlies=="Left"){TextEdit.AlignLeft}
                        else if(msgBoxAlies=="Center"){TextEdit.AlignHCenter}
                        else {TextEdit.AlignHCenter}
                    } //jyjon_20120302
                    color: colorInfo.brightGrey
                    activeFocusOnPress: false
                    cursorVisible: false
                    readOnly: true
                    wrapMode: TextEdit.Wrap
                    anchors.horizontalCenter: parent.horizontalCenter
                    onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
                }
            } // End Flickable

            //--------------------- ScrollBar #
           MScroll {
               x:parent.x+parent.width-scrollWidth; y:flick.y+scrollY; z:1
               scrollArea: flick;
               height: flick.height-(scrollY*2)-8; width: scrollWidth
               anchors.right: flick.right
               visible: flick.contentHeight > msgBoxHeight
               selectedScrollImage: imgFolderPopup+"scroll_bell_bg.png"
           } //# End MScroll
        } // End Item

        //--------------------- Button ListView ##
        Item{
            id: idBtnPopup
            x: btnAreaX; y: btnAreaY
            width: btnAreaWidth; height: btnAreaHeight

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
