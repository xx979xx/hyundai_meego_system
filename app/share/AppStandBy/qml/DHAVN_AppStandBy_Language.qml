import Qt 4.7
import com.settings.variables 1.0
import "SimpleItems"
import StandByAppConstants 1.0
import AppEngineQMLConstants 1.0
import QmlSimpleItems 1.0
import QmlPopUpPlugin 1.0 as POPUPWIDGET
import PopUpConstants 1.0
import "DHAVN_AppStandBy_General.js" as General
import "DHAVN_AppStandBy_Images.js" as Images


FocusScope {
    id : idLang
    x: 0; y:93
    width : 1280; height : 720
    focus : true
    anchors.fill: parent

    property int cv: UIListener.GetCountryVariantFromQML()
    property int langID: EngineListener.GetLanguageID()
    property int vehicleVariant: EngineListener.CheckVehicleStatus()        // 0x00: DH,  0x01: KH,  0x02: VI
    property int evvVariant: EngineListener.CheckEvvStatus()            //  0. DH       1. 15MY     2. PE
    property int focus_Index: 0//-1
    property int current_Index: 0
    property int jog_focus: 1 //0 // 0: left,  1: right,  2:title mode -> 0. left 삭제
    property int jog_tmpFocus: 0
    property bool jog_pressed: false
    property bool focusVisible: true
property bool upLongPressed: false
property bool downLongPressed: false
property int currentTopIndex: 0
property int changeLangId: -1
property bool backBtnExit: false
property bool backBtnPress: false


    function getLang()
    {
        langID = EngineListener.GetLanguageID()
    }

    function setRadiolistIndex( )
    {
        switch ( vehicleVariant )
        {
            case 1:
            {
                switch( cv )
                    {
                case 0:
                    changeLangId = listKoreadId.get(current_Index).list_id
                    break;
                case 2:
                    changeLangId = listChinaId.get(current_Index).list_id
                    break;
                case 3:
                    changeLangId = listGeneralId.get(current_Index).list_id
                    break;
                case 4:
                    changeLangId = listMiddleEastId.get(current_Index).list_id
                    break;
                case 5:
                    changeLangId = listEuropaId_KH.get(current_Index).list_id
                    break;
                case 6:
                    changeLangId = listCanadaId.get(current_Index).list_id
                    break;
                case 7:
                    changeLangId = listRussiaId_KH.get(current_Index).list_id
                    break;
                case 1:
                default:
                    changeLangId = listNorthAmericaId.get(current_Index).list_id
                    break;
                }
            }
            break;
            case 0:
            default:
            {
                if ( evvVariant == 2 )      // DHPE
                {

                    switch( cv )
                        {
                    case 0:
                        changeLangId = listKoreadId.get(current_Index).list_id
                        break;
                    case 2:
                        changeLangId = listChinaId.get(current_Index).list_id
                        break;
                    case 3:
                        changeLangId = listGeneralId.get(current_Index).list_id
                        break;
                    case 4:
                        changeLangId = listMiddleEastId.get(current_Index).list_id
                        break;
                    case 5:
                        changeLangId = listEuropaId_DHPE.get(current_Index).list_id
                        break;
                    case 6:
                        changeLangId = listCanadaId.get(current_Index).list_id
                        break;
                    case 7:
                        changeLangId = listRussiaId_DHPE.get(current_Index).list_id
                        break;
                    case 1:
                    default:
                        changeLangId = listNorthAmericaId.get(current_Index).list_id
                        break;
                    }

                }
                else {

                    switch( cv )
                        {
                    case 0:
                        changeLangId = listKoreadId.get(current_Index).list_id
                        break;
                    case 2:
                        changeLangId = listChinaId.get(current_Index).list_id
                        break;
                    case 3:
                        changeLangId = listGeneralId.get(current_Index).list_id
                        break;
                    case 4:
                        changeLangId = listMiddleEastId.get(current_Index).list_id
                        break;
                    case 5:
                        changeLangId = listEuropaId.get(current_Index).list_id
                        break;
                    case 6:
                        changeLangId = listCanadaId.get(current_Index).list_id
                        break;
                    case 7:
                        changeLangId = listRussiaId.get(current_Index).list_id
                        break;
                    case 1:
                    default:
                        changeLangId = listNorthAmericaId.get(current_Index).list_id
                        break;
                    }

                }
            }
        }
        if ( changeLangId != langID ) {
            langID = changeLangId
            EngineListener.ChangeLanguage( langID );
            setRadiolistCurrentindex()
            EngineListener.showToastPopup( true );
        }
    }

    function showToastPopup()
    {
        toast_popup.visible = true
        focusVisible = false
        toast_disappear_timer.restart()
    }

    function setRadiolistCurrentindex()
    {
        switch(cv)
        {
          case -1://eCVKorea
          case 0://eCVKorea
          {
              switch ( langID )
              {
                  case Settings.SETTINGS_LANGUAGE_KO:
                  current_Index = 0;
                  break
                  case Settings.SETTINGS_LANGUAGE_EN:
                  case Settings.SETTINGS_LANGUAGE_EN_US:
                  current_Index = 1;
                  break
              }
              break
          }
          case 1://eCVNorthAmerica
          case 6://eCVCanada
          {
              switch ( langID )
              {
                  case Settings.SETTINGS_LANGUAGE_EN:
                  case Settings.SETTINGS_LANGUAGE_EN_US:
                  current_Index = 0
                  break
                  case Settings.SETTINGS_LANGUAGE_ES_NA:
                  current_Index = 1
                  break
                  case Settings.SETTINGS_LANGUAGE_FR_NA:
                  current_Index = 2
                  break
                  case Settings.SETTINGS_LANGUAGE_KO:
                  current_Index = 3
                  break
              }
              break;
          }
          case 2://eCVChina
          {
              switch ( langID )
              {
                  case Settings.SETTINGS_LANGUAGE_ZH_MA:
                  current_Index = 0
                  break
                  case Settings.SETTINGS_LANGUAGE_EN_UK:
                  current_Index =1
                  break
                  case Settings.SETTINGS_LANGUAGE_KO:
                  current_Index = 2
                  break
              }
              break;
          }
          case 3://eCVGeneral
          {
              switch ( langID )
              {
                  case Settings.SETTINGS_LANGUAGE_EN_UK:
                  current_Index = 0
                  break
                  case Settings.SETTINGS_LANGUAGE_KO:
                  current_Index = 1
                  break
              }
              break
          }
          case 4://eCVMiddleEast
          {
              switch ( langID )
              {
                  case Settings.SETTINGS_LANGUAGE_AR:
                  current_Index = 0;
                  break
                  case Settings.SETTINGS_LANGUAGE_EN_UK:
                  current_Index = 1
                  break
                  case Settings.SETTINGS_LANGUAGE_FR:
                  current_Index = 2;
                  break
                  case Settings.SETTINGS_LANGUAGE_KO:
                  current_Index =  3
                  break
              }
              break
          }
          case 5://eCVEuropa
          {
              if ( listRowView.model == listEuropaId ) {
                  switch ( langID )
                  {
                      case Settings.SETTINGS_LANGUAGE_EN_UK:
                      current_Index = 0
                      break
                      case Settings.SETTINGS_LANGUAGE_FR:
                      current_Index = 1;
                      break
                      case Settings.SETTINGS_LANGUAGE_ES:
                      current_Index = 2
                      break
                      case Settings.SETTINGS_LANGUAGE_RU:
                      current_Index = 3
                      break
                      case Settings.SETTINGS_LANGUAGE_PT:
                      current_Index = 4
                      break
                      case Settings.SETTINGS_LANGUAGE_DE:
                      current_Index = 5
                      break
                      case Settings.SETTINGS_LANGUAGE_PL:
                      current_Index = 6
                      break
                      case Settings.SETTINGS_LANGUAGE_IT:
                      current_Index = 7
                      break
                      case Settings.SETTINGS_LANGUAGE_NL:
                      current_Index = 8
                      break
                      case Settings.SETTINGS_LANGUAGE_SV:
                      current_Index = 9
                      break
                      case Settings.SETTINGS_LANGUAGE_TR:
                      current_Index = 10
                      break
                      case Settings.SETTINGS_LANGUAGE_CS:
                      current_Index = 11
                      break
                      case Settings.SETTINGS_LANGUAGE_DA:
                      current_Index = 12
                      break
                      case Settings.SETTINGS_LANGUAGE_SK:
                      current_Index = 13
                      break
                      case Settings.SETTINGS_LANGUAGE_KO:
                      current_Index = 14
                      break
                  }
              }
              else if (  listRowView.model == listEuropaId_DHPE  ){
                  switch ( langID )
                  {
                      case Settings.SETTINGS_LANGUAGE_EN_UK:
                      current_Index = 0
                      break
                      case Settings.SETTINGS_LANGUAGE_CS:
                      current_Index = 1;
                      break
                      case Settings.SETTINGS_LANGUAGE_DA:
                      current_Index = 2
                      break
                      case Settings.SETTINGS_LANGUAGE_DE:
                      current_Index = 3
                      break
                      case Settings.SETTINGS_LANGUAGE_ES:
                      current_Index = 4
                      break
                      case Settings.SETTINGS_LANGUAGE_FR:
                      current_Index = 5
                      break
                      case Settings.SETTINGS_LANGUAGE_IT:
                      current_Index = 6
                      break
                      case Settings.SETTINGS_LANGUAGE_NL:
                      current_Index = 7
                      break
                      case Settings.SETTINGS_LANGUAGE_PL:
                      current_Index = 8
                      break
                      case Settings.SETTINGS_LANGUAGE_PT:
                      current_Index = 9
                      break
                      case Settings.SETTINGS_LANGUAGE_RU:
                      current_Index = 10
                      break
                      case Settings.SETTINGS_LANGUAGE_SK:
                      current_Index = 11
                      break
                      case Settings.SETTINGS_LANGUAGE_SV:
                      current_Index = 12
                      break
                      case Settings.SETTINGS_LANGUAGE_TR:
                      current_Index = 13
                      break
                      case Settings.SETTINGS_LANGUAGE_KO:
                      current_Index = 14
                      break
                  }
              }
              else {
                  switch ( langID )
                  {
                      case Settings.SETTINGS_LANGUAGE_EN_UK:
                      current_Index = 0
                      break
                      case Settings.SETTINGS_LANGUAGE_KO:
                      current_Index = 1
                      break
                  }
              }
          }
          break;
          case 7://Russia
          {
              if ( listRowView.model == listRussiaId_KH ) {
                  switch ( langID )
                  {
                      case Settings.SETTINGS_LANGUAGE_RU:
                      current_Index = 0
                      break
                      case Settings.SETTINGS_LANGUAGE_EN_UK:
                      current_Index = 1
                      break
                      case Settings.SETTINGS_LANGUAGE_KO:
                      current_Index = 2
                      break
                  }
              }

              else if ( listRowView.model == listRussiaId ) {
                  switch ( langID )
                  {
                      case Settings.SETTINGS_LANGUAGE_RU:
                      current_Index = 0
                      break
                      case Settings.SETTINGS_LANGUAGE_EN_UK:
                      current_Index = 1
                      break
                      case Settings.SETTINGS_LANGUAGE_FR:
                      current_Index = 2
                      break
                      case Settings.SETTINGS_LANGUAGE_ES:
                      current_Index = 3
                      break
                      case Settings.SETTINGS_LANGUAGE_PT:
                      current_Index = 4
                      break
                      case Settings.SETTINGS_LANGUAGE_DE:
                      current_Index = 5
                      break
                      case Settings.SETTINGS_LANGUAGE_PL:
                      current_Index = 6
                      break
                      case Settings.SETTINGS_LANGUAGE_IT:
                      current_Index = 7
                      break
                      case Settings.SETTINGS_LANGUAGE_NL:
                      current_Index = 8
                      break
                      case Settings.SETTINGS_LANGUAGE_SV:
                      current_Index = 9
                      break
                      case Settings.SETTINGS_LANGUAGE_TR:
                      current_Index = 10
                      break
                      case Settings.SETTINGS_LANGUAGE_CS:
                      current_Index = 11
                      break
                      case Settings.SETTINGS_LANGUAGE_DA:
                      current_Index = 12
                      break
                      case Settings.SETTINGS_LANGUAGE_SK:
                      current_Index = 13
                      break
                      case Settings.SETTINGS_LANGUAGE_KO:
                      current_Index = 14
                      break
                  }
              }

              else {
                  switch ( langID )
                  {
                      case Settings.SETTINGS_LANGUAGE_RU:
                      current_Index = 0
                      break
                      case Settings.SETTINGS_LANGUAGE_CS:
                      current_Index = 1
                      break
                      case Settings.SETTINGS_LANGUAGE_DA:
                      current_Index = 2
                      break
                      case Settings.SETTINGS_LANGUAGE_DE:
                      current_Index = 3
                      break
                      case Settings.SETTINGS_LANGUAGE_EN_UK:
                      current_Index = 4
                      break
                      case Settings.SETTINGS_LANGUAGE_ES:
                      current_Index = 5
                      break
                      case Settings.SETTINGS_LANGUAGE_FR:
                      current_Index = 6
                      break
                      case Settings.SETTINGS_LANGUAGE_IT:
                      current_Index = 7
                      break
                      case Settings.SETTINGS_LANGUAGE_NL:
                      current_Index = 8
                      break
                      case Settings.SETTINGS_LANGUAGE_PL:
                      current_Index = 9
                      break
                      case Settings.SETTINGS_LANGUAGE_PT:
                      current_Index = 10
                      break
                      case Settings.SETTINGS_LANGUAGE_SK:
                      current_Index = 11
                      break
                      case Settings.SETTINGS_LANGUAGE_SV:
                      current_Index = 12
                      break
                      case Settings.SETTINGS_LANGUAGE_TR:
                      current_Index = 13
                      break
                      case Settings.SETTINGS_LANGUAGE_KO:
                      current_Index = 14
                      break
                  }
              }
              break
          }
        }
    }


    function setVisualCue( ) //  left , press ) // state )
    {
        topCue.source = Images.const_AppUserManual_Cue_U_N
        bottomCue.source = Images.const_AppUserManual_Cue_D_D
    }

    function updownSetVisualCue( up , pressed , focusChange )
    {
        switch ( up )
        {
            case true:
            {
                if ( pressed )
                {
                    visualCue.y = General.const_AppUserManual_Cue_Y - 3
                    topCue.source = Images.const_AppUserManual_Cue_U_S
                    if ( focusChange ) {
                        bottomCue.source = Images.const_AppUserManual_Cue_D_N
                    }
                }
                else
                {
                    visualCue.y = General.const_AppUserManual_Cue_Y
                    if ( focusChange ) {
                        topCue.source = Images.const_AppUserManual_Cue_U_D
                        bottomCue.source = Images.const_AppUserManual_Cue_D_N
                    }
                    else {
                        topCue.source = Images.const_AppUserManual_Cue_U_N
                    }
                }
            }
            break;
            case false:
            {
                if ( pressed )
                {
                    visualCue.y = General.const_AppUserManual_Cue_Y + 3
                    bottomCue.source = Images.const_AppUserManual_Cue_D_S
                    topCue.source = Images.const_AppUserManual_Cue_U_N
                }
                else
                {
                    visualCue.y = General.const_AppUserManual_Cue_Y
                    topCue.source = Images.const_AppUserManual_Cue_U_N
                    bottomCue.source = Images.const_AppUserManual_Cue_D_D
                }
            }
            break;
        }
    }

    function listAccelerate( event )
    {
        switch ( event )
        {
            case UIListenerEnum.JOG_WHEEL_LEFT:
            {
                if( focus_Index == 0 )
                {
                    return;
                }
                upLongPressed = true
                listRowView.currentIndex = --focus_Index;
            }
            break
            case UIListenerEnum.JOG_WHEEL_RIGHT:
            {
                updownSetVisualCue( false , true, true )
                if( focus_Index == (listRowView.count - 1) )
                return;
                listRowView.currentIndex = ++focus_Index;
            }
            break
        }
        positionViewAtPageUpDown();
        positionViewAtIndex(currentIndex, ListView.Contain)
    }

    function setCurrentTopIndex()
    {
        if( listRowView.indexAt(0, listRowView.contentY) == -1 )
        {
            if(listRowView.atYBeginning)
                currentTopIndex = 0

            if(listRowView.atYEnd)
            {
                if( listRowView.count > 6 && listRowview.count < 12 )
                    currentTopIndex = 6
                else
                    currentTopIndex = listRowView.count-6
            }
        }
        else
            currentTopIndex = listRowView.indexAt(0, listRowView.contentY)
    }

    function positionViewAtPageUpDown()
    {
        if ( focus_Index < currentTopIndex ) {
            if ( focus_Index > 5 )
                currentTopIndex = focus_Index - 5
            else
                currentTopIndex = 0
        }
        else {
            if ( focus_Index > currentTopIndex + 5 ) {
                if ( focus_Index +  5 >= listRowView.count )
                    currentTopIndex = listRowView.count - 6
                else
                    currentTopIndex = focus_Index
            }
        }
        listRowView.positionViewAtIndex( currentTopIndex, ListView.Beginning)
        return;

        if (focus_Index < 6 )
        {
            if(focus_Index >= currentTopIndex && focus_Index < currentTopIndex+6)
                return
            else
                listRowView.positionViewAtIndex(0, ListView.Beginning)
        }
        else if(focus_Index > 5 && focus_Index < 12)
        {
            if(focus_Index >= currentTopIndex && focus_Index < currentTopIndex+6)
                return
            else
                listRowView.positionViewAtIndex( 6 , ListView.Beginning)
        }
        else
        {
            if(focus_Index >= currentTopIndex && focus_Index < currentTopIndex+6)
                return
            else
                listRowView.positionViewAtIndex(listRowView.count-6, ListView.Beginning)
        }
    }

    Timer {
        id: down_long_press_timer

        repeat: true
        interval: 100

        onTriggered: listAccelerate(UIListenerEnum.JOG_WHEEL_RIGHT )
    }

    Timer {
        id: up_long_press_timer

        repeat: true
        interval: 100

        onTriggered: listAccelerate(UIListenerEnum.JOG_WHEEL_LEFT )
    }

    Image
    {
        id: imgBg
        anchors.fill: parent
       source: Images.BACKGROUND_IMAGE
       Item {
           id: titleMode

           Image {
               id: img_title
               x:0; y:93
               source: Images.BG_TITLE
           }

           Image {
               id: img_btnBack
               x: ( langID == 20 )  ? 3 : 860 + 138 + 138//890 + 121 + 121 + 3 ;
               y: 92
               width: sourceSize.width; height: sourceSize.height
               source: ( langID == 20 )  ?  ( jog_focus == 2 ) ? Images.BTN_BACK_ARAB_F : Images.BTN_BACK_ARAB_N :    ( jog_focus == 2 ) ? Images.BTN_BACK_F : Images.BTN_BACK_N  //  EngineListener.GetStrConst(CONST.BTN_BACK_ARAB_N) :  EngineListener.GetStrConst(CONST.BTN_BACK_N)
           }
           MouseArea {
               id: backMA
               anchors.fill: img_btnBack
               onPressed: {
                   backBtnPress = true
                   backBtnExit = false
               }
               onReleased: {
                   if ( backBtnPress && !backBtnExit )  {
                       jog_focus = 2
                       EngineListener.HandleBackLanguage()
                   }
                   backBtnPress = false
               }
               onExited: {
                   backBtnExit = true
               }
           }
           Image {
               id: img_btnBackFocus
               x: ( langID == 20 )  ? 3 : 860 + 138 + 138//890 + 121 + 121 + 3 ;
               y: 92
               source: langID == 20 ?  Images.BTN_BACK_ARAB_P  :  Images.BTN_BACK_P //EngineListener.GetStrConst(CONST.BTN_BACK_ARAB_F) :  EngineListener.GetStrConst(CONST.BTN_BACK_F)
               visible:  ( backBtnPress && !backBtnExit ) || ( jog_focus == 2 && jog_pressed ) //  img_focus_title
           }
       }


       Item {
           id: listMode
           x: 0; y:0;
           Image {
               id: img_line_menu_list
               x: ( langID == 20 )  ? 744 : 43; y: 261
               source: Images.LINE_MENU_LIST
           }
           Image {
               id: img_focus_menu_list
               x: ( langID == 20 )  ? 744-35 : 34; y: 166 + 5;
               source: jog_pressed ?  Images.MENU_TAB_L_P :  Images.MENU_TAB_L_F
               visible: jog_focus == 0 //  focus_left
           }
           Image {
               id: img_menu_l
               x: ( langID == 20 )  ? 618 : 0; y: 166 -3;// z: 1
               source: ( langID == 20 )  ? Images.MENU_L_ARAB_S : Images.MENU_L_S
               visible: ( jog_focus == 0 || ( jog_focus == 2 && jog_tmpFocus == 0 )) ? true : false
           }
           Text {
               id: txt_left_list
               x: ( langID == 20 )  ? 744 : 43+14; y: 196 - 12
               width: 479 - 14
               height: 90//720 - 166
               color:  vehicleVariant == 1 ? General.const_COLOR_TEXT_SELECT_RED : General.const_COLOR_TEXT_SELECT_BLUE
               font.pixelSize: General.const_APP_SETTINGS_FONT_SIZE_TEXT_40PT
               font.family: General.FONT_BOLD
               wrapMode: Text.WordWrap; textFormat: Text.RichText
               horizontalAlignment: ( langID == 20 ) ? Text.AlignRight : Text.AlignLeft
               text:  qsTranslate( "main", "STR_SETTING_GENERAL_LAN" ) + EngineListener.empty
           }
            Image
            {
                id: img_menu_r
                source: langID == 20 ? Images.MENU_R_ARAB :  Images.MENU_R
                x: 0; y: 163
            }
            Image {
                id: img_menu_r_s
                x: ( langID == 20 )  ? 0 : 585; y: 166 -3;// z: 1000
                source: ( langID == 20 )  ? Images.MENU_R_ARAB_S : Images.MENU_R_S
                visible: ( jog_focus == 1 || ( jog_focus == 2 && jog_tmpFocus == 1 )) ? true : false
            }
           Row {
               x: ( langID == 20 )  ? 0 : 708 - 9; y: 170 // + 3
               width:  ( langID == 20 )  ? 618 : 1280 - 708 //473;
               height: 530

               ListModel {
                    id: listKoreadId

                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_KOR"
                        list_id: Settings.SETTINGS_LANGUAGE_KO
                        bDis: false
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_ENG"
                        list_id: Settings.SETTINGS_LANGUAGE_EN_US
                        bDis: false
                    }
                }

               ListModel {
                    id: listNorthAmericaId

                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_ENG"
                        list_id: Settings.SETTINGS_LANGUAGE_EN_US
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_SPANISH"
                        list_id: Settings.SETTINGS_LANGUAGE_ES_NA
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_FRENCH"
                        list_id: Settings.SETTINGS_LANGUAGE_FR_NA
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_KOR"
                        list_id: Settings.SETTINGS_LANGUAGE_KO
                    }
                }

               ListModel {
                    id: listChinaId

                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_CHINESE"
                        list_id: Settings.SETTINGS_LANGUAGE_ZH_MA
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_ENG"
                        list_id: Settings.SETTINGS_LANGUAGE_EN_UK
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_KOR"
                        list_id: Settings.SETTINGS_LANGUAGE_KO
                    }
                }

               ListModel {
                    id: listGeneralId

                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_ENG"
                        list_id: Settings.SETTINGS_LANGUAGE_EN_UK
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_KOR"
                        list_id: Settings.SETTINGS_LANGUAGE_KO
                    }
                }

               ListModel {
                    id: listMiddleEastId

                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_ARABIC"
                        list_id: Settings.SETTINGS_LANGUAGE_AR
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_ENG"
                        list_id: Settings.SETTINGS_LANGUAGE_EN_UK
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_FRENCH"
                        list_id: Settings.SETTINGS_LANGUAGE_FR
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_KOR"
                        list_id: Settings.SETTINGS_LANGUAGE_KO
                    }
                }

               ListModel {
                    id: listEuropaId

                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_ENGLISH_UK"
                        list_id: Settings.SETTINGS_LANGUAGE_EN_UK
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_FRENCH"
                        list_id: Settings.SETTINGS_LANGUAGE_FR
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_SPANISH"
                        list_id: Settings.SETTINGS_LANGUAGE_ES
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_RUSSIAN"
                        list_id: Settings.SETTINGS_LANGUAGE_RU
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_PORTUGUESE_EUR"
                        list_id: Settings.SETTINGS_LANGUAGE_PT
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_GERMAN"
                        list_id: Settings.SETTINGS_LANGUAGE_DE
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_POLISH"
                        list_id: Settings.SETTINGS_LANGUAGE_PL
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_ITALIAN"
                        list_id: Settings.SETTINGS_LANGUAGE_IT
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_DUTCH"
                        list_id: Settings.SETTINGS_LANGUAGE_NL
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_SWEDISH"
                        list_id: Settings.SETTINGS_LANGUAGE_SV
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_TURKISH"
                        list_id: Settings.SETTINGS_LANGUAGE_TR
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_CZECH"
                        list_id: Settings.SETTINGS_LANGUAGE_CS
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_DANISH"
                        list_id: Settings.SETTINGS_LANGUAGE_DA
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_SLOVALIA"
                        list_id: Settings.SETTINGS_LANGUAGE_SK
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_KOR"
                        list_id: Settings.SETTINGS_LANGUAGE_KO
                    }
                }

               ListModel {
                    id: listEuropaId_DHPE

                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_ENGLISH_UK"
                        list_id: Settings.SETTINGS_LANGUAGE_EN_UK
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_CZECH"
                        list_id: Settings.SETTINGS_LANGUAGE_CS
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_DANISH"
                        list_id: Settings.SETTINGS_LANGUAGE_DA
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_GERMAN"
                        list_id: Settings.SETTINGS_LANGUAGE_DE
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_SPANISH"
                        list_id: Settings.SETTINGS_LANGUAGE_ES
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_FRENCH"
                        list_id: Settings.SETTINGS_LANGUAGE_FR
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_ITALIAN"
                        list_id: Settings.SETTINGS_LANGUAGE_IT
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_DUTCH"
                        list_id: Settings.SETTINGS_LANGUAGE_NL
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_POLISH"
                        list_id: Settings.SETTINGS_LANGUAGE_PL
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_PORTUGUESE_EUR"
                        list_id: Settings.SETTINGS_LANGUAGE_PT
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_RUSSIAN"
                        list_id: Settings.SETTINGS_LANGUAGE_RU
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_SLOVALIA"
                        list_id: Settings.SETTINGS_LANGUAGE_SK
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_SWEDISH"
                        list_id: Settings.SETTINGS_LANGUAGE_SV
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_TURKISH"
                        list_id: Settings.SETTINGS_LANGUAGE_TR
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_KOR"
                        list_id: Settings.SETTINGS_LANGUAGE_KO
                    }
                }

                ListModel {
                     id: listEuropaId_KH

                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_ENGLISH_UK"
                         list_id: Settings.SETTINGS_LANGUAGE_EN_UK
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_KOR"
                         list_id: Settings.SETTINGS_LANGUAGE_KO
                     }
                 }
                ListModel {
                     id: listRussiaId

                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_RUSSIAN"
                         list_id: Settings.SETTINGS_LANGUAGE_RU
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_ENGLISH_UK"
                         list_id: Settings.SETTINGS_LANGUAGE_EN_UK
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_FRENCH"
                         list_id: Settings.SETTINGS_LANGUAGE_FR
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_SPANISH"
                         list_id: Settings.SETTINGS_LANGUAGE_ES
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_PORTUGUESE_EUR"
                         list_id: Settings.SETTINGS_LANGUAGE_PT
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_GERMAN"
                         list_id: Settings.SETTINGS_LANGUAGE_DE
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_POLISH"
                         list_id: Settings.SETTINGS_LANGUAGE_PL
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_ITALIAN"
                         list_id: Settings.SETTINGS_LANGUAGE_IT
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_DUTCH"
                         list_id: Settings.SETTINGS_LANGUAGE_NL
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_SWEDISH"
                         list_id: Settings.SETTINGS_LANGUAGE_SV
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_TURKISH"
                         list_id: Settings.SETTINGS_LANGUAGE_TR
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_CZECH"
                         list_id: Settings.SETTINGS_LANGUAGE_CS
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_DANISH"
                         list_id: Settings.SETTINGS_LANGUAGE_DA
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_SLOVALIA"
                         list_id: Settings.SETTINGS_LANGUAGE_SK
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_KOR"
                         list_id: Settings.SETTINGS_LANGUAGE_KO
                     }
                 }

                ListModel {
                     id: listRussiaId_DHPE

                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_RUSSIAN"
                         list_id: Settings.SETTINGS_LANGUAGE_RU
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_CZECH"
                         list_id: Settings.SETTINGS_LANGUAGE_CS
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_DANISH"
                         list_id: Settings.SETTINGS_LANGUAGE_DA
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_GERMAN"
                         list_id: Settings.SETTINGS_LANGUAGE_DE
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_ENGLISH_UK"
                         list_id: Settings.SETTINGS_LANGUAGE_EN_UK
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_SPANISH"
                         list_id: Settings.SETTINGS_LANGUAGE_ES
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_FRENCH"
                         list_id: Settings.SETTINGS_LANGUAGE_FR
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_ITALIAN"
                         list_id: Settings.SETTINGS_LANGUAGE_IT
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_DUTCH"
                         list_id: Settings.SETTINGS_LANGUAGE_NL
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_POLISH"
                         list_id: Settings.SETTINGS_LANGUAGE_PL
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_PORTUGUESE_EUR"
                         list_id: Settings.SETTINGS_LANGUAGE_PT
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_SLOVALIA"
                         list_id: Settings.SETTINGS_LANGUAGE_SK
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_SWEDISH"
                         list_id: Settings.SETTINGS_LANGUAGE_SV
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_TURKISH"
                         list_id: Settings.SETTINGS_LANGUAGE_TR
                     }
                     ListElement {
                         name: "STR_SETTING_GENERAL_LAN_KOR"
                         list_id: Settings.SETTINGS_LANGUAGE_KO
                     }
                 }

                ListModel {
                      id: listRussiaId_KH

                      ListElement {
                          name: "STR_SETTING_GENERAL_LAN_RUSSIAN"
                          list_id: Settings.SETTINGS_LANGUAGE_RU
                      }
                      ListElement {
                          name: "STR_SETTING_GENERAL_LAN_ENGLISH_UK"
                          list_id: Settings.SETTINGS_LANGUAGE_EN_UK
                      }
                      ListElement {
                          name: "STR_SETTING_GENERAL_LAN_KOR"
                          list_id: Settings.SETTINGS_LANGUAGE_KO
                      }
                  }
               ListModel {
                    id: listCanadaId
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_ENG"
                        list_id: Settings.SETTINGS_LANGUAGE_EN_US
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_SPANISH"
                        list_id: Settings.SETTINGS_LANGUAGE_ES_NA
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_FRENCH"
                        list_id: Settings.SETTINGS_LANGUAGE_FR_NA
                    }
                    ListElement {
                        name: "STR_SETTING_GENERAL_LAN_KOR"
                        list_id: Settings.SETTINGS_LANGUAGE_KO
                    }
                }

               Component {
                   id: listDelegate
                   Rectangle {
                       id: idItem
                       width: 530
                       height: 89
                       color: "transparent"
                       anchors.left:  parent.left
                       anchors.leftMargin: ( langID == 20 )  ?  43 : 0
                       Image
                       {
                           id: focusImage
                           anchors.left: parent.left
                           anchors.leftMargin:  ( langID == 20 ) ? -9 : 10
                           anchors.top: line_id.top
                           anchors.topMargin: -90
                           width: 530
                           source:  ( jog_pressed ) ? Images.MENU_TAB_L_P : Images.MENU_TAB_L_F
                           visible: ( focus_Index == index )  && ( jog_focus == 1 ) && focusVisible
                       }
                       Image
                       {
                           id: pressImage
                           anchors.left: parent.left
                           anchors.leftMargin: ( langID == 20 )  ? -9 : 10
                           anchors.top: line_id.top
                           anchors.topMargin: -89
                           width: 530
                           source:  Images.MENU_TAB_L_P
                           visible: mouseList.pressed
                       }

                     Text {
                         id: txt_right_list; text:  qsTranslate( "main", name)  + EngineListener.empty
                         anchors.left: parent.left
                         anchors.leftMargin:  ( langID == 20 ) ? 9 : 40
                         anchors.verticalCenter: parent.verticalCenter
                         width: 479
                       font.pixelSize: General.const_APP_SETTINGS_FONT_SIZE_TEXT_40PT
                       color: vehicleVariant == 1 ? focusImage.visible ? General.const_COLOR_TEXT_BRIGHT_GREY : General.const_COLOR_TEXT_COMMON_GREY
                                : General.const_COLOR_TEXT_BRIGHT_GREY
                       font.family: General.FONT_REGULAR
                       wrapMode: Text.WordWrap; textFormat: Text.RichText
                       horizontalAlignment:  ( langID == 20 ) ? Text.AlignRight : Text.AlignLeft
                     }

                     Image {
                         anchors.left: parent.left; anchors.leftMargin:  ( langID == 20 ) ? 75-43 : 449+14;
                         anchors.top: parent.top; anchors.topMargin: 20
                         source: Images.RADIO_N
                     }
                     Image {
                         anchors.left: parent.left; anchors.leftMargin:   ( langID == 20 ) ? 75-43 : 449+14;
                         anchors.top: parent.top; anchors.topMargin: 20
                         source: Images.RADIO_S
                         visible: current_Index == index
                     }

                       Image {
                           id: line_id
                           y: 89
                           source: Images.LINE_MENU_LIST
                       }

                       MouseArea {
                           id: mouseList
                           anchors.fill: parent
                           onReleased: {
                               current_Index = index;
                               focus_Index = index
                               setCurrentTopIndex()
                               jog_focus = 1
                               changeLangId = list_id;
                               setVisualCue( true , false )
                               if ( changeLangId != langID ) {
                                   langID = changeLangId
                                   EngineListener.ChangeLanguage( langID );
                                   setRadiolistCurrentindex()
                                   EngineListener.showToastPopup( true );
                               }
                           }
                       } // Mouse Area
                   }    // Item
               } // Component

               ListView {
                   id: listRowView
                   x:  ( langID == 20 ) ? 0 : 708; y: 180
                   width: 630
                   height: 534-170
                   anchors.fill: parent
                   model: vehicleVariant == 1 ?
                              ( cv  == 1) ? listNorthAmericaId
                                       : ( cv == 2 ) ? listChinaId
                                                     : ( cv == 3) ? listGeneralId
                                                                  : ( cv == 4 ) ? listMiddleEastId
                                                                                : ( cv == 5 ) ? listEuropaId_KH
                                                                                              : ( cv == 6 ) ? listCanadaId
                                                                                                        : ( cv == 7 ) ? listRussiaId_KH
                                                                                                            : listKoreadId
                            : ( cv  == 1) ? listNorthAmericaId
                                 : ( cv == 2 ) ? listChinaId
                                          : ( cv == 3) ? listGeneralId
                                                       : ( cv == 4 ) ? listMiddleEastId
                                                                     : ( cv == 5 ) ? (evvVariant == 2 ) ? listEuropaId_DHPE : listEuropaId
                                                                                   : ( cv == 6 ) ? listCanadaId
                                                                                           : ( cv == 7 ) ? ( evvVariant == 2 ) ?   listRussiaId_DHPE :  listRussiaId
                                                                                                 : listKoreadId
                   focus: true
                   delegate: listDelegate
                   clip: true
                   snapMode: ListView.SnapToItem
                   cacheBuffer: 10000
                   onCurrentIndexChanged: {
                   }
                   onMovementEnded: {
                       currentIndex = indexAt( contentX, contentY )
                       if ( focus_Index - currentIndex  < 6 && focus_Index - currentIndex  >= 0 ) {
                           currentIndex = focus_Index
                       }
                       else {
                           focus_Index = currentIndex
                           positionViewAtIndex( currentIndex, ListView.Beginning)
                       }
                       jog_focus = 1
                       updownSetVisualCue( false , false, true )
                   }
                   Item
                   {
                       x: 540
                       y: 28
                       width: scrollBar.width
                       height: parent.height - 25
                       clip: true
                       visible: ( listRowView.count > 5 ? true : false )

                       VerticalScrollBar
                       {
                           id: scrollBar
                           height: parent.height - 25
                           anchors.left: parent.left
                           position: listRowView.visibleArea.yPosition
                           pageSize: listRowView.visibleArea.heightRatio
                       }
                   }
               }
           }

           Component.onCompleted:
           {
               EngineListener.showToastPopup( false );
               getLang();
               setRadiolistCurrentindex()
               setVisualCue()
               if ( current_Index != 0 )
                   focus_Index = 0
               else
                   focus_Index = current_Index + 1
               jog_focus = 1
               listRowView.positionViewAtIndex(0, ListView.Beginning)
           }
       }
    }

    Timer
    {
       id: toast_disappear_timer
       interval: 3000
       repeat: false
       running: false
       onTriggered:
       {
           EngineListener.showToastPopup( false );
           toast_popup.visible = false
           focusVisible = true
       }
    }

    POPUPWIDGET.PopUpText
    {
        id: toast_popup
        z: 1000
        message: toast_text_model
        icon_title: EPopUp.LOADING_ICON
        visible: false
    }
    ListModel
    {
    id: toast_text_model
    ListElement { msg: QT_TR_NOOP("STR_SETTINGS_CHANGE_LANGUAGE") }
    }

    Item {
        Image
        {
                id: visualCue
                x:  General.const_AppUserManual_Cue_X; y: General.const_AppUserManual_Cue_Y
                z: 10
                smooth: true
                source: Images.const_AppUserManual_Cue

                Image
                {
                        id:rightCue
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: General.const_AppUserManual_Cue_Margin_1
                        smooth: true
                        source: Images.const_AppUserManual_Cue_R_D
                        z: 10
                }

                Image
                {
                        id: leftCue
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: General.const_AppUserManual_Cue_Margin_1
                        smooth: true
                        source: Images.const_AppUserManual_Cue_L_D
                        z: 10
                }

                Image
                {
                        id: topCue
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: General.const_AppUserManual_Cue_Margin_2
                        smooth: true
                        source:  Images.const_AppUserManual_Cue_U_N
                        z: 10
                }

                Image
                {
                        id: bottomCue
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: General.const_AppUserManual_Cue_Margin_2
                        smooth: true
                        source:  Images.const_AppUserManual_Cue_D_D
                        z: 10
                }
        }
    }
    Connections
    {
         target: mergeMain.focusIndex == General.const_APP_STANDBYCLOCK_FOCUSINDEX_STANDBY_LANGUAGE ?  EngineListener : null

         onSignalFg:
         {
             backBtnPress = false
             jog_pressed = false
         }

        onSignalJog:
        {
            if ( idStandByMain.isMainScreen || toast_popup.visible ) return;
            if ( screenId != UIListener.getCurrentScreen() )  return;
            switch ( jog_focus )
            {
                case 1: {
                switch( arrow )
                {
                case UIListenerEnum.JOG_LEFT:
                break;
                case UIListenerEnum.JOG_RIGHT:
                break;
                case  UIListenerEnum.JOG_UP:
                {
                    if( status ==  0 ) { // UIListenerEnum.KEY_STATUS_PRESSED) {
                        updownSetVisualCue( true, true, false )
                    }
                if( status == 2 ) { // UIListenerEnum.KEY_STATUS_LONG_PRESSED) {
                        up_long_press_timer.restart()
                    }
                    else if( status === 1 ) { //  UIListenerEnum.KEY_STATUS_RELEASED ) {
                        up_long_press_timer.stop()
                        if ( upLongPressed ) {
                            upLongPressed = false
                            updownSetVisualCue( true, false, false )
                        }
                        else {
                            updownSetVisualCue( true, false, true)
                            jog_focus = 2;
                            jog_tmpFocus = 1
                        }
                    }
                else if ( status ==  4 ) { // UIListenerEnum.KEY_STATUS_CANCELED ) {
                        up_long_press_timer.stop()
                        upLongPressed = false
                        updownSetVisualCue( true, false, false )
                    }
                }
                break;
                case UIListenerEnum.JOG_DOWN:
                {
                if ( status == 0 ) //  UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        downLongPressed = true
                    }
                    if ( status == 2 ) { // UIListenerEnum.KEY_STATUS_LONG_PRESSED) {
                        if ( downLongPressed ) {
                            down_long_press_timer.restart()
                        }
                    }
                    if ( status == 1 ) // UIListenerEnum.KEY_STATUS_RELEASED)
                    {
                        downLongPressed = false
                        down_long_press_timer.stop()
                        down_long_press_timer.interval = 100
                        updownSetVisualCue( false , false, true )
                    }
                    else if ( status ==  4 ) { //  UIListenerEnum.KEY_STATUS_CANCELED ) {
                        down_long_press_timer.stop()
                        down_long_press_timer.interval = 100
                        downLongPressed = false
                        updownSetVisualCue( false , false, true )
                    }
                }
                break;
                case UIListenerEnum.JOG_CENTER:
                {
                    if( status == 0 ) // UIListenerEnum.KEY_STATUS_PRESSED)
                    {
                        if((focus_Index > -1 ) && (focus_Index < listRowView.count) )
                        {
                            jog_pressed = true
                        }
                    }
                    else if( status == 1 ) { // UIListenerEnum.KEY_STATUS_RELEASED ) {
                        jog_pressed = false
                        current_Index = focus_Index;
                        setRadiolistIndex();
                    }
                    else if ( status ==  4 ) { //  UIListenerEnum.KEY_STATUS_CANCELED ) {
                        jog_pressed = false
                    }
                }
                    break;
                case UIListenerEnum.JOG_WHEEL_LEFT:
                {
                    if ( status == 0 ) // UIListenerEnum.KEY_STATUS_PRESSED )
                    {
                        if ( langID == 20 ) {
                            if ( focus_Index < ( listRowView.count -1 ) )
                            {
                                  listRowView.currentIndex = ++focus_Index;
                            }
                            else {
                                if ( listRowView.count > 6 ) {
                                    focus_Index = 0
                                    listRowView.currentIndex = focus_Index
                                }
                            }
                        }
                        else {
                            if ( focus_Index > 0 ) {
                                listRowView.currentIndex = --focus_Index;
                            }
                            else {
                                if ( listRowView.count > 6 ) {
                                    focus_Index =  listRowView.count-1
                                    listRowView.currentIndex = focus_Index
                                }
                            }
                        }
                        positionViewAtPageUpDown();
                        positionViewAtIndex(currentIndex, ListView.Contain)
                    }
                }
                    break;
                case UIListenerEnum.JOG_WHEEL_RIGHT:
                {
                    if ( status == 0 ) // UIListenerEnum.KEY_STATUS_PRESSED )
                    {
                        if ( langID == 20 ) {
                            if ( focus_Index > 0 ) {
                                listRowView.currentIndex = --focus_Index;
                            }
                            else {
                                if ( listRowView.count > 6 ) {
                                    focus_Index =  listRowView.count-1
                                    listRowView.currentIndex = focus_Index
                                }
                            }
                        }
                        else {
                            if ( focus_Index < ( listRowView.count -1 ) )
                            {
                                  listRowView.currentIndex = ++focus_Index;
                            }
                            else {
                                if ( listRowView.count > 6 ) {
                                    focus_Index = 0
                                    listRowView.currentIndex = focus_Index
                                }
                            }
                        }
                        positionViewAtPageUpDown();
                        positionViewAtIndex(currentIndex, ListView.Contain)
                    }
                }
                    break;
                }
                } break;        // case jog_focus 1

                case 2: {
                    switch( arrow )
                    {
                    case UIListenerEnum.JOG_UP:
                    {
                        if( status == 0 ) { //  UIListenerEnum.KEY_STATUS_PRESSED) {
                            updownSetVisualCue( true , false , true )
                        }
                    }
                    break;
                    case  UIListenerEnum.JOG_DOWN:
                    {
                        if ( status == 0 ) // UIListenerEnum.KEY_STATUS_PRESSED)
                        {
                            jog_focus = 1 // jog_tmpFocus
                            updownSetVisualCue( false , true , true )
                        }
                    }
                    break;
                    case UIListenerEnum.JOG_CENTER:
                    {
                        if( status == 0 ) // UIListenerEnum.KEY_STATUS_PRESSED)
                        {
                            jog_pressed = true
                        }
                        else if( status == 1 ) { // UIListenerEnum.KEY_STATUS_RELEASED ) {
                            jog_pressed = false
                        //if( status === UIListenerEnum.KEY_STATUS_RELEASED )
                            EngineListener.HandleBackLanguage()
                        }
                        else if ( status ==  4 ) { // UIListenerEnum.KEY_STATUS_CANCELED ) {
                            jog_pressed = false
                        }
                    }
                        break;
                    }
                } break;          // case jog_focus 2
            }
        }
         onBackKeyPressed:
         {
             if ( screenId != UIListener.getCurrentScreen() )  return;
             EngineListener.HandleBackLanguage()
         }

         onRetranslateUI: {
             getLang()
             showToastPopup( true );
         }
    }

}
