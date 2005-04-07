/*
 * Copyright (C) 2001-2005 Anne-Marie Mahfouf <annma@kde.org>

    This program is free software; you can redistribute it and/or
    modify it under the terms of version 2 of the GNU General Public
    License as published by the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

#ifndef KHANGMANVIEW_H
#define KHANGMANVIEW_H

class KPushButton;
class KHangMan;
#include <krandomsequence.h>
//from libkdeedu
#include <keduvocdata.h>
/**
 * This is the main view class for KHangMan.  Most of the non-menu,
 * non-toolbar, and non-statusbar (e.g., non frame) GUI code should go
 * here.
 */

class KHangManView : public QWidget
{
    Q_OBJECT
public:

    KHangManView(KHangMan *parent=0, const char *name=0);

    virtual ~KHangManView();

    ///parent instance
    KHangMan *khangman;
    QPixmap seaPicture;
    void paintHangman();
signals:

private:
    KLineEdit *charWrite;

    QColor m_fillColor;

    KPushButton *guessButton;

protected:

    ///Paint the texts
    void paintEvent( QPaintEvent * );
    ///necessary to have it all resize correctly
    void resizeEvent(QResizeEvent *);
    ///set the background pixmap to the QPixmap argument
    void slotSetPixmap(QPixmap& );
    
    QString missedL;

    QString temp;
    ///store the hint when there is one
    QString tip;
    
    QString stripWord, sword;
    
    int c, d, f, g;
    ///word is the random word to be guessed
    QString word;
    ///goodWord is the hidden word that is filled in
    QString goodWord;
    ///how many times you missed, when it reaches 10, you are hanged
    int missedChar;
    ///tmp is to check if not twice the same random number
    int tmp;
    ///true if only one instance of each letter is displayed
    bool b_oneLetter;
    ///true if Type accents is enabled for the languages that support it
    bool accent_b;
    ///true if language = es, ca, pt or pt_BR
    bool m_accent;
    ///allWords contains all letters already guessed
    QStringList allWords;
    ///If true, the word contains the QString
    bool containsChar(const QString &);
    void replaceLetters(const QString &);
    QPixmap px[11];
    QPixmap bluePic, miss_bluePic;
    void paintWord();
    
    void reset();
    
    void game();

    void readFile();
    ///If true, the uppercase and lower case are disctincts (world capitals)
    bool upperBool;
    ///KDE random generator
    KRandomSequence random;
    ///true if hint is enabled for the fiels that support it
    bool hintBool;
    //QRect aux;
    ///Enable hints on mouse right click if Hints exist
    virtual void mousePressEvent(QMouseEvent *mouse);
    
    void paintMissedTwice();
    
    void paintWordTwice();
    
    int redIndex;
        
public slots:

    void slotNewGame();
private slots:
    void slotTry();
    void timerDone();
    void timerWordDone();
    
signals:
    /**
    * Use this signal to change the content of the statusbar
    */
    void signalChangeLanguage(int);
    ///emit this signal to say if this is a kvtml file or not (hints enabled or not)
    void signalKvtml(bool);
};

#endif // KHANGMANVIEW_H
 
