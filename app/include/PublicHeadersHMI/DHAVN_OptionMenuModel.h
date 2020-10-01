#ifndef DHAVN_OPTIONMENUMODEL_H
#define DHAVN_OPTIONMENUMODEL_H

#include <QAbstractListModel>
#include <QModelIndex>
#include <QVariant>

struct OPTION_MENU_T
{
   int             nId;                   // Item Id
   QString         sText;                 // Name item
   bool            bCheckBox;             // Checkbox visible if bCheckBox = true, not visible if bCheckBox = false
   bool            bRadioBtn;             // Radio button visible if bRadioBtn = true, not visible if bRadioBtn = false
   bool            bSelected;             // If Checkbox or Radio button visible and bSelected = true - Checkbox or Radio button is selected
   bool            bSeparator;            // Separator beetween item, if needed
   bool            bEnabled;              // Enable/Disable item
   OPTION_MENU_T*  vAttachedMenu;         // Next level menu
   int             nCountItemAttachedMenu;// Count item next level menu
   QString         sIcon;                 // Icon before Name item
};
// modified by Dmitry 01.05.13
class OptionMenuModel : public QAbstractListModel
{
    Q_OBJECT
   enum Roles
   {
     itemId = Qt::UserRole + 1,
     itemName,
     Checkbox,
     Radiobutton,
     Select,
     Separator,
     Attachedmenu,
     Enabled,
     HasNextLevel,
     iconFile
   };

   Q_PROPERTY(QString header READ getHeader NOTIFY headerChanged)

public:
    OptionMenuModel( OPTION_MENU_T* item, int size, QObject *parent = 0 );

    QVariant data(const QModelIndex &index, int role) const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    OPTION_MENU_T* findInCurrentMenu( int itemId );

    Q_INVOKABLE QString getCurrentMenuHeader();
    Q_INVOKABLE OptionMenuModel* nextLevel( int aIndex );
    Q_INVOKABLE void checkBoxSelected( int aIndex, bool flag );
    Q_INVOKABLE void radioButtonSelected( int aIndex );
    Q_INVOKABLE void itemEnabled( int aItemId, bool bEnable );
    Q_INVOKABLE void itemTextChange( int aItemId, QString sText );
    Q_INVOKABLE bool getEnabled(int index); // added by wspark 2013.02.26 for ISV 70132
	//[KOR][ITS][178060][minor](aettie.ji)
    Q_INVOKABLE bool getSelected(int index);
    Q_INVOKABLE bool isCheckBox(int index);
    Q_INVOKABLE bool isRadioBtn(int index);

    Q_INVOKABLE void clearModels(bool purge);
    QString getHeader();
    void updateModel( OPTION_MENU_T* item, int count );

Q_SIGNALS:
   void changeCurrentMenuHeader(QString menuHeader);
   void headerChanged();

private:
    void itemEnabledPrivate( int aItemId, bool bEnable );
    void itemTextChangePrivate( int aItemId, QString sText );


private:
    OPTION_MENU_T* m_currentMenu;
    int m_currentMenuCount;
    QList<OptionMenuModel*> m_layers;
};
// modified by Dmitry 01.05.13
//Q_DECLARE_METATYPE( OptionMenuModel )

#endif // DHAVN_OPTIONMENUMODEL_H
