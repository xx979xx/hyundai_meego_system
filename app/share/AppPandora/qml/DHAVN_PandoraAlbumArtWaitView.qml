import Qt  4.7
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES

Item {
    id: albumArtloadingItem
    property int counter : PR.const_PANDORA_TIMER_COUNTER_MIN_VAL

    Image {
        id: albumArtloadingWaitImage
        x: PR.const_PANDORA_TRACK_VIEW_ALBUM_ART_LOADING_IMG_X_OFFSET
        y: PR.const_PANDORA_TRACK_VIEW_ALBUM_ART_LOADING_IMG_Y_OFFSET
        source: PR_RES.const_APP_PANDORA_CONNECTING_WAIT[counter]
    }
    onVisibleChanged:
    {

        if(visible === false)
        {
            waitTimer.stop();
        }
    }

    Timer
    {
        id: waitTimer
        interval: 100;  running: albumArtloadingItem.visible; repeat: true //esjang modified 2013.09.06 for loading icon spec

        onTriggered: {

            counter = counter + 1;

            if( counter == PR.const_PANDORA_TIMER_COUNTER_MAX_VAL )
            {
                counter = PR.const_PANDORA_TIMER_COUNTER_MIN_VAL ;
            }
            albumArtloadingWaitImage.source = PR_RES.const_APP_PANDORA_CONNECTING_WAIT[counter];

        }
    }
}
