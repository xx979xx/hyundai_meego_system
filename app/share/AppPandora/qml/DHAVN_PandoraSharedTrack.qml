import Qt 4.7
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES

Item {
    id: controlIcon

    //property string iconText;

    x: 1172
    y: 224 -93
    width: PR.const_PANDORA_STATION_LIST_VIEW_SHARED_IMAGE_WIDTH
    //width: 210
    //height: 45
    visible: false
    Image {
        id: icon_share
        source: PR_RES.const_APP_PANDORA_TRACK_VIEW_SHARE_STATION// PR_RES.const_APP_PANDORA_LIST_VIEW_ICON_SHARED
        //visible: false
        //anchors.top:  alphabetwise.top
       // anchors.topMargin: PR.const_PANDORA_STATION_LIST_VIEW_SHARED_IMAGE_TOPMARGIN
        //x: PR.const_PANDORA_STATION_LIST_VIEW_SHARED_IMAGE_X;
       // width: PR.const_PANDORA_STATION_LIST_VIEW_SHARED_IMAGE_WIDTH
    }

}

