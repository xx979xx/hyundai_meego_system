/**
 * FileName: SportsRankedListDetail.qml
 * Author: David.Bae
 * Time: 2012-06-04 18:04
 *
 * - 2012-06-04 Initial Created by David
 */
import Qt 4.7

// System Import
import "../QML/DH" as MComp
// Label Import
import "./Common" as XMCommon
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "../XMData" as MXData
//import "../../component/XMData/Common" as XMCommon

MComp.MComponent {
    id:container
    x:0; y:0;
    XMCommon.StringInfo { id: stringInfo }

    focus: true
    Image{
        id: idBgImage
        x: 0; y: 0
        width: 1280; height: 555
        source : (container.activeFocus == true && focusOn) ? imageInfo.imgFolderGeneral + "bg_full_f.png" : ""
    }

    // For List Header/////////////////////////////////////////////////////////////////////////////
    Component{
        id: idProgressMotorScoreHeader                      // Motor List Header :: not Final
        Item {
            Image{
                id: idLineBar1
                x: 0; y: 0;
                source: imageInfo.imgFolderGeneral + "list_line.png"
            }
            Image{
                id: idLineBar2
                x: 0; y:idLineBar1.y+64;
                source: imageInfo.imgFolderGeneral + "list_line.png"
            }
            Image{
                id: idLineDividerBar1
                x: 178; y:idLineBar1.y;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Image{
                id: idLineDividerBar2
                x: idLineDividerBar1.x+422; y:idLineBar1.y;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Image{
                id: idLineDividerBar3
                x: idLineDividerBar2.x+121; y:idLineBar1.y;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Image{
                id: idLineDividerBar4
                x: idLineDividerBar3.x+368; y:idLineBar1.y;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Text {
                id: idOrder
                x: 57; y:idLineBar1.y+25-(font.pixelSize/2);
                width: 112
                text: "Order"
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idDriver
                x: idOrder.x+idOrder.width+20; y:idOrder.y;
                width: 402
                text: "Driver"
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idNumber
                x: idDriver.x+idDriver.width+21; y:idOrder.y;
                width: 100
                text: "No."
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idCar
                x: idNumber.x+idNumber.width+20; y:idOrder.y;
                width: 348
                text: "Car"
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idLaps
                x: idCar.x+idCar.width+20; y:idOrder.y;
                width: 112
                text: "Laps"
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
        }
    }

    Component{
        id: idFinalMotorScoreHeader                      // Motor List Header :: Final
        Item {
            Image{
                id: idLineBar1
                x: 0; y: 0;
                source: imageInfo.imgFolderGeneral + "list_line.png"
            }
            Image{
                id: idLineBar2
                x: 0; y:idLineBar1.y+64;
                source: imageInfo.imgFolderGeneral + "list_line.png"
            }
            Image{
                id: idLineDividerBar1
                x: 260; y:idLineBar1.y;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Image{
                id: idLineDividerBar2
                x: idLineDividerBar1.x+790; y:idLineBar1.y;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Text {
                id: idTime
                x: 57; y:idLineBar1.y+25-(font.pixelSize/2);
                width: 180
                text: "Time"
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idWinner
                x: idTime.x+idTime.width+40; y:idLineBar1.y+25-(font.pixelSize/2);
                width: 750
                text: "Winner"
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idLap
                x: idWinner.x+idWinner.width+40; y:idLineBar1.y+25-(font.pixelSize/2);
                width: 100
                text: "Laps"
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
        }
    }

    Component{
        id: idGolfScoreHeader                               // Golf List Header
        Item{
            Image{
                id: idGolfLineBar1
                x: 0; y: 0;
                source: imageInfo.imgFolderGeneral + "list_line.png"
            }
            Image{
                id: idGolfLineBar2
                x: 0; y:idGolfLineBar1.y+64;
                source: imageInfo.imgFolderGeneral + "list_line.png"
            }
            Image{
                id: idGolfLineDividerBar1
                x: 170; y:idGolfLineBar1.y;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Image{
                id: idGolfLineDividerBar2
                x: idGolfLineDividerBar1.x+830; y:idGolfLineBar1.y;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Text {
                id: idRank
                x: 57; y:idGolfLineBar1.y+25-(font.pixelSize/2);
                width: 112
                text: "Rank"
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idName
                x: idRank.x+idRank.width+21; y:idRank.y;
                width: 890-80
                text: "Name"
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idScore
                x: idName.x+idName.width+20; y:idRank.y;
                width: 112+80
                text: "Score"
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    onVisibleChanged: {
        if(visible)
            idMenuBar.textTitle = sportsRankDetailItemModel.raceName;
    }

    Component{
        id: idListDelegate
        XMDelegate.XMSportsScoreNScheduleListDelegateRankedList{
        }
    }

    Flickable{
        id: idDetailFullScreen
        anchors.fill: parent
        contentX: 0; contentY: 0
        contentWidth: parent.width
        contentHeight: idDetailHeader.height + idDetailScoreList.height + 1
        flickableDirection: Flickable.VerticalFlick
        interactive : contentHeight > height ? true : false
        clip: true;
        focus: false;


        onMovementStarted:{
            idMenuBar.contentItem.focus = true;
        }

        MouseArea{
            anchors.fill: parent
            onReleased: {
                if(idMenuBar.contentItem != null)
                    idMenuBar.contentItem.focus = true;
            }
        }

        Item{
            id: idDetailHeader
            x: 0; y:0
            width: parent.width
            height: 320 - 166 + 64
            Text {
                id: idTitle
                x: 58
                y: 40-(font.pixelSize/2);
                width: 1021
                height: font.pixelSize
                text: sportsRankDetailItemModel.trackName//trackName
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 40
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                x: 58
                y: idTitle.y+56;
                width: 1021
                height: font.pixelSize
                text: sportsRankDetailItemModel.sportsID == sportsLabel.iSPORTS_GOLF ? "$" + getCurrencyStringByPurse(sportsRankDetailItemModel.purse) + " " + "/" + " " + getCurrencyStringByPurse(sportsRankDetailItemModel.yds) + " " + "yardage" : getStringFromEpoch()
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 36
                color: colorInfo.grey
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            MComp.MButton {
                id: idLiveCast
                visible: (sportsRankDetailItemModel.homeTeamCommentaryChannel > 0 || sportsRankDetailItemModel.visitingTeamCommentaryChannel > 0 || sportsRankDetailItemModel.nationalTeamCommentaryChannel > 0)
                x: 930+100+58
                y: idTitle.y
                width:138;
                height: 112
                bgImage: imageInfo.imgFolderXMData + "btn_widget_02_n.png"
                bgImagePress: imageInfo.imgFolderXMData + "btn_widget_02_p.png"
                bgImageFocus: imageInfo.imgFolderXMData + "btn_widget_02_f.png"
                bgImageFocusPress: imageInfo.imgFolderXMData + "btn_widget_02_p.png"

                fgImage: imageInfo.imgFolderXMData + "icon_widget_radio.png"
                fgImageX: 33
                fgImageY: 14
                fgImageWidth: 77
                fgImageHeight: 77
                fgImageVisible: true;

                onClickOrKeySelected: {
                    var hCH = sportsRankDetailItemModel.homeTeamCommentaryChannel;
                    var vCH = sportsRankDetailItemModel.visitingTeamCommentaryChannel;
                    var nCH = sportsRankDetailItemModel.nationalTeamCommentaryChannel;

                    idPopupLiveCast.show(hCH,vCH,nCH);
                }
                MXData.XMRectangleForDebug{}
            }

            Loader{
                id: idDetailScoreListHeader
                x: 0
                y: 320 - 166
                width: parent.height
                height: 64
                sourceComponent: sportsRankDetailItemModel.sportsID == sportsLabel.iSPORTS_GOLF ? idGolfScoreHeader :
                                                                                                  sportsRankDetailItemModel.eventState == sportsLabel.iEVENT_STATE_FINAL ? idFinalMotorScoreHeader : idProgressMotorScoreHeader;
            }
        }

        ListView {
            id: idDetailScoreList
            x: 0; y: idDetailHeader.height
            width: parent.width
            height: 64*count+2  // for bottom line
            clip: true
            model: sportsRankDetailItemModel
            delegate: idListDelegate
            interactive: false
        }
        Behavior on contentY{
            SmoothedAnimation{duration: 100}
        }
    }

    MComp.MScroll{
        x:idDetailFullScreen.x + idDetailFullScreen.width - 28; y: 33// z:1
        width: 14
        height: idDetailFullScreen.height-y-y//474;
        scrollArea:idDetailFullScreen
        selectedScrollImage: imgFolderGeneral+"scroll_menu_list_bg.png"
        visible: idDetailFullScreen.interactive
    }

    onWheelLeftKeyPressed: {
        var tempContentY = idDetailFullScreen.contentY - (64*3);
        if(tempContentY < 0)
            idDetailFullScreen.contentY = 0;
        else
            idDetailFullScreen.contentY = tempContentY;
    }

    onWheelRightKeyPressed: {
        var tempContentY = idDetailFullScreen.contentY + (64*3);
        if(tempContentY > idDetailFullScreen.contentHeight - idDetailFullScreen.height)
            idDetailFullScreen.contentY = idDetailFullScreen.contentHeight - idDetailFullScreen.height;
        else
            idDetailFullScreen.contentY = tempContentY;
    }

    function onCheckFocus(){
        if(idDetailFullScreen.interactive)
        {
            // over size
            upFocusAndLock(false);
        }else
        {
            upFocusAndLock(true);
        }
    }

    function getCurrencyStringByPurse(str)
    {
        var reg = /(^[+-]?\d+)(\d{3})/;
        var n = str;
        n +='';
        while (reg.test(n))
        {
          n = n.replace(reg,'$1'+','+'$2');
            }
           return n;
    }

    function getStringFromEpoch()
    {
        var day = new Date();
        day.setTime(sportsRankDetailItemModel.epoch*1000);
        var dayUTC = new Date(day.getUTCFullYear(), day.getUTCMonth(), day.getUTCDate(), day.getUTCHours(), day.getUTCMinutes(), day.getUTCSeconds(), day.getUTCMilliseconds());

        return Qt.formatDate(dayUTC, "ddd, MMM dd");
    }

}
