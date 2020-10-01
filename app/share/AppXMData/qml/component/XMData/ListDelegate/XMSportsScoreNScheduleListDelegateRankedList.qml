import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData
import "../List" as XMList
import "../../XMData/Javascript/ConvertUnit.js" as MConvertUnit

FocusScope{
    id: idListItem
    x:0; y:0
    width:ListView.view.width;
    height:64
    Loader{
        id: idLoader
        sourceComponent: getSourceComponentBySportsID()
    }

    Component{
        id: idCompMotorItem
        Item {
            id: idMotorListTitle
            Loader{
                id : idGolfDelegateLoder
                sourceComponent: sportsRankDetailItemModel.eventState == 3 ? idCompMotorStatus3 : idCompMotorStatus2
            }
        }
    }

    Component{
        id: idCompMotorStatus2;                                       // In Progress
        Item{
            //display List
            Image{
                id: idLineBar1
                x: 0; y:64;
                source: imageInfo.imgFolderGeneral + "list_line.png"
            }
            Image{
                id: idLineDividerBar1
                x: 178; y:0;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Image{
                id: idLineDividerBar2
                x: idLineDividerBar1.x+422; y:0;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Image{
                id: idLineDividerBar3
                x: idLineDividerBar2.x+121; y:0;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Image{
                id: idLineDividerBar4
                x: idLineDividerBar3.x+368; y:0;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }

            // table data
            Text {
                id: idOrder1
                x: 57; y:25-(font.pixelSize/2);
                width: 112
                text: rank
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }

            Text {
                id: idDriver1
                x: idOrder1.x+idOrder1.width+20; y:25-(font.pixelSize/2)
                width: 402
                text: rankingName
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idNumber1
                x: idDriver1.x+idDriver1.width+21; y:25-(font.pixelSize/2);
                width: 100
                text: rankingNumber
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idCar1
                x: idNumber1.x+idNumber1.width+20; y:25-(font.pixelSize/2);
                width: 348
                text: rankingCar
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idLaps1
                x: idCar1.x+idCar1.width+20; y:25-(font.pixelSize/2);
                width: 112
                text: rankingScore
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
        id: idCompMotorStatus3;                                       // In Progress
        Item{
            Image{
                id: idLineBar1
                x: 0; y:64;
                source: imageInfo.imgFolderGeneral + "list_line.png"
            }
            Image{
                id: idLineDividerBar1
                x: 260; y:0;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Image{
                id: idLineDividerBar2
                x: idLineDividerBar1.x+790; y:0;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }

            Text {
                id: idTimeRank
                x: 57; y:25-(font.pixelSize/2);
                width: 180
                text: MConvertUnit.convertTimeFormatForRank(rank);
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idWinnerRank
                x: idTimeRank.x+idTimeRank.width+40; y:25-(font.pixelSize/2);
                width: 750
                text: rankingName
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idLapRank
                x: idWinnerRank.x+idWinnerRank.width+40; y:25-(font.pixelSize/2);
                width: 100
                text: rankingScore
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
        id: idCompGolfStatus2                                       // In Progress
        Item{
            Image{
                id: idGolfLineBar1
                x: 0; y:64;
                source: imageInfo.imgFolderGeneral + "list_line.png"
            }
            Image{
                id: idGolfLineDividerBar1
                x: 170; y:0;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Image{
                id: idGolfLineDividerBar2
                x: idGolfLineDividerBar1.x+830; y:0;
                source: imageInfo.imgFolderXMData + "movie_divider_03.png"
            }
            Text {
                id: idRank1
                x: 57; y:25-(font.pixelSize/2);
                width: 112
                text: rank
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idRankNanme1
                x: idRank1.x+idRank1.width+21; y:idRank1.y
                width: 890-80
                text: rankingName
                font.family: systemInfo.font_NewHDR
                font.pixelSize: 34
                color: colorInfo.brightGrey
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide:Text.ElideRight
                MXData.XMRectangleForDebug{}
            }
            Text {
                id: idRankScore1
                x: idRankNanme1.x+idRankNanme1.width+20; y:idRank1.y;
                width: 112+80
                text: rankingScore
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

    function getSourceComponentBySportsID()
    {
        switch(sportsID)
        {
        case 5:
            return idCompMotorItem;
        case 6:
            return idCompGolfStatus2;
        default:
            return null;
        }
    }
}
