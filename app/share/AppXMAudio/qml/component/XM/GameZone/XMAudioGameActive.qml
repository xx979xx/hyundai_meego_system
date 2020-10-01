/**
 * FileName: RadioMain.qml
 * Author: HYANG
 * Time: 2012-02
 *
 * - 2012-02 Initial Crated by HYANG
 */

import Qt 4.7
import "../../QML/DH" as MComp
import "../../../component/XM/JavaScript/XMAudioOperation.js" as XMOperation

MComp.MComponent {
    id: idRadioGameActiveQml
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    //************************************************************************* # Property, State #
    state: (idAppMain.gDriverRestriction == false) ? "GAMEACTIVE" : "GAMEACTIVERESTRICTION"

    property Item topBand: idRadioGameActiveBand
    property int selectedAcitveItem: 0

    //****************************** # SXM Radio - Title area #
    MComp.MBigBand {
        id: idRadioGameActiveBand
        x: 0; y: 0

        //****************************** # Tab button OFF #
        tabBtnFlag: true        //bandTab button On/Off
        tabBtnCount: 3
        tabBtnText: stringInfo.sSTR_XMRADIO_LIVE
        tabBtnText2: stringInfo.sSTR_XMRADIO_SET_TEAM
        tabBtnText3: stringInfo.sSTR_XMRADIO_ACTIVE
        selectedBand: stringInfo.sSTR_XMRADIO_ACTIVE
        tabBtnSendTextSize: XMOperation.checkFranceLanguage();

        //****************************** # button clicked or key selected #
        onTabBtn1Clicked: {
            console.log("### gameactive - Live Clicked ###");
            giveForceFocus(3);
            setAppMainScreen("AppRadioGameZone", false);
        }
        onTabBtn2Clicked: {
            console.log("### gameactive - Game Set Clicked ###");
            giveForceFocus(3);
            setAppMainScreen("AppRadioGameSet", false);
        }
        onTabBtn3Clicked: {
            console.log("### gameactive - Acitve Clicked ###");
            giveForceFocus(3);
        }

        onBackBtnClicked: {
            console.log("### gameactive - BackKey Clicked ###")
            giveForceFocus(3);
            setGameActiveClose();
            setAppMainScreen( "AppRadioMain" , false);
        }

        Keys.onPressed: {
            if(event.key == Qt.Key_Down)
            {
                checkFocusGameActiveListAndBand();
            }
        }

        onTuneLeftKeyPressed: {
            if(idRadioGameActiveBand.activeFocus)
            {
                checkFocusGameActiveListAndBand();
            }
        }

        onTuneRightKeyPressed: {
            if(idRadioGameActiveBand.activeFocus)
            {
                checkFocusGameActiveListAndBand();
            }
        }
    }

    //****************************** # SXM Radio - Display Area #
    MComp.MComponent{
        id:idRadioGameActiveDisplay
        focus: true

        //****************************** # Channel List #
        XMAudioGameActiveList {
            id: idRadioGameActiveList
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
            width: systemInfo.lcdWidth; height: systemInfo.contentAreaHeight
            focus: true
        }
    }

    MComp.MComponent{
        id: idRadioGameActiveDriverRestrictionDisplay

        //Driver Restriction
        XMAudioGameActiveDriverRestriction {
            id: idRadioGameActiveDriverRestrictionList
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
        }
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        setGameActiveClose();
        setAppMainScreen( "AppRadioMain" , false);
    }
    /* CCP Home Key */
    onHomeKeyPressed: {
        setGameActiveClose();
        UIListener.HandleHomeKey();
    }

    onVisibleChanged: {
        if(idRadioGameActive.visible)
        {
            if(idAppMain.gDriverRestriction == true)
            {
                idRadioGameActiveBand.giveForceFocus(3);
                idRadioGameActiveBand.focus = true;
            }
            else
            {
                idRadioGameActiveBand.tabBtnSendTextSize = XMOperation.checkFranceLanguage();

                if(idRadioGameActiveList.gameActiveListCount == 0)
                {
                    changeFocusToGameActiveAndBand();
                }
                else
                {
                    idRadioGameActiveBand.giveForceFocus(3);
                    idRadioGameActiveList.onInitGameActive();
                    changeFocusToGameActiveList();
                }
            }
        }
        else
        {
            idRadioGameActiveList.aGAMEActiveListModel.currentIndex = -1;
        }
    }

    onStateChanged: {
        if(!visible) return;

        if(idAppMain.gDriverRestriction == true)
        {
            if(!idRadioGameActiveBand.activeFocus)
                idRadioGameActiveBand.giveForceFocus(7);
            idRadioGameActiveBand.focus = true;
        }
    }

    //****************************** # Function #
    function setGameActiveClose()
    {
        idRadioGameActive.visible = false;
        UIListener.HandleSetTuneKnobKeyOperation(0);
        UIListener.HandleSetSeekTrackKeyOperation(0);
    }

    function changeFocusToGameActiveList(){
        idRadioGameActiveBand.focus = false;
        idRadioGameActiveDisplay.focus = true;
    }

    function changeFocusToGameActiveAndBand(){
        idRadioGameActiveDisplay.focus = false;
        idRadioGameActiveBand.focus = true;
        idRadioGameActiveBand.giveForceFocus(3);
        return idRadioGameActiveBand;
    }

    function checkFocusGameActiveListAndBand(){
        if(idAppMain.gDriverRestriction == true)
        {
            idRadioGameActiveBand.focus = true;
        }
        else
        {
            if(idRadioGameActiveList.gameActiveListCount == 0)
            {
                idRadioGameActiveBand.focus = true;
            }
            else
            {
                idRadioGameActiveList.onGameActivePosUpdate();
                changeFocusToGameActiveList();
            }
        }
    }

    //****************************** # States #
    states: [
        State{
            name: "GAMEACTIVE"
            PropertyChanges{target: idRadioGameActiveDriverRestrictionDisplay; opacity: 0;}
            PropertyChanges{target: idRadioGameActiveDisplay; opacity: 1;}
        },
        State{
            name: "GAMEACTIVERESTRICTION"
            PropertyChanges{target: idRadioGameActiveDisplay; opacity: 0;}
            PropertyChanges{target: idRadioGameActiveDriverRestrictionDisplay; opacity: 1;}
        }
    ]

    transitions: [
        Transition{
            ParallelAnimation{ PropertyAnimation{properties: "opacity"; duration: 0; easing.type: "InCubic"} }
        }
    ]
}
