/**
 * FileName: XMSportsRootListDelegate.qml
 * Author: David.Bae
 * Time: 2012-06-04 09:59
 *
 * - 2012-06-04 Initial Created by David
 */

import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData

XMDataSmallTypeListDelegate{
    id: idListItem
    x:0; y:0
    z: index
    width:ListView.view.width-35; height:92

    //Signal
    signal sportsListSelected(int sportID, string sportName, int level /*int leagueId, int affiliateID, int sportsID, string affiliateName*/);

    function listIcon(sportID)
    {
        switch(sportID){
        case 0:
            return imageInfo.imgFolderXMData + "logo_aggregate.png";
        case 1:
            return imageInfo.imgFolderXMData + "logo_football.png";
        case 2:
            return imageInfo.imgFolderXMData + "logo_baseball.png";
        case 3:
            return imageInfo.imgFolderXMData + "logo_basketball.png";
        case 4:
            return imageInfo.imgFolderXMData + "logo_icehockey.png";
        case 5:
            return imageInfo.imgFolderXMData + "logo_motorsport.png";
        case 6:
            return imageInfo.imgFolderXMData + "ico_nascar.png";
        case 7:
            return imageInfo.imgFolderXMData + "ico_nfl.png";
        case 8:
            return imageInfo.imgFolderXMData + "ico_nfl.png";

        }
    }

//    Image {
//        id:idBrandIconBg
//        x: idBrandIcon.x; y: idBrandIcon.y
//        width : 73; height:  53
//        source: imageInfo.imgFolderXMData + "bg_logo_s.png" //must be changed to sports logo bg.
//    }
//    Image {
//        id:idBrandIcon
//        x: 30; y: 183-systemInfo.headlineHeight
//        width:73;height:53

//        source: listIcon(sportID);
//    }

    //Sports Name
    Text {
        id: idText
        x: /*idBrandIcon.x+idBrandIcon.width+23*/47; y: /*12*/17+27-font.pixelSize/2;
        width: 845; height: 40
        text: sportName
        font.family: systemInfo.font_NewHDR
        font.pixelSize: 40
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide:Text.ElideRight
        MXData.XMRectangleForDebug{}
    }

    onClickOrKeySelected: {
        //var level = 0;
        if(pressAndHoldFlag == false){
            if(playBeepOn)
                UIListener.playAudioBeep();
            ListView.view.currentIndex = index;
            sportsListSelected(sportID, sportName, 0); // arg must be modified.
        }
    }

    //property int debugOnOff: idAppMain.debugOnOff;
    Text {
        x:5; y:12; id:idFileName
        text:"XMSportsRootListDelegate.qml";
        color : colorInfo.transparent;
    }
    Rectangle{
        x:10
        y:65
        visible:isDebugMode();
        Column{
            Row{
                Text{text:"["+index+"] Id:" + sportID + ", Name:" + sportName; color:"white"}
            }
        }
    }
}
