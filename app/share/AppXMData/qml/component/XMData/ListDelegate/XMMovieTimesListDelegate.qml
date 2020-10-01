import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData/Javascript/ConvertUnit.js" as MConvertUnit

Component {
    MComp.MComponent {
        id: idListItem
        x:24; y:0
        z: index
        width:ListView.view.width; height:93

        Text {
            id: idText
            x: 0; y: 42 - font.pixelSize/2;
            width: 500
            text: theaterName
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide : Text.ElideRight
        }

        Text {
            id: idPoint
            x: 10+109+250+24+120+24; y: 42 - font.pixelSize/2;
            width: 174
            text: MConvertUnit.convertToDU(distanceUnitChange,distance) + (distanceUnitChange == false ? " km" : " mile")
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }

        Loader { id: idFocusImage; x: -12; y: -9}

        Image {
            x: 6; y: parent.height
            source: imageInfo.imgFolderBt_phone + "line_list.png"
        }

        Image {
            x:10+109+250+24+120+24+180+45;
            y: 8+9
            source: selectSource(direction)

            function selectSource(jDirection) {
                var direct = parseInt(jDirection);
                if( direct > 341 || direct <= 11 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_01.png";
                else if( direct > 11 && direct <= 33 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_02.png";
                else if( direct > 33 && direct <= 55 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_03.png";
                else if( direct > 55 && direct <= 77 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_04.png";
                else if( direct > 77 && direct <= 99 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_05.png";
                else if( direct > 99 && direct <= 121 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_06.png";
                else if( direct > 121 && direct <= 143 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_07.png";
                else if( direct > 143 && direct <= 165 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_08.png";
                else if( direct > 165 && direct <= 187 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_09.png";
                else if( direct > 187 && direct <= 209 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_10.png";
                else if( direct > 209 && direct <= 231 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_11.png";
                else if( direct > 231 && direct <= 253 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_12.png";
                else if( direct > 253 && direct <= 275 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_13.png";
                else if( direct > 275 && direct <= 297 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_14.png";
                else if( direct > 297 && direct <= 319 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_15.png";
                else if( direct > 319 && direct <= 341 )
                    return imageInfo.imgFolderVR + "icon_navi_arrow_16.png";
                else
                    return imageInfo.imgFolderVR + "icon_navi_arrow_01.png";
            }
        }

        MComp.Button {
            id: idEditButton
            x: 10+109+250+24+120+24+180+45+126; y: 8+9
            width: 90; height: 69
            bgImage: imageInfo.imgFolderRadio_Xm + "btn_skip_n.png"
            bgImagePressed: imageInfo.imgFolderRadio_Xm + "btn_skip_p.png"
            text: stringInfo.sSTR_XMDATA_GO
            imgFillMode: Image.Stretch
            fontName: systemInfo.font_NewHDB
            bgFocusImageZValue: 3
            bgTextShadowZValue: 2
            fontColorShadow: colorInfo.buttonGrey
            bgTextZValue: 1

            onBackKeyPressed: {
                gotoBackScreen(false);//CCP
            }
            onHomeKeyPressed: {
                gotoFirstScreen();
            }

            onClickOrKeySelected: {
                if(playBeepOn)
                    UIListener.playAudioBeep();
            }
//            onClicked: {
//                UIListener.playAudioBeep();
//            }
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
    Text {
        x:5; y:12; id:idFileName
        text:"XMMovieTimesListDelegate.qml";
        color : "white";
        visible:isDebugMode()
    }
    Rectangle{
        id:idDebugInfoView
        z:200
        visible:isDebugMode()
        Column{
            id:idDebugInfo1
            x: 600
            y: -20
//            Text{text: "[QML Infomation]"; color: "yellow"; }
//            Text{text: "container Focus : " + container.focus; color: "white"; }
//            Text{text: "-idCenterFocusScope Focus : " + idCenterFocusScope.focus; color: "white"; }
//            Text{text: "- idMovieMain Focus : " + idMovieMain.focus; color: "white"; }
//            Text{text: "-  idMovie Focus : " + idMovie.focus; color: "white"; }
//            Text{text: "-  idTheater Focus : " + idTheater.focus; color: "white"; }
//            Text{text: "- idMovieListFocusScope Focus : " + idMovieListFocusScope.focus; color: "white"; }
//            Text{text: "-  idAllMovie Focus : " + idAllMovie.focus; color: "white"; }
//            Text{text: "-  idAllTheater Focus : " + idAllTheater.focus; color: "white"; }

            //Text{text: "-idOptionMenuForAll Focus : " + idOptionMenuForAll.focus; color: "white"; }
        }
    }
}
