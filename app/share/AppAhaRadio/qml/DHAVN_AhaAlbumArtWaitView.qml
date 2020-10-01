import Qt  4.7
import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES

Item {
    id: albumArtloadingItem
    property int counter : PR.const_AHA_TIMER_COUNTER_MIN_VAL
    property int exceptionCounter : 0
    //hsryu_0611_album_reflection
    property string albumArtLoad : (visible) ? albumArtloadingWaitImage.source : ""

    Image {
        id: albumArtloadingWaitImage
        x: PR.const_AHA_TRACK_VIEW_ALBUM_ART_LOADING_IMG_X_OFFSET
        y: PR.const_AHA_TRACK_VIEW_ALBUM_ART_LOADING_IMG_Y_OFFSET
        source: PR_RES.const_APP_AHA_CONNECTING_WAIT[counter]
    }

    Timer
    {
        id: waitTimer
        interval: 100   //wsuk.kim 130906 loading animation interval 100ms/frame
        running: albumArtloadingItem.visible
        repeat: true

        onTriggered: {
            counter = counter + 1
            if(counter == PR.const_AHA_TIMER_COUNTER_MAX_VAL)
            {
                counter = PR.const_AHA_TIMER_COUNTER_MIN_VAL
            }

            if(exceptionCounter === 400) //hsryu_0314_default_albumart
            {
                exceptionCounter = 0;
                albumArtloadingItem.visible = false;
            }
            exceptionCounter++;

            albumArtloadingWaitImage.source = PR_RES.const_APP_AHA_CONNECTING_WAIT[counter]
        }
    }
}
