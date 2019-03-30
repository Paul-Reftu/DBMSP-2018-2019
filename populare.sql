drop table "Blacklisted IPs";
drop table "Blacklisted Passwords";
drop table "Shopping Cart";
drop table "Item List";
drop table "Users";

create table "Blacklisted IPs" (
ID number(38,0) primary key not null,
IP varchar(16)
);

create table "Blacklisted Passwords" (
ID number(38,0) primary key not null,
Password varchar(25)
);

ALTER TABLE "Users"
  MODIFY Username varchar2(50)
  /

CREATE OR REPLACE TYPE list IS VARRAY(10) of number(38,0)
/
create table "Users" (
ID number(38,0) primary key not null,
Balance number(36,2),
IP varchar(16),
"Failed Logins" int,
Adress varchar(150),
Username varchar(50),
Password varchar(25),
"Last Signin" Date,
"List of Searches" list
)
/

create table "Shopping Cart" (
"User ID" number(38,0) primary key not null,
"Total Price" number(36,2)
);

alter table "Shopping Cart" add
CONSTRAINT FK_User FOREIGN KEY ("User ID") REFERENCES "Users"(ID);

create table "Item List" (
"User ID" number(38,0) primary key not null,
"List of Products" list
);

alter table "Item List" add
CONSTRAINT FK_User_Product FOREIGN KEY ("User ID") REFERENCES "Users"(ID);


create table "Products" (
ID number(38,0) primary key not null,
Price number(36,2),
Name varchar(16),
Warrant int,
"Selling Company" varchar(50),
Color varchar(15),
Model varchar(10),
"Production Date" Date,
"Category" varchar(30)
)

describe "Blacklisted IPs";

set SERVEROUTPUT ON;
Declare
v_id number(38,0) := 0;
v_ip varchar (15);
v_duplicat varchar (15) :=' ';
begin
while v_id<1000 loop
v_id:=v_id+1;
v_ip := to_char(floor(DBMS_RANDOM.value(1,1000))) || '.' || to_char(floor(DBMS_RANDOM.value(1,1000))) || '.' ||  to_char(floor(DBMS_RANDOM.value(1,1000))) || '.' ||  to_char(floor(DBMS_RANDOM.value(1,1000)));
begin
  select "Blacklisted IPs".IP into v_duplicat from "Blacklisted IPs" where IP = v_ip;
  EXCEPTION when NO_DATA_FOUND THEN
  insert into "Blacklisted IPs" values (v_id,v_ip);
end;
v_duplicat:=' ';
end loop;
end;



