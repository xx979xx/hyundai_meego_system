��    �      d  �   �
      8     9  �   O  �     <   �     �     �               1     B     X     r     y  7   �     �     �     �      �       &   6     ]  .   |  4   �  "   �        D   $  A   i  7   �  !   �       "   #  A   F  +   �  '   �     �     �       #   "     F  #   ^  -   �     �     �  $   �               4  %   N  F   t     �     �  *   �          *     >     X     q     �  %   �     �     �  %   �  #        @     Z  1   m  8   �  (   �       ,     )   I     s  *   �  !   �  y   �     W      t  *   �     �  ?   �  4        C     W     m      �     �  %   �  !   �  0   	  8   :  @   s     �     �  D   �     ,     C  1   Z  '   �  0   �  ,   �  )     (   <  &   e     �     �  -   �  '   �  )     !   =  '   _     �     �     �     �  "   �  /   �  6   +  6   b  >   �  �   �     �      �   &   �   M   �   5   D!  2   z!  +   �!  6   �!  #   "     4"  (   D"     m"  .   �"     �"      �"     �"     	#     &#  &   D#  3   k#  h   �#  0   $  '   9$     a$  N   x$     �$  O   �$     %%  
   E%     P%  5   f%  #   �%  ,   �%  0   �%     &  "   $&     G&  	   a&     k&     &  1   �&     �&     �&     �&     �&  (   '  1   /'     a'    j'     �(  	  )  �   *  T   �*     �*     +     7+     @+     Z+     k+  !   �+     �+     �+  B   �+     ,     ",     ;,  )   @,  '   j,  E   �,  $   �,  <   �,  G   :-  /   �-  6   �-  l   �-  [   V.  U   �.  +   /  (   4/  .   ]/  K   �/  6   �/  .   0     >0     ]0     |0  9   �0      �0  7   �0  <   -1     j1  "   �1  :   �1  !   �1     
