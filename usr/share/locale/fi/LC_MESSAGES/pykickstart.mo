��          �   %   �      P  �   Q  ,   *      W  %   x  5   �    �    �     �  0     /   @     p  6   �     �  R   �  q     p   �  .   �  >   )     h      �     �  !   �  %   �  )   	  /   .	  �  ^	  �   *  G   �  #   4  )   X  ?   �  �   �    �  &   �  4   �  8   #     \  7   r     �  L   �  n     n   s     �  4     !   6  #   X     |  !   �  4   �  2   �  5                                                                                            	                    
                %s does not end with %%end.  This syntax has been deprecated.  It may be removed from future releases, which will result in a fatal error from kickstart.  Please modify your kickstart file to use this updated syntax. File uses a deprecated option or command.
%s General error in input file:  %s General kickstart error in input file Group cannot specify both --nodefaults and --optional Ignoring deprecated command on line %(lineno)s:  The %(cmd)s command has been deprecated and no longer has any effect.  It may be removed from future releases, which will result in a fatal error from kickstart.  Please modify your kickstart file to remove this command. Ignoring deprecated option on line %(lineno)s:  The %(option)s option has been deprecated and no longer has any effect.  It may be removed from future releases, which will result in a fatal error from kickstart.  Please modify your kickstart file to remove this option. Illegal url for %%ksappend: %s Option %(opt)s: invalid boolean value: %(value)r Option %(opt)s: invalid string value: %(value)r Option %s is required Required flag set for option that doesn't take a value Script The following problem occurred on line %(lineno)s of the kickstart file:

%(msg)s
 The option %(option)s was introduced in version %(intro)s, but you are using kickstart syntax version %(version)s The option %(option)s was removed in version %(removed)s, but you are using kickstart syntax version %(version)s The version %s is not supported by pykickstart There was a problem reading from line %s of the kickstart file Unable to open %%ksappend file Unable to open %%ksappend file:  Unknown command: %s Unsupported version specified: %s halt after the first error or warning parse include files when %include is seen version of kickstart syntax to validate against Project-Id-Version: pykickstart
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2007-10-04 13:22-0400
PO-Revision-Date: 2007-10-05 20:15+0300
Last-Translator: Ville-Pekka Vainio <vpivaini@cs.helsinki.fi>
Language-Team: Finnish <laatu@lokalisointi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Poedit-Language: Finnish
X-Poedit-Country: Finland
X-Generator: KBabel 1.11.4
Plural-Forms: nplurals=2; plural=(n != 1);
 %s ei pääty %%end.  Tämä syntaksi on vanhentunut.  Se voidaan poistaa tulevista versioista, josta seuraa vakava kickstart-virhe.  Muokkaa kickstart-tiedostoa käyttämään uutta syntaksia. Tiedosto käyttää käytöstä poistunutta valitsinta tai komentoa.
%s Yleinen virhe syötetiedostossa: %s Yleinen kickstart-virhe syötetiedostossa Ryhmä ei voi määrittää sekä --nodefaults että --optional Jätetään huomiotta vanhentunut komento rivillä %(lineno)s:  Komento %(cmd)s on vanhentunut eikä sillä ole enää vaikutusta. Se voidaan poistaa tulevista versioista, josta seuraa vakava kickstart-virhe.  Poista tämä valitsin kickstart-tiedostosta. Jätetään huomiotta vanhentunut valitsin rivillä %(lineno)s:  Valitsin %(option)s on vanhentunut eikä sillä ole enää vaikutusta. Se voidaan poistaa tulevista versioista, josta seuraa vakava kickstart-virhe.  Poista tämä valitsin kickstart-tiedostosta. Tiedoston %%ksappend URL ei kelpaa: %s Valitsin %(opt)s: virheellinen totuusarvo: %(value)r Valitsin %(opt)s: virheellinen merkkijonoarvo: %(value)r Valitsin %s vaaditaan Vaadittu lippu asetettu valitsimelle, joka ei ota arvoa Komentosarja Seuraava ongelma tapahtui kickstart-tiedoston rivillä %(lineno)s:

%(msg)s
 Valitsin %(option)s esiteltiin versiossa %(intro)s, mutta käytössä on kicstart-syntaksin versio %(version)s Valitsin %(option)s poistettiin versiossa %(removed)s, mutta käytät kickstart-syntaksin versiota %(version)s Pykickstart ei tue versiota %s Kickstart-tiedoston rivin %s lukemisessa oli ongelma Tiedostoa %%ksappend ei voi avata Tiedostoa %%ksappend ei voi avata:  Tuntematon komento: %s Tukematon versio määritetty: %s lopeta ensimmäisen virheen tai varoituksen jälkeen jäsennä include-tiedostot kun %include huomataan versio kickstart-syntaksista, jota vasten validoidaan 