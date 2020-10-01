/**
 * FileName: SportsLabelDefinition.qml
 * Author: David.Bae
 * Time: 2012-06-07 17:41
 *
 * - 2012-06-07 Initial Created by David
 */

import Qt 4.7

Item {
    id: sportsLabelDefinition

    //This infomation be defined in "SX-9845-0168 Satellite Module Services(SMS) API and Design Document"

    //////////////////////////////////////////////////////////////////////////////////////////////////
    // Event State : p738
    //  SX-9845-0168 Satellite Module Services(SMS) API Design Document.pdf :: 12.69.4.3  Event State (0x02)
    property int iEVENT_STATE_SCHEDULED                                                  : 0x00;
    property int iEVENT_STATE_PRE_GAME                                                   : 0x01;
    property int iEVENT_STATE_IN_PROGRAM                                                 : 0x02;
    property int iEVENT_STATE_FINAL                                                      : 0x03;
    property int iEVENT_STATE_DELAYED_EVENT_HAS_NOT_STARTED                              : 0x04;
    property int iEVENT_STATE_STARTED_BUT_CURRENTLY_SUSPENDED                            : 0x05;
    property int iEVENT_STATE_STARTED_BUT_PLAY_ABANDONED_FOR_THE_DAY_PLAY_WILL_BE_RESUMED: 0x06;
    property int iEVENT_STATE_CANCELLED_RESCHEDULED_AT_A_LATER_DATE                      : 0x07;

    //////////////////////////////////////////////////////////////////////////////////////////////////
    //

    //SX-9845-0168 Satellite Module Services(SMS) API Design Document.pdf :: 12.68.6.6  Known Sport IDs
    property int iSPORTS_MULTI_SPORT: 0
    property int iSPORTS_FOOTBALL: 1
    property int iSPORTS_BASEBALL: 2
    property int iSPORTS_BASKETBALL: 3
    property int iSPORTS_ICE_HOCKEY : 4
    property int iSPORTS_MOTORSPORT : 5
    property int iSPORTS_GOLF: 6
    property int iSPORTS_SOCCER: 7
    property int iSPORTS_TENNIS: 8

    //SX-9845-0168 Satellite Module Services(SMS) API Design Document.pdf :: 12.68.6.7  Known Information Classes
    property int iINFOCLASS_HEAD_TO_HEAD_EVENT: 0
    property int iINFOCLASS_RANKED_LIST_EVENT: 1
    property int iINFOCLASS_SEASON_SUMMARY: 2
    property int iINFOCLASS_NEWS_ITEM: 3
    property int iINFOCLASS_PARTICIPANT_STATISTICS: 4
    property int iINFOCLASS_PARTICIPANT_INDEX: 5
    property int iINFOCLASS_EVENT_DESCRIPTION: 6

    //Function
    function getEventState(eventState){
        switch(eventState){
        case iEVENT_STATE_SCHEDULED:
            return "Scheduled";
        case iEVENT_STATE_PRE_GAME:
            return "Pre-game";
        case iEVENT_STATE_IN_PROGRAM:
            return "T-"+index
        case iEVENT_STATE_FINAL:
            return "Final";
        case iEVENT_STATE_DELAYED_EVENT_HAS_NOT_STARTED:
            return "Delayed. Event has not started"
        case iEVENT_STATE_STARTED_BUT_CURRENTLY_SUSPENDED:
            return "Event started, but currently suspended";
        case iEVENT_STATE_STARTED_BUT_PLAY_ABANDONED_FOR_THE_DAY_PLAY_WILL_BE_RESUMED:
            return "Event started, but play abandoned for the day. Play will be resumed";
        case iEVENT_STATE_CANCELLED_RESCHEDULED_AT_A_LATER_DATE:
            return "Event Cancelled. Rescheduled at a later date";
        default:
            return "Unknown Event State";
        }
    }
}
