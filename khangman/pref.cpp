/*
 * Copyright (C) 2001-2003 Anne-Marie Mahfouf <annma@kde.org>
 */


//KDE headers
#include <kapplication.h>
#include <kconfig.h>
#include <kdebug.h>
#include <klocale.h>
//Qt headers
#include <qbuttongroup.h>
#include <qcombobox.h>
#include <qlabel.h>
#include <qlayout.h>
#include <qradiobutton.h>
//Project headers
#include "pref.h"


KHangManPreferences::KHangManPreferences()
    : KDialogBase(TreeList, i18n("KHangMan Preferences"),
                  Help|Default|Ok|Apply|Cancel, Ok)
{
     //disable the Apply button before any changes are made
     enableButton( Apply, false);

    QFrame *frame;
    frame = addPage(i18n("General"), i18n("General"));
    m_pageOne = new KHangManPrefPageOne(frame);

     frame = addPage(i18n("Language"), i18n("Data language"));
     m_pageTwo = new KHangManPrefPageTwo(frame);

    readConfig();
    //set the values read in config file
    slotSet();

    QObject::connect(m_pageOne->buttonGroup, SIGNAL(clicked(int)), this, SLOT(slotMode(int)));
    QObject::connect(m_pageOne->buttonGroup, SIGNAL(clicked(int)), this, SLOT(slotChanged()));
    QObject::connect(m_pageOne->levelBox, SIGNAL(activated(int)), this, SLOT(slotLevel(int)));
    QObject::connect(m_pageOne->levelBox, SIGNAL(activated(int)), this, SLOT(slotChanged()));
    QObject::connect(m_pageTwo->langGroup, SIGNAL(clicked(int)), this, SLOT(slotLang(int)));
    QObject::connect(m_pageTwo->langGroup, SIGNAL(clicked(int)), this, SLOT(slotChanged()));
}

KHangManPrefPageOne::KHangManPrefPageOne(QWidget *parent)
    : pref1ui(parent)
{
	adjustSize();
}

KHangManPrefPageTwo::KHangManPrefPageTwo(QWidget *parent)
    : pref2ui(parent)
{
	adjustSize();
}

void KHangManPreferences::readConfig()
{
   	KConfigBase *conf = kapp->config();
	if (conf)
	{
  		conf->setGroup("Settings");
   		levelString = conf->readEntry("level");
		modeString = conf->readEntry("mode");
		conf->setGroup("Language");
   		langNum = conf->readNumEntry("myLanguage");
		if (langNum<0 || langNum >2)
			langNum = 0;
	}
	if( !levelString )
  		slotDefault();
}

//Set the system defaults
void KHangManPreferences::slotDefault()
{
	levelString="easy";
	modeString="nobg";
	langNum = 0;
	slotSet();
}

//Apply changes made in the dialog and close the dialog
void KHangManPreferences::slotOk()
{
	if( configChanged )
     	   slotApply();
	accept();
}

//Apply changes made in the dialog and disable the Apply button
void KHangManPreferences::slotApply()
{
	enableButton( Apply, false );
        configChanged = false;
	writeConfig();
	//emit a signal which is connected to a slot in khangman.cpp
	emit aClicked();
}

//Don't validate the new changes in the dialog (after Apply was hit) and close the dialog
void KHangManPreferences::slotCancel()
{
	cancelBool=true;
	accept();
}

void KHangManPreferences::slotSet()
{
	if (levelString=="easy")
		m_pageOne->levelBox->setCurrentItem(0);
	if (levelString=="medium")
		m_pageOne->levelBox->setCurrentItem(1);
	if (levelString=="hard")
		m_pageOne->levelBox->setCurrentItem(2);
	if (levelString=="animals")
		m_pageOne->levelBox->setCurrentItem(3);
	//if (levelString=="own")
	//	m_pageOne->levelBox->setCurrentItem(4);
	if (modeString=="blue")
		m_pageOne->blueBox->setChecked(true);
	if (modeString=="nobg")
		m_pageOne->noBgBox->setChecked(true);
	if (modeString=="nature")
		m_pageOne->natureBox->setChecked(true);
	if (langNum==0)
		m_pageTwo->enBox->setChecked(true);
	if (langNum==1)
		m_pageTwo->frBox->setChecked(true);
	if (langNum==2)
		m_pageTwo->spBox->setChecked(true);
}

void KHangManPreferences::slotMode(int id)
{
	switch(id){
	case 0:
		modeString = "nobg";
		break;
	case 1:
		modeString = "blue";
		break;
	case 2:
		modeString = "nature";
		break;
	}
	enableButton( Apply, false );
        configChanged = false;
}

void KHangManPreferences::slotLang(int id)
{
	langNum = id;
	slotSet();
	langChanged = true;
	enableButton( Apply, false );
        configChanged = false;
}

void KHangManPreferences::slotLevel(int id)
{
	switch(id){
	case 0:
		levelString="easy";
		break;
	case 1:
		levelString="medium";
		break;
	case 2:
		levelString="hard";
		break;
	case 3:
		levelString="animals";
		break;
	/*case 4:
		levelString="own";
		break;*/
	}
	enableButton( Apply, false );
        configChanged = false;
	levelChanged = true;
}

//Write settings in config
void KHangManPreferences::writeConfig()
{
	KConfigBase *conf = kapp->config();
	if (conf)
	{
		conf->setGroup( "Settings");
		conf->writeEntry( "level", levelString);
		conf->writeEntry( "mode", modeString);
		conf->writeEntry("levelFile", levelString+".txt");
		conf->setGroup("Language");
		conf->writeEntry("myLanguage", langNum);
		conf->sync();
	}
}

//called whenever a change has been made in the settings
//Apply button is enabled so it can be clicked to apply the changes
void KHangManPreferences::slotChanged()
{
    enableButton( Apply, true );
    configChanged = true;
}


#include "pref.moc"
