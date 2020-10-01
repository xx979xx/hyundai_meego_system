import Qt 4.7

Rectangle{
    x:0;y:0
    width: parent.width
    height: parent.height
    border.color: "green"
    border.width: 1
    color:"transparent"
    visible:isDebugMode()
}
