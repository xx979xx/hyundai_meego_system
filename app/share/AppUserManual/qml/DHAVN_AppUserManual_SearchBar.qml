import Qt 4.7
import AppEngineQMLConstants 1.0

import "DHAVN_AppUserManual_Images.js" as Images
import "DHAVN_AppUserManual_Dimensions.js" as Dimensions

Item
{
    id: appUserManualSearchBar    

    property bool searchBtnPress: false
    property bool searchBtnExit: false
    property bool backBtnPress: false
    property bool backBtnExit: false
    property bool enableSearch: false
    property int keypadType: -1

    function clearSearchBar()
    {
        console.log("SearchBar.qml :: clearSearchBar()")
        searchBtnPress = false
        backBtnPress = false
        enableSearch = false
        hideMarker()
    }

    function setKeypadType( type )
    {
        console.log("SearchBar.qml :: setKeypadType() : " , type )
        keypadType = type
    }

//    function displayTextDeleteAll( key, label, state )
    function displayTextDeleteAll()
    {
        console.log("SearchBar.qml :: displayTextDeleteAll()")
        textBox.deleteAll( )
    }
    function displayTextDeleteCurPosition()
    {
        console.log("SearchBar.qml :: displayTextDeleteCurPosition()")
        textBox.deleteCurPosition( )
    }
    function displayText( key, label, state )
    {
        console.log("SearchBar.qml ::  displayText() key, label, state : ", key, label, state)
        textBox.input( key, label, state )
//        keypadType != 2 ?  textBox.input( key, label, state ) : textBox_arab.input( key, label, state );         // 아랍 키패드일 경우 반전
//        langId != 20 ?  textBox.input( key, label, state ) : textBox_arab.input( key, label, state );         // 아랍어일 경우 반전
    }

    function pinyInput(  position , label )
    {
        textBox.pinyInput(  position , label )
    }

    function getSearchIcon()
    {
        console.log("SearchBar.qml :: getSearchIcon() - enableSearch: " , enableSearch)
        return enableSearch
    }

    function setSearchIcon( status )
    {
        enableSearch = status
    }

    function setChineseKeypad( pinyin )
    {
        textBox.setChineseKeypad( pinyin )
    }

    function searchChinesePinyin()
    {
        textBox.searchChinesePinyin()
    }

    function setPinyinColor( lastPinYinPosition )
    {
        console.log("SearchBar.qml :: setPinyinColor()")
        textBox.setPinyinColor( lastPinYinPosition )
    }

    function getSelectTextLength()
    {
        return textBox.getSelectTextLength()
    }

    function deleteSelectedText()
    {
        return textBox.deleteSelectedText()
    }

    function selectedTextToInputText()      // 중국향 select text 입력 상태에서 searchBar로 focus 이동 시 selected text를 input text로 변환
    {
        textBox.selectedTextToInputText()
    }

    function showMarker()
    {
        console.log("SearchBar.qml :: showMarker()")
        textBox.showMarker( )
//        keypadType != 2 ?  textBox.showMarker() : textBox_arab.showMarker()         // 아랍 키패드일 경우 반전
//        langId != 20 ?  textBox.showMarker() : textBox_arab.showMarker()         // 아랍어일 경우 반전
    }

    function hideMarker_chinesePopup()
    {
        console.log("SearchBar.qml :: hideMarker_chinesePopup()")
        textBox.hideMarker_chinesePopup( )
    }

    function hideMarker()
    {
        console.log("SearchBar.qml :: hideMarker()")
        textBox.hideMarker( )
//        keypadType != 2 ?  textBox.hideMarker() : textBox_arab.hideMarker()         // 아랍 키패드일 경우 반전
//        langId != 20 ?  textBox.hideMarker() : textBox_arab.hideMarker()         // 아랍어일 경우 반전
    }

    function moveFocusB()
    {
        textBox.moveFocusB( )
//        keypadType != 2 ?  textBox.moveFocusB() : textBox_arab.moveFocusB()         // 아랍 키패드일 경우 반전
//        langId != 20 ?  textBox.moveFocusB() : textBox_arab.moveFocusB()         // 아랍어일 경우 반전
    }

    function moveFocusF()
    {
        textBox.moveFocusF( )
//        keypadType != 2 ?  textBox.moveFocusF() : textBox_arab.moveFocusF()         // 아랍 키패드일 경우 반전
//        langId != 20 ?  textBox.moveFocusF() : textBox_arab.moveFocusF()         // 아랍어일 경우 반전
    }



    /* Back Button */

//    Rectangle
//    {
//        id: backButtonBorder
//        height: backButton.height
//        width: backButton.width
//        radius: 5
//        color: Dimensions.const_AppUserManual_Rectangle_Color_Transparent
//        x: Dimensions.const_AppUserManual_Back_Button_X
//        property int focus_id: Dimensions.const_AppUserManual_SearchBack_FocusIndex
//        border.color: Dimensions.const_AppUserManual_GoTo_Text_Color
//        border.width: ( appUserManualSearchView.searchFocusIndex == focus_id ) ? Dimensions.const_AppUserManual_Button_Border_Width : 0


        Image
        {
            id: searchbar_bg
            x: 0; y: 0;
            width: 1270; height: 72;
            source: Images.const_AppUserManual_BG_Title
        }

        Image
        {
            id: backButton
//            anchors.centerIn: parent
            x: appUserManual.langId == 20 ? 3 :  1129+10 //Dimensions.const_AppUserManual_Back_Button_X - 7
            source: appUserManualSearchView.focus_index == Dimensions.const_AppUserManual_Focus_SearchBar_Back && appUserManualSearchView.focus_visible ?
                ( appUserManual.langId == 20 ? Images.const_WIDGET_BB_ME_IMG_FOCUS : Images.const_WIDGET_BB_IMG_FOCUSED )
                : ( appUserManual.langId == 20 ? Images.const_WIDGET_BB_ME_IMG_NORMAL : Images.const_WIDGET_BB_IMG_NORMAL )
            property int focus_id: Dimensions.const_AppUserManual_SearchBack_FocusIndex

            MouseArea
            {
                id: backMA
                anchors.fill: parent
                enabled: !appUserManual.lockoutMode && !appUserManual.touchLock

                onClicked:
                {
                    appUserManualSearchView.focus_index = -1
                    appUserManual.handleBackKey( false , false , false );
                }
                onPressed: {
                    console.log("SearchBar.qml :: backMA onPressed")
                    backBtnPress = true
                    backBtnExit = false
                }
                onReleased: {
                    console.log("SearchBar.qml :: backMA onReleased")
                    backBtnPress = false
                }
                onExited: {
                    console.log("SearchBar.qml :: backMA onExited")
                    backBtnExit = true
                }
            }
        }
        Image
        {
            id: backButtonPressed
//            anchors.centerIn: parent
            x: appUserManual.langId == 20 ? 3 : 1129+10 // Dimensions.const_AppUserManual_Back_Button_X - 7
            source: appUserManual.langId == 20 ? Images.const_WIDGET_BB_ME_IMG_PRESSED : Images.const_WIDGET_BB_IMG_PRESSED
            visible: ( backBtnPress && !backBtnExit ) || ( appUserManualSearchView.focus_index == Dimensions.const_AppUserManual_Focus_SearchBar_Back && appUserManualSearchView.jogPressed )
        }
//    }

    /* Search Button */

//    Rectangle
//    {
//        id: searchButtonRect
//        width: searchButton.width
//        height: searchButton.height
//        radius: 5
//        color: Dimensions.const_AppUserManual_Rectangle_Color_Transparent
//        x: Dimensions.const_AppUserManual_Search_Button_X
//        property int focus_id: Dimensions.const_AppUserManual_SearchButton_FocusIndex
//        border.color: Dimensions.const_AppUserManual_GoTo_Text_Color
//        border.width: ( appUserManualSearchView.searchFocusIndex == focus_id ) ? Dimensions.const_AppUserManual_Button_Border_Width : 0

        Image
        {
            id: searchButton
            x: appUserManual.langId == 20 ?  141  : 991+7 // Dimensions.const_AppUserManual_Search_Button_X - 7
            property int focus_id: Dimensions.const_AppUserManual_SearchButton_FocusIndex
            source: appUserManualSearchView.focus_index == Dimensions.const_AppUserManual_Focus_SearchBar_Search && appUserManualSearchView.focus_visible ?
                Images.const_AppUserManual_Search_Button_Image_F
                :  Images.const_AppUserManual_Search_Button_Image_N

            Image
            {
                id: searchButtonPressed
                anchors.fill: parent
                source: Images.const_AppUserManual_Search_Button_Image_P
                visible: ( searchBtnPress && !searchBtnExit ) || ( appUserManualSearchView.focus_index == Dimensions.const_AppUserManual_Focus_SearchBar_Search && appUserManualSearchView.jogPressed )
            }
            Image
            {
                id: icoSearch
                anchors.left: parent.left; anchors.leftMargin: 41;
                anchors.top: parent.top; anchors.topMargin: 6
                source: appUserManual.searchText.length == 0 ? Images.const_AppUserManual_Search_Ico_D
                    : ( UIListener.GetCountryVariantFromQML() == 2 && !enableSearch ) ? Images.const_AppUserManual_Search_Ico_D
                    : Images.const_AppUserManual_Search_Ico_N
            }
            MouseArea
            {
                id: searchMA
                anchors.fill: parent
                enabled: appUserManual.searchText.length == 0 /* || appUserManual.touchLock */? false
                    : ( UIListener.GetCountryVariantFromQML() == 2 && !enableSearch ) ? false
                    : true
//                enabled: ( (UIListener.GetCountryVariantFromQML() == 2 && enableSearch) || appUserManual.searchText.length != 0 ) && !appUserManual.lockoutMode

                onClicked:
                {
                    if( appUserManual.searchText.length != 0 )
                    {
                        console.log("SearchBar.qml :: searchMA onClicked")
                        if ( appUserManualSearchView.checkSearching() ) {
                            appUserManualSearchView.waitSearch()
                        }
                        else {
                            appUserManualSearchView.toastPopupVisible(true)
                            appUserManualSearchView.startSearchTimer()
//                            appUserManual.searchString( true )
                            appUserManualSearchView.focus_index = Dimensions.const_AppUserManual_Focus_SearchBar
                        }
                    }
                }
                onPressed: {
                    console.log("SearchBar.qml :: searchMA onPressed")
                    searchBtnPress = true
                    searchBtnExit = false
                }
                onReleased: {
                    console.log("SearchBar.qml :: searchMA onReleased")
                    searchBtnPress = false
                }
                onExited: {
                    console.log("SearchBar.qml :: searchMA onExited")
                    searchBtnExit = true
                }
            }
        }
//    }

    /* Search Box */

    Rectangle
    {
        id: searchBoxRect
        width: textBox.width
        height: Dimensions.const_AppUserManual_SearchBox_Height
        radius: 5
        color: Dimensions.const_AppUserManual_Rectangle_Color_Transparent
        x: appUserManual.langId == 20 ? 281 : 7 // Dimensions.const_AppUserManual_SearchBox_X

        property int focus_id: Dimensions.const_AppUserManual_SearchBox_FocusIndex
//
//        border.color: Dimensions.const_AppUserManual_GoTo_Text_Color
//        border.width: ( appUserManualSearchView.focus_index == Dimensions.const_AppUserManual_Focus_SearchBar ) ? Dimensions.const_AppUserManual_Button_Border_Width : 0
//        border.width: ( appUserManualSearchView.searchFocusIndex == focus_id ) ? Dimensions.const_AppUserManual_Button_Border_Width : 0

        DHAVN_AppUserManual_SearchBox
        {
            id: textBox
            x: Dimensions.const_AppUserManual_SearchBox_X
            z: Dimensions.const_AppUserManual_SearchBox_Z
            width: Dimensions.const_AppUserManual_SearchBox_Width
            height: Dimensions.const_AppUserManual_SearchBox_Height
//            visible: keypadType != 2 // 키패드가 중동 키패드일 경우 우측 정렬
//            visible: appUserManual.langId != 20

            onHandleSearchBoxClickEvent:
            {
                appUserManualSearchView.searchTextBoxClicked()
            }

            onClearAutomata:
            {
                appUserManualSearchView.clearAutomata()
            }
        }
    }
}
