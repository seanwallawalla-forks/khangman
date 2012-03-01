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

import QtQuick 1.1
import QtMultimediaKit 1.1

import com.nokia.meego 1.0
import com.nokia.extras 1.0

Page {

    orientationLock: PageOrientation.LockLandscape;

    property string originalWord;
    property variant alphabet: khangmanEngineHelper.alphabet();
    property int originalWordStatus: originalWordStatusEnumeration.init;
    property color originalWordLetterRectangleColor: Qt.rgba(0, 0, 0, 0);
    property int countDownTimerValue: khangmanEngineHelper.resolveTime;

    QtObject {  // status enum hackery :)
        id: originalWordStatusEnumeration;
        property int init: 1;
        property int active: 2;
        property int resolved: 3;
    }

    onStatusChanged: {
        if (status == PageStatus.Active) {
            secondTimer.repeat = true;
            secondTimer.restart();
        }
    }

    function pushPage(file) {
        var component = Qt.createComponent(file)
        if (component.status == Component.Ready)
            pageStack.push(component);
        else
            console.log("Error loading component:", component.errorString());
    }

    function nextWord() {
        anagramHintInfoBanner.hide();
        originalWordStatus = originalWordStatusEnumeration.init;
        originalWord = khangmanEngineHelper.createNextWord();
        anagramLetterRepeater.model = anagram;
        originalWordLetterRepeater.model = anagram;
        countDownTimerValue = khangmanEngineHelper.resolveTime;
    }

    // Create an info banner with icon
    InfoBanner {
        id: khangmanHintInfoBanner;
        text: qsTr("This is an info banner with icon for the hints");
        iconSource: "dialog-information.png";
    }

    // These tools are available for the main page by assigning the
    // id to the main page's tools property
    ToolBarLayout {
        id: mainPageTools;
        visible: false;

        ToolIcon {
            iconSource: "help-hint.png";

            onClicked: {
                khangmanHintInfoBanner.text = khangmanEngine.hint();
                khangmanHintInfoBanner.timerShowTime = khangmanEngineHelper.hintHideTime * 1000;

                // Display the info banner
                khangmanHintInfoBanner.show();
            }
        }

        ToolButton {
            text: categorySelectionDialog.model[categorySelectionDialog.selectedIndex];

            anchors {
                centerIn: parent;
            }

            onClicked: {
                categorySelectionDialog.open();
            }
        }

        ToolIcon {
            iconSource: "timer-pause.png";

            onClicked: {
                anagramHintInfoBanner.hide();

                pageStack.pop();

                secondTimer.repeat = false;
                secondTimer.stop();

            }
        }

        ToolIcon {
            iconSource: "go-next.png";

            onClicked: {
                if (khangmanEngineHelper.sound) {
                    nextWordSoundEffect.play();
                }

                nextWord();
                secondTimer.repeat = true;
                secondTimer.restart();
            }
        }
    }

    tools: mainPageTools;

    // Create a selection dialog with the vocabulary titles to choose from.
    MySelectionDialog {
        id: categorySelectionDialog;
        titleText: "Choose the word category"
        selectedIndex: 1;

        model: khangmanGame.vocabularyList();

        onSelectedIndexChanged: {

            if (khangmanEngineHelper.sound) {
                nextWordSoundEffect.play();
            }

            khangmanGame.useVocabulary(selectedIndex);
            nextWord();
        }
    }

    Timer {
        id: secondTimer;
        interval: 1000;
        repeat: true;
        running: false;
        triggeredOnStart: false;

        onTriggered: {
             if (khangmanEngineHelper.resolveTime != 0 && --countDownTimerValue == 0) {
                 stop();
                 if (khangmanEngineHelper.sound) {
                    ewDialogAppearSoundEffect.play();
                 }
             }
        }
    }

    Timer {
        id: khangmanResultTimer;
        interval: 1000;
        repeat: false;
        running: false;
        triggeredOnStart: false;

        onTriggered: {
            originalWordLetterRectangleColor = Qt.rgba(0, 0, 0, 0);
            nextAnagram();

            secondTimer.repeat = true;
            secondTimer.start();
        }
    }

    Row {
        spacing: 5;

        anchors {
            right: parent.right;
            top: parent.top;
            topMargin: 5;
            rightMargin: 5;
        }

        LetterElement {
            letterText: Math.floor(countDownTimerValue / 60 / 10);
            visible: khangmanEngineHelper.resolveTime == 0 ? false : true;
        }

        LetterElement {
            letterText: Math.floor(countDownTimerValue / 60 % 10);
            visible: khangmanEngineHelper.resolveTime == 0 ? false : true;
        }

        LetterElement {
            letterText: ":";
            visible: khangmanEngineHelper.resolveTime == 0 ? false : true;
        }

        LetterElement {
            letterText: Math.floor(countDownTimerValue % 60 / 10);
            visible: khangmanEngineHelper.resolveTime == 0 ? false : true;
        }

        LetterElement {
            letterText: Math.floor(countDownTimerValue % 60 % 10);
            visible: khangmanEngineHelper.resolveTime == 0 ? false : true;
        }
    }

    Column {
        anchors {
            horizontalCenter: parent.horizontalCenter;
            verticalCenter: parent.verticalCenter;
        }

        spacing: 20;

        Row {
            id: originalWordRow;
            anchors {
                horizontalCenter: parent.horizontalCenter;
            }

            spacing: 10;
            Repeater {
                id: originalWordLetterRepeater;
                model: alphabet;
                LetterElement {
                    id: originalWordLetterId;
                    letterText: modelData;

                    MouseArea {
                        anchors.fill: parent;
                        hoverEnabled: true;

                        onClicked: {
                            if (originalWordStatus != originalWordStatusEnumeration.resolved)
                            {
                                if (currentOriginalWordIndex == originalWordLetterRepeater.model.length)
                                {
                                    khangmanResultTimer.start();
                                    originalWordStatus = originalWordStatusEnumeration.resolved;
                                    jhangmanHintInfoBanner.hide();
                                    if (khangmanEngineHelper.compareWords() == true)
                                    {
                                        originalWordLetterRectangleColor = "green";

                                        if (khangmanEngineHelper.sound) {
                                            rightSoundEffect.play();
                                        }
                                    }
                                    else
                                    {
                                        originalWordLetterRectangleColor = "red";

                                        if (khangmanEngineHelper.sound) {
                                            wrongSoundEffect.play();
                                        }
                                    }
                                }
                            }
                       }
                    }
                }
            }
        }


    }
}
