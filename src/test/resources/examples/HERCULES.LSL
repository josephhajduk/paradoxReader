MZP      €€  Є       @                                   Р   Ї і	Ќ!ЄLЌ!РРThis program must be run under Microsoft Windows.
$            NE
!
     	Г                @ P !!ї     
           P   q  Б      0А    Б     0 0А    Б     1'0А     Б     X 0А    Б     `9 0А    	Б     Щ…0А    А     b 0А    m 0А    | 0А    З
 0А      Hercules  LIBENTRY  WEP             Є ЋЄ Ћ                                         !Borland Standard File           ю         @   |              ю А~ ю      @       	ю               ю              ю               ю               ю               ю АF Library   Form   UIManager   UIContainer   UIObject   	ю АТ  АМ€€€€€€sT-                                             open+ close+ canArrive2 arrive2 setFocus+ canDepart2 removeFocus+ depart2 mouseEnter, mouseExit, mouseMove, mouseDown, mouseUp, mouseDouble, mouseRightDown, mouseRightUp, mouseRightDouble, keyPhysical- keyChar- action. menuAction/ timer4 pushButton+ changeValue0 calcField+ run+ newValue+ proc+ error3 status1 mouseClick, init+ Uses Type Var Const Proc handleRequest enterNewCustomer buildSearchForm outputMailList outputCustTF outputFilteredMailList fetchTemplate outputCityOptionList ю АP € АJ€€                   A  b    АФ  €€ #b ;// This generic handleRequest method must exist
;// in any ObjectPAL handler libraries - it is
;// called by the WebServer when a request is
;// received.
;//
method handleRequest(strHandler String, var Request OleAuto, var Response OleAuto) Logical

	;// This is a list of the URIs that the HERCULES library
   ;// knows how to handle.
   ;//
	switch
   	case (lower(strHandler) = "enter_new_customer") :
      	return enterNewCustomer(Request, Response)

   	case (lower(strHandler) = "build_search_form") :
      	return buildSearchForm(Request, Response)

   	case (lower(strHandler) = "output_mail_list") :
      	return outputMailList(Request, Response)

   	case (lower(strHandler) = "output_filtered_mail_list") :
      	return outputFilteredMailList(Request, Response)

		otherwise :
      	return FALSE

	endSwitch

endMethod
 handleRequest $% ;// This method inserts a new customer into the
;// Customer table from the HTML form named NEWCUST
;//
method enterNewCustomer(var Request OleAuto, var Response OleAuto) Logical
var
	strFName,
   strLName,
   strEMail,
   strAddress,
   strCity,
   strState,
   strZip,
   strComments,
   strResult		String
endVar

   strFName		= Request.GetField("FirstName")
   strLName		= Request.GetField("LastName")
   strEMail		= Request.GetField("EMail")
   strAddress	= Request.GetField("Address")
   strCity		= Request.GetField("City")
   strState		= Request.GetField("State")
   strZip		= Request.GetField("Zip")
   strComments	= Request.GetField("Comments")

{	msgInfo("Input Info", string(
		"FirstName: ", strFName, "\n",
		"LastName: ", strLName, "\n",
		"EMail: ", strEMail, "\n",
		"Address: ", strAddress, "\n",
		"City: ", strCity, "\n",
		"State: ", strState, "\n",
		"Zip: ", strZip, "\n",
		"Comments: ", strComments))}

	tcCustomer.edit()
   tcCustomer.insertRecord()

	tcCustomer."FirstName" = strFName
	tcCustomer."LastName" = strLName
	tcCustomer."EMail" = strEMail
	tcCustomer."Street" = strAddress
	tcCustomer."City" = strCity
	tcCustomer."State/Prov" = strState
	tcCustomer."Zip/Postal Code" = strZip
	tcCustomer."Comments" = strComments
	tcCustomer."DateEntered" = today()

	tcCustomer.postRecord()
   tcCustomer.endEdit()

	Response.ResultString = string(
		fetchTemplate("HTML_HEADER1"),

      "Thanks for Joinging the Mailing List",

		fetchTemplate("HTML_HEADER2"),
		fetchTemplate("HERC_BODY"),
		fetchTemplate("NEW_CUST1"),

      strFName, " ", strLName,

		fetchTemplate("NEW_CUST2"),

      tcCustomer."CustNo",

		fetchTemplate("NEW_CUST3"),
		fetchTemplate("PDOX_SERVER"),
		fetchTemplate("HTML_FOOTER") )

	return TRUE

