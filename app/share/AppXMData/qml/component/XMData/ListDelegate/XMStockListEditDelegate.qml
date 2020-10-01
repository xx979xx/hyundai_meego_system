import Qt 4.7

// System Import
import "../../QML/DH" as MComp

Component {
    MComp.MComponent {
        id: idListItem
        x:0; y:0
        z: index
        width:ListView.view.width-35;
        height: 92
        Image {
            id: idBGFocus
            x: 0; y:0
            source: (idListItem.activeFocus && focusOn) ? imageInfo.imgFolderMusic + "tab_list_f.png" : ""
        }
        Image {
            x: 0; y: parent.height
            source: imageInfo.imgFolderMusic + "tab_list_line.png"
        }
        Text {
            id: idText
            x: 49
            y: 0//44 - font.pixelSize/2;
            width: 294
            height: 91
            text: Symbol
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: idAmount
            x: idText.x + idText.width + 39
            y: 0//idText.y
            width: 181
            height: 91
            text: LastSale
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: idPoint
            x: idAmount.x + idAmount.width + 115
            y: 0//idText.y
            width: 207
            height: 91
            text: PriceChange
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: changeTextColor(idPoint.text)
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }

        onHomeKeyPressed: {
            gotoFirstScreen();
        }
        onBackKeyPressed: {
            gotoBackScreen(false);//CCP
        }
        onWheelRightKeyPressed: {
            if(ListView.view.flicking || ListView.view.moving)   return;
            ListView.view.moveOnPageByPage(rowPerPage, true);

        }
        onWheelLeftKeyPressed: {
            if(ListView.view.flicking || ListView.view.moving)   return;
            ListView.view.moveOnPageByPage(rowPerPage, false);

        }
        onClickOrKeySelected: {
            ListView.view.currentIndex = index;
        }
    }
}
