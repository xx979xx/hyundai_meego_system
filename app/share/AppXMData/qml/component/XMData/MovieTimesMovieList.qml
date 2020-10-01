import Qt 4.7

// Local Import
import "./List" as XMList
import "./ListDelegate" as XMDelegate
import "../QML/DH" as MComp
import "./ListElement" as XMListElement
import "./Popup" as MPopup
import "./Javascript/Definition.js" as MDefinition

import "../../component/XMData/Common" as XMCommon //XMCommon.StringInfo { id: stringInfo }

FocusScope{
    id:container

    XMCommon.StringInfo { id: stringInfo }

    property int    index:0;
    property int    entryID : 0
    property string szTheaterName : ""
    property string szAddress : ""
    property string szPhoneNumber : ""
    property double fLatitude: 0.0;
    property double fLongitude: 0.0
    property string szState: "";
    property string szCity: "";
    property string szStreet: "";
    property string szZipcode: "";
    property int    iAmenityseating:0;
    property int    iAmenityrocker:0;
    property bool checkBTConnectStatus: idAppMain.isBTConnectStatus;
    property bool goPressStatus : false;
    property bool callPressStatus : false;

    //Signal
    signal goButtonClicked(int index, int entryID, string name, string address, string phonenumber, double latitude,double longitude, string statename, string city, string street, string zipcode, int amenityseating, int amenityrocker);

    onVisibleChanged:
    {
        if(visible == true)
        {
            idMenuBar.menuBtnFlag = false;
        }else
        {
            idMenuBar.menuBtnFlag = true;
        }
    }

    Component.onCompleted: {
        container.forceActiveFocus();
        idGoButton.forceActiveFocus();
    }

    focus:true;

    // Theater Address
    MComp.DDScrollTicker{
        id: idAddress
        x: 101; y: 8;
        width: 947; height: 79;
        text: szAddress
        fontFamily : systemInfo.font_NewHDR
        fontSize: 40
        color: colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        tickerEnable: true
        tickerFocus: (idGoButton.activeFocus && idAppMain.focusOn)
    }

//    Text {
//        id: idAddress
//        x: 101; y: 7+37 - font.pixelSize/2;
//        width: 947; height: font.pixelSize+10;
//        text: szAddress
//        font.family: systemInfo.font_NewHDR
//        font.pixelSize: 40
//        color: colorInfo.brightGrey
//        horizontalAlignment: Text.AlignLeft
//        verticalAlignment: Text.AlignVCenter
//        //clip: true
//        elide : Text.ElideRight

//        Rectangle{
//            width:parent.width
//            height:parent.height
//            border.color: "white"
//            border.width: 1
//            color:"transparent"
//            visible: isDebugMode();
//        }
//    }
    // Theater Go Button
    MComp.MButton{
        id:idGoButton
        x:101 + 947 + 41
        y: 8
        width: 134; height: 79

        bgImage:            imageInfo.imgFolderXMData + "btn_go_n.png"
        bgImagePress:       imageInfo.imgFolderXMData + "btn_go_p.png"
        bgImageFocus:       imageInfo.imgFolderXMData + "btn_go_f.png"

        firstText: stringInfo.sSTR_XMDATA_GO
        firstTextX: 12
        firstTextSize:32
        firstTextColor: colorInfo.brightGrey
        firstTextStyle: systemInfo.font_NewHDB
        focus:true;

        onClicked: {
            goPressStatus = true;
        }

        onSelectKeyPressed: {
            goPressStatus = true;
        }
        onClickOrKeySelected: {
            if(goPressStatus)
            {
                idGoButton.forceActiveFocus();
                checkSDPopup(index, entryID, szTheaterName, szAddress, szPhoneNumber, fLatitude, fLongitude, szState, szCity, szStreet, szZipcode, iAmenityseating, iAmenityrocker);
            }
            goPressStatus = false;
        }
        onWheelRightKeyPressed: {
            (checkBTConnectStatus == false) ? null : idCallButton.focus = true;
        }
	
        KeyNavigation.down: idMovieList.count != 0 ? idMovieList : null;
    }

    // Theater Phone Number
    Text {
        id: idCallNum
        x: 101; y: 7+37+53+37 - font.pixelSize/2;
        width: 947; height: font.pixelSize+10;
        text: szPhoneNumber
        font.family: systemInfo.font_NewHDR
        font.pixelSize: 40
        color: (checkBTConnectStatus == false) ? colorInfo.disableGrey : colorInfo.brightGrey
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        //clip: true
        elide : Text.ElideRight
    }
    // Theater Call Button
    MComp.MButton{
        id:idCallButton
        x: 101 + 947 + 41
        y: 8+37+53
        width: 134; height: 79

        bgImage:            (checkBTConnectStatus == false) ? imageInfo.imgFolderXMData + "btn_call_d.png" : imageInfo.imgFolderXMData + "btn_call_n.png"
        bgImagePress:       imageInfo.imgFolderXMData + "btn_call_p.png"
        bgImageFocus:       imageInfo.imgFolderXMData + "btn_call_f.png"
        mEnabled: checkBTConnectStatus

        onClicked: {
            callPressStatus = true;
        }

        onSelectKeyPressed: {
            callPressStatus = true;
        }
        onClickOrKeySelected: {
            if(callPressStatus)
            {
                idCallButton.forceActiveFocus();

                if(idAppMain.isCallStart == false)
                {
                    UIListener.doOutGoingBTCall(szPhoneNumber)
                }
                else
                {
                    idCallPopup.show();
                }
            }
            callPressStatus = false;
        }

        onWheelLeftKeyPressed: {
            idGoButton.focus = true;
        }

        KeyNavigation.down:idMovieList.count != 0 ? idMovieList : null;
    }
    Component{
        id: idMovieTimesMovieListDelegate
        XMDelegate.XMMovieTimesMovieStarttimeListDelegate {
        }
    }

    function checkFocusOfMovementEnd()
    {
        checkFocusOfScreen();
    }

    function checkFocusOfScreen()
    {
        if(idMovieList.visible && (container.activeFocus || idMenuBar.contentItem.KeyNavigation.up.activeFocus)){
            idCenterFocusScope.focus = true;
            idMovieList.focus = true;
        }
    }

    XMList.XMDataNormalList {
        id: idMovieList
        y: 344-166//idCallButton.y + idCallButton.height
        width: parent.width;
        height : 90 * 4 //parent.height-y;//systemInfo.subMainHeight - systemInfo.bandHeight - y
        focus: true
        listModel: movieListByTheater
        listDelegate: idMovieTimesMovieListDelegate
        selectedIndex: -1;
        upFocusItem : (checkBTConnectStatus == false) ? idGoButton : idCallButton;

        KeyNavigation.up:idMovieList
        KeyNavigation.down: idMovieList


        onItemClicked: {
            idDescriptionPopup.textTitle = itemTitle;
            idDescriptionPopup.visible = true;
        }

        Text {
            id:idEmptyLabel;
            x:30;y: 313-systemInfo.headlineHeight - font.pixelSize/2
            width:parent.width-30
            text: stringInfo.sSTR_XMDATA_NO_MOVIE_DATA
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: systemInfo.font_NewHDR
            font.pixelSize: 40
            wrapMode: Text.Wrap
            color: colorInfo.brightGrey
            visible: idMovieList.count == 0
        }

        onCountChanged: {
            if(visible)
            {
                if(count == 0)
                {
                    idGoButton.focus = true;
                    idGoButton.KeyNavigation.down = null;
                    idCallButton.KeyNavigation.down = null;
                }else
                {
                    idGoButton.KeyNavigation.down = idMovieList;
                    idCallButton.KeyNavigation.down = idMovieList;
                }
            }
        }

        Connections{
            target : movieTimesDataManager
            onCheckForFocus:{
                if(idMovieList.visible)
                {
                    if(idMovieList.count == 0)
                    {
                        idGoButton.KeyNavigation.down = null;
                        idCallButton.KeyNavigation.down = null;
                    }
                    else
                    {
                        idGoButton.KeyNavigation.down = idMovieList;
                        idCallButton.KeyNavigation.down = idMovieList;
                    }
                }
            }
        }
        //XMRectangleForDebug{}
    }
    // Upper line
    Image {
        x: 0; y: idMovieList.y
        source: imageInfo.imgFolderGeneral + "list_line.png"
    }

    onCheckBTConnectStatusChanged:{
        if(checkBTConnectStatus == false)
        {
            idGoButton.focus = true;
            callPressStatus = false;
        }
    }
}