endMethod
 enterNewCustomer %2 method buildSearchForm(var Request OleAuto, var Response OleAuto) Logical
var
	strResult		String
endVar

	strResult = string(
		fetchTemplate("HTML_HEADER1"),

      "Search the Glass Sculpture Enthusiasts List",

		fetchTemplate("HTML_HEADER2"),
		fetchTemplate("HERC_BODY"),
		fetchTemplate("SEARCH_LIST1"),

      outputCityOptionList(),

		fetchTemplate("SEARCH_LIST2"),
		fetchTemplate("PDOX_SERVER"),
		fetchTemplate("HTML_FOOTER") )

	Response.Expires = dateTime()
   Response.ResultString = strResult

   return TRUE

endMethod
 buildSearchForm АT  Var

	tcCustomer		TCursor
   tcTemplate		TCursor
   strPath			String

endVar
 Var   Ш method open(var eventInfo Event)
var
	dynFile		DynArray[] String
endVar

	splitFullFileName(getFileName(), dynFile)
   strPath = dynFile["DRIVE"] + dynFile["PATH"]

	if (NOT tcCustomer.open(strPath + "Customer.DB")) then
   	eventInfo.setErrorCode(CANNOTARRIVE)
   endIf

  	if (NOT tcTemplate.open(strPath + "Hercules.DB")) then
   	eventInfo.setErrorCode(CANNOTARRIVE)
   endIf

endMethod
 open+ АD  Const

	FID_TPL_TEMPLATE		= 1
   FID_TPL_HTML			= 2

endConst
 Const &Э ;// This method dumps out the entire mailing list from the Customer table.
;//
method outputMailList(var Request OleAuto, var Response OleAuto) Logical
var
	strResponse		String
endVar

	strResponse = string(
		fetchTemplate("HTML_HEADER1"),

      "Hercules Glass Company Mailing List",

		fetchTemplate("HTML_HEADER2"),
		fetchTemplate("HERC_BODY"),
		fetchTemplate("MAIL_LIST1"),

      outputCustTF(""),		;// output the unfiltered Customer List

		fetchTemplate("MAIL_LIST2"),
		fetchTemplate("PDOX_SERVER"),
		fetchTemplate("HTML_FOOTER") )

	Response.Expires = dateTime()
   Response.ResultString = strResponse

	return TRUE

endMethod
 outputMailList 'Т method outputCustTF(strCity String) String
var
	strStream	String
endVar

	if strCity.isBlank() then
   	tcCustomer.switchIndex()
      tcCustomer.setRange()
   else
   	tcCustomer.switchIndex("City")
    	tcCustomer.setRange(strCity, strCity)
   endIf

   if (tcCustomer.nRecords() > 0) then
   	strStream = fetchTemplate("CUSTTF_HEADER")

   	scan tcCustomer :
	     	strStream = strStream + string(
         	"<TR><TD>",
            tcCustomer."FirstName", " ",
            tcCustomer."LastName",
            "</TD><TD>",
            "<A HREF=\"mailto:",
            tcCustomer."EMail",
            "\">",
            tcCustomer."EMail",
            "</A>",
            "</TD></TR>\n")
      endScan

     	strStream = strStream + "</TABLE>\n"
   else
   	strStream = blank()
   endIf

  	tcCustomer.switchIndex()
   tcCustomer.setRange()

   return strStream

