import Qt  4.7
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES

Item {
    id: loadingItem

    //QML Properties Declaration
    property int counter: 0

    Image {
        id: loadingWaitImage
        source: PR_RES.const_APP_PANDORA_CONNECTING_WAIT[counter]
    }
    Timer
    {
        id: waitTimer
        interval: 100;  running: true; repeat: true  //esjang modified 2013.09.06 for loading icon spec

        onTriggered: {

            counter = counter + 1;

            if( counter == PR.const_PANDORA_TIMER_COUNTER_MAX_VAL )
            {
                counter = PR.const_PANDORA_TIMER_COUNTER_MIN_VAL;
            }
            loadingWaitImage.source = PR_RES.const_APP_PANDORA_CONNECTING_WAIT[counter];

        }
    }
}
