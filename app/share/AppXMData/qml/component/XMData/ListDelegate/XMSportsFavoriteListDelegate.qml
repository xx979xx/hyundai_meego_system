/**
 * FileName: XMSportsFavoriteListDelegate.qml
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
    width:ListView.view.width; height:92

    //Signal
    signal sportTeamSelected(int tID, int lID, string tName, string nName, string aName, string lName);

    //Affiliate Name
    MComp.DDScrollTicker{
        id: idText
        x: 47/*idLogoImg.x+idLogoImg.width+23*//*13+87*/; y: 0;
        width: 709;
        height: parent.height
        text: teamNickName;
        fontFamily : systemInfo.font_NewHDR
        fontSize: 40
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }

    Image {
        id: idSportsIcon
        x: idText.textPaintedWidth + 52
        y: parent.height/4;
        source: getSportsImageSource(uID);
        visible: true
    }

    Image {
        id: idFemaleIcon
        x: idSportsIcon.x + 57; y: parent.height/4;
        source: imageInfo.imgFolderXMDataSports + "icon_woman.png";
        visible: leagueName == "Women's College Basketball"? true : false;
    }

    onClickOrKeySelected: {
        if(pressAndHoldFlag == false){
            if(playBeepOn)
                UIListener.playAudioBeep();
            ListView.view.currentIndex = index;
            sportTeamSelected(teamID, leagueID, teamName, nickName, teamAbbr, leagueName); // arg must be modified.
        }
    }

    function getSportsImageSource(lID)
    {
        switch(lID)
        {
            case 0:
            case 4:
                return imageInfo.imgFolderXMDataSports + "icon_rugby.png"
            case 1:
                return imageInfo.imgFolderXMDataSports + "icon_baseball.png"
            case 2://[ITS 181428]
            case 5:
            case 6:
                return imageInfo.imgFolderXMDataSports + "icon_basketball.png"
            case 3:
                return imageInfo.imgFolderXMDataSports + "icon_hockey.png"
            default:
            break;
        }
    }

    Text {
        x:5; y:12; id:idFileName
        text:"XMSportsFavoriteListDelegate.qml";
        color : colorInfo.transparent;
    }
    Rectangle{
        x:10
        y:65
        visible:isDebugMode();
        Column{
            Row{
                Text{text:"["+index+"] tID:"+teamID +", lID:"+ uID + ", Name:" + teamName + ", NickName:" + nickName + ", ABBR:" + teamAbbr + ", LeagueName:" + leagueName + ", favorite:" + favorite; color:"white"}
//                Text{text:"["+index+"] aID:"+affiliateID +", sID:"+ sportID + ", lID:" + leagueID + ", aName:" + affiliateName; color:"white"}
            }
        }
    }
}
