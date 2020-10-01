import Qt 4.7
import "DHAVN_AppAhaConst.js" as PR
import "DHAVN_AppAhaRes.js" as PR_RES

/** Text message */

Column
{
    id: popup_text
    /** --- Input parameters --- */
    property ListModel txtModel: ListModel {}
    property bool txtOnly: false
    property bool use_icon: false
    property int alignment

    function retranslateUI( context )
    {
       if (context) { __lang_context = context }
       __emptyString = " "
       __emptyString = ""
    }

    property string __lang_context: PR.const_AHA_LANGCONTEXT
    property string __emptyString: ""

    /** --- Child object --- */
    anchors.left: parent.left
    //anchors.top: parent.top
    anchors.verticalCenter: parent.verticalCenter

    Repeater
    {
        model: txtModel

        delegate: Component
        {

        Text
            {
                id: id_text
                text: argstext(index)
                height: 44
                width:parent.width
                anchors.left:parent.left
                horizontalAlignment: Text.AlignHCenter//alignment//use_icon == false ? Text.AlignLeft : Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color:  PR.const_TEXT_COLOR
                font.pointSize:   PR.const_TEXT_PT
                font.family: PR.const_TEXT_FONT_FAMILY
                wrapMode: Text.WordWrap
                style : Text.Sunken
            }//text
        }//delegate
    }//repeater


    function argstext(index)
    {
    if ( txtModel.get(index).msg.indexOf("STR_") !== 0 )
           {
               return txtModel.get(index).msg
           }

           if(txtModel.get(index).arguments != undefined) {
               var translation = (qsTranslate( __lang_context, txtModel.get(index).msg) + __emptyString);
               for (var i = 0; i < txtModel.get(index).arguments.count; i++)
               {
                   translation = translation.arg(txtModel.get(index).arguments.get(i).arg1);
               }
               return translation;
           }

           return (txtModel.get(index).arg1 == undefined) ?
                       qsTranslate(__lang_context, txtModel.get(index).msg) + __emptyString :
                       (qsTranslate( __lang_context, txtModel.get(index).msg) + __emptyString).arg(txtModel.get(index).arg1)
    }
}

