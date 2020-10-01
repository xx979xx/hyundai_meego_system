import QtQuick 1.1
import QmlHomeScreenDefPrivate 1.0
import AppEngineQMLConstants 1.0


Item  {
    id: container

    property real itemHeight: 112
    property int step: 1
    property int focusIndex: 0 //getDefaultIndex()
    property bool focusVisible: true
    property bool lastFoucsVisible: false
    property bool bShowSystemPopup: false           // ITS 263652.  flick move end 시 popup visible check
    property bool bShowPopup: false                         // ITS 263652
    //property real lastContenY: 0


    Component.onCompleted: {
        listView.contentY = 50
        listView.contentY = focusIndex * 112
        SubMenuListModel.nFocusIndex = container.focusIndex
    }

//    onFocusChanged: {
//        console.log("home 2nd menu focusIndex = " + focusIndex)
//    }

    function setPageUpDownIcon () {

        if (SubMenuListModel.nCountItems <= 5)
        {
            subMenuLoader.item.setPageUpDownIcon(false, false)
        }

        else if (listView.contentY <0)
        {
            subMenuLoader.item.setPageUpDownIcon(false, true)
        }

        else if (listView.contentY > ((SubMenuListModel.nCountItems-5) * 112) )
        {
            subMenuLoader.item.setPageUpDownIcon(true, false)
        }

        else if (listView.contentY == 0)
        {
            subMenuLoader.item.setPageUpDownIcon(false, true)
        }
        else if (listView.contentY == ( (SubMenuListModel.nCountItems-5) * 112) )
        {
            subMenuLoader.item.setPageUpDownIcon(true, false)
        }
        else
        {
            subMenuLoader.item.setPageUpDownIcon(true, true)
        }
    }



    function setFocusVisible (value) {
        focusVisible = value
    }

    function setFocusIndex (focusIndex) {
        container.focusIndex = focusIndex
        SubMenuListModel.nFocusIndex = focusIndex
        listView.currentIndex = focusIndex

        listView.contentY = 0

        if (focusIndex < 5)
        {
            listView.contentY = 0
        }
        else if (focusIndex > 4 && focusIndex < 10)
        {
            if (SubMenuListModel.nCountItems < 10 )
            {
                listView.contentY += (SubMenuListModel.nCountItems - 5) * 112
            }
            else
            {
                listView.contentY += 5 * 112
            }
        }

        else if (focusIndex > 9 && focusIndex < 15)
        {
            if (SubMenuListModel.nCountItems < 15 )
            {
                listView.contentY += (SubMenuListModel.nCountItems - 5) * 112
            }
            else
            {
                listView.contentY += 10 * 112
            }
        }

        setPageUpDownIcon()
    }


    function setDefaultFocusIndex () {
        container.focusIndex = 0
        SubMenuListModel.nFocusIndex = 0
        listView.currentIndex = 0
        listView.contentY = 0

        setPageUpDownIcon()
    }

    function wheelLeft() {

        if (listView.flicking || listView.moving ) return

        if (container.focusIndex > 0)
        {
            container.focusIndex--

            var listTopIndex = listView.contentY / 112

            if (listTopIndex > container.focusIndex)
            {
                if (listTopIndex < 5)
                {
                    step = 0 - listTopIndex
                    //wheel_ani.running = true
                    listView.contentY += (step*112)
                }

                else
                {
                    step = -5
                    //wheel_ani.running = true
                    listView.contentY += (step*112)
                }

            }

            listView.currentIndex = container.focusIndex
            SubMenuListModel.nFocusIndex = container.focusIndex
        }

        else if (SubMenuListModel.nCountItems > 5 && container.focusIndex == 0)
        {
            container.focusIndex = SubMenuListModel.nCountItems-1
            listView.contentY = 0
            listView.contentY = (SubMenuListModel.nCountItems-1-4)*112
            listView.currentIndex = container.focusIndex
            SubMenuListModel.nFocusIndex = container.focusIndex
        }
    }

    function wheelRight() {

        if (listView.flicking || listView.moving ) return

        if (container.focusIndex < SubMenuListModel.nCountItems - 1)
        {
            container.focusIndex++

            var listBottomIndex = listView.contentY / 112 + 4

            if (listBottomIndex < container.focusIndex)
            {
                if ( (SubMenuListModel.nCountItems-1-listBottomIndex) >=5 )
                {
                    step = 5
                    //wheel_ani.running = true
                    listView.contentY += (step*112)
                }

                else
                {
                    step = SubMenuListModel.nCountItems-1-listBottomIndex
                    //wheel_ani.running = true
                    listView.contentY += (step*112)
                }
            }

            listView.currentIndex = container.focusIndex
            SubMenuListModel.nFocusIndex = container.focusIndex
            //step = 1

            //wheel_ani.running = true
        }

        else if (SubMenuListModel.nCountItems > 5 && container.focusIndex == SubMenuListModel.nCountItems - 1)
        {
            container.focusIndex = 0
            listView.contentY = 0
            listView.currentIndex = container.focusIndex
            SubMenuListModel.nFocusIndex = container.focusIndex
        }
    }

    Connections {
        target: EngineListener

        onSetMediaMenuFocusIndex: {
            console.log("kjw :: onSetMediaMenuFocusIndex")
            if(screen == UIListener.getCurrentScreen())
            {
                if (index == -1)
                {
                    if (container.focusIndex > SubMenuListModel.nCountItems - 1)
                    {
                        container.focusIndex = SubMenuListModel.nCountItems - 1
                        SubMenuListModel.nFocusIndex = container.focusIndex
                        setFocusIndex(container.focusIndex)
                    }
                    else
                    {
                        SubMenuListModel.nFocusIndex = container.focusIndex
                        setFocusIndex(container.focusIndex)
                    }
                }

                else
                {
                    container.focusIndex = index
                    SubMenuListModel.nFocusIndex = index
                    setFocusIndex(index)
                }
            }
        }
        onClosepopup:
        {
            if( screen != UIListener.getCurrentScreen() ) return
           console.log("kjw :: popup close !!")
            bShowPopup = false
           focusVisible = true
        }
    }

    Component {
        id: item_delegate

        Item{
            id: item

            width: 530; height: 112

            //opacity: wheel_ani.running ? 0.75 : 1

            property bool jogPressed: false

            Connections {
                target: listView

                onContentYChanged : {
                    item.x = calc_X(index)
                    item.visible = calc_Visible(index)
                }
            }

            Connections {
                target: View

                onUpdateSubModel: {
                    item.x = calc_X(index)
                    item.visible = calc_Visible(index)
                }
            }


            Component.onCompleted: {
                item.x = calc_X(index)
                item.visible = calc_Visible(index)
            }

            function itemClicked()
            {
                if( bEnabled )
                {
                    /*
                    // BL 통화중일 경우 AAP 진입 불가 팝업 출력
                    if ( EngineListener.checkCallStartBL() ) {
                        if (  nAppId == EHSDefP.APP_ID_AUDIO_ANDROID_AUTO ) {
                            ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_DISABLE_CONNECTIVITY_BLCALL );
                            return;
                        }
                    }
                    */

                    // CarPlay 통화 중일 경우,
                    //===============>>>>>  AV Disable
                    if ( EngineListener.checkCallStartCarPlay() ) {
                        EngineListener.logForQML("CurvedList.qml - itemClicked() - nAppId:  " + nAppId + ", nViewId: " + nViewId );
                        // entered only photo of Media
                        if (  (nAppId >= EHSDefP.APP_ID_AUX &&  nAppId <=  EHSDefP.APP_ID_VIDEO_DISC)) {
                            ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_DISABLE_AV_CALL );
                            bShowPopup = true
                            focusVisible = false
                                return;
                        }
                    }
                    // AA VR 실행 중일 경우,
                    // CarPlay Siri VR 실행 중일 경우,
                    //===============>>>>>  AV Disable
                    if ( EngineListener.checkVrStatusCarplaySiri() || EngineListener.checkVrStatusAA()  ) {
                        EngineListener.logForQML("CurvedList.qml - itemClicked() - nAppId:  " + nAppId + ", nViewId: " + nViewId );
                        // entered only photo of Media
                        if (  (nAppId >= EHSDefP.APP_ID_AUX &&  nAppId <=  EHSDefP.APP_ID_VIDEO_DISC)) {
                            ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_DISABLE_AV_VR );
                            bShowPopup = true
                            focusVisible = false
                                return;
                        }
                    }
                    EngineListener.LaunchApplication( nAppId, nViewId, UIListener.getCurrentScreen(), ViewControll.GetDisplay() , sText );
                }
                else
                {
                    ViewControll.ShowPopUp( nAppId, nViewId );
                    bShowPopup = true
                    focusVisible = false
                }
            }

            function cal_Y (index) {
                return  index * 112 - listView.contentY
            }

            function calc_Visible (index) {
                var currentY = cal_Y(index)

                if (currentY < -67 || currentY >= (112 * 4.6))
                    return false

                else
                    return true
            }

            function calc_X (index) {
                var currentY = cal_Y(index)

                return ((-0.002551*currentY*(currentY-448)))
            }

            Image {
                id: image_line
                y:112
                source: "/app/share/images/AppHome/2dep_line.png"
            }

            Image {
                id : image_focus

                x: -86; y:41

                visible: (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? true : false

                source: "/app/share/images/AppHome/2dep_list_f.png"
            }

            Image{
                id: image_item_icon

                x:  (itemMouseArea.pressed || item.jogPressed) ? 0 :
                    (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? -24 : 0

                y:  (itemMouseArea.pressed || item.jogPressed) ? 0 :
                    (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? -24 : 0

                source: (container.focusVisible && SubMenuListModel.nFocusIndex == index && item.jogPressed) ? sImage + "_p.png" :
                        (itemMouseArea.pressed) ? sImage + "_p.png" :
                        (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? sImage + "_f.png" :
                        (bEnabled == false) ? sImage + "_d.png" : sImage + "_n.png"

            }

            Text {
                id: text_item_name

                x: 54
                //width: 250

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: 140

                font.pointSize: (container.focusVisible && SubMenuListModel.nFocusIndex == index && item.jogPressed) ? 35 :
                                (itemMouseArea.pressed) ? 35 :
                                (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? 37 : 35

                font.family: (itemMouseArea.pressed) ? EngineListener.getFont(true) :
                            (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? EngineListener.getFont(true) : EngineListener.getFont(false)

                color:  (itemMouseArea.pressed) ? "#3CB3FF" :
                        (bEnabled == false) ? "#3F4D5C" :
                        (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? "#3CB3FF" : "#FAFAFA"

                text: qsTranslate( "main", sText ) + LocTrigger.empty

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }

/*
            Image {
                id: image_google

                anchors.left: text_item_name.right
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter

                source: (container.focusVisible && SubMenuListModel.nFocusIndex == index && item.jogPressed) ? "/app/share/images/AppHome/icon_google_n.png" :
                        (itemMouseArea.pressed) ? "/app/share/images/AppHome/icon_google_n.png" :
                        (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? "/app/share/images/AppHome/icon_google_f.png" : "/app/share/images/AppHome/icon_google_n.png"

                visible: (UIListener.GetCountryVariantFromQML() == 1 && sText == "STR_SEND_TO_CAR")
            }
*/

            Text
            {
                id: bluetooth

                anchors.left: text_item_name.right
                anchors.verticalCenter: parent.verticalCenter

                font.pointSize: (container.focusVisible && SubMenuListModel.nFocusIndex == index && item.jogPressed) ? 35 :
                                (itemMouseArea.pressed) ? 35 :
                                (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? 37 : 35

                font.family: (itemMouseArea.pressed) ? EngineListener.getFont(true) :
                            (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? EngineListener.getFont(true) : EngineListener.getFont(false)

                color:  (itemMouseArea.pressed) ? "#3CB3FF" :
                        (bEnabled == false) ? "#3F4D5C" :
                        (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? "#3CB3FF" : "#9E9E9E"

                text : qsTranslate( "main", "STR_HOME_BT_AHA_PANDORA" ) + LocTrigger.empty

                visible : ((sText == "STR_HOME_BT_AHA") || (sText == "STR_HOME_BT_PANDORA"))

            }

            MouseArea {
                id: itemMouseArea
                anchors.fill: parent

                onPressed:  {
                    //image_item_icon.source = item_model.get(index).image_path + "_p.png"
                }

                onClicked:  {
                    if (!goSubMenuAni.running && !goMainMenuAni.running)
                    {

                        container.focusIndex = index
                        SubMenuListModel.nFocusIndex = index
                        listView.currentIndex = index
                        item.itemClicked()
                    }
                }
            }

            Connections {
                target: UIListener

                onSignalJogNavigation: {
                    if (popUpLoader.status != Loader.Ready && SubMenuListModel.nFocusIndex == index && container.focusVisible)
                    {
                        if(LocTrigger.arab)
                        {
                            if( ( status == UIListenerEnum.KEY_STATUS_PRESSED ) && arrow == UIListenerEnum.JOG_RIGHT ) {
                                EngineListener.BackKeyHandler(UIListener.getCurrentScreen())
                            }
                        }
                        else
                        {
                            if( ( status == UIListenerEnum.KEY_STATUS_PRESSED ) && arrow == UIListenerEnum.JOG_LEFT ) {
                                EngineListener.BackKeyHandler(UIListener.getCurrentScreen())
                            }
                        }

                        if( ( status == UIListenerEnum.KEY_STATUS_PRESSED ) && arrow == UIListenerEnum.JOG_CENTER ) {
                            item.jogPressed = true;
                        }

                        if( ( status == UIListenerEnum.KEY_STATUS_RELEASED ) && arrow == UIListenerEnum.JOG_CENTER ) {

                            item.jogPressed = false;

                            if (!goSubMenuAni.running && !goMainMenuAni.running)
                            {
                                item.itemClicked()
                            }
                        }

                        if( ( status == UIListenerEnum.KEY_STATUS_CANCELED ) && arrow == UIListenerEnum.JOG_CENTER ) {
                            item.jogPressed = false;
                            ViewControll.bJogPressed = false
                        }
                    }
                }
            }
        }
    }

    Component {
        id: item_delegate_arab

        Item{
            id: item

            width: 675; height: 112

            //opacity: wheel_ani.running ? 0.75 : 1

            property bool jogPressed: false

            Connections {
                target: listView

                onContentYChanged : {
                    item.x = calc_X(index)
                    item.visible = calc_Visible(index)
                }
            }

            Connections {
                target: View

                onUpdateSubModel: {
                    item.x = calc_X(index)
                    item.visible = calc_Visible(index)
                }
            }

            Component.onCompleted: {
                item.x = calc_X(index)
                item.visible = calc_Visible(index)
            }

            function itemClicked()
            {
                if( bEnabled )
                {
                    /*
                    // BL 통화중일 경우 AAP 진입 불가 팝업 출력
                    if ( EngineListener.checkCallStartBL() ) {
                        if (  nAppId == EHSDefP.APP_ID_AUDIO_ANDROID_AUTO ) {
                            ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_DISABLE_CONNECTIVITY_BLCALL );
                            return;
                        }
                    }
                    */

                    // CarPlay 통화 중일 경우,
                    //===============>>>>>  AV Disable
                    if ( EngineListener.checkCallStartCarPlay() ) {
                        EngineListener.logForQML("CurvedList.qml - itemClicked() - nAppId:  " + nAppId + ", nViewId: " + nViewId );
                        // entered only photo of Media
                        if (  (nAppId >= EHSDefP.APP_ID_AUX &&  nAppId <=  EHSDefP.APP_ID_VIDEO_DISC)) {
                            ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_DISABLE_AV_CALL );
                            bShowPopup = true
                            focusVisible = false
                                return;
                        }
                    }
                    // AA VR 실행 중일 경우,
                    // CarPlay Siri VR 실행 중일 경우,
                    //===============>>>>>  AV Disable
                    if ( EngineListener.checkVrStatusCarplaySiri() || EngineListener.checkVrStatusAA()  ) {
                        EngineListener.logForQML("CurvedList.qml - itemClicked() - nAppId:  " + nAppId + ", nViewId: " + nViewId );
                        // entered only photo of Media
                        if (  (nAppId >= EHSDefP.APP_ID_AUX &&  nAppId <=  EHSDefP.APP_ID_VIDEO_DISC)) {
                            ViewControll.ShowPopUpConnectivity( EHSDefP.POPUP_DISABLE_AV_VR );
                            bShowPopup = true
                            focusVisible = false
                                return;
                        }
                    }
                    EngineListener.LaunchApplication( nAppId, nViewId, UIListener.getCurrentScreen(), ViewControll.GetDisplay() , sText );
                }
                else
                {
                    ViewControll.ShowPopUp( nAppId, nViewId );
                    bShowPopup = true
                    focusVisible = false
                }
            }

            function cal_Y (index) {
                return  index * 112 - listView.contentY
            }

            function calc_Visible (index) {
                var currentY = cal_Y(index)

                if (currentY < -67 || currentY >= (112 * 4.6))
                    return false

                else
                    return true
            }

            function calc_X (index) {
                var currentY = cal_Y(index)

                return 0 - ((-0.002551*currentY*(currentY-448)))
            }

            Image {
                id: image_line
                y:112
                source: "/app/share/images/AppHome/2dep_line.png"
            }

            Image {
                id : image_focus

                x: -76; y:41

                visible: (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? true : false

                source: "/app/share/images/AppHome/arab/2dep_list_f.png"
            }

            Image{
                id: image_item_icon

                x:  (itemMouseArea.pressed || item.jogPressed) ? parent.width - 109 :
                    (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? parent.width - 109 -24 : parent.width - 109

                y:  (itemMouseArea.pressed || item.jogPressed) ? 0 :
                    (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? -24 : 0

                source: (container.focusVisible && SubMenuListModel.nFocusIndex == index && item.jogPressed) ? sImage + "_p.png" :
                        (itemMouseArea.pressed) ? sImage + "_p.png" :
                        (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? sImage + "_f.png" :
                        (bEnabled == false) ? sImage + "_d.png" : sImage + "_n.png"

            }

            Text {
                id: text_item_name

                x: 54; width: 250

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: 140

                font.pointSize: (container.focusVisible && SubMenuListModel.nFocusIndex == index && item.jogPressed) ? 35 :
                                (itemMouseArea.pressed) ? 35 :
                                (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? 37 : 35

                font.family: (itemMouseArea.pressed) ? EngineListener.getFont(true) :
                            (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? EngineListener.getFont(true) : EngineListener.getFont(false)

                color: (itemMouseArea.pressed) ? "#3CB3FF" :
                        (bEnabled == false) ? "#3F4D5C" :
                        (container.focusVisible && SubMenuListModel.nFocusIndex == index) ? "#3CB3FF" : "#FAFAFA"

                text: qsTranslate( "main", sText ) + LocTrigger.empty

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }

            MouseArea {
                id: itemMouseArea
                anchors.fill: parent

                onPressed:  {
                    //image_item_icon.source = item_model.get(index).image_path + "_p.png"
                }

                onClicked:  {
                    if (!goSubMenuAni.running && !goMainMenuAni.running)
                    {

                        container.focusIndex = index
                        SubMenuListModel.nFocusIndex = index
                        listView.currentIndex = index
                        item.itemClicked()
                    }
                }
            }

            Connections {
                target: UIListener

                onSignalJogNavigation: {
                    if (popUpLoader.status != Loader.Ready && SubMenuListModel.nFocusIndex == index && container.focusVisible)
                    {
                        if(LocTrigger.arab)
                        {
                            if( ( status == UIListenerEnum.KEY_STATUS_PRESSED ) && arrow == UIListenerEnum.JOG_RIGHT ) {
                                EngineListener.BackKeyHandler(UIListener.getCurrentScreen())
                            }
                        }
                        else
                        {
                            if( ( status == UIListenerEnum.KEY_STATUS_PRESSED ) && arrow == UIListenerEnum.JOG_LEFT ) {
                                EngineListener.BackKeyHandler(UIListener.getCurrentScreen())
                            }
                        }

                        if( ( status == UIListenerEnum.KEY_STATUS_PRESSED ) && arrow == UIListenerEnum.JOG_CENTER ) {
                            item.jogPressed = true;
                        }

                        if( ( status == UIListenerEnum.KEY_STATUS_RELEASED ) && arrow == UIListenerEnum.JOG_CENTER ) {

                            item.jogPressed = false;

                            if (!goSubMenuAni.running && !goMainMenuAni.running)
                            {
                                item.itemClicked()
                            }
                        }

                        if( ( status == UIListenerEnum.KEY_STATUS_CANCELED ) && arrow == UIListenerEnum.JOG_CENTER ) {
                            item.jogPressed = false;
                            ViewControll.bJogPressed = false
                        }
                    }
                }
            }
        }
    }

    /*
    Component {
        id: header_delegate

        Item{
            id: heder

            width: 530; height: 112 * 3
        }
    }
    */

    ListView  {
        id: listView
        anchors.fill: parent

        //header: header_delegate
        //footer: header_delegate
        delegate: LocTrigger.arab ? item_delegate_arab : item_delegate
        model: SubMenuListModel

        interactive: true
        boundsBehavior: Flickable.DragAndOvershootBounds
        snapMode: ListView.SnapToItem
        cacheBuffer: 10000

        onMovementEnded: {
            //console.log("onMovementEnded")

            var listTopIndex = listView.contentY / 112
            var listBottomIndex = listView.contentY / 112 + 4

            if (listTopIndex > container.focusIndex || listBottomIndex < container.focusIndex)
            {
                container.focusIndex = listTopIndex
                SubMenuListModel.nFocusIndex = container.focusIndex

            }

            if ( !bShowSystemPopup && !bShowPopup ) subMenuLoader.item.moveFocusToList()
        }

        onContentYChanged: {
            setPageUpDownIcon()
        }
    }

    Connections {
        target: UIListener
        onSignalShowSystemPopup: {
            //console.log("onSignalShowSystemPopup")
            bShowSystemPopup = true
            focusVisible = false
        }
        onSignalHideSystemPopup: {
            //console.log("onSignalHideSystemPopup")
            bShowSystemPopup = false
            focusVisible = true
            subMenuLoader.item.moveFocusToList()
        }
    }

    /*
    SequentialAnimation {
        id: wheel_ani
        running: false

        NumberAnimation { target: listView; property: "contentY"; from: listView.contentY; to: listView.contentY + (step*112); duration: Math.abs(75*step) }
    }
    */

    function getDefaultIndex () {
        var count = SubMenuListModel.nCountItems
        var value

        if (count < 5)
        {
            if (count <3)
            {
                value = 0
            }
            else
            {
                value = 1
            }
        }
        else
        {
            value = 2
        }

        return value
    }
}
//}
