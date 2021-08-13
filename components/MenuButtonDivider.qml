import QtQuick 2.9

import "." as LibertyComponents
import "effects/" as LibertyEffects

Rectangle {
    color: LibertyComponents.Style.appWindowBorderColor
    height: 1

    LibertyEffects.ColorTransition {
        targetObj: parent
        blackColor: LibertyComponents.Style._b_appWindowBorderColor
        whiteColor: LibertyComponents.Style._w_appWindowBorderColor
    }
}
