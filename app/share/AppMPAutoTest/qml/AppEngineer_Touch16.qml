import Qt 4.7

Rectangle{
    width: 1280
    height: 720

    Rectangle{
        id:btn1
        x:0
        y:0
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "1";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(1)
            }
        }
    }


    Rectangle{
        id:btn2
        x:320
        y:0
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "2";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(2)
            }
        }
    }

    Rectangle{
        id:btn3
        x:640
        y:0
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "3";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(3)
            }
        }
    }

    Rectangle{
        id:btn4
        x:960
        y:0
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "4";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(4)
            }
        }
    }

    Rectangle{
        id:btn5
        x:btn1.x
        y:btn1.y+btn1.height
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "5";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(5)
            }
        }
    }

    Rectangle{
        id:btn6
        x:btn2.x
        y:btn2.y+btn2.height
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "6";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(6)
            }
        }
    }

    Rectangle{
        id:btn7
        x:btn3.x
        y:btn3.y+btn3.height
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "7";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(7)
            }
        }
    }

    Rectangle{
        id:btn8
        x:btn4.x
        y:btn4.y+btn4.height
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "8";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(8)
            }
        }
    }

    Rectangle{
        id:btn9
        x:btn5.x
        y:btn5.y+btn5.height
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "9";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(9)
            }
        }
    }

    Rectangle{
        id:btn10
        x:btn6.x
        y:btn6.y+btn6.height
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "10";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(10)
            }
        }
    }

    Rectangle{
        id:btn11
        x:btn7.x
        y:btn7.y+btn7.height
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "11";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(11)
            }
        }
    }

    Rectangle{
        id:btn12
        x:btn8.x
        y:btn8.y+btn8.height
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "12";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(12)
            }
        }
    }

    Rectangle{
        id:btn13
        x:btn9.x
        y:btn9.y+btn9.height
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "13";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(13)
            }
        }
    }

    Rectangle{
        id:btn14
        x:btn10.x
        y:btn10.y+btn10.height
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "14";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(14)
            }
        }
    }

    Rectangle{
        id:btn15
        x:btn11.x
        y:btn11.y+btn11.height
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "15";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(15)
            }
        }
    }

    Rectangle{
        id:btn16
        x:btn12.x
        y:btn12.y+btn12.height
        width: 320
        height:180

        color: "lightblue"
        border.color: "black"

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "16";font.pixelSize: 48
        }

        MouseArea{
            anchors.fill: parent
            onReleased:{
                parent.color = "blue"
                ATParser.clickTouch2(16)
            }
        }
    }

}