declare
TYPE varr IS VARRAY(100) OF varchar2(40);
lista varr := varr('123456','porsche','firebird','prince','rosebud
','password','guitar','butter','beach','jaguar
','12345678','chelsea','united','amateur','great
','1234','black','turtle','7777777','cool
','diamond','steelers','muffin','cooper
','12345','	nascar ','	tiffany ','	redsox','1313
','dragon','jackson ','	zxcvbn ','	star',' 	scorpio
','qwerty','cameron ','	tomcat ','	testing ','	mountain
','696969','654321 ','	golf ','	shannon 	','madison
','mustang','computer','bond007','murphy','987654');
v_id number(38,0) := 0;
v_parola varchar (25);
begin
while v_id < lista.count() loop
v_id:=v_id+1;
v_parola:=trim(lista(v_id));
insert into "Blacklisted Passwords" values (v_id,v_parola);
end loop;
end;



declare
TYPE varr IS VARRAY(1500) OF varchar2(40);
lista varr := varr('adonis','adora','adore','adoree','adorne','adrea','adreanna','adri','adria','adriaens','adrian','adriana','adriane','adrianna','adrianne','adrie','adriel','adrien','adriena','adrienne','denis',
'denise','denna','denni','dennie','dennis','denny','denver','deny','denys','denyse','denzel','denzil','eadie','eadith','ealasaid','eamon','eamonn','earl','earle','earnest','eartha','eason','easter','easton',
'eastreg','eba','ebba','eben','ebonee','ebony','ebrahim','echo','ecocafe','ed','eda','eddi','eddie','eddy','ede','edee','edel','edeline','eden','elset','elsey','elsi','elsie','elsinore','elspeth','elsy',
'elton','eluned','elva','elvera','elvert','elvina','elvira','elvis','elwira','elwood','elwyn','ely','elyn','elyse','elysee','elysha','elysia','elyssa','elyza','elza','elzbieta','em','ema','emad','emalee','emalia',
'emanuel','jo','joachim','joan','joana','joane','joanie','joann','jo ann','jo-ann','joanna','joannah','joanne','jo-anne','joannes','joannie','joao','joaquin','job','jobey','jobi','jobie','jobina','joby','maarten',
'mab','mabel','mabelle','mable','mac','mace','macey','macie','maciej','mack','mackenzie','macy','mada','madalena','madalene','madalyn','madan','maddalena','maddi','maddie','maddison','maddox','maddy','madel',
'madelaine','madeleine','madelena','madelene','madelin','madelina','madeline','madella','madelle','madelon','rori','rorie','rory','ros','rosa','rosabel','rosabella','rosabelle','rosaleen','rosalia','rosalie',
'rosalina','rosalind','rosalinda','rosalinde','rosaline','rosalyn','rosalynd','rosalynn','rosamond','tiff','tiffani','tiffanie','tiffany','tiffi','tiffie','tiffy','tiger','tiina','tilak','tilda','tildi',
'tildie','tildy','tillie','tilly','tilmon','tim','timi','timm','timmi','valentia','valentin','valentina','valentine','valentino','valera','valeria','valerie','valery','valerye','valida','valina','valinda',
'valli','vallie','vallier','vallipuram','vally','valma','valry','van','vance','vanda','vanessa','vania','vanity','van-king','vanna','vanni','vannie','vanny','vanya','varennes','vasan','vasco','vassilis',
'vasu','vaughn','vax','ved','veda','veen','veena','veleta','velma','velvet','ven','veneice','venetia','venita','venkat','venkatakrishna','venkataraman','venus','vera','veradis','vere','verena','verene',
'karoline','karoly','karon','karrah','karrie','karry','karson','karsten','karter','kartik','kary','karyl','karylin','karyn','kas','kasey','kash','kasifa','kason','kasper','kass','kassandra','kassem',
'kassey','kassi','kassia','kassidy','kassie','kast','kat','kata','katalin','katara','katarina','kataryna','kate','katee','katelyn','katelynn','katerina','katerine','katey','joli','jolie','joline','joly',
'jolyn','jolynn','jo-marie','jon','jonah','jonas','jonathan','jonathon','jonell','jonelle','joni','jonie','jonis','jonquil','jonthan','jonty','joo-euin','joo-geok','joon','jooran','jordain','jordan','jordana',
'jordanna','jordon','jordy','jordyn','jorey','jorge','jori','jorie','jorja','jorrie','jorry','jos','josanne','joscelin','jose','josee','josef','josefa','josefina','joseline','joselyn','joseph','josepha','josephina',
'josephine','josey','josh','joshi','joshua','josi','josiah','josie','josine','joss','josselyn','jossine','josue','josy','jourdan','journey','jovan','joy','joya','joyan','joyann','joyce','joycelin','joydeep',
'joye','joyous','jozef','jozsef','jr','jsandye','juan','frederic','frederica','frederick','fredericka','frederika','frederique','fredi','fredia','fredra','fredrick','fredrika','freek','freeman','freida',
'freya','frida','frieda','friederike','frinel','fritz','froukje','fscocos','fulvia','fung','furrukh','fu-shin','fuzal','fwp','fwpas','fwpreg','fynn','gaal','gabbey','gabbi','gabbie','gabby','gabe',
'gabey','gabi','gabie','wade','wai','wai-bun','wai-chau','waichi','wai-ching','wai-hung','wai-leung','wai-man','waja','wakako','walker','wallace','walley','wallie','wallis','walliw','wally',
'walt','walter','walton','waly','wan','wanda','wandie','wandis','waneta','wanids','wannell','warden','wargnier','warren','warwick','wassim','waverley','waverly','waylon','wayne','weber',
'wee-lin','wee-seng','wee-thong','weilin','weiping','weitzel','weldon','wen','wenda','wendel','wendeline','wendell','wendi','wendie','wendy','wendye','wen-kai','wenona','wenonah','wenxi','weringh',
'werner','wes','wesley','westin','weston','whitfield','whitney','wiebe','wiebren','wiele','wiesje','wieslaw','wieslawa','wil','wilbert','wilbur','wileen','wiley','wilf','wilford','wilfred','wilhelm',
'wilhelmina','wilhelmine','wilhelmus','wilie','wilkin','will','willa','willabella','willam','willamina','willard','willeke','willem','willetta','willette','willi','william','willie','willis','willow',
'willy','willyt','wilma','wilmer','wilmette','wilmont','wilona','wilone','wilow','wilson','wilton','win','windowing','windy','wing','wing-ki','wing-man','wini','winifred','winna','winnah','winne',
'winni','winnie','winnifred','winny','winona','winonah','winston','winter','witold','wits','witte','wladyslaw','woei-peng','wojciech','wolf','wolfgang','wonda','wong','woodline','woodrow','woodson',
'woody','woon','wray','wren','wrennie','wyatt','wylma','wylo','wynn','wynne','wynnie','wynny','wynona','xander','xandra','xandria','xanthe','xantippe','xavier','xaviera','xena','xenia','xerxes','xia',
'xiaofeng','xiaojing','xiaomei','xiao-ming','ximena','xi-nam','xochil','xochitl','xu','xuan-lien','xuong','xylia','xylina','yahir','yalcin','yalonda','yana','yanna','yannick','yannis','yan-zhen','yao',
'yara','yardley','yarlanda','yasar','yaser','yasmeen','yasmin','yasmina','yasmine','yate','yatish','yau-fun','yavar','yavuz','yawar','yazmin','yc','yee-ning','yehuda','yehudi','yeirnie','yelena',
'yen','yesenia','yessica','yestin','yetta','yettie','yetty','yeung','yevette','yih','yihban','yikhon','ying','ylaine','ynes','ynez','yodha','yogesh','yogi','yokan','yoke','yoke-kee','yoko','yolanda',
'yolande','yolane','yolanthe','yong','yongli','yonik','yoram','york','yoselin','yoshi','yoshiaki','yoshiko','yoshimitsu','yosuf','youji','young-june','yousef','youssef','youwen','yovonnda','ysabel',
'yu','yuan','yu-chung','yudy','yueh','yueli','yue-min','yuen','yuen-pui','yueping','yu-hung','yuji','yu-kai','yukihiko','yukinaga','yukinobu','yuko','yuksel','yukuo','yuk-wha','yula','yulissa','yumi',
'yung','yuri','yussuf','yusuf','yutaka','yvaine','yvan','yves','yvet','yvette','yvon','yvonne','zabrina','zac','zach','zachariah','zachary','zachery','zack','zackary','zackery','zada','zadie','zafar',
'zafer','zahara','zaheera','zahid','zahir','zahirul','zahra','zaiden','zaihua','zain','zainab','zaine','zaira','zak','zakia','zalee','zali','zan','zander','zandra','zane','zaneta','zanni',
'zara','zarah','zarella','zaria','zarla','zarrin','zaven','zaya','zayden','zayla','zaylen','zayn','zayne','zbignew','zbigniew','zdenek','zdenka','zdenko','zea','zeb','zebulon','zed','zehir-charlie',
'zehra','zein','zeina','zeke','zelda','zelida','zelina','zeljko','zelma','zena','zendaya','zenia','zeph','zere','zero','zeth','zhanna','zhengyu','zia','ziad','zig','ziggy','zilvia','zina','zino','zion',
'zita','zitella','ziva','zoe','zoel','zoenka','zoey','zofia','zohar','zola','zoltan','zonda','zondra','zongyi','zonnya','zora','zorah','zoran','zorana','zorina','zorine','zouheir','zoya','zsazsa','zsa zsa',
'zuben','zula','zulema','zulfikar','zuri','zuriel','zuzana','zyana','zyg','zygmunt','zylen');
v_id number(38,0) := 0;
v_nume1 varchar (40);
v_nume2 varchar (40);
v_duplicat varchar (80) :=' ';
v_ip varchar (15);
begin
while v_id < 100000 loop
v_id:=v_id+1;
v_nume1 := lista(floor(DBMS_RANDOM.value(1,lista.count())));
v_nume2 := lista(floor(DBMS_RANDOM.value(1,lista.count())));
begin
  select "Users".Username into v_duplicat from "Users" where Username = trim(v_nume1 || '.' || v_nume2);
  EXCEPTION when NO_DATA_FOUND THEN
    v_ip := to_char(floor(DBMS_RANDOM.value(1,1000))) || '.' || to_char(floor(DBMS_RANDOM.value(1,1000))) || '.' ||  to_char(floor(DBMS_RANDOM.value(1,1000))) || '.' ||  to_char(floor(DBMS_RANDOM.value(1,1000)));
    insert into "Users" (ID,Balance,IP,"Failed Logins",Adress,Username,Password,"Last Signin") values (
    v_id,
    round(DBMS_RANDOM.value(1,5000),2),
    v_ip,
    floor(DBMS_RANDOM.value(1,15)),
    to_char(round(DBMS_RANDOM.value(-90,+90),6) || ' ' || round(DBMS_RANDOM.value(-180,+180),6)),
    trim(v_nume1 || '.' || v_nume2),
    dbms_random.string('X', 10),
    to_date(trunc(dbms_random.value(2458573,2454833)),'J')
    );
end;
v_duplicat:=' ';
end loop;
end;
