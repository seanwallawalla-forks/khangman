/******************************************************************************
 * This file is part of the KHangMan project
 * Copyright (C) 2012 Laszlo Papp <lpapp@kde.org>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

import QtQuick 2.3
import QtQuick.Controls 1.2
//import com.nokia.meego 1.0
//import com.nokia.extras 1.0

Item {

    property int settingsPageMargins: 15;

    /*QueryDialog {
        id: khangmanWordResolveTimeUserGuideDialog;
        message: i18n("<b>KHangMan word resolve time</b>: Maximum allowed time for resolving the word in KHangMan");
    }*/

    /*QueryDialog {
        id: hintShowDurationUserGuideDialog;
        message: i18n("<b>Hint show duration:</b> The duration for showing the hint for the actual word");
    }*/

    /*QueryDialog {
        id: soundsUserGuideDialog;
        message: i18n("<b>Sounds:</b> Turn all the sounds on or off inside the game");
    }*/

    function pushPage(file) {
        var component = Qt.createComponent(file)
        if (component.status == Component.Ready)
            pageStack.push(component);
        else
            console.log(i18n("Error loading component:", component.errorString()));
    }

    MySelectionDialog {
        id: languageSelectionDialog;
        title: i18n("Select a language");
        selectedIndex: 0;

        model: khangman.languageNames();

        onSelectedIndexChanged: {
            khangman.selectedLanguage = model[selectedIndex];
        }
    }

    Connections {
        target: khangman;

        onHintHideTimeChanged: {
            hintAppearanceSlider.value = khangman.hintHideTime;
        }

        onResolveTimeChanged: {
            resolveTimeSlider.value = khangman.resolveTime;
        }

        onSoundChanged: {
            soundsSwitch.checked = khangman.sound;
        }
    }

    Component.onCompleted: {
        hintAppearanceSlider.value = khangman.hintHideTime;
        resolveTimeSlider.value = khangman.resolveTime;
        soundsSwitch.checked = khangman.sound;
    }


    Rectangle {
        id: settingsPageMainRectangle;
        color: "black";
        anchors.fill: parent;

        Flickable {
            anchors {
                fill: parent;
                margins: settingsPageMargins;
            }

            contentWidth: settingsPageMainColumn.width;
            contentHeight: settingsPageMainColumn.height;

            Column {
                id: settingsPageMainColumn;
                width: settingsPageMainRectangle.width - 2*settingsPageMargins;

                spacing: 10;

                Label {
                    width: parent.width;
                    text: i18n("KHangMan Settings");
                    font.pixelSize: 32;
                }

                Image {
                    id: separator1;
                    width: parent.width;
                    height: 2;
                    fillMode: Image.TileHorizontally;
                    source: "separator.png";
                }

                Column {
                    width: parent.width;
                    spacing: 5;

                    Item {
                        //height: childrenRect.height;
                        width: parent.width;

                        Label {
                            id: hintAppearanceLabel;

                            anchors {
                                left: parent.left;
                                verticalCenter: parent.verticalCenter;
                            }

                            text: i18n("Hint show duration in seconds");
                            font.bold: true;
                        }

                        ToolBar {
                            ToolButton {
                                iconSource: "image://theme/icon-l-user-guide-main-view"

                                anchors {
                                    right: parent.right;
                                    verticalCenter: parent.verticalCenter;
                                }

                                onClicked: {
                                    hintShowDurationUserGuideDialog.open();
                                }
                            }
                    }

                    Slider {
                        id: hintAppearanceSlider;
                        width: parent.width - 10;
                        stepSize: 1;
                        tickmarksEnabled : true
                        updateValueWhileDragging : true
                        //valueIndicatorVisible: true;
                        minimumValue: 0;
                        maximumValue: 10;
                        anchors.horizontalCenter: parent.horizontalCenter;

                        onValueChanged: {
                            khangman.hintHideTime = value;
                        }
                    }
                }

                Image {
                    id: separator2;
                    width: parent.width;
                    height: 2;
                    fillMode: Image.TileHorizontally;
                    source: "separator.png";
                }

                Column {
                    width: parent.width;
                    spacing: 5;

                    Item {
                        //height: childrenRect.height;
                        width: parent.width;

                        Label {
                            id: resolveTimeLabel;

                            anchors {
                                left: parent.left;
                                verticalCenter: parent.verticalCenter;
                            }

                            text: i18n("Word resolve time in seconds");
                            font.bold: true;
                        }

                        ToolBar {
                            ToolButton {
                                iconSource: "image://theme/icon-l-user-guide-main-view"

                                anchors {
                                    right: parent.right;
                                    verticalCenter: parent.verticalCenter;
                                }

                                onClicked: {
                                    khangmanWordResolveTimeUserGuideDialog.open();
                                }
                            }
                        }
                    }

                    Slider {
                        id: resolveTimeSlider;
                        width: parent.width - 10;
                        stepSize: 15;
                        tickmarksEnabled : true
                        updateValueWhileDragging : true
                        //valueIndicatorVisible: true;
                        minimumValue: 0;
                        maximumValue: 300;
                        anchors.horizontalCenter: parent.horizontalCenter;

                        onValueChanged: {
                            khangman.resolveTime = value;
                        }
                    }
                }

                Image {
                    id: separator3;
                    width: parent.width;
                    height: 2;
                    fillMode: Image.TileHorizontally;
                    source: "separator.png";
                }

                Item {
                    //height: childrenRect.height;
                    width: parent.width;

                    Label {
                        anchors {
                            left: parent.left;
                            verticalCenter: parent.verticalCenter;
                        }

                        text: i18n("Sounds");
                        font.bold: true;
                    }

                    ToolButton {
                        iconSource: "image://theme/icon-l-user-guide-main-view"

                        anchors {
                            right: soundsSwitch.left;
                            verticalCenter: parent.verticalCenter;
                        }

                        onClicked: {
                            soundsUserGuideDialog.open();
                        }
                    }

                    Switch {
                        id: soundsSwitch;
                        anchors {
                            right: parent.right;
                            verticalCenter: parent.verticalCenter;
                        }

                        onCheckedChanged: {
                            khangman.sound = checked;
                        }
                    }
                }

                Image {
                    id: separator4;
                    width: parent.width;
                    height: 2;
                    fillMode: Image.TileHorizontally;
                    source: "separator.png";
                }

                ListItem {
                    iconSource: "language-settings.png";
                    titleText: i18n("Language");
                    subtitleText: khangman.selectedLanguage ? khangman.selectedLanguage : "English";
                    iconId: "textinput-combobox-arrow";
                    iconVisible: true;
                    mousePressed: languageSelectionMouseArea.pressed;

                    MouseArea {
                        id: languageSelectionMouseArea;
                        anchors.fill: parent;
                        onClicked: {
                            languageSelectionDialog.open();
                       }
                    }
                }
            }
        }
    }

    //tools: commonTools;
}
}
