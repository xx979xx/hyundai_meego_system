��          �   %   �      P  �   Q  ,   *      W  %   x  5   �    �    �     �  0     /   @     p  6   �     �  R   �  q     p   �  .   �  >   )     h      �     �  !   �  %   �  )   	  /   .	  d  ^	  �   �
  >   �  -   �  4   *  F   _  *  �  %  �  "   �  7     7   R     �  C   �     �  [   �  �   I  �   �  2   x  P   �  )   �  ,   &     S  '   j  <   �  7   �  -                                                                                            	                    
                %s does not end with %%end.  This syntax has been deprecated.  It may be removed from future releases, which will result in a fatal error from kickstart.  Please modify your kickstart file to use this updated syntax. File uses a deprecated option or command.
%s General error in input file:  %s General kickstart error in input file Group cannot specify both --nodefaults and --optional Ignoring deprecated command on line %(lineno)s:  The %(cmd)s command has been deprecated and no longer has any effect.  It may be removed from future releases, which will result in a fatal error from kickstart.  Please modify your kickstart file to remove this command. Ignoring deprecated option on line %(lineno)s:  The %(option)s option has been deprecated and no longer has any effect.  It may be removed from future releases, which will result in a fatal error from kickstart.  Please modify your kickstart file to remove this option. Illegal url for %%ksappend: %s Option %(opt)s: invalid boolean value: %(value)r Option %(opt)s: invalid string value: %(value)r Option %s is required Required flag set for option that doesn't take a value Script The following problem occurred on line %(lineno)s of the kickstart file:

%(msg)s
 The option %(option)s was introduced in version %(intro)s, but you are using kickstart syntax version %(version)s The option %(option)s was removed in version %(removed)s, but you are using kickstart syntax version %(version)s The version %s is not supported by pykickstart There was a problem reading from line %s of the kickstart file Unable to open %%ksappend file Unable to open %%ksappend file:  Unknown command: %s Unsupported version specified: %s halt after the first error or warning parse include files when %include is seen version of kickstart syntax to validate against Project-Id-Version: fr
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2007-10-04 13:22-0400
PO-Revision-Date: 2007-10-26 21:50+0200
Last-Translator: Thomas Canniot <mrtom@fedoraproject.org>
Language-Team: Français <fedora-trans-fr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Generator: KBabel 1.11.4
 %s ne se termine pas par %%end. Cette syntaxe a été dépréciée. Elle pourra être supprimée lors de futures versions, ce qui provoquera une erreur fatale de kickstart. Merci de modifier votre fichier kickstart et d'utiliser la nouvelle syntaxe. Le fichier utilise une option ou une commande dépréciée.
%s Erreur générale dans le fichier source : %s Erreur générale de kickstart due au fichier source Le groupe ne peut pas à la fois spécifier --nodefaults et --optional Ignorer la commande dépréciée sur la ligne %(lineno)s : La commande %(cmd)s a été dépréciée et n'a plus d'effet. Elle pourra être supprimée lors de futures versions, ce qui provoquera une erreur fatale de kickstart.  Merci de modifier votre fichier kickstart et de retirer cette commande. Ignorer l'option dépréciée sur la ligne %(lineno)s : L'option %(option)s a été dépréciée et n'a plus d'effet. Elle pourra être supprimée lors de futures versions, ce qui provoquera une erreur fatale de kickstart.  Merci de modifier votre fichier kickstart et de retirer cette option. URL illégale pour %%ksappend : %s Option %(opt)s : valeur booléenne invalide : %(value)r Option %(opt)s : valeur de chaîne invalide : %(value)r L'option %s est requise L'ensemble des paramètres pour cette option ne prend aucune valeur Script Le problème suivant s'est produit sur la ligne %(lineno)s du fichier kickstart :

%(msg)s
 L'option %(option)s a été implémentée dans la version %(intro)s, mais vous utilisez la syntaxe de kickstart correspondant à la version %(version)s L'option %(option)s a été supprimée dans la version %(removed)s, mais vous utilisez la syntaxe de kickstart correspondant à la version %(version)s La version %s n'est pas supportée par pykickstart Un problème  est survenu lors de la lecture de la ligne %s du fichier kickstart Impossible d'ouvrir le fichier %%ksappend Impossible d'ouvrir le fichier %%ksappend :  Commande inconnue : %s Version spécifiée non supportée : %s arrêt après le premier message d'avertissement ou d'erreur analyse les fichiers inclus quand %include est observé Version de la syntaxe de kickstart à valider 