import Qt 4.7

// System Import
import "../../QML/DH" as MComp

Component {
    MComp.MComponent {
        id: idListItem
        x:24; y:0
        z: index
        width:ListView.view.width; height:93

        function iconImagePath() {
            switch( sportsDataManager.searchLEAGUEName(modelData) )
            {
            case "MLB"    : return imageInfo.imgFolderXMData + "icon_xm_team_01.png";
            case "NFL"    : return imageInfo.imgFolderXMData + "icon_xm_team_02.png";
            case "NBA"    : return imageInfo.imgFolderXMData + "icon_xm_team_03.png";
            case "NHL"    : return imageInfo.imgFolderXMData + "icon_xm_team_04.png";
            case "NASCAR" : return imageInfo.imgFolderXMData + "icon_xm_team_05.png";
            case "OTHER"  : return imageInfo.imgFolderXMData + "icon_xm_team_06.png";
            default: return "";
            }
        }

        Image {
            x: 11; y: 11
            source: iconImagePath();
        }

        Text {
            id: idText
            x: 11+88 ; y: 42 - font.pixelSize/2;
            width: 1007
            text: modelData
            font.family: systemInfo.font_NewHDB
            font.pixelSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Loader { id: idFocusImage; x: -12; y: -9}

        Image {
            y: parent.height
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
