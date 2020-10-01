import Qt 4.7

// System Import
import "../../QML/DH" as MComp

Component {
    MComp.MComponent {
        id: idListItem
        x:24; y:0
        z: index
        width:ListView.view.width; height:93

        Text {
            id: idText
            x: 6; y: 44 - font.pixelSize/2;
            width: 1207
            clip: true
            text: display
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
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
                source: imageInfo.imgFolderGeneral + "list_f.png"
            }
        }


        states: [
            State {
                name: "active"; when: idListItem.activeFocus && focusOn
                PropertyChanges { target: idFocusImage; sourceComponent: idBGFocus }
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
