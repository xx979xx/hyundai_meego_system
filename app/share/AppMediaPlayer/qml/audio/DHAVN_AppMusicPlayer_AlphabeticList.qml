import QtQuick 1.0
import "DHAVN_AppMusicPlayer_General.js" as MPC
import "DHAVN_AppMusicPlayer_Resources.js" as RES

Item
{
    id: root

    //property int countryvariant : AudioListViewModel.GetCountryVariant(); //removed by junam 2013.08.20 for quick bar
    property int icon_search_left_margin
    property int icon_index_left_margin
    property int list_view_top_margin: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_LIST_LISTVIEW_TOP_MARGIN
    property int item_width
    property int item_height_top_part
    property int item_height_bottom_part
    property variant listInner : listView
    property alias listTextInner : listView.model

    //{ added by jaehwan 2013.10.25 for ISV 90617
    property variant hiddenListInner : hiddenListView
    property alias hiddenListTextInner : hiddenListView.model
    //} added by jaehwan 2013.10.25

    property int item_top_margin : MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ICON_INDEX_TOP_MARGIN_A // added by cychoi 2015.12.04 for ITS 270606

    //{changed by junam 2013.06.01 for adding exception iPod song
    // { modify by EUNHYE 2012.07.09 for CR11224
    //property variant listTextInner : countryvariant ? ((countryvariant == 4) ? listModelMed : listModelEng) : listModelKor
    //property int letterCount : countryvariant ? ((countryvariant == 4) ? 11 : 9) : 10
    // } modify by EUNHYE 2012.07.09 for CR11224

    //added by junam 2013.08.20 for quick bar
    ListModel { id: listModel }

    //added by jaehwan 2013.10.25 for ISV 90617
    ListModel { id: hiddenListModel }


    function getListModel()
    {
        var alphabeticList = AudioListViewModel.getAlphabeticList(AudioController.iPodSortingOrder);

        if(alphabeticList.length <= 9)
        {
            root.item_height_top_part = MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_TOP_PART_ENG;
            root.item_height_bottom_part = MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_BOTTOM_PART_ENG;
        }
        else if(alphabeticList.length == 10)
        {
            root.item_height_top_part = MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_TOP_PART;
            root.item_height_bottom_part = MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_BOTTOM_PART;
        }
        else //if(listModel.count >= 11)
        {
            root.item_height_top_part = MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_TOP_PART_MED;
            root.item_height_bottom_part = MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_USB_ITEM_HEIGHT_BOTTOM_PART_MED;
        }

        for ( var idx in alphabeticList )
        {

            if( idx < listModel.count )
            {
                //EngineListenerMain.qmlLog("DHAVN_AppMusicPlayer_AlphabeticList.qml : repelace model at "+ alphabeticList.length)
                listModel.set( idx, {"letter": alphabeticList[idx]});
            }
            else
            {
                //EngineListenerMain.qmlLog("DHAVN_AppMusicPlayer_AlphabeticList.qml : append model at "+ alphabeticList.length)
                listModel.append({"letter": alphabeticList[idx]});
            }
        }        
        while(alphabeticList.length < listModel.count)
        {
            //EngineListenerMain.qmlLog("DHAVN_AppMusicPlayer_AlphabeticList.qml : remove model at "+ alphabeticList.length)
            listModel.remove(alphabeticList.length)
        }

        return listModel;
    }
    //}added by junam

   //{ added by jaehwan 2013.10.25 for ISV 90617
    function getHiddenListModel()
    {
        var hiddenAlphabeticList = AudioListViewModel.getHiddenAlphabeticList(AudioController.iPodSortingOrder);
        var alphabeticList = AudioListViewModel.getAlphabeticList(AudioController.iPodSortingOrder);

        var weightList = new Array(hiddenAlphabeticList.length)
        //calculate flag for item's height
        var itemWeight = 0
        for ( var idx in hiddenAlphabeticList )
        {
            var visibleLetter = false;
            for ( var i in alphabeticList)
            {
                if (alphabeticList[i] == hiddenAlphabeticList[idx])
                {
                    visibleLetter = true;
                }

            }
            if(visibleLetter)
            {
                var j = idx -1;
                while(weightList[j] > 0 && j >= 0)
                {
                    weightList[j] = itemWeight;  // count of items btween visible two letters (not visible)
                    j--;
                }
                if (hiddenAlphabeticList[idx] == '#' || j == idx -1 ) // modified by jaehwan 2013.11.19 for ISV-94561
                {
                    weightList[idx] =  -2; // #
                    itemWeight = 0;
                }
                else
                {
                    weightList[idx] =  -1; //visible index
                    itemWeight = 0;
                }
            }
            else
            {
                weightList[idx] = ++itemWeight;
            }
        }

        for ( var idx in hiddenAlphabeticList )
        {
            if( idx < hiddenListModel.count )
            {
                hiddenListModel.set(idx, {"letter": hiddenAlphabeticList[idx],"gap": weightList[idx]});
            }
            else
            {
                hiddenListModel.append({"letter": hiddenAlphabeticList[idx],"gap": weightList[idx]});
            }
        }
        while(hiddenAlphabeticList.length < hiddenListModel.count)
        {
            hiddenListModel.remove(hiddenAlphabeticList.length)
        }

        return hiddenListModel;
    }
   //} added by jaehwan 2013.10.25

    width: item_width
    height: listView.height + list_view_top_margin

    Component
    {
        id: itemDelegate

        Item
        {
            id : quickItem
            width: parent.width
            height: root.item_height_top_part + root.item_height_bottom_part

            Text
            {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter // modify by EUNHYE 2012.07.09 for CR11224
                anchors.leftMargin: root.icon_index_left_margin

                text: letter
                //font.pixelSize : MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_FONT_SIZE_TEXT_HDB_22_FONT
                font.pointSize : MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_FONT_SIZE_TEXT_HDB_22_FONT   //modified by aettie.ji 2012.11.28 for uxlaunch update
                font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB
                color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
            }

            Image
            {
                id: iconIndex

                //{changed by junam 2013.06.08 for sort
                //visible: (letter =='V'|| letter =='U') ? false: true // modify by eunhye 2013.03.06 for New UX
                visible: (index + 1 == listView.count) ? false: true
                //}changed by junam

                //{ added by eunhye 2012.08.23 New UX:Music(LGE) #5,7,8,11,14,17,18
                //anchors.horizontalCenter: parent.horizontalCenter
                //anchors.verticalCenter: parent.verticalCenter
                //anchors.verticalCenterOffset: root.item_height_top_part - root.item_height_bottom_part + MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_ICON_INDEX_MARGIN; //modify by EUNHYE 2012.07.09 for CR11224
                anchors.top: parent.top
                anchors.topMargin: root.item_height_top_part + root.item_top_margin // modified by cychoi 2015.12.04 for ITS 270606 //root.item_height_top_part + MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ICON_INDEX_LEFT_MARGIN
                anchors.left: parent.left
                anchors.leftMargin: MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ICON_INDEX_LEFT_MARGIN
                //} added by eunhye 2012.08.23 New UX:Music(LGE) #5,7,8,11,14,17,18

                source: RES.const_APP_MUSIC_PLAYER_URL_IMG_QUICKSCROLL_DOT
            }
        }
    }
   //{ added by jaehwan 2013.10.25 for ISV 90617
    Component
    {
        id: hiddenItemDelegate

        Item
        {
            id : quickItem
            width: parent.width
            height: {
                        if (gap == -1) //visible letters
                        {
                            root.item_height_top_part + 6 // modified by jaehwan 2013.11.19 , give more height to visible letter
                        }
                        else if (gap == -2) // '#' case, no other hidden letters.
                        {
                            root.item_height_top_part + root.item_height_bottom_part
                        }
                        else //invisible letters, dividing the space of '.' image.
                        {
                            ( root.item_height_bottom_part - 6) / gap // modified by jaehwan 2013.11.19 , give more height to visible letter
                        }
                     }

            Text
            {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter // modify by EUNHYE 2012.07.09 for CR11224
                anchors.leftMargin: root.icon_index_left_margin

                text: letter
                visible: false
                font.pointSize : MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_FONT_SIZE_TEXT_HDB_22_FONT   //modified by aettie.ji 2012.11.28 for uxlaunch update
                font.family: MPC.const_APP_MUSIC_PLAYER_FONT_FAMILY_NEW_HDB
                color: MPC.const_APP_MUSIC_PLAYER_COLOR_TEXT_BRIGHT_GREY
            }

        }
   }
   //} added by jaehwan

   ListView
   {
      id: listView
      width: parent.width
      //{changed by junam 2013.06.01 for adding exception iPod song
      // { modify by EUNHYE 2012.07.09 for CR11224
      //height: countryvariant ? ( (countryvariant == 4) ? (listModelMed.count * ( item_height_top_part + item_height_bottom_part)) :
      //listModelEng.count * ( item_height_top_part + item_height_bottom_part )) :
      //                                          listModelKor.count * ( item_height_top_part + item_height_bottom_part )
      // } modify by EUNHYE 2012.07.09 for CR11224
      height: model.count *  ( item_height_top_part + item_height_bottom_part )
      //}changed by junam
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.topMargin: root.list_view_top_margin
      clip: true;
      boundsBehavior: Flickable.StopAtBounds
      //{changed by junam 2013.08.20 for quick bar
      //model: getCountryVariantSortModel();
      model: getListModel();
      //}changed by junam
      delegate: itemDelegate
   }

   Connections
      {
          target:EngineListenerMain
          onRetranslateUi:
          {
              // { added by cychoi 2015.12.04 for ITS 270606
              EngineListenerMain.qmlLog( "EngineListenerMain onRetranslateUi aLanguageId = " + aLanguageId )
              if(aLanguageId == MPC.const_LANG_KOR || aLanguageId == MPC.const_LANG_CHN || aLanguageId == MPC.const_LANG_ARB)
              {
                 root.item_top_margin = MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ICON_INDEX_TOP_MARGIN_A
              }
              else
              {
                 root.item_top_margin = MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ICON_INDEX_TOP_MARGIN_B
              }
              // } added by cychoi 2015.12.04
              listView.model=getListModel();
              hiddenListView.model=getHiddenListModel();
          }
      }


   //{ added by jaehwan 2013.10.25 for ISV 90617
   ListView
   {
      id: hiddenListView
      width: parent.width
      height: root.listTextInner.count *  ( root.item_height_top_part + root.item_height_bottom_part )
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.topMargin: root.list_view_top_margin
      clip: true;
      boundsBehavior: Flickable.StopAtBounds
      model: getHiddenListModel();
      delegate: hiddenItemDelegate
   }
   //} added by jaehwan

   // { added by cychoi 2015.12.04 for ITS 270606
   Component.onCompleted:
   {
      var aLanguageId = AudioListViewModel.GetLanguage()
      EngineListenerMain.qmlLog( "EngineListenerMain onCompleted aLanguageId = " + aLanguageId )
      if(aLanguageId == MPC.const_LANG_KOR || aLanguageId == MPC.const_LANG_CHN || aLanguageId == MPC.const_LANG_ARB)
      {
         root.item_top_margin = MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ICON_INDEX_TOP_MARGIN_A
      }
      else
      {
         root.item_top_margin = MPC.const_APP_MUSIC_PLAYER_ALPHABETIC_IPOD_ICON_INDEX_TOP_MARGIN_B
      }
   }
   // } added by cychoi 2015.12.04
}

