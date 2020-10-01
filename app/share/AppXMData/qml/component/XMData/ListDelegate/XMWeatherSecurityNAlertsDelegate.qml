/**
 * FileName: XMWeatherSecurityNAlertsDelegate.qml
 * Author: David.Bae
 * Time: 2012-06-04 09:59
 *
 * - 2012-06-04 Initial Created by David
 */

import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData

MComp.MComponent{
    id: idListItem
    x: 0
    width: ListView.view.width - 35
    height: 92

    Image {
        id: idBgImage
        x: 0; y:0
        source: isMousePressed() ? imageInfo.imgFolderGeneral + "list_p.png" : (idListItem.activeFocus && focusOn) ? imageInfo.imgFolderGeneral + "list_f.png" : ""
    }

    Image {
        id:idLine
        x: 0; y: parent.height
        source: imageInfo.imgFolderGeneral + "list_line.png"
    }

    Component.onCompleted: {
        if(ListView.view.count > 0)
        {
            upFocusAndLock(false);
        }
    }

    Image{
        x: 67; y: 28
        property int number: (WSApriority+1)
        property string strNumber: ""
        source : strNumber
        onNumberChanged: {
            if(number < 10)
                strNumber = imageInfo.imgFolderXMData + "bar_wsa_color_0"+number+".png"
            else
                strNumber = imageInfo.imgFolderXMData + "bar_wsa_color_"+number+".png";
        }
    }


    MComp.DDScrollTicker{
        id: idText
        x: 102; y: 0;
        width: 1125
        height: 92
        text: UIListener.getFullNameForMsgType(WSAmsgType) + " " + "(" + WSAlocationDes+ ")"
        fontFamily : systemInfo.font_NewHDR
        fontSize: 40
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }

    onClickOrKeySelected: {
        console.log("WSAentryID:"+WSAentryID+", WSAmsgID:"+WSAmsgID+", WSAstartTime:"+WSAstartTime+", WSAendTime:"+WSAendTime+
                    ", WSAlanguage:"+WSAlanguage+", WSApriority:"+WSApriority+", WSAmsgType:"+WSAmsgType+", WSAlocationExtType:"+WSAlocationExtType+
                    ", WSAlocationDes:"+WSAlocationDes+", WSAmsgText:"+WSAmsgText+", WSAisDeletedItem:"+WSAisDeletedItem+", WSAisDeleteItem:"+WSAisDeleteItem+
                    ", WSADistanceRole:"+WSADistanceRole+", WSAUniqKey:"+WSAUniqKey+", WSAShapeForRegionRole:"+WSAShapeForRegionRole+", WSAPointCountRole:"+WSAPointCountRole);
        if(playBeepOn)
            UIListener.playAudioBeep();
        forceActiveFocus();
        showWSADetail(WSAUniqKey);
    }

    onWheelRightKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        ListView.view.moveOnPageByPage(rowPerPage, true);
    }
    onWheelLeftKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        ListView.view.moveOnPageByPage(rowPerPage, false);
    }

    //property int debugOnOff: idAppMain.debugOnOff;
    Text {
        x:5; y:12; id:idFileName
        text:"XMWeatherSecurityNAlertsDelegate.qml";
        color : colorInfo.transparent;
    }

    MXData.XMRectangleForDebug{
        Column{
            Text{ x:0; width:1240
                text: "WSAentryID:"+WSAentryID+",WSAmsgID:"+WSAmsgID+",WSAstartTime:"+WSAstartTime+",WSAendTime:"+WSAendTime+",WSAlanguage:"+WSAlanguage+",WSApriority:"+WSApriority; wrapMode: Text.WordWrap; font.pixelSize: 12; color: "red"; font.bold: true;}
            Text{ x:0; width:1240
                text: ",WSAmsgType:"+WSAmsgType+",WSAlocationExtType:"+WSAlocationExtType
                      +",WSAlocationDes:"+WSAlocationDes+",WSAmsgText:"+WSAmsgText+",WSAisDeletedItem:"+WSAisDeletedItem+",WSAisDeleteItem:"+WSAisDeleteItem+",WSADistanceRole:"+WSADistanceRole; wrapMode: Text.WordWrap; font.pixelSize: 12; color: "red"; font.bold: true;}
            Text{ x:0; width:1240
                text: ",WSAUniqKey:"+WSAUniqKey+",WSAShapeForRegionRole:"+WSAShapeForRegionRole+",WSAPointCountRole:"+WSAPointCountRole; wrapMode: Text.WordWrap; font.pixelSize: 12; color: "red"; font.bold: true;}
        }
    }
}
