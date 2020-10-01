/**
 * FileName: XMSportsFavoriteSearchListDelegate.qml
 * Author: David.Bae
 * Time: 2012-06-14 14:54
 *
 * - 2012-06-14 Initial Created by David
 */

import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData

MComp.MComponent{
    id: idListItem
    x:101; y:0

    z: index
    width:ListView.view.width- x; height:92

    //Signal
    signal addSportTeamToFavorites(int index, int lID, int uID, string lName, int tID, string tName, string nName, string aName);
    signal delSportTeamToFavorites(int index, int lID, int uID, string lName, int tID, string tName, string nName, string aName);

    Image {
        x: -13/*0*/; y: parent.height
        source: imageInfo.imgFolderGeneral + "list_line.png"//imageInfo.imgFolderMusic + "tab_list_line.png"
    }

    MComp.DDScrollTicker{
        id: idText
        x: 0; y: 0;
        width: 824
        height: parent.height
        text: teamNickName;
        fontFamily : systemInfo.font_NewHDR
        fontSize: 40
        color: colorInfo.subTextGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }

    Image {
        id: idSportsIcon
        x: idText.textPaintedWidth + 10
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

    MComp.MButton{
        id:idAddFavoriteButton
        x: 870
        y: 7
        focus : true
        width: 274; height: 79

        bgImage:            imageInfo.imgFolderXMData + "btn_fav_n.png"
        bgImagePress:       imageInfo.imgFolderXMData + "btn_fav_p.png"
        bgImageFocus:       imageInfo.imgFolderXMData + "btn_fav_f.png"

        firstText: favorite == "on" ? stringInfo.sSTR_XMDATA_DELETEFAVORITE : stringInfo.sSTR_XMDATA_ADDFAVORITE

        firstTextX: 9
        firstTextSize: 26//32
        firstTextColor: colorInfo.subTextGrey
        firstTextStyle: systemInfo.font_NewHDB

        onClickOrKeySelected: {
            idListItem.ListView.view.currentIndex = index;
            idCenterFocusScope.focus = true;
            if(firstText == stringInfo.sSTR_XMDATA_DELETEFAVORITE)
            {
                delSportTeamToFavorites(index, leagueID, uID, leagueName, teamID, teamName, nickName, teamAbbr);
            }else{
                if(sportsDataManager.canIAddToFavorite() == true)
                {
                    addSportTeamToFavorites(index, leagueID, uID, leagueName, teamID, teamName, nickName, teamAbbr);
                }
                else
                {
                    showListIsFull();
                }
            }
        }
    }
    onClickOrKeySelected: {
        if(playBeepOn)
            UIListener.playAudioBeep();
        idListItem.ListView.view.currentIndex = index;
        idCenterFocusScope.focus = true;
        if(idAddFavoriteButton.firstText == stringInfo.sSTR_XMDATA_DELETEFAVORITE)
        {
            delSportTeamToFavorites(index, leagueID, uID, leagueName, teamID, teamName, nickName, teamAbbr);
        }else{
            if(sportsDataManager.canIAddToFavorite() == true)
                addSportTeamToFavorites(index, leagueID, uID, leagueName, teamID, teamName, nickName, teamAbbr);
            else
                showListIsFull();
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

    onWheelRightKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        ListView.view.moveOnPageByPage(rowPerPage, true);



    }
    onWheelLeftKeyPressed: {
        if(ListView.view.flicking || ListView.view.moving)   return;
        ListView.view.moveOnPageByPage(rowPerPage, false);

    }

    Rectangle{
        x:10
        y:65
        visible:isDebugMode();
        Column{
            Row{
                //Text{text:"["+index+"] lID:" + leagueID + ", uID:"+ uID + ", LeagueName:" + leagueName + "tID:"+teamID + ", teamName:" + teamName + ", NickName:" + nickName + ", ABBR:" + teamAbbr + ", favorite:"+favorite; color:"white"}
//                Text{text:"["+index+"] affiliateID:" + affiliateID + ", sportID:"+ sportID + ", leagueID:" + leagueID + "affiliateName:"+affiliateName; color:"white"}
            }
        }
    }
}
