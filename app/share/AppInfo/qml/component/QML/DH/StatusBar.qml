import Qt 4.7

// teleca import
import QmlStatusBarWidget 1.0
import AppEngineQMLConstants 1.0

MComponent {
    id: idContainer

    property alias focusIndex: idStatusBarWidget.focus_index

    signal keyNaviUp(string index);
    signal keyNaviDown(string index);

    function retranslateUi(langId)
    {
        idStatusBarWidget.retranslateUi(langId);
    }

    QmlStatusBarWidget {
        id: idStatusBarWidget
        focus: true
        anchors.top: parent.top
        anchors.left: parent.left
        homeSCR: true // if you do not want a curtain flow, please change to false.
        focus_visible: idContainer.activeFocus && idContainer.showFocus

        onActivateMainMenu: {
            if(playBeepOn) //jyjon_20120314
                idAppMain.playBeep();
            idContainer.homeKeyPressed();
        }

        onLostFocus:
        {
            //console.log("onLostFocus: " + arrow + " focus_index: " + focus_index);
            if( arrow == UIListenerEnum.JOG_DOWN )
                keyNaviDown(focus_index);
            else if( arrow == UIListenerEnum.JOG_UP )
                keyNaviUp(focus_index);
        }

        onButtonClick: {
            switch( buttonId )
            {
            case ann.const_BUTTON_ID_DATE_TIME_SETTINGS:
                break;

            case ann.const_BUTTON_ID_SOUND_SETTINGS:
                break;

            case ann.const_BUTTON_ID_WIDGET_DISPLAY_SETTINGS:
                break;

            case ann.const_BUTTON_ID_DISPLAY_SETTINGS:
                break;

            case ann.const_BUTTON_ID_DISPLAY:
                break;
            }
        }
    }
}
