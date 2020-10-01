import Qt 4.7

// System Import
import "../../QML/DH" as MComp
import "../../XMData" as MXData
import "../List" as XMList
import "../../../component/XMData/Javascript/WeatherForecast.js" as MJavascript
import "../../../component/XMData/Javascript/ConvertUnit.js" as MConvertUnit


XMDataSportsLargeTypeListDelegate{
    id: idListItem
//    x:0; y:0;
    y: 0
    width:ListView.view.width; height: 158

    property bool summerTime: interfaceManager.DBIsDayLightSaving
    property bool timeFormatChange: interfaceManager.DBIs24TimeFormat

    onClickOrKeySelected: {
        if(isDebugVersion)
        {
//            roles[AffiliateIDRole] = "affiliateID";
//            roles[AffiliateNameRole] = "affiliateName";
//            roles[ThereIsNoTableDataRole] = "thereIsNoTableData";
//            roles[SportsIDRole] = "sportsID";
//            roles[TableIDRole] = "tableID";
//            roles[InformationClassRole] = "informationClass";
//            roles[SeasonStatusRole] = "seasonStatus";
//            roles[EpochRole] = "epoch";
//            roles[ReceiptTimeRole] = "receiptTime";
//            roles[HeaderKeyRole] = "headerKey";
//            roles[THeadNameRole] = "tHeadName";
//            roles[HomeTeamNameRole] = "HomeTeamName";
//            roles[VisitingTeamNameRole] = "visitingTeamName";
//            roles[EventStateRole] = "eventState";
//            roles[EventDivisionRole] = "eventDivision";
//            roles[EventClockRole] = "eventClock";
//            roles[EventStartTimeRole] = "eventStartTime";
//            roles[HomeTeamScoreRole] = "homeTeamScore";
//            roles[VisitingTeamScoreRole] = "visitingTeamScore";
//            roles[HomeTeamSupplementalInfoRole] = "homeTeamSupplementalInfo";
//            roles[VisitingTeamSupplementalInfoRole] = "visitingTeamSupplementalInfo";
//            roles[ResultRole] = "result";
//            roles[ExtraInformationRole] = "extraInformation";
//            roles[HomeTeamCommentaryChannelRole] = "homeTeamCommentaryChannel";
//            roles[VisitingTeamCommentaryChannelRole] = "visitingTeamCommentaryChannel";
//            roles[NationalTeamCommentaryChannelRole] = "nationalTeamCommentaryChannel";
//            roles[RaceNameRole] = "raceName";
//            roles[TrackNameRole] = "trackName";
//            roles[HeadlineBodyRole] = "HeadlineBodyRole";
//            roles[RankRole] = "Rank";
//            roles[YdsRole] = "Yds";
//            roles[PurseRole] = "Purse";
//            roles[RefTable] = "RefTable";
//            roles[RankingNameList] = "RankingNameList";
//            roles[RankingScoreList] = "RankingScoreList";
//            roles[SectionNameRole] = "SectionName";
//            roles[UniqKey] = "UniqKey";
//            roles[RootAffiliateID] = "RootAffiliateID";
//            roles[StartDateTimeUTC] = "StartDateTimeUTC";
//            var time = eventClock.;
            console.log("affiliateID:"+affiliateID+",affiliateName:"+affiliateName+",thereIsNoTableData:"+thereIsNoTableData+",sportsID:"+sportsID+",tableID:"+tableID+
                        ",informationClass:"+informationClass+",seasonStatus:"+seasonStatus+",epoch:"+epoch+",receiptTime:"+receiptTime+",headerKey:"+headerKey+
                        ",tHeadName:"+tHeadName+",HomeTeamName:"+HomeTeamName+",visitingTeamName:"+visitingTeamName+",eventState:"+eventState+",eventDivision:"+eventDivision+
                        ",eventDivision:"+eventDivision+",eventClock:"+eventClock+",eventStartTime:"+eventStartTime+",homeTeamScore:"+homeTeamScore+",visitingTeamScore:"+visitingTeamScore+
                        ",homeTeamSupplementalInfo:"+homeTeamSupplementalInfo+",visitingTeamSupplementalInfo:"+visitingTeamSupplementalInfo+",result:"+result+
                        ",extraInformation:"+extraInformation+",homeTeamCommentaryChannel:"+homeTeamCommentaryChannel+",visitingTeamCommentaryChannel:"+visitingTeamCommentaryChannel+
                        ",nationalTeamCommentaryChannel:"+nationalTeamCommentaryChannel+",raceName:"+raceName+",trackName:"+trackName+",HeadlineBodyRole:"+HeadlineBodyRole+
                        ",Rank:"+Rank+",Yds:"+Yds+",Purse:"+Purse+",RefTable:"+RefTable+",RankingNameList:"+RankingNameList+",RankingScoreList:"+RankingScoreList+",SectionName:"+SectionName+
                        ",UniqKey:"+UniqKey+",RootAffiliateID:"+RootAffiliateID+",StartDateTimeUTC:"+StartDateTimeUTC+",StartDate:"+StartDate);
        }
    }

    BorderImage {
        id: idBGFocus
        x: parent.x+19; y:0
        width: parent.width-19-30; height: parent.height
        source: imageInfo.imgFolderXMData + "bg_widget_02_f.png"
        visible: idListItem.activeFocus && focusOn
        border { left: 20; right: 20; top: 20; bottom: 20 }
    }
    BorderImage {
        id:idBgImage
        x: parent.x+19; y:0
        width: parent.width-19-30; height: parent.height
        source: imageInfo.imgFolderXMData + "bg_widget_02_n.png"
        visible: idBGFocus.visible == false
        border { left: 20; right: 20; top: 20; bottom: 20 }
    }

    //[ISV 88554]
    Item{
        // Layout
        focus: true;        
        //Visiting Team Name
        MComp.DDScrollTicker{
            id: idVisitingTeam
            x: 57; y: 15+25-(34/2);
            width: 633
            height: 51
            text: visitingTeamName
            fontFamily : systemInfo.font_NewHDR
            fontSize: 34
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            tickerEnable: true
            tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
        }
        Text {
            id: idVisitingTeamScore
            x: idVisitingTeam.x+idVisitingTeam.width + 10/*20*/; y: 15+25-(font.pixelSize/2);
            width: 62+10
            text: "-"
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 34
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide:Text.ElideRight
        }
        //Home Team Name
        MComp.DDScrollTicker{
            id: idHomeTeam
            x: idVisitingTeam.x; y: 15+25+32+32-(fontSize/2);
            width: idVisitingTeam.width
            height: 51
            text: HomeTeamName
            fontFamily : systemInfo.font_NewHDR
            fontSize: 34
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            tickerEnable: true
            tickerFocus: (idListItem.activeFocus && idAppMain.focusOn)
        }
        Text {
            id: idHomeTeamScore
            x: idVisitingTeamScore.x; y: 15+25+32+32-(font.pixelSize/2);
            width: idVisitingTeamScore.width
            text: "-"
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 34
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide:Text.ElideRight
        }

        Text {
            id: idStartTime
            x: idVisitingTeamScore.x+idVisitingTeamScore.width + 40; y: 15+25+32-(font.pixelSize/2);
            width: 410
            text: MConvertUnit.convertTimeFormatForSports(eventStartTime, false, timeFormatChange)
//            text: MConvertUnit.convertTimeFormatForSports(eventStartTime, summerTime, timeFormatChange)
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            color: colorInfo.brightGrey
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide:Text.ElideRight
        }
    }

    //Function
    function getEventState(eventState){
        switch(eventState){
        case sportsLabel.iEVENT_STATE_SCHEDULED:
            return "Scheduled";
        case sportsLabel.iEVENT_STATE_PRE_GAME:
            return "Pre-game";
        case sportsLabel.iEVENT_STATE_IN_PROGRAM:
            return "T-"+index
        case sportsLabel.iEVENT_STATE_FINAL:
            return "Final";
        case sportsLabel.iEVENT_STATE_DELAYED_EVENT_HAS_NOT_STARTED:
            return "Delayed. Event has not started"
        case sportsLabel.iEVENT_STATE_STARTED_BUT_CURRENTLY_SUSPENDED:
            return "Event started, but currently suspended";
        case sportsLabel.iEVENT_STATE_STARTED_BUT_PLAY_ABANDONED_FOR_THE_DAY_PLAY_WILL_BE_RESUMED:
            return "Event started, but play abandoned for the day. Play will be resumed";
        case sportsLabel.iEVENT_STATE_CANCELLED_RESCHEDULED_AT_A_LATER_DATE:
            return "Event Cancelled. Rescheduled at a later date";
        default:
            return "Unknown Event State";
        }
    }
    Rectangle{
        x:25
        y:15
        visible:isDebugMode();
        Column{
            Row{
                Text{
                    color : "white";
                    text:"[HomeTeamName] : "+ HomeTeamName + " [visitingTeamName] : "+ visitingTeamName + " [eventClock] : "+ eventClock + " [eventDivision] : "+ eventDivision + " [eventState] : "+ eventState + " [eventStartTime] : "+ eventStartTime
                }
            }
        }
    }
}
