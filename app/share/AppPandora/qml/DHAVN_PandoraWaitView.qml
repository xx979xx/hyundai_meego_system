import Qt  4.7
import "DHAVN_AppPandoraConst.js" as PR
import "DHAVN_AppPandoraRes.js" as PR_RES
import CQMLLogUtil 1.0

Item {
    id: loadingItem
        
    property string logString :""
    property int counter : PR.const_PANDORA_TIMER_COUNTER_MIN_VAL

    function __LOG( textLog , level)
    {
       logString = "wait view.qml::" + textLog ;
       logUtil.log(logString , level);
    }

    //added by jyjeon 2014-07-01 for ITS 239919
    function handleRetranslateUI(languageId)
    {
        connectingWaitText1.text = qsTranslate("main","STR_PANDORA_LOADING");
    }
    //added by jyjeon 2014-07-01 for ITS 239919

    Image {
        id: loadingWaitImage
        x: PR.const_PANDORA_LOADING_WAIT_IMAGE_X_OFFSET
        y: PR.const_PANDORA_LOADING_WAIT_IMAGE_Y_OFFSET
        source: PR_RES.const_APP_PANDORA_CONNECTING_WAIT[0]
    }

    Text
    {
        id: connectingWaitText1
        color: PR.const_PANDORA_LOADING_TEXT_COLOR
        text: qsTranslate("main","STR_PANDORA_LOADING");
        font.pointSize: PR.const_PANDORA_LOADING_TEXT_FONT_SIZE
        font.family: PR.const_PANDORA_LOADING_TEXT_FONT_FAMILY
        x: PR.const_PANDORA_LOADING_WAIT_TEXT_LOADING_X_OFFSET
        y: PR.const_PANDORA_LOADING_WAIT_TEXT_LOADING_Y_OFFSET
        width: PR.const_PANDORA_LOADING_TEXT_WIDTH
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Timer
    {
        id: waitTimer
        interval: 100;
        running: true;
        repeat: true //esjang modified 2013.09.06 for loading icon spec
        triggeredOnStart : loadingItem.visible;

        onTriggered: {

            counter = counter + 1;

            if( (counter) == (PR.const_PANDORA_TIMER_COUNTER_MAX_VAL ))
            {
                counter = PR.const_PANDORA_TIMER_COUNTER_MIN_VAL ;
            }
            //__LOG("esjang 130906 counter: " + counter + " / " + PR.const_PANDORA_TIMER_COUNTER_MAX_VAL , LogSysID.LOW_LOG );
            loadingWaitImage.source = PR_RES.const_APP_PANDORA_CONNECTING_WAIT[counter];
        }
    }
}
