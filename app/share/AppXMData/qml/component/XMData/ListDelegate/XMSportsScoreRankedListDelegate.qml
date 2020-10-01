import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData
import "../List" as XMList


XMDataSmallTypeListNormalDelegate{
    id: idListItem
    y: 0
    width:ListView.view.width; height: 92

    Image {
        id: idBgImage
        x: 0; y:0
        source: isMousePressed() ? imageInfo.imgFolderGeneral + "list_p.png" : (idListItem.activeFocus && focusOn) ? imageInfo.imgFolderGeneral + "list_f.png" : ""
    }
    Image{
        x: 0; y:idListItem.height;
        source: imageInfo.imgFolderGeneral + "list_line.png"
    }

    MComp.DDScrollTicker{
        id: idName
        x: 102-15; y: 0;
        width: 840
        height: 90
        text: raceName
        fontFamily : systemInfo.font_NewHDR
        fontSize: 40
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
    }
    Text{
        id: idEpochDate
        x: 843; y: 0
        width : 320; height: 90
        text: getStringFromEpoch(epoch)
        font.family: systemInfo.font_NewHDR
        font.pixelSize: 40
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        elide:Text.ElideRight
    }
    onClickOrKeySelected: {
        if(isDebugVersion)
        {
            console.log("affiliateID:"+affiliateID+",affiliateName:"+affiliateName+",thereIsNoTableData:"+thereIsNoTableData+",sportsID:"+sportsID+",tableID:"+tableID+
                        ",informationClass:"+informationClass+",seasonStatus:"+seasonStatus+",epoch:"+epoch+",receiptTime:"+receiptTime+",headerKey:"+headerKey+
                        ",tHeadName:"+tHeadName+",HomeTeamName:"+HomeTeamName+",visitingTeamName:"+visitingTeamName+",eventState:"+eventState+",eventDivision:"+eventDivision+
                        ",eventDivision:"+eventDivision+",eventClock:"+eventClock+",eventStartTime:"+eventStartTime+",homeTeamScore:"+homeTeamScore+",visitingTeamScore:"+visitingTeamScore+
                        ",homeTeamSupplementalInfo:"+homeTeamSupplementalInfo+",visitingTeamSupplementalInfo:"+visitingTeamSupplementalInfo+",result:"+result+
                        ",extraInformation:"+extraInformation+",homeTeamCommentaryChannel:"+homeTeamCommentaryChannel+",visitingTeamCommentaryChannel:"+visitingTeamCommentaryChannel+
                        ",nationalTeamCommentaryChannel:"+nationalTeamCommentaryChannel+",raceName:"+raceName+",trackName:"+trackName+",HeadlineBodyRole:"+HeadlineBodyRole+
                        ",Rank:"+Rank+",Yds:"+Yds+",Purse:"+Purse+",RefTable:"+RefTable+",RankingNameList:"+RankingNameList+",RankingScoreList:"+RankingScoreList+",SectionName:"+SectionName+
                        ",UniqKey:"+UniqKey+",RootAffiliateID:"+RootAffiliateID+",StartDateTimeUTC:"+StartDateTimeUTC);
        }
        if(playBeepOn)
            UIListener.playAudioBeep();
        selectRankedListItem(UniqKey)
    }

    MXData.XMRectangleForDebug{
        Column{
            Text{ x:0; width:1240
                text: "affiliateID:"+affiliateID+",affiliateName:"+affiliateName+",thereIsNoTableData:"+thereIsNoTableData+",sportsID:"+sportsID+",tableID:"+tableID+",informationClass:"+informationClass
                       +",seasonStatus:"+seasonStatus+",epoch:"+epoch+",receiptTime:"+receiptTime+",headerKey:"+headerKey; font.pixelSize: 12; color: "red"; font.bold: true;}
            Text{ x:0; width:1240
                text: ",tHeadName:"+tHeadName+",HomeTeamName:"+HomeTeamName
                      +",visitingTeamName:"+visitingTeamName+",eventState:"+eventState+",eventDivision:"+eventDivision+",eventClock:"+eventClock+",eventStartTime:"+eventStartTime; font.pixelSize: 12; color: "red"; font.bold: true;}
            Text{ x:0; width:1240
                text: ",homeTeamScore:"+homeTeamScore+",visitingTeamScore:"+visitingTeamScore+",homeTeamSupplementalInfo:"+homeTeamSupplementalInfo+",visitingTeamSupplementalInfo"+visitingTeamSupplementalInfo
                      +",result:"+result+",extraInformation:"+extraInformation+",homeTeamCommentaryChannel:"+homeTeamCommentaryChannel+",visitingTeamCommentaryChannel:"+visitingTeamCommentaryChannel; font.pixelSize: 12; color: "red"; font.bold: true;}
            Text{ x:0; width:1240
                text: ",nationalTeamCommentaryChannel"+nationalTeamCommentaryChannel+",raceName:"+raceName+",trackName:"+trackName+",HeadlineBodyRole:"+HeadlineBodyRole+",Rank:"+Rank
                      +",Yds:"+Yds+",Purse:"+Purse+",RefTable:"+RefTable+",RankingNameList:"+RankingNameList; font.pixelSize: 12; color: "red"; font.bold: true;}
            Text{ x:0; width:1240
                text: ",RankingScoreList:"+RankingScoreList+",SectionName:"+SectionName
                      +",RootAffiliateID:"+RootAffiliateID+",StartDateTimeUTC:"+StartDateTimeUTC; font.pixelSize: 12; color: "red"; font.bold: true;}
            Text{ x:0; width:1240
                text: ",UniqKey:"+UniqKey; font.pixelSize: 12; color: "red"; font.bold: true;}
        }
    }
}
