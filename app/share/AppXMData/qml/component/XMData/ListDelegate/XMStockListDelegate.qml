import Qt 4.7

// System Import
import "../../QML/DH" as MComp

Component {
    MComp.MComponent {
        id: idListItem
        x:24; y:0
        z: index
        width:ListView.view.width; height:93

        // Function for Change Text Color
        function changeTextColor(text) {
            if( text.charAt(0) == '+')
                return "#2F7DFF";
            else if( text.charAt(0) == '-')
                return "#EA3939";
            else
                return colorInfo.brightGrey;
        }

        Text {
            id: idText
            x: 6; y: 42 - font.pixelSize/2;
            width: 465
            text: modelData
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            id: idAmount
            x: 6+465+107; y: 42 - font.pixelSize/2;
            width: 304
            text: stockDataManager.searchLastSale(modelData)
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            id: idPoint
            x: 6+465+107+304+107; y: 42 - font.pixelSize/2;
            width: 237
            text: stockDataManager.searchPriceChange(modelData)
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: changeTextColor(idPoint.text)
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }

        Loader { id: idFocusImage; x: -12; y: -9}

        Image {
            x: 6; y: parent.height
            source: imageInfo.imgFolderBt_phone + "line_list.png"
        }

        Component {
            id: idBGFocus
            Image {
//                source: imageInfo.imgFolderDmb + "list_dmb_f.png"
                source: imageInfo.imgFolderGeneral + "list_f.png"
            }
        }

//        Loader { id: idFocusImage; x: -12; y: -9}

        states: [
            State {
                name: "active"; when: idListItem.activeFocus && focusOn
                PropertyChanges { target: idFocusImage; sourceComponent: idBGFocus }
//                StateChangeScript { script: ListView.view.positionViewAtIndex(index, ListView.Contain) }
            },
            State {
                name: "inactive"; when: !idListItem.activeFocus
                PropertyChanges { target: idFocusImage; source: '' }
            }
        ]

        onClickOrKeySelected: {
            itemClicked(idText.text);
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
    }
}