endMethod
 outputCustTF (б ;// This method dumps out the entire mailing list from the Customer table.
;//
method outputFilteredMailList(var Request OleAuto, var Response OleAuto) Logical
var
	strResponse		String
   strCity			String
   strOutput		String
endVar

	strCity = Request.GetField("City")
   strOutput = outputCustTF(strCity)

   if (strOutput.isBlank()) then
   	strOutput = string(
      	fetchTemplate("NOBODY_IN_CITY1"), strCity,
      	fetchTemplate("NOBODY_IN_CITY2") )
   endIf

	strResponse = string(
		fetchTemplate("HTML_HEADER1"),

      "Hercules Glass Company Mailing List",

		fetchTemplate("HTML_HEADER2"),
		fetchTemplate("HERC_BODY"),
		fetchTemplate("FILTERED_MAIL_LIST1"),

      strCity,

		fetchTemplate("FILTERED_MAIL_LIST2"),

      strOutput,

		fetchTemplate("FILTERED_MAIL_LIST3"),
		fetchTemplate("PDOX_SERVER"),
		fetchTemplate("HTML_FOOTER") )

	Response.Expires = dateTime()
   Response.ResultString = strResponse

	return TRUE

endMethod
 outputFilteredMailList )Є  method fetchTemplate(strTemplate String) String

	if (NOT tcTemplate.qLocate(strTemplate)) then
   	return ""
   else
   	return tcTemplate.(FID_TPL_HTML)
   endIf

endMethod
 fetchTemplate *… method outputCityOptionList() String
var
	strList		String
	qbe			Query
   tcCities		TCursor
endVar

	qbe.appendTable(strPath + "Customer")
   qbe.checkField(strPath + "Customer", "City", CHECKCHECK)
   qbe.executeQBE(tcCities)

	strList.blank()

   scan tcCities :
   	strList = strList + string(
      	"<OPTION VALUE=\"",
      	tcCities.(1),
      	"\"> ",
      	tcCities.(1),
      	"\n" )
	endScan

	return strList

endMethod
 outputCityOptionList    p        A  b    ]                                               ААА †  †    Щ                   ѕ .    >  €€€€        А ю А
     ю А   ю А                                 `  V   ±       Ќ  €€€€                  Ї            …                   d                       €€€€    §                                                              Щ  Q  …   Ѕ           	CONTAINER     т   Ѕ      €€€€±               €€€€            d  \  b  ACTIVE     >       €€€€±               €€€€            Ї  ≤      LASTMOUSECLICKED     Ф  \     €€€€±               €€€€              €      SUBJECT     б  ≤     €€€€±               €€€€            b  Z      LASTMOUSERIGHTCLICKED     <  €     €€€€±               €€€€                        SELF     Ж  Z     €€€€±               €€€€                	#LIBRARY1     Ќ  §     €€€€±  ?             €€€€[                 R
                              T          г                              S                                                                          7            	                          Y                                      Ї       FID_TPL_TEMPLATE         FID_TPL_HTML        
TCCUSTOMER   А   L      
TCTEMPLATE   »   L      STRPATH     V               €€€€Ќ                                                                      HANDLEREQUEST      л  #     –   METHOD_SELFV   
STRHANDLERҐ   REQUESTҐ   RESPONSE             €€€€l                                  №      К              І          METHOD_SELF    –  √  
STRHANDLER    V      REQUEST    Ґ      RESPONSE    Ґ                       €€€€Ќ                                                                  н  ENTERNEWCUSTOMER      л  $     –   METHOD_SELFҐ   REQUESTҐ   RESPONSE             €€€€ю          √  №          І      B  Y        +      )  s  Н  METHOD_SELF    –      REQUEST    Ґ      RESPONSE    Ґ  ¬  ц               €€€€Ќ                                                                  ґ  BUILDSEARCHFORM      л  %     –   METHOD_SELFҐ   REQUESTҐ   RESPONSE             €€€€d                                  І      q      F      О          METHOD_SELF    –      REQUEST    Ґ      RESPONSE    Ґ  T  \               €€€€Ќ                                                                  Щ  OPEN                  –   METHOD_SELFо   	EVENTINFO             €€€€…                              ў	          Љ	                  a      METHOD_SELF    –      	EVENTINFO    о  Ї  Ѕ               €€€€Ќ                                                                      OUTPUTMAILLIST      л  &     –   METHOD_SELFҐ   REQUESTҐ   RESPONSE             €€€€ь	                                  >  П                %          METHOD_SELF    –      REQUEST    Ґ      RESPONSE    Ґ  	  ф	               €€€€Ќ                                                                      OUTPUTCUSTTF      V  '     –   METHOD_SELFV   STRCITY             €€€€`  ђ      v                              Y                          METHOD_SELF    –      STRCITY    V  R
  X               €€€€Ќ                                                                      OUTPUTFILTEREDMAILLIST      л  (     –   METHOD_SELFҐ   REQUESTҐ   RESPONSE             €€€€Ч          д                      б  «  Ђ              »          METHOD_SELF    –  э  REQUEST    Ґ      RESPONSE    Ґ  ґ  П               €€€€Ќ                                                                  ¬  FETCHTEMPLATE      V  )     –   METHOD_SELFV   STRTEMPLATE             €€€€                                                                  METHOD_SELF    –      STRTEMPLATE    V  н  ы               €€€€Ќ                                                                      OUTPUTCITYOPTIONLIST      V  *     –   METHOD_SELF             €€€€C  1  F                                  4                        METHOD_SELF    –  Y  ;      STRFNAME  Љю€€V      STRLNAME  Ўю€€V      STREMAIL  фю€€V  ц  