2  *   2  ,   J2  w   w2     �2  !   �2  =    3     ^3     |3     �3     �3     �3     �3  0   4     94  $   R4  6   w4  :   �4  $   �4     5  ?   "5  T   b5  /   �5  %   �5  D   6  2   R6  )   �6  B   �6  .   �6  �   !7  4   �7  2   %8  H   X8     �8  R   �8  9   9     >9  !   V9     x9  2   �9  3   �9  4   �9  /   3:  ;   c:  K   �:  Y   �:  !   E;  !   g;  \   �;     �;     <  8   $<  0   ]<  1   �<  2   �<  ,   �<  /    =  &   P=  #   w=     �=  =   �=  .   �=  1   >  )   P>  N   z>  -   �>     �>      ?     ?  '   2?  D   Z?  V   �?  B   �?  R   9@  �   �@     aA  ,   yA  "   �A  a   �A  >   +B  9   jB  7   �B  ;   �B  -   C     FC  9   YC  %   �C  3   �C     �C  &   D     +D  $   ID  %   nD  2   �D  ?   �D  u   E  1   }E  (   �E  %   �E  t   �E     sF  e   �F  %   �F  
   G     G  7   5G  ,   mG  $   �G  7   �G     �G  (   �G     %H     DH     IH     bH  I   sH  #   �H     �H  !   �H     I  4   I  >   SI     �I     �              �   �   g   Q      n   .   7   Z   �      �       {   %   �   �   `   o   -   �   S   T      5       �       y   [       P   v   }   r          B      O   F   l   _       R   �   �   ;   W   �   0   #                   �       
          "           �   �   @       x   �   Y       8   �   �       �   H   '             �          4       h   s       �   a   �   p   �   ^       N   �       =         D               6   K   	   2      G      �   \       A       �       ]   �   M   ,   b   i         �       e   �   V       u       X          >   :       �              c   z   (   ~   �          I           �   E          +           J                 L          f   �                         U   �   ?      �       C   �   �       �       q   |          t   �      /   )   9       &   $      1   *   !   3   �   j   w           �   m   d       k   <   �    
<action> is one of:
 
<name> is the device to create under %s
<device> is the encrypted device
<key slot> is the LUKS key slot number to modify
<key file> optional key file for the new key for luksAddKey action
 
Default compiled-in device cipher parameters:
	plain: %s, Key: %d bits, Password hashing: %s
	LUKS1: %s, Key: %d bits, LUKS header hashing: %s
 
WARNING: real device header has different UUID than backup! %s: requires %s as arguments (Obsoleted, see man page.) <device> <device> <key slot> <device> <name>  <device> [<key file>] <device> [<new key file>] <name> <name> <device> Align payload at <n> sector boundaries - for luksFormat All key slots full.
 Argument <action> missing. BITS BLKGETSIZE failed on device %s.
 BLKROGET failed on device %s.
 Backup LUKS device header and keyslots Backup file %s doesn't exist.
 Backup file do not contain valid LUKS header.
 Can't do passphrase verification on non-tty inputs.
 Can't format LUKS without device.
 Can't wipe header on device %s.
 Cannot add key slot, all slots disabled and no volume key provided.
 Cannot create LUKS header: header digest failed (using hash %s).
 Cannot create LUKS header: reading random salt failed.
 Cannot get info about device %s.
 Cannot get process priority.
 Cannot initialize crypto backend.
 Cannot initialize device-mapper. Is dm_mod kernel module loaded?
 Cannot not read %d bytes from key file %s.
 Cannot open device %s for %s%s access.
 Cannot open device %s.
 Cannot open device: %s
 Cannot open file %s.
 Cannot open header backup file %s.
 Cannot read device %s.
 Cannot read header backup file %s.
 Cannot retrieve volume key for plain device.
 Cannot unlock memory. Cannot wipe device %s.
 Cannot write header backup file %s.
 Command failed with code %i Command successful.
 Create a readonly mapping DM-UUID for device %s was truncated.
 Data offset or key size differs on device and backup, restore failed.
 Device %s %s%s Device %s already exists.
 Device %s doesn't exist or access denied.
 Device %s has zero size.
 Device %s is busy.
 Device %s is not active.
 Device %s is too small.
 Display brief usage Do not ask for confirmation Enter LUKS passphrase to be deleted:  Enter LUKS passphrase:  Enter any passphrase:  Enter any remaining LUKS passphrase:  Enter new passphrase for key slot:  Enter passphrase for %s:  Enter passphrase:  Error during update of LUKS header on device %s.
 Error re-reading LUKS header after update on device %s.
 Error reading passphrase from terminal.
 Error reading passphrase.
 Failed to access temporary keystore device.
 Failed to obtain device mapper directory. Failed to open key file %s.
 Failed to open temporary keystore device.
 Failed to read from key storage.
 Failed to setup dm-crypt key mapping for device %s.
Check that kernel supports %s cipher (check syslog for more info).
%s Failed to stat key file %s.
 Failed to write to key storage.
 File with LUKS header and keyslots backup. Help options: How many sectors of the encrypted data to skip at the beginning How often the input of the passphrase can be retried Invalid device %s.
 Invalid key size %d.
 Invalid key size.
 Invalid plain crypt parameters.
 Key %d not active. Can't wipe.
 Key size must be a multiple of 8 bits Key slot %d active, purge first.
 Key slot %d is full, please select another one.
 Key slot %d is invalid, please select between 0 and %d.
 Key slot %d is invalid, please select keyslot between 0 and %d.
 Key slot %d is invalid.
 Key slot %d is not used.
 Key slot %d material includes too few stripes. Header manipulation?
 Key slot %d unlocked.
 Key slot %d verified.
 LUKS header detected but device %s is too small.
 No key available with this passphrase.
 No known cipher specification pattern detected.
 Obsolete option --non-exclusive is ignored.
 Option --header-backup-file is required.
 Out of memory while reading passphrase.
 PBKDF2 iteration time for LUKS (in ms) Passphrases do not match.
 Print package version Read the key from a file (can be /dev/random) Read the volume (master) key from file. Requested LUKS hash %s is not supported.
 Requested file %s already exist.
 Restore LUKS device header and keyslots Resume suspended LUKS device. SECTORS Show debug messages Show this help message Shows more detailed error messages Slot number for new key (default is first free) Suspend LUKS device and wipe key (all IOs are frozen). The cipher used to encrypt the disk (see /proc/crypto) The hash used to create the encryption key from the passphrase The reload action is deprecated. Please use "dmsetup reload" in case you really need this functionality.
WARNING: do not use reload to touch LUKS devices. If that is the case, hit Ctrl-C now.
 The size of the device The size of the encryption key The start offset in the backend device This is the last keyslot. Device will become unusable after purging this key. This operation is not supported for %s crypt device.
 This operation is supported only for LUKS device.
 This will overwrite data on %s irrevocably. Timeout for interactive passphrase prompt (in seconds) Unable to obtain sector size for %s Unknown action. Unknown crypt device type %s requested.
 Unsupported LUKS version %d.
 Verifies the passphrase by asking for it twice Verify passphrase:  Volume %s is already suspended.
 Volume %s is not active.
 Volume %s is not suspended.
 Volume key buffer too small.
 Volume key does not match the volume.
 WARNING!!! Possibly insecure memory. Are you root?
 Warning: exhausting read requested, but key file %s is not a regular file, function might never return.
 Wrong UUID format provided, generating new one.
 [OPTION...] <action> <action-specific>] add key to LUKS device already contains LUKS header. Replacing header will destroy existing keyslots. create device does not contain LUKS header. Replacing header can destroy data on that device. dump LUKS partition information exclusive  formats a LUKS device identical to luksKillSlot - DEPRECATED - see man page key slot %d selected for deletion.
 memory allocation error in action_luksFormat modify active device - DEPRECATED - see man page msecs open LUKS device as mapping <name> print UUID of LUKS device read-only remove LUKS mapping remove device removes supplied key or key file from LUKS device resize active device secs setpriority %u failed: %s show device status tests <device> for LUKS partition header wipes key with number <key slot> from LUKS device writable Project-Id-Version: cryptsetup 1.1.0-rc4
Report-Msgid-Bugs-To: dm-crypt@saout.de
POT-Creation-Date: 2010-07-03 15:49+0200
PO-Revision-Date: 2010-01-05 22:17+0100
Last-Translator: Roland Illig <roland.illig@gmx.de>
Language-Team: German <translation-team-de@lists.sourceforge.net>
Language: de
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
 
<Aktion> ist eine von:
 
<Name> ist das Gerät, das unter %s erzeugt wird
<Gevice> ist das verschlüsselte Gerät
<Schlüsselfach> ist die Nummer des zu verändernden LUKS-Schlüsselfachs
<Schlüsseldatei> optionale Schlüsseldatei für für den neuen Schlüssel der »luksAddKey«-Aktion
 
Standard-Verschlüsselungsparameter:
	plain: %s, Schlüssel: %d Bits, Passsatz-Hashen: %s
	LUKS1: %s, Schlüssel: %d Bits, LUKS-Kopfbereich-Hashen: %s
 
WARNUNG: Der Kopfbereich des echten Geräts hat eine andere UUID als die Sicherung! %s: Benötigt %s als Argumente (Überholt, siehe Handbuch.) <Gerät> <Gerät> <Schlüsselfach> <Gerät> <Name>  <Gerät> [<Schlüsseldatei>] <Gerät> [<neue Schlüsseldatei>] <Name> <Name> <Gerät> Nutzdaten an Grenzen von <n> Sektoren ausrichten - für luksFormat Alle Schlüsselfächer voll.
 Argument <Aktion> fehlt. BITS BLKGETSIZE fehlgeschlagen auf Gerät %s.
 BLKROGET fehlgeschlagen auf Gerät %s.
 Sichern des Kopfbereichs und der Schlüsselfächer eines LUKS-Geräts Sicherungskopie %s existiert nicht.
 Sicherungskopie enthält keinen gültigen LUKS-Kopfbereich.
 Kann die Passsatz-Verifikation nur auf Terminal-Eingaben durchführen.
 Ohne Gerät kann LUKS nicht formatiert werden.
 Kann den Kopfbereich auf Gerät %s nicht auslöschen.
 Kann kein Schlüsselfach hinzufügen, alle Fächer sind deaktiviert und kein Laufwerksschlüssel angegeben.
 Kann LUKS-Kopfbereich nicht erzeugen: Auszug des Kopfbereich fehlgeschlagen (mit Hash %s).
 Kann LUKS-Kopfbereich nicht erzeugen: Lesen der zufälligen Streuung fehlgeschlagen.
 Kann Infos über Gerät %s nicht bekommen.
 Kann Prozesspriorität nicht ermitteln.
 Kann das Krypto-Backend nicht initialisieren.
 Kann die Gerätezuordnung nicht laden. Ist das Kernelmodul dm_mod geladen?
 Kann %d Bytes aus der Schlüsseldatei %s nicht lesen.
 Kann Gerät %s nicht zum %s%szugriff öffnen.
 Kann Gerät %s nicht öffnen.
 Kann Gerät nicht öffnen: %s
 Kann Datei %s nicht öffnen.
 Kann Sicherheitskopie %s des Kopfbereichs nicht öffnen.
 Kann nicht von Gerät %s lesen.
 Kann Sicherheitskopie %s des Kopfbereichs nicht lesen.
 Kann Laufwerksschlüssel für Plain-Gerät nicht ermitteln.
 Kann Speicher nicht entsperren. Kann Gerät %s nicht auslöschen.
 Kann Sicherungskopie %s des Kopfbereichs nicht schreiben.
 Befehl fehlgeschlagen mit Code %i Befehl erfolgreich.
 Eine schreibgeschützte Zuordnung erzeugen DM-UUID für Gerät %s wurde abgeschnitten.
 Unterschiedliche Datenposition oder Schlüsselgröße zwischen Gerät und Sicherung, Wiederherstellung fehlgeschlagen.
 Gerät %s %s%s Das Gerät %s existiert bereits.
 Gerät %s existiert nicht oder ist vor Zugriffen geschützt.
 Gerät %s hat die Größe 0.
 Gerät %s ist beschäftigt.
 Gerät %s ist nicht aktiv.
 Gerät %s ist zu klein.
 Kurze Aufrufsyntax anzeigen Nicht auf Bestätigung warten Geben Sie den zu löschenden LUKS-Passsatz ein:  LUKS-Passsatz eingeben:  Geben Sie irgendeinen Passsatz ein:  Geben Sie einen eventuell weiteren LUKS-Passsatz ein:  Geben Sie den neuen Passsatz für das Schlüsselfach ein:  Geben Sie den Passsatz für %s ein:  Passsatz eingeben:  Fehler beim Aktualisieren des LUKS-Kopfbereichs auf Gerät %s.
 Fehler beim Neueinlesen des LUKS-Kopfbereichs nach dem Aktualisieren auf Gerät %s.
 Fehler beim Lesen des Passsatzes vom Terminal.
 Fehler beim Einlesen des Passsatzes.
 Zugriff auf das temporäre Schlüsselspeichergerät fehlgeschlagen.
 Kann Gerätezuordnungsverzeichnis nicht ermitteln. Konnte Schlüsseldatei %s nicht öffnen.
 Öffnen des temporären Schlüsselspeichergeräts fehlgeschlagen.
 Lesen des Schlüsselspeichers fehlgeschlagen.
 Einrichten der dm-crypt-Schlüsselzuordnung für Gerät %s fehlgeschlagen.
Prüfen Sie, dass der Kernel die %s-Verschlüsselung unterstützt.
(Sehen Sie im System-Log nach, ob sich dort Hinweise finden.)
%s Konnte Infos zur Schlüsseldatei %s nicht bekommen.
 Schreiben des Schlüsselspeichers fehlgeschlagen.
 Datei mit der Sicherung der LUKS-Kopfdateien und den Schlüsselfächern. Hilfe-Optionen: Wieviele Sektoren der verschlüsselten Daten am Anfang übersprungen werden sollen Wie oft die Eingabe des Passsatzes wiederholt werden kann Ungültiges Gerät %s.
 Ungültige Schlüsselgröße %d.
 Ungültige Schlüsselgröße.
 Ungültige Parameter für Plain-Verschlüsselung.
 Schlüssel %d nicht aktiv. Kann nicht auslöschen.
 Schlüsselgröße muss ein Vielfaches von 8 Bit sein Schlüsselfach %d aktiv, löschen Sie es erst.
 Schlüsselfach %d ist voll, bitte wählen Sie ein anderes.
 Schlüsselfach %d ist ungültig, bitte wählen Sie eins zwischen 0 und %d.
 Schlüsselfach %d ist ungültig, bitte wählen Sie ein Schlüsselfach zwischen 0 und %d.
 Schlüsselfach %d ist ungültig.
 Schlüsselfach %d ist unbenutzt.
 Material für Schlüsselfach %d enthält zu wenige Streifen. Manipulation des Kopfbereichs?
 Schlüsselfach %d entsperrt.
 Schlüsselfach %d verifiziert.
 LUKS-Kopfbereich gefunden, aber Gerät %s ist zu klein.
 Kein Schlüssel mit diesem Passsatz verfügbar.
 Kein bekanntes Verschlüsselungsmuster entdeckt.
 Überholte Option --non-exclusive wird ignoriert.
 Option --header-backup-file wird benötigt.
 Zu wenig Speicher zum Einlesen des Passsatzes.
 PBKDF2 Iterationszeit for LUKS (in ms) Passsätze stimmen nicht überein.
 Paketversion ausgeben Schlüssel aus einer Datei lesen (kann auch /dev/random sein) Laufwerks-(Master-)Schlüssel aus Datei lesen. Verlangter LUKS-Hash %s wird nicht unterstützt.
 Angeforderte Datei %s existiert bereits.
 Wiederherstellen des Kopfbereichs und der Schlüsselfächer eines LUKS-Geräts Ausgeschaltetes LUKS-Gerät wiederanschalten. SEKTOREN Zeigt Debugging-Meldungen an Diese Hilfe anzeigen Zeigt detailliertere Fehlermeldungen an Fachnummer für den neuen Schlüssel (im Zweifel das nächste leere) LUKS-Gerät ausschalten und alle Schlüssel auslöschen (alle IOs werden eingefroren). Der Algorithmus zum Verschlüsseln der Platte (siehe /proc/crypto) Das Hashverfahren, um den Verschlüsselungsschlüssel aus dem Passsatz zu erzeugen Die »reload«-Aktion ist veraltet. Bitte nutzen Sie »dmsetup reload«, falls Sie das wirklich brauchen.
WARNUNG: Benutzen Sie »reload« nicht, um LUKS-Geräte zu berühren. Drücken Sie in diesem Fall Strg-C.
 Die Größe des Geräts Die Größe des Verschlüsselungsschlüssels Der Startabstand im Backend-Gerät Dies ist das letzte Schlüsselfach. Wenn Sie das auch noch löschen, wird das Gerät unbrauchbar. Diese Operation wird für Kryptogerät %s nicht unterstützt.
 Diese Operation wird nur für LUKS-Geräte unterstützt.
 Hiermit überschreiben Sie Daten auf %s unwiderruflich. Frist für interaktive Eingabe des Passsatzes (in Sekunden) Kann Sektorengröße für %s nicht ermitteln. Unbekannte Aktion. Unbekannte Art des Verschlüsselungsgeräts %s verlangt.
 Nicht unterstützte LUKS-Version %d.
 Verifiziert den Passsatz durch doppeltes Nachfragen Passsatz wiederholen:  Laufwerk %s ist bereits abgeschaltet.
 Laufwerk %s ist nicht aktiv.
 Laufwerk %s ist nicht abgeschaltet.
 Laufwerks-Schlüsselpuffer zu klein.
 Der Laufwerksschlüssel passt nicht zum Laufwerk.
 WARNUNG!!! Möglicherweise unsicherer Speicher. Sind Sie Root?
 Warnung: Ermüdendes Lesen verlangt, aber die Schlüsseldatei %s ist keine reguläre Datei, das könnte ewig dauern.
 Falsches UUID-Format angegeben, generiere neues.
 [OPTION...] <Aktion> <aktionsabhängig>] Schlüssel zu LUKS-Gerät hinzufügen enthält bereits einen LUKS-Kopfbereich. Das Ersetzen des Kopfbereichs wird bestehende Schlüsselfächer zerstören. Gerät erzeugen enthält keinen LUKS-Kopfbereich. Das Ersetzen des Kopfbereichs kann Daten auf dem Gerät zerstören. LUKS-Partitionsinformationen ausgeben exklusiven Formatiert ein LUKS-Gerät identisch zu luksKillSlot - DEPRECATED - siehe Handbuch Schlüsselfach %d zum Löschen ausgewählt.
 Speicherproblem in action_luksFormat aktives Gerät verändern - DEPRECATED - siehe Handbuch msek LUKS-Gerät als Zuordnung <Name> öffnen UUID des LUKS-Geräts ausgeben Lese LUKS-Zuordnung entfernen Gerät entfernen Entfernt bereitgestellten Schlüssel oder Schlüsseldatei vom LUKS-Gerät Größe des aktiven Geräts ändern sek setpriority %u fehlgeschlagen: %s Gerätestatus anzeigen Testet <Gerät> auf Kopfbereich einer LUKS-Partition Löscht Schlüssel mit Nummer <Schlüsselfach> vom LUKS-Gerät Schreib 