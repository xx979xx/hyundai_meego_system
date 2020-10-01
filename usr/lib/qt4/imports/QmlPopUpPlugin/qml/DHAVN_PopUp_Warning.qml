import Qt 4.7
import "DHAVN_PopUp_Constants.js" as CONST
import "DHAVN_PopUp_Import.js" as TYPES
import "DHAVN_PopUp_Resources.js" as RES

Item
{
    id: warning
    property string sContentTextTitle: ""
    property string sContentTextProblem: ""
    property string sTitleText: qsTranslate(__lang_context, "Warning!") + __emptyString
    property bool bShowTitleButton: false
    property int nWindowType: TYPES.const_DISPLAY_B

    function retranslateUI( context )
    {
       if (context) { __lang_context = context }
       __emptyString = " "
       __emptyString = ""

       if( titleContent.text.length == 0 )
       {
          problemText.y = CONST.const_FIRST_LINE_MY_ALONG;
       }
       if( problemText.text.length == 0 )
       {
          titleContent.y = CONST.const_FIRST_LINE_MY_ALONG;
       }

    }

    property string __lang_context: CONST.const_LANGCONTEXT
    property string __emptyString: ""

    signal closeWarning()

    height: CONST.const_DISPLAY_HEIGTH
    width: CONST.const_DISPLAY_WIDHT
    Image
    {
        id: background
        source: RES.const_POPUP_TYPE_B
        fillMode: Image.PreserveAspectFit
        height: CONST.const_TYPE_B_HEIGTH
        width: CONST.const_TYPE_B_WIDHT
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text
        {
           id: title
           x: CONST.const_TITLE_X
           y: CONST.const_TITLE_MY - CONST.const_TITLE_TEXT_PT
           color: "white"
           font.pointSize: CONST.const_TITLE_TEXT_PT
           text: qsTranslate( __lang_context, sTitleText) + __emptyString
           elide: Text.ElideMiddle

        }

        Text
        {
           id: titleContent
           y: CONST.const_FIRST_LINE_MY - CONST.const_TITLE_TEXT_PT
           color: "white"
           font.pointSize: CONST.const_CONTENT_TEXT_PT
           text: qsTranslate( __lang_context, sContentTextTitle) + __emptyString
           anchors.horizontalCenter: parent.horizontalCenter
           elide: Text.ElideMiddle

        }

        Text
        {
           id: problemText
           text: qsTranslate( __lang_context, sContentTextProblem) + __emptyString
           y: CONST.const_SECOND_LINE_MY - CONST.const_TITLE_TEXT_PT
           color: "white"
           font.pointSize: CONST.const_CONTENT_TEXT_PT
           anchors.horizontalCenter: parent.horizontalCenter
           elide: Text.ElideMiddle
        }

        Image
        {
           id: closeButton
           source: RES.const_POPUP_CLOSE_BUTTON_N
           x: CONST.const_TITLE_BUTTON_X
           y: CONST.const_TITLE_BUTTON_Y
           fillMode: Image.PreserveAspectFit

           MouseArea
           {
               anchors.fill: closeButton
               beepEnabled: false
               onPressed:
               {

                  closeButton.source = RES.const_POPUP_CLOSE_BUTTON_P
               }
               onReleased:
               {
                  UIListener.ManualBeep();
                  closeWarning();
                  closeButton.source = RES.const_POPUP_CLOSE_BUTTON_N
               }
           }
        }

        Image
        {
           id: cancelButton
           source: RES.const_POPUP_A_01_BUTTON_N
           beepEnabled: false
           anchors.horizontalCenter: parent.horizontalCenter
           y: CONST.const_BUTTON_Y
           fillMode: Image.PreserveAspectFit

           MouseArea
           {
               anchors.fill: parent
               onPressed:
               {

                  cancelButton.source = RES.const_POPUP_A_01_BUTTON_P
               }
               onReleased:
               {
                  UIListener.ManualBeep();
                  cancelButton.source = RES.const_POPUP_A_01_BUTTON_N
                  closeWarning();                  
               }
           }

           Text
           {
              id: buttonText
              anchors.verticalCenter: parent.verticalCenter
              anchors.horizontalCenter: parent.horizontalCenter
              color: "white"
              font.pointSize: CONST.const_TITLE_TEXT_PT
              text: qsTranslate( __lang_context, "Ok") + __emptyString
              elide: Text.ElideMiddle

           }
        }
    }
}
