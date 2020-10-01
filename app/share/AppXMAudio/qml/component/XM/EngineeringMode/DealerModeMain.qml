import Qt 4.7
import "../../QML/DH" as MComp

MComp.MComponent {
    id:idRadioDealerModeQml
    x:0; y:0
    width: systemInfo.lcdWidth; height: systemInfo.subMainHeight
    focus: true

    state : (gSXMENGMode == "ENGNORMAL") ? "ENGNORMAL" : "ENGDATA"

    property string selectEdit : ""      //"Latitude" "Longitude"
    property string selectNumLat : UIListener.HandleGetLatitude()
    property string selectNumLon : UIListener.HandleGetLongitude()

    property bool bResetSatrt : false

    //****************************** # Dealer Mode Title #
    MComp.MBand {
        id: idRadioDealerModeBand
        x: 0; y: 0
        focus: true

        titleText: "Dealer Mode > Dynamic > XM"
        tabBtnFlag: false
        reserveBtnFlag: false
        subBtnFlag: false
        subBtnText: stringInfo.sSTR_XMRADIO_DATA
        menuBtnFlag: false

        //****************************** # button clicked or key selected #
        onBackBtnClicked: {
            console.log("### Engineering Mode - BackKey Clicked ###")

            setNoDealMode();
            setDealerModeClose();
            setAppMainScreen("AppRadioMain", false);
            UIListener.HandleBackKey(bTouchBack);
        }
    }

    //****************************** # SXM Radio - Display Area #
    MComp.MComponent{
        id:idRadioDealListDisplay

        EngineeringListList {
            id : xm_engineeringlist_listview
            x: 0; y: systemInfo.headlineHeight-systemInfo.statusBarHeight
            height: systemInfo.lcdHeight - y - 55
        }

        Image{
            id: idButtons
            x: 0; y: xm_engineeringlist_listview.y + xm_engineeringlist_listview.height
            source: imageInfo.imgFolderGeneral+"bg_title.png"
        }
    }

    MComp.MComponent {
        id: idRadioPopupDim1LineQml
        width: systemInfo.lcdWidth
        height: systemInfo.subMainHeight
        visible: bResetSatrt

        Rectangle{
            width: parent.width; height: parent.height
            color: colorInfo.black
            opacity: 0.6
        }

        Image {
            id: idLoadingImage
            width: 76; height: 76
            x: (systemInfo.lcdWidth - idLoadingImage.width)/2
            y: (systemInfo.subMainHeight - idLoadingImage.height)/2
            source: imageInfo.imgFolderPopup + "loading/loading_01.png";
            property bool on: parent.visible && PLAYInfo.Advisory != "MODULE STOP"
            NumberAnimation on rotation { running: idLoadingImage.on; from: 0; to: 360; loops: Animation.Infinite; duration: 2400 }
        }

        Text{
            x:0
            y:idLoadingImage.y + idLoadingImage.height + 30
            width: systemInfo.lcdWidth; height: 66
            text: "Complete\nPlease reboot"
            color:colorInfo.brightGrey
            font { family: systemInfo.font_NewHDR; pixelSize: 36}
            verticalAlignment:Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            visible: PLAYInfo.Advisory == "MODULE STOP"
        }
    }

    /* CCP Back Key */
    onBackKeyPressed: {
        console.log("DealerMain - BackKey Clicked")
        setNoDealMode();
        setDealerModeClose();
        setAppMainScreen("AppRadioMain", false);
        UIListener.HandleBackKey(false);
    }
    /* CCP Home Key */
    onHomeKeyPressed: {
        console.log("DealerListMain - HomeKey Clicked");
        UIListener.HandleHomeKey();
    }

    onVisibleChanged: {
        if(visible)
        {
            idRadioDealerModeBand.focus = true;
        }
    }

    function setDealerModeClose()
    {
        idRadioDealerMode.visible = false;
    }

    /////////////////////////////////////////////////////////////
    // Dealer Mode Timer
    /////////////////////////////////////////////////////////////
    property string engMode : "noeng"// "eng"//
    property int countEng : 1
    property int max_waiting_second_Eng : 5

    Timer {
        id:idDealerModeTimer
        interval: 100
        repeat: true

        onTriggered: {
            if(countEng == max_waiting_second_Eng){

                UIListener.HandleEngineeringListView()
                resetTimer()
            }
            countEng++;
        }
        function startTimer()
        {
            countEng = 1;
            running = true;
        }
        function stopTimer()
        {
            countEng = 1;
            running = false;
        }
        function resetTimer(){
            countEng = 1;
        }
    }

    function setEngMode()
    {
        if(engMode == "noeng")
        {
            engMode = "eng";
            UIListener.settEngineeringMode(true);
            idDealerModeTimer.startTimer();

            return true;
        }

        return false;
    }

    function setNoDealMode()
    {
        if(engMode == "eng")
        {
            engMode = "noeng";
            idDealerModeTimer.stopTimer();
            countEng = 1;
            return true;
        }

        return false;
    }
}