STRADDRESS  €€€V    STRCITY  ,€€€V      STRSTATE  H€€€V      STRZIP  d€€€V      STRCOMMENTS  А€€€V      	STRRESULT  Ь€€€V      	STRRESULT  Ь€€€V      DYNFILE  t€€€ z     8       V          STRRESPONSE  Ь€€€V      	STRSTREAM  Ь€€€V      STRRESPONSE  Ь€€€V      STRCITY  А€€€V      	STROUTPUT  d€€€V      STRLIST  Ь€€€V      QBE  $€€€e      TCCITIES  №ю€€L                  rВ  €       Й                                                                                                            О  rВЙ     €    Ж  r      
   @   W  `                                                                                                                                                                                     "  >  rВ 	             †
  †
  Ѕ                          	   
            #                                                  $  ,  ,  ,                                            $   %   '   (   )   *   +   ,   -   .   /   1   2   4   G   I   %  X  X  H                                   &  a  a  ^                                   '  њ  њ  ™                             
                     !   $   %   '   )   (  i  i  q                 	   
               &   '   )   +   )  Џ  Џ  ь                              	   *  ÷  ÷  L                       	   
                    Ж  РРРй        ит€€€     #   4   4        ћ   #   4   Ь€€€   
 Ь€€€ ,  %Р€€€P9    #   4   Д€€€,   
   
$$   (t G  B  Ь€€€   
 Ь€€€ H  %Р€€€P9    #   4   Д€€€,   
   
$%   (t з   в   Ь€€€   
 Ь€€€ d  %Р€€€P9    #   4   Д€€€,   
   
$&   (t З   В   Ь€€€   
 Ь€€€ А  %Р€€€P9    #   4   Д€€€,   
   
$(   (t '   "    #   4    Ь     (t      #   4        $   Ь€€€    Д€€€    Р€€€              и“э€€     $   ґ   Ф       е   $   ґ   Љю€€|ю€€   
 ®  -   А *t  $   ґ   Ўю€€|ю€€   
 ƒ  -   А *t  $   ґ   фю€€|ю€€   
 а  -   А *t  $   ґ   €€€|ю€€   
 ь  -   А *t  $   ґ   ,€€€|ю€€   
   -   А *t  $   ґ   H€€€|ю€€   
 4  -   А *t  $   ґ   d€€€|ю€€   
 P  -   А *t  $   ґ   А€€€|ю€€   
 l  -   А *t  $$   ґ   pю€€ А    pю€€ $%   ґ   pю€€ А    pю€€ $'   ґ    А    ®  %ю€€TЉю€€*t  $(   ґ    А    ƒ  %ю€€TЎю€€*t  $)   ґ    А    а  %ю€€Tфю€€*t  $*   ґ    А    И  %ю€€T€€€*t  $+   ґ    А      %ю€€T,€€€*t  $,   ґ    А    §  %ю€€TH€€€*t  $-   ґ    А    ј  %ю€€Td€€€*t  $.   ґ    А    l  %ю€€TА€€€*t  $/   ґ    А    №  %ю€€T ю€€  
 ю€€*t  $1   ґ   pю€€ А    qpю€€ $2   ґ   pю€€ А    pю€€ $4   ґ      
  $ь€€»э€€, ш  &дэ€€Р $)   Рэ€€, 0  &ђэ€€Р $)Xэ€€, L  &tэ€€Р $) э€€, h  &<э€€Р $)Љю€€ Д  Ўю€€иь€€, †  &э€€Р $) А    Љ  %ю€€T∞ь€€, Ў  &ћь€€Р $)xь€€, ф  &Фь€€Р $)@ь€€,   &\ь€€Р $)  4 
!8 )8 $G   ґ    ,     (t      $I   ґ          А€€€    $ь€€    @ь€€    \ь€€    |ю€€    xь€€    Фь€€    Ь€€€    ∞ь€€    ћь€€    ю€€    Љю€€    иь€€    э€€    pю€€    Ўю€€     э€€    <э€€    фю€€    Xэ€€    tэ€€    €€€    Рэ€€    ђэ€€    ,€€€    H€€€    »э€€    дэ€€    d€€€     ю€€              и¶ч€€     %      м       m   %      Ь€€€№э€€d€€€, ш  &А€€€Р $) 8  ,€€€, 0  &H€€€Р $)фю€€, L  &€€€Р $)Љю€€, T  &Ўю€€Р $)†ю€€,$*hю€€, p  &Дю€€Р $)0ю€€, ф  &Lю€€Р $)шэ€€,   &ю€€Р $) 	 $ 
!( *Р  %         
!  ћэ€€  	ћэ€€)8 %         
  Ь€€€)8 %       ,     (t      %           Ђ   ћэ€€	    №э€€    шэ€€    ю€€    0ю€€    Lю€€    hю€€    Дю€€    d€€€    †ю€€    Љю€€    Ўю€€    А€€€    фю€€    €€€    ,€€€    H€€€    Ь€€€              и^х€€          f	   x        K  ђ€€€       f	   X€€€  +X€€€t€€€ =      f	      t€€€ М  рt€€€ ®  р%X€€€(*Р    	   f	   L€€€ А       ƒ  %X€€€( L€€€&@€€€р      
   f	      
 а   	+      f	   L€€€ »       и  %X€€€( L€€€&@€€€р         f	      
 а   	+      f	        ;   t€€€1   ђ€€€    @€€€    L€€€    X€€€                    
  + иЭу€€     &   ≤
          z   &   ≤
   Ь€€€јэ€€d€€€, ш  &А€€€Р $)   ,€€€, 0  &H€€€Р $)фю€€, L  &€€€Р $)Љю€€,    &Ўю€€Р $)Дю€€, <  &†ю€€Р $'Lю€€, X  &hю€€Р $)ю€€, ф  &0ю€€Р $)№э€€,   &шэ€€Р $) 	 $ 
!( *Р  &   ≤
      
!  ∞э€€  	∞э€€)8 &   ≤
      
  Ь€€€)8 &   ≤
    ,     (t      &   ≤
        і   ∞э€€	    јэ€€    №э€€    шэ€€    ю€€    0ю€€    Lю€€    hю€€    Ь€€€    Дю€€    †ю€€    d€€€    Љю€€    Ўю€€    А€€€    фю€€    €€€    ,€€€    H€€€              и?с€€     '      T          '      Р€€€   
 Р€€€N    '      Д€€€ А    eД€€€ '      Р€€€ А      Ъ! Z    '
      Р€€€ А       cР€€€ '      Р€€€ А      
   
   Ъ!  '      x€€€ А    x€€€ t  %Р€€€HR   '      Ь€€€@€€€, |  &\€€€Р $)*Р  '      Р€€€ А    ЗД€€€ А    ИД€€€&4€€€рі    '      Ь€€€Ь€€€\€€€ Ш   А    ®  %–ю€€T Д   А    ƒ  %lю€€T і   –   А    а  %ю€€T м   А    а  %§э€€T    $    , 
!0 %@€€€(*Р Р€€€ А    Й+€€€ '      Ь€€€Ь€€€ @  %\€€€(*Р '    '!      Ь€€€dэ€€  dэ€€*t  '$      Р€€€ А    eР€€€ '%      Р€€€ А      Ъ!  ''      Ь€€€   (Р      ')           u   dэ€€    4€€€    @€€€    §э€€    \€€€    ю€€    Р€€€    Ь€€€    lю€€    –ю€€    x€€€    Д€€€              иХн€€     (   U   М       i   (
   U   А€€€$€€€   
   -   А *t  (   U   d€€€мю€€,А€€€&€€€Р $'*Р  (   U   аю€€d€€€ аю€€]    (   U   d€€€Мю€€мю€€, \  &€€€Р $)А€€€®ю€€, x  &ƒю€€Р $)   
! *Р  (   U   Ь€€€<э€€мю€€, ш  &€€€Р $)   ®ю€€, 0  &ƒю€€Р $)pю€€, L  &Мю€€Р $)8ю€€, Ф  &Tю€€Р $)А€€€ ю€€, ∞  &ю€€Р $)d€€€»э€€, ћ  &дэ€€Р $)Рэ€€, ф  &ђэ€€Р $)Xэ€€,   &tэ€€Р $)  , 
!0 *Р  (&   U      
!  ,э€€  	,э€€)8 ('   U      
  Ь€€€)8 ()   U    ,     (t      (+   U        Ў   ,э€€	    <э€€    Xэ€€    tэ€€    Рэ€€    ђэ€€    »э€€    дэ€€    €€€     ю€€    ю€€    $€€€    8ю€€    Tю€€    d€€€    pю€€    Мю€€    ®ю€€    ƒю€€    А€€€    Ь€€€    аю€€    мю€€              и$к€€     )   Ђ   |        ®    )   Ђ   ђ€€€ »      
   П! &†€€€р'    )   Ђ    <     (Р 4   /    )   Ђ    »    и  %<€€€X   (Р      )	   Ђ        $   †€€€    ђ€€€    <€€€              и(й€€     *   ё          ∞   *   ё   Єю€€$€€€    р  %јю€€( !"Єю€€ *	   ё   ђю€€$€€€    р  %јю€€(       e"ђю€€ *
   ё   ђю€€$€€€№ю€€ ( ђю€€ *   ё   Ь€€€  *   ё   ђю€€№ю€€ З†ю€€№ю€€ И†ю€€&Фю€€р|    *   ё   Ь€€€Ь€€€јю€€   №ю€€   %0ю€€X 0  №ю€€   %ћэ€€X L     
! %∞э€€(*Р ђю€€№ю€€ Йc€€€ *   ё   Ь€€€   (Р      *   ё        l   ∞э€€    ћэ€€    јю€€    0ю€€    Ь€€€    №ю€€    Фю€€    †ю€€    ђю€€    $€€€"    Єю€€              и№ж€€         @     ијж€€         @ ,  L  ;  0  6    1    ,  р  %  и     ћ    ∞    Ф    x  
  \    @     $  ы    ц  м  с  –  м  і  з  Ш  в  |  Ё  t  Ў  X  —  <  ћ     «    ¬  и  љ  а  Є  ƒ  ±  ®  ђ  М  І  p  Ґ  T  Э  8  Ш  ,  У    О  ф  Й  Ў  Д  Љ    †  z  Д  u  h  p  L  k  0  f    a  ш  \  №  W  ј  R  §  M  И  H  l  C  P  >  4  9    4  ь  /  а  *  ƒ  %  ®     Ь    А    d    H    ,          »       А       :   9   8    7    6   5   4   3   2   1   0   /   .   -   ,   +   *     )   (   '   &   %   sД$   #   "                                                                      
   	                                   0enter_new_customerbuild_search_formoutput_mail_listoutput_filtered_mail_list	FirstNameGETFIELDLastNameEMailAddressCityStateZipCommentsStreet
State/Prov          Zip/Postal CodeDateEnteredRESULTSTRINGHTML_HEADER1$Thanks for Joinging the Mailing ListHTML_HEADER2	HERC_BODY	NEW_CUST1 	NEW_CUST2CustNo	NEW_CUST3PDOX_SERVERHTML_FOOTER+Search the Glass Sculpture Enthusiasts ListSEARCH_LIST1      SEARCH_LIST2EXPIRESDRIVEPATHCustomer.DBHercules.DB#Hercules Glass Company Mailing List
MAIL_LIST1 
MAIL_LIST2CUSTTF_HEADER<TR><TD>	</TD><TD><A HREF="mailto:"></A>   </TD></TR>
	</TABLE>
NOBODY_IN_CITY1NOBODY_IN_CITY2FILTERED_MAIL_LIST1FILTERED_MAIL_LIST2FILTERED_MAIL_LIST3Customer<OPTION VALUE=""> 
               