��          �   %   �      P  �   Q  ,   *      W  %   x  5   �    �    �     �  0     /   @     p  6   �     �  R   �  q     p   �  .   �  >   )     h      �     �  !   �  %   �  )   	  /   .	  U  ^	  c  �
  ]     2   v  B   �  L   �  �  9  �  �  (   M  9   v  9   �  "   �  Q        _  e   o  �   �  �   �  O   V  X   �  )   �  +   )     U  L   o  0   �  K   �  <   9                                                                                         	                    
                %s does not end with %%end.  This syntax has been deprecated.  It may be removed from future releases, which will result in a fatal error from kickstart.  Please modify your kickstart file to use this updated syntax. File uses a deprecated option or command.
%s General error in input file:  %s General kickstart error in input file Group cannot specify both --nodefaults and --optional Ignoring deprecated command on line %(lineno)s:  The %(cmd)s command has been deprecated and no longer has any effect.  It may be removed from future releases, which will result in a fatal error from kickstart.  Please modify your kickstart file to remove this command. Ignoring deprecated option on line %(lineno)s:  The %(option)s option has been deprecated and no longer has any effect.  It may be removed from future releases, which will result in a fatal error from kickstart.  Please modify your kickstart file to remove this option. Illegal url for %%ksappend: %s Option %(opt)s: invalid boolean value: %(value)r Option %(opt)s: invalid string value: %(value)r Option %s is required Required flag set for option that doesn't take a value Script The following problem occurred on line %(lineno)s of the kickstart file:

%(msg)s
 The option %(option)s was introduced in version %(intro)s, but you are using kickstart syntax version %(version)s The option %(option)s was removed in version %(removed)s, but you are using kickstart syntax version %(version)s The version %s is not supported by pykickstart There was a problem reading from line %s of the kickstart file Unable to open %%ksappend file Unable to open %%ksappend file:  Unknown command: %s Unsupported version specified: %s halt after the first error or warning parse include files when %include is seen version of kickstart syntax to validate against Project-Id-Version: ja
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2007-10-04 13:22-0400
PO-Revision-Date: 2007-10-06 16:22+0900
Last-Translator: Hyu_gabaru Ryu_ichi <hyu_gabaru@yahoo.co.jp>
Language-Team: Japanese <ja@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Generator: KBabel 1.9.1
 %s が %%end で終わっていません。この構文は廃止予定になっています。将来のリリースでは削除される可能性があり、キックスタートの致命的なエラーとなります。使用中のキックスタートファイルを修正し、これの更新された構文を使用するようにしてください。 ファイルは無用になったオプションかコマンドを使用しています。
%s 入力ファイル内の一般的なエラー:  %s 入力ファイル内の一般的なキックスタートエラー --nodefaults と --optional の両方のグループは指定できません %(lineno)s 行の廃止されたコマンドを無視します: %(cmd)s コマンドは廃止されており、どんな効果も持ちません。将来のリリースでは削除される可能性があり、キックスタートの致命的なエラーとなります。使用中のキックスタートファイルを修正して、このコマンドを取り除いてください。 %(lineno)s 行の廃止されたオプションを無視します: %(option)s オプションは廃止されており、どんな効果も持ちません。将来のリリースでは削除される可能性があり、キックスタートの致命的なエラーとなります。使用中のキックスタートファイルを修正して、このオプションを取り除いてください。 %%ksappend としては不正な url: %s オプション %(opt)s: 無効なブール値: %(value)r オプション %(opt)s: 無効な文字列値: %(value)r オプション %s は必須です 値を取らないオプションに必要なフラグが設定されています スクリプト 以下の問題がキックスタートファイルの %(lineno)s 行で発生しました:

%(msg)s
 オプション %(option)s はバージョン %(intro)s 内で紹介されていますが、ユーザーはキックスタート構文のバージョン %(version)s を使用しています。 オプション %(option)s はバージョン %(removed)s の中で削除されていますが、ユーザーはキックスタート構文バージョン %(version)s を使用しています バージョン %s はキックスタートでサポートされていません キックスタートファイルの %s の行の読み込みに問題がありました %%ksappend ファイルを開けません %%ksappend ファイルを開けません:  不明なコマンド: %s サポートされていないバージョンが指定されています: %s 最初のエラーまたは警告で停止する %include が表示された時に include ファイルを構文解析する 確証対象のキックスタート構文のバージョン 