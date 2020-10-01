import Qt 4.7
import "DHAVN_AppFATC_Constant.js" as CONST


ListView
{
    id: list_view
    onActiveFocusChanged: {
        //console.log("onActiveFocusChanged currentIndex = "+list_view.currentIndex + "focus_index = "+ focus_index);
        list_view.currentIndex = focus_index
        //console.log("currentItem.bEnable = " + list_view.currentItem.bEnable)
//        if(list_view.currentItem.bEnable==false)
//            focus_index++;
    }
    onFocusChanged: {
        //console.log("onFocusChanged currentIndex = "+list_view.currentIndex + "focus_index = "+ focus_index);
        list_view.currentIndex = focus_index
        //console.log("currentItem.bEnable = " + list_view.currentItem.bEnable)
//        if(list_view.currentItem.bEnable==false)
//            focus_index++;
    }

    /** --- Input parameters --- */
    property ListModel list: ListModel {}

    property int itemHeight: 0
    property string separatorPath: ""

    property bool focusWidth: false
    property bool bIsActiv: true

    property bool focus_visible: true
    property int focus_id: -1
    property bool bPressed: false
    property int pressedIndex:-1
    property int cv
    property string __fontfamily
    property int _elide: Text.ElideNone
    property bool drsShow : false

    //dmchoi
    property bool loadingVisable : false
    property bool checkBoxVisable : true

    /** --- Signals --- */
    signal itemClicked( variant itemId )
    signal lostFocus( int arrow, int focusID );
    signal focusChanged(variant itemId)
    signal closeMenu();
    signal itemPressed(variant bpress);
    signal canceledTouch();

    Connections{
        target:UIListener
        onSignalShowSystemPopup:{
            //console.log("onSignalShowSystemPopup")
            focus_visible = false
        }
        onSignalHideSystemPopup:{
            //console.log("onSignalHideSystemPopup")
            focus_visible = true
        }
    }

    Connections{
        target: uiListener
        // 주행 규제시에는 text scroll ticker 중지하는 것이 사양
        onDrsChanged: {
            if (UIListener.isDrsShow() == true) {
                drsShow = true;

                list_view.currentItem.stopTextScrollTicker();
            }
            else {
                drsShow = false;
            }
        }
    }

    function setDefaultFocus( arrow )
    {
        var ret = focus_id
        if ( count <= 0 || bIsActiv == false)
        {
            lostFocus( arrow, focus_id )
            ret = -1
        }
        return ret
    }

    Keys.onPressed: {
        //console.log("NonAV_Item_List onPressed")
        switch( event.key )
        {
            case Qt.Key_Enter :
            case Qt.Key_Return:
            {
                if (list_view.currentIndex==0 && rear_Offdisp==0x0) {
                    return;
                }
                list_view.currentIndex = focus_index;
                pressedIndex=list_view.currentIndex;
                bPressed = true;
                list_view.itemPressed(bPressed) //dmchoi
                event.accepted=true;
                break;
            }

            case Qt.Key_Home:
            {
                list_view.closeMenu();
                event.accepted=true;
                break;
            }

        }        
        focus_visible= true
    }

    Keys.onReleased:  {
        //console.log("NonAV_Item_List onPressed")
        switch( event.key )
        {
            case Qt.Key_Enter :
            case Qt.Key_Return:
            {
                if (list_view.currentIndex==0 && rear_Offdisp==0x0) {
                    return;
                }
                list_view.currentIndex = focus_index;
                pressedIndex=list_view.currentIndex;
                bPressed = false;
                list_view.itemPressed(bPressed) //dmchoi

                if(list_view.currentItem.bEnable==false)
                    return

                list_view.itemClicked( focus_index )
                event.accepted=true;

                //dmchoi
                if (list_view.currentIndex!=3) {
                    loadingVisable = true;
                }
                checkBoxVisable = false;
                //uiListener.playAudioBeep();
                break;
            }

            case Qt.Key_Left :
            {
                list_view.closeMenu();
                break;
            }

            case Qt.Key_Right :
            {
                event.accepted=true;
                break;
            }

            //case Qt.Key_Down :
            case Qt.Key_Equal:
            {
                if(focus_index < list.count - 1 ) {
                    focus_index++;
                }
                event.accepted=true;
                break;
            }
            //case Qt.Key_Up :
            case Qt.Key_Minus:
            {
                if (list_view.currentIndex==1 && rear_Offdisp==0x0) {
                    return;
                }
                if ( focus_index > 0 )
                    focus_index--;
                break;
            }
            case Qt.Key_I:
            case Qt.Key_Backspace:
            {
                list_view.closeMenu();
                break;
            }
        }//end of switch
    }//end of release

    /** --- Private property --- */
    property int focus_index: 0

    /** --- Object property --- */
    model: list
//    boundsBehavior: Flickable.StopAtBounds

    /** --- Child object --- */
    delegate: Item
    {
        id: listItem
        height: itemHeight
        width: parent.width//separator.sourceSize.width
        //anchors.horizontalCenter: parent.horizontalCenter
        property bool bEnable : true

        function stopTextScrollTicker() {
            marqueeTimer.stop()
            scrollStartAni.stop()
            scrollStartAni_r.stop()
            intervalTimer.stop()
             if (cv!=20) {
                id_text.anchors.leftMargin=0
             }
             else {
                 id_text.anchors.rightMargin=0
             }
        }

        /** Pressed Img */
        Image
        {
            id: pressed
            height: parent.height
            width: separator.width//focus.width
            anchors.left: parent.left
            anchors.leftMargin: /*cv != 4*/cv!=20 ? 78 : 8 + 5
            source: (list_view.pressedIndex==index)? imgFolderGeneral + "bg_optionmenu_list_p.png" : ""
            visible: bPressed
        }


        /** Focused Img */
        Image
        {
            id : id_focus_img
            height: parent.height
            width: separator.width//focusWidth ? parent.width : focus.sourceSize.width
            anchors.left: parent.left
            anchors.leftMargin: /*cv != 4*/cv!=20 ? 78 : 8 + 5
            source: imgFolderGeneral + "bg_optionmenu_list_f.png"
            visible: ((focus_index==index) && focus_visible)
            onVisibleChanged: {
                if (id_focus_img.visible==false || drsShow==true)
                {
                   stopTextScrollTicker();
                }

            }
        } // image

        /** focus Pressed Img */
        Image
        {
            id: focus_pressed
            height: parent.height
            width: separator.width
            anchors.left: parent.left
            anchors.leftMargin: /*cv != 4*/cv!=20 ? 78 : 8 + 5
            source: (list_view.pressedIndex == index)? imgFolderGeneral + "bg_optionmenu_list_p.png" : ""
            visible: (bPressed && focus_visible && (!disableItem))
        }

        Text {
            id: id_text_full_width
            text: (name.substring(0,4) == "STR_") ? qsTranslate(LocTrigger.empty + CONST.const_LANGCONTEXT, name) : name
            font.pointSize: 32
            font.family: __fontfamily
            color: "transparent"
            visible: false
        }

        Item {
            id:id_scroll_rect
            width: 324
            height:parent.height
            anchors.left:  parent.left
            anchors.leftMargin:  /*cv != 4*/cv!=20 ? 78 + 3 + 27 : 8 + 5+3+ 20 + 51//78 + 3 + 27
            property int baseX: x - anchors.leftMargin
            clip:true

            Text {
                id: id_text
                anchors.verticalCenter: id_scroll_rect.verticalCenter
                text: ( name.substring( 0, 4 ) == "STR_" ) ?
                                qsTranslate( LocTrigger.empty + CONST.const_LANGCONTEXT, name):
                                name
                font.pointSize:  32
                font.family: __fontfamily
                color: (!disableItem)? Qt.rgba(212/255, 212/255, 212/255, 1) : colorDisableGrey
                width: {
                    if (drsShow == false) {
                        id_focus_img.visible == false ? id_scroll_rect.width : id_text_full_width.width > id_scroll_rect.width ? id_text_full_width.width : id_scroll_rect.width    //textWidth < id_scroll_rect.width ? id_scroll_rect.width : textWidth
                    }
                    else {
                        id_scroll_rect.width
                    }
                }
                //clip: true
                elide: {
                    if (drsShow == false) {
                        id_focus_img.visible == false ? cv!=20 ? Text.ElideRight : Text.ElideLeft : Text.ElideNone
                    }
                    else {
                        cv!=20 ? Text.ElideRight : Text.ElideLeft
                    }
                }
                onColorChanged: {
//                    color==colorDisableGrey ? id_mArea.enabled=false : id_mArea.enabled=true;
//                    color==colorDisableGrey ? listItem.bEnable=false : listItem.bEnable=true;
                    id_mArea.enabled=true;
                    listItem.bEnable=true;
                }
                states: [ State{
                        name: "normal" ; when: cv != 20
                        AnchorChanges{ target: id_text; anchors.left: parent.left}
                        PropertyChanges{ target: id_text; horizontalAlignment:Text.AlignLeft}
                    },
                    State{
                        name: "reverse"; when: cv == 20
                        AnchorChanges{ target: id_text; anchors.right: parent.right}
                        PropertyChanges{ target: id_text; horizontalAlignment:Text.AlignRight}
                }]

                function getTextWidth(text, pointSize, parent)
                {
                    var width;
                    var textElement = Qt.createQmlObject(
                                'import Qt 4.7; Text {' + 'font.family: ' + __fontfamily +  '; font.pointSize: ' + pointSize + '; color: "transparent"; text: "' + text + '"}',
                            parent, "calcColumnWidths");
                    width = textElement.width;
                    textElement.destroy();
                    //console.log("getTextWidth width =  " + width + " text :" + text)
                    return width;
                }
                Text{
                    id: id_tail_text
                    anchors.verticalCenter: parent.verticalCenter
                    //anchors:cv !=20 ? left = parent.right + 120 : right = parent.left - 120
                    text: parent.text
                    font.pointSize:  parent.font.pointSize
                    font.family: parent.font.family
                    color:parent.color
                    states: [State{
                        name: "RIGHT_TAIL" ; when: cv != 20
                        AnchorChanges{ target: id_tail_text; anchors.left: parent.right}
                        PropertyChanges{ target: id_tail_text; anchors.leftMargin:120}
                    },
                    State{
                        name: "LEFT_TAIL"; when: cv == 20
                        AnchorChanges{ target: id_tail_text; anchors.right: parent.left}
                        PropertyChanges{ target: id_tail_text; anchors.rightMargin:120}
                    }]
                }
                SequentialAnimation
                {
                    id: scrollStartAni
                    running: {
                        if (drsShow == false)
                            (id_scroll_rect.width < id_text.implicitWidth)&&id_focus_img.visible&&cv!=20
                        else
                            false
                    }
                    loops: Animation.Infinite
                    PauseAnimation { duration: 1000 }
                    PropertyAnimation {
                        target: id_text
                        property: "anchors.leftMargin"//"x"
                        to: -(id_text.paintedWidth + 120)
                        duration: (id_text.paintedWidth + 120)/100 * 1000
                        // 0.01초에 1픽셀 이동 -> 1초에 100픽셀 이동
                        // Scroll되어야 할 길이 = 실제 Text의 길이 + 120(Scroll Text간 간격)
                    }
                    PauseAnimation { duration: 1500 }
                    PropertyAction { target: id_text; property: "anchors.leftMargin"; value: 0 }
                }
                SequentialAnimation
                {
                    id: scrollStartAni_r
                    running:{
                        if (drsShow == false)
                            (id_scroll_rect.width < id_text.implicitWidth)&&id_focus_img.visible&&cv==20
                        else
                            false
                    }
                    loops: Animation.Infinite
                    PauseAnimation { duration: 1000 }
                    PropertyAnimation {
                        target: id_text
                        property: "anchors.rightMargin"
                        to: -(id_text.paintedWidth + 120)
                        duration: (id_text.paintedWidth + 120)/100 * 1000
                        // 0.01초에 1픽셀 이동 -> 1초에 100픽셀 이동
                        // Scroll되어야 할 길이 = 실제 Text의 길이 + 120(Scroll Text간 간격)
                    }
                    PauseAnimation { duration: 1500 }
                    PropertyAction { target: id_text; property: "anchors.rightMargin"; value: 0 }
                }
            }

            Timer {
                id: marqueeTimer
                interval: 10
                onTriggered:
                {
                    if (/*cv != 4*/cv!=20) {
                        //if(id_text.x == id_scroll_rect.width - id_text.width)//id_text.textWidth)
                        if(id_text.x == (id_text.width+120)* -1/*id_scroll_rect.x*/)
                        {
                            marqueeTimer.stop()
                            intervalTimer.restart()
                     //       marqueeTimer_reverse.restart()
                        }
                        id_text.x -= 1;
                    }
                    else {

                        if ((id_text.x-120) == id_scroll_rect.baseX + id_scroll_rect.width)
                        {
                            marqueeTimer.stop()
                            intervalTimer.restart()
                            //marqueeTimer_reverse.restart()
                        }
                        id_text.x += 1;
                    }
                }
                repeat: true
               // running:(id_scroll_rect.width < id_text.width/*id_text.textWidth*/)&&id_focus_img.visible
            }

            Timer {
                id: intervalTimer
                interval: 2500
                onTriggered: {
                    if (UIListener.GetLanguageFromQML()!=20)
                        id_text.x = id_scroll_rect.baseX
                    else
                        id_text.x = id_scroll_rect.width-id_text_full_width.width
                    marqueeTimer.restart();
                }
                repeat:false
            }
        }
        
        Image {
             id: image_checkbox
             anchors.left:cv!= 20 ? id_scroll_rect.right:parent.left
             anchors.leftMargin:cv!=20 ? 5 : 8+5+21
             anchors.verticalCenter: id_scroll_rect.verticalCenter
             source: (!disableItem) ? ((isChekedState) ? imgFolderGeneral+"ico_check_s.png" : imgFolderGeneral+"ico_check_n.png") : imgFolderGeneral+"ico_check_d.png"
             visible: list_view.pressedIndex == index ? ((loadingVisable == true) && focus_visible ? false : isCheckNA ) : isCheckNA
        }

        //dmchoi
        Image {
            id: loading_icon
            source: (list_view.pressedIndex == index && index!=3) ? imgFolderGeneral + "loading_01.png" : ""
            anchors.left:cv!= 20 ? id_scroll_rect.right:parent.left
            anchors.leftMargin:cv!=20 ? 5 : 8+5+21
            anchors.verticalCenter: id_scroll_rect.verticalCenter
            visible: (loadingVisable && focus_visible && (!disableItem)) ? true : false;//(bPressed == false) && focus_visible ? true : false
            property bool on: parent.visible;
            NumberAnimation on rotation { running: loading_icon.on; from: 0; to: 360; loops: Animation.Infinite; duration: 1800 }
        }

    Image  {
            //{ modified by Aettie.ji for New UX(Music) #46 on 2012.10.18
            id: separator
            //visible: index
            visible: true
            source: separatorPath
            //anchors.top: parent.top
            //anchors.bottom: parent.bottom
            width:422
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 76
            anchors.leftMargin: /*cv != 4*/cv!=20 ? 78 : 8 + 3
            //{ modified by Aettie.ji for New UX(Music) #46 on 2012.10.18
        }

    MouseArea {
            id: id_mArea
            anchors.fill: parent
            property int startX : 0
            enabled: (!disableItem)? true:false
            beepEnabled: (!disableItem)? true:false
            onClicked:
            {
                //console.log("onClicked Index =  " + index)
                if(!disableItem) {
                    list_view.itemClicked( index )
                }
            }
            onPressed: {
                //console.log("onPressed Index =  " + index)
                if(!disableItem) {
                    startX = mouseX;
                    bPressed = true;
                    pressedIndex=index;
                    //focus_visible=false;
                    list_view.focusChanged(index);
                    list_view.itemPressed(bPressed) //dmchoi
                }
            }

            onReleased: {
                //console.log("onReleased Index =  " + index)
                if(!disableItem) {
                    bPressed = false;
                    focus_index=index;
                    list_view.itemPressed(bPressed);
                    if (list_view.currentIndex!=3) loadingVisable = true;
                    checkBoxVisable = false;
                    if(mouseX - startX > 100) {
                      list_view.closeMenu();
                    }
                    focus_visible = true;

                    if (index==3) list_view.currentIndex = index;
                }

            }
            onCanceled:{
                //console.log("onCanceled Index =  " + index);
                //if(!disableItem) {
                bPressed = false;
                canceledTouch();/*; bClicked = false*/
                //}
            }
        }
    }//end of delegate item

    onFocus_indexChanged:
    {
        list_view.positionViewAtIndex(list_view.focus_index, ListView.Contain)
        list_view.focusChanged(list_view.focus_index)
    }
}
