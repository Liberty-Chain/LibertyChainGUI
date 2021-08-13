import QtQuick 2.9

import "../components" as LibertyComponents

TextEdit {
    color: LibertyComponents.Style.defaultFontColor
    font.family: LibertyComponents.Style.fontRegular.name
    selectionColor: LibertyComponents.Style.textSelectionColor
    wrapMode: Text.Wrap
    readOnly: true
    selectByMouse: true
    // Workaround for https://bugreports.qt.io/browse/QTBUG-50587
    onFocusChanged: {
        if(focus === false)
            deselect()
    }
}
