��          �   %   �      P  �   Q  ,   *      W  %   x  5   �    �    �     �  0     /   @     p  6   �     �  R   �  q     p   �  .   �  >   )     h      �     �  !   �  %   �  )   	  /   .	  �  ^	  T    �   a  ]     ~   _  �   �  �  h  �  4  <     W   @  W   �  E   �  �   6       �   (    �    �  Z   �  _   U  :   �  <   �  &   -  [   T  �   �  g   F  y   �                                                                                         	                    
                %s does not end with %%end.  This syntax has been deprecated.  It may be removed from future releases, which will result in a fatal error from kickstart.  Please modify your kickstart file to use this updated syntax. File uses a deprecated option or command.
%s General error in input file:  %s General kickstart error in input file Group cannot specify both --nodefaults and --optional Ignoring deprecated command on line %(lineno)s:  The %(cmd)s command has been deprecated and no longer has any effect.  It may be removed from future releases, which will result in a fatal error from kickstart.  Please modify your kickstart file to remove this command. Ignoring deprecated option on line %(lineno)s:  The %(option)s option has been deprecated and no longer has any effect.  It may be removed from future releases, which will result in a fatal error from kickstart.  Please modify your kickstart file to remove this option. Illegal url for %%ksappend: %s Option %(opt)s: invalid boolean value: %(value)r Option %(opt)s: invalid string value: %(value)r Option %s is required Required flag set for option that doesn't take a value Script The following problem occurred on line %(lineno)s of the kickstart file:

%(msg)s
 The option %(option)s was introduced in version %(intro)s, but you are using kickstart syntax version %(version)s The option %(option)s was removed in version %(removed)s, but you are using kickstart syntax version %(version)s The version %s is not supported by pykickstart There was a problem reading from line %s of the kickstart file Unable to open %%ksappend file Unable to open %%ksappend file:  Unknown command: %s Unsupported version specified: %s halt after the first error or warning parse include files when %include is seen version of kickstart syntax to validate against Project-Id-Version: pykickstart.master
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2007-10-04 13:22-0400
PO-Revision-Date: 2008-03-11 12:58+0530
Last-Translator: Runa Bhattacharjee <runab@fedoraproject.org>
Language-Team: Bengali INDIA <fedora-trans-bn_IN@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Generator: KBabel 1.11.4
Plural-Forms: nplurals=2; plural=(n != 1);



 %s-র শেষে %%end প্রয়োগ করা হয় না। এই সিন্টেক্স বর্তমানে অবচিত হয়েছে।  ভবিষ্যতের কোনো রিলিজে এটি অপসারণ করা হবে যার ফলে kickstart কর্মের সময় গুরুতর ত্রুটির ইঙ্গিত দেওয়া হবে। নতুন সিন্টেক্স ব্যবহার করে kickstart ফাইলটি অনগ্রহ করে পরিবর্তন করুন। ফাইলের মধ্যে কোনো অবিচত অপশন অথবা কমান্ড প্রয়োগ করা হয়েছে।
%s ইনপুট ফাইলের মধ্যে সাধারণ সমস্যা:  %s ইনপুট ফাইলের মধ্যে kickstart সংক্রান্ত সাধারণ সমস্যা দল দ্বারা --nodefaults ও --optional উভয় একযোগে নির্ধারণ করা যাবে না %(lineno)s পংক্তির মধ্যে উল্লিখিত অবচিত বিকল্প অগ্রাহ্য করা হচ্ছে:  %(cmd)s বিকল্পটি অবচিত হয়েছে ও বর্তমানে কোনো প্রভাব সৃষ্টি করে না। ভবিষ্যতের কোনো রিলিজে এটি অপসারণ করা হবে যার ফলে kickstart কর্মের সময় গুরুতর ত্রুটির ইঙ্গিত দেওয়া হবে। অনুগ্রহ করে kickstart ফাইল থেকে এই বিকল্পটি মুছে ফেলুন। %(lineno)s পংক্তির মধ্যে উল্লিখিত অবচিত বিকল্প অগ্রাহ্য করা হচ্ছে:  %(option)s বিকল্পটি অবচিত হয়েছে ও বর্তমানে কোনো প্রভাব সৃষ্টি করে না। ভবিষ্যতের কোনো রিলিজে এটি অপসারণ করা হবে যার ফলে kickstart কর্মের সময় গুরুতর ত্রুটির ইঙ্গিত দেওয়া হবে। অনুগ্রহ করে kickstart ফাইল থেকে এই বিকল্পটি মুছে ফেলুন। %%ksappend-র ক্ষেত্রে অবৈধ url: %s %(opt)s বিকল্প: বুলিয়ান মান বৈধ নয়: %(value)r %(opt)s বিকল্প: স্ট্রিং মান বৈধ নয়: %(value)r %s বিকল্প উল্লেখ করা আবশ্যক কোনো মান গ্রহণ করতে অক্ষম বিকল্পের জন্য আবশ্যক মানের ফ্ল্যাগ নির্ধারণ করা হয়েছে স্ক্রিপ্ট kickstart ফাইলের %(lineno)s পংক্তির মধ্যে নিম্নলিখিত সমস্যা উৎপন্ন হয়েছে:

%(msg)s
 %(option)s বিকল্পটি %(intro)s সংস্করণে প্রস্তুত করা হয়েছে। আপনি বর্তমানে kickstart সিন্টেক্স সংস্করণ %(version)s ব্যবহার করছেন। %(option)s বিকল্পটি %(removed)s সংস্করণে অপসারণ করা হয়েছে। আপনি বর্তমানে kickstart সিন্টেক্স সংস্করণ %(version)s ব্যবহার করছেন। %s সংস্করণটি pykickstart দ্বারা সমর্থিত নয় Kickstart ফাইলের %s পংক্তি থেকে পড়তে সমস্যা %%ksappend ফাইল খুলতে ব্যর্থ %%ksappend ফাইল খুলতে ব্যর্থ:  অজানা কমান্ড: %s অসমর্থিত সংস্করণ উল্লিখিত হয়েছে: %s প্রথম ত্রুটি অথবা সতর্কবার্তা উৎপন্ন হলে স্থগিত করা হবে %include প্রদর্শিত হলে include ফাইল পার্স করা হবে যে kickstart সিন্টেক্স সংস্করণের সাথে যাচাই করা হবে 