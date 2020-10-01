import QtQuick 1.1

Loader {
    id: node

    property int node_id: -1
    property string name: "FocusedLoader"
    property bool focusable: true
    visible: (status == Loader.Ready)
    property int focus_default: -1
    property bool focus_visible: false

    property variant links: [ -1, -1, -1, -1 ]

    signal lostFocus(int arrow)
    signal hideFocus()
    signal showFocus()
    signal grabFocus(int n_id) // added by Dmitry 07.08.13 for ITS0175300

    function handleJogEvent(arrow, status)
    {
        log("handleJogEvent node id = [" + node_id + "]")

        if (node.status == Loader.Ready)
        {
           item.handleJogEvent(arrow, status)
        }
    }

    function setDefaultFocus()
    {
        log("setDefaultFocus node id = [" + node_id + "]")
        if (node.status == Loader.Ready)
        {
            item.setDefaultFocus()
        }
    }

    onHideFocus:
    {
       focus_visible = false
       if (node.status == Loader.Ready)
       {
           item.hideFocus()
       }
    }

    onShowFocus:
    {
       focus_visible = true
       if (node.status == Loader.Ready)
       {
           item.showFocus()
       }
    }

    onStatusChanged:
    {
       log("onStatusChanged node id = [" + node_id + "] node.status = " + node.status)
       if (node.status == Loader.Ready)
       {
           node.item.lostFocus.disconnect(node.lostFocus)
           node.item.lostFocus.connect(node.lostFocus)
           node.item.grabFocus.disconnect(node.grabFocus) // added by Dmitry 07.08.13 for ITS0175300
           node.item.grabFocus.connect(node.grabFocus) // added by Dmitry 07.08.13 for ITS0175300
           if (focus_visible)
           {
              node.item.setDefaultFocus()
              node.item.showFocus()
           }
       }
    }

    onSourceChanged:
    {
       log("onSourceChanged node id = [" + node_id + "] source = " + source)
    }

    function log(str)
    {
        //EngineListener.qmlLog("[" + name + "] " + str)
    }
}
