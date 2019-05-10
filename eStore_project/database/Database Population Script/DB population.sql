drop table Users;
drop table Activities;
drop table Country;
drop table CountryConnections;
drop table Orders;
drop table Orderdetails;
drop table products;
drop table searches;

create table Users (
ID number(38,0) primary key not null,
username varchar(50),
password varchar(25),
email varchar(70),
adress varchar(150)
)
/

create table Searches (
ID number(38,0) primary key not null,
userID number(38,0),
search varchar(50),
Foreign key (userID) REFERENCES Users(ID)
)
/


create table Products (
ID number(38,0) primary key not null,
sellerID number(38,0),
name varchar(50),
description varchar(200),
type varchar(40),
price number(36,2),
Foreign key (sellerID) REFERENCES Users(ID)
)
/


create table Activities(
ID number(38,0) primary key not null,
userID number(38,0),
name varchar(50),
time timestamp,
Foreign key (userID) REFERENCES Users(ID)
)
/


create table Country (
ID number(38,0) primary key not null,
name varchar(50)
)
/

create table countryConnections (
countryOneID number(38,0),
countryTwoID number(38,0),
cost number(36,2),
Foreign key (countryOneID) REFERENCES Country(ID),
Foreign key (countryTwoID) REFERENCES Country(ID)
)
/


create table Orders (
ID number(38,0) primary key not null,
buyerID number(38,0),
destCountryID number(38,0),
placed_at timestamp,
arrived_on timestamp,
Foreign key (buyerID) REFERENCES Users(ID),
Foreign key (destCountryID) REFERENCES Country(ID)
)
/


create table OrderDetails (
ID number(38,0) primary key not null,
orderID number(38,0),
productID number(38,0),
quantity integer,
Foreign key (orderID) REFERENCES Orders(ID),
Foreign key (productID) REFERENCES Products(ID)
)
/




  set serveroutput on;
declare
TYPE varr IS VARRAY(1000) OF varchar2(70);
prenume varr := varr('MARY','PATRICIA','LINDA','BARBARA','ELIZABETH','JENNIFER','MARIA','SUSAN','MARGARET','DOROTHY','LISA','NANCY','KAREN','BETTY','HELEN','SANDRA','DONNA','CAROL','RUTH'
,'SHARON','MICHELLE','LAURA','SARAH','KIMBERLY','DEBORAH','JESSICA','SHIRLEY','CYNTHIA','ANGELA','MELISSA','BRENDA','AMY','ANNA','REBECCA','VIRGINIA','KATHLEEN','PAMELA','MARTHA','DEBRA'
,'AMANDA','STEPHANIE','CAROLYN','CHRISTINE','MARIE','JANET','CATHERINE','FRANCES','ANN','JOYCE','DIANE','ALICE','JULIE','HEATHER','TERESA','DORIS','GLORIA','EVELYN','JEAN','CHERYL'
,'MILDRED','KATHERINE','JOAN','ASHLEY','JUDITH','ROSE','JANICE','KELLY','NICOLE','JUDY','CHRISTINA','KATHY','THERESA','BEVERLY','DENISE','TAMMY','IRENE','JANE','LORI','RACHEL','MARILYN'
,'ANDREA','KATHRYN','LOUISE','SARA','ANNE','JACQUELINE','WANDA','BONNIE','JULIA','RUBY','LOIS','TINA','PHYLLIS','NORMA','PAULA','DIANA','ANNIE','LILLIAN','EMILY','ROBIN','PEGGY','CRYSTAL','GLADYS'
,'RITA','DAWN','CONNIE','FLORENCE','TRACY','EDNA','TIFFANY','CARMEN','ROSA','CINDY','GRACE','WENDY','VICTORIA','EDITH','KIM','SHERRY','SYLVIA','JOSEPHINE','THELMA','SHANNON','SHEILA','ETHEL'
,'ELLEN','ELAINE','MARJORIE','CARRIE','CHARLOTTE','MONICA','ESTHER','PAULINE','EMMA','JUANITA','ANITA','RHONDA','HAZEL','AMBER','EVA','DEBBIE','APRIL','LESLIE','CLARA','LUCILLE','JAMIE','JOANNE'
,'ELEANOR','VALERIE','DANIELLE','MEGAN','ALICIA','SUZANNE','MICHELE','GAIL','BERTHA','DARLENE','VERONICA','JILL','ERIN','GERALDINE','LAUREN','CATHY','JOANN','LORRAINE','LYNN','SALLY','REGINA',
'ERICA','BEATRICE','DOLORES','BERNICE','AUDREY','YVONNE','ANNETTE','JUNE','SAMANTHA','MARION','DANA','STACY','ANA','RENEE','IDA','VIVIAN','ROBERTA','HOLLY','BRITTANY','MELANIE','LORETTA','YOLANDA'
,'JEANETTE','LAURIE','KATIE','KRISTEN','VANESSA','ALMA','SUE','ELSIE','BETH','JEANNE','VICKI','CARLA','TARA','ROSEMARY','EILEEN','TERRI','GERTRUDE','LUCY','TONYA','ELLA','STACEY','WILMA','GINA',
'KRISTIN','JESSIE','NATALIE','AGNES','VERA','WILLIE','CHARLENE','BESSIE','DELORES','MELINDA','PEARL','ARLENE','MAUREEN','COLLEEN','ALLISON','TAMARA','JOY','GEORGIA','CONSTANCE','LILLIE','CLAUDIA'
,'JACKIE','MARCIA','TANYA','NELLIE','MINNIE','MARLENE','HEIDI','GLENDA','LYDIA','VIOLA','COURTNEY','MARIAN','STELLA','CAROLINE','DORA','JO','VICKIE','MATTIE','TERRY','MAXINE','IRMA','MABEL','MARSHA'
,'MYRTLE','LENA','CHRISTY','DEANNA','PATSY','HILDA','GWENDOLYN','JENNIE','NORA','MARGIE','NINA','CASSANDRA','LEAH','PENNY','KAY','PRISCILLA','NAOMI','CAROLE','BRANDY','OLGA','BILLIE','DIANNE','TRACEY'
,'LEONA','JENNY','FELICIA','SONIA','MIRIAM','VELMA','BECKY','BOBBIE','VIOLET','KRISTINA','TONI','MISTY','MAE','SHELLY','DAISY','RAMONA','SHERRI','ERIKA','KATRINA','CLAIRE','LINDSEY','LINDSAY','GENEVA'
,'GUADALUPE','BELINDA','MARGARITA','SHERYL','CORA','FAYE','ADA','NATASHA','SABRINA','ISABEL','MARGUERITE','HATTIE','HARRIET','MOLLY','CECILIA','KRISTI','BRANDI','BLANCHE','SANDY','ROSIE','JOANNA','IRIS'
,'EUNICE','ANGIE','INEZ','LYNDA','MADELINE','AMELIA','ALBERTA','GENEVIEVE','MONIQUE','JODI','JANIE','MAGGIE','KAYLA','SONYA','JAN','LEE','KRISTINE','CANDACE','FANNIE','MARYANN','OPAL','ALISON','YVETTE'
,'MELODY','LUZ','SUSIE','OLIVIA','FLORA','SHELLEY','KRISTY','MAMIE','LULA','LOLA','VERNA','BEULAH','ANTOINETTE','CANDICE','JUANA','JEANNETTE','PAM','KELLI','HANNAH','WHITNEY','BRIDGET','KARLA','CELIA'
,'LATOYA','PATTY','SHELIA','GAYLE','DELLA','VICKY','LYNNE','SHERI','MARIANNE','KARA','JACQUELYN','ERMA','BLANCA','MYRA','LETICIA','PAT','KRISTA','ROXANNE','ANGELICA','JOHNNIE','ROBYN','FRANCIS','ADRIENNE'
,'ROSALIE','ALEXANDRA','BROOKE','BETHANY','SADIE','BERNADETTE','TRACI','JODY','KENDRA','JASMINE','NICHOLE','RACHAEL','CHELSEA','MABLE','ERNESTINE','MURIEL','MARCELLA','ELENA','KRYSTAL','ANGELINA','NADINE'
,'KARI','ESTELLE','DIANNA','PAULETTE','LORA','MONA','DOREEN','ROSEMARIE','ANGEL','DESIREE','ANTONIA','HOPE','GINGER','JANIS','BETSY','CHRISTIE','FREDA','MERCEDES','MEREDITH','LYNETTE','TERI','CRISTINA'
,'EULA','LEIGH','MEGHAN','SOPHIA','ELOISE','ROCHELLE','GRETCHEN','CECELIA','RAQUEL','HENRIETTA','ALYSSA','JANA','KELLEY','GWEN','KERRY','JENNA','TRICIA','LAVERNE','OLIVE','ALEXIS','TASHA','SILVIA','ELVIRA'
,'CASEY','DELIA','SOPHIE','KATE','PATTI','LORENA','KELLIE','SONJA','LILA','LANA','DARLA','MAY','MINDY','ESSIE','MANDY','LORENE','ELSA','JOSEFINA','JEANNIE','MIRANDA','DIXIE','LUCIA','MARTA','FAITH','LELA'
,'JOHANNA','SHARI','CAMILLE','TAMI','SHAWNA','ELISA','EBONY','MELBA','ORA','NETTIE','TABITHA','OLLIE','JAIME','WINIFRED','KRISTIE','JAMES','JOHN','ROBERT','MICHAEL','WILLIAM','DAVID','RICHARD','CHARLES'
,'JOSEPH','THOMAS','CHRISTOPHER','DANIEL','PAUL','MARK','DONALD','GEORGE','KENNETH','STEVEN','EDWARD','BRIAN','RONALD','ANTHONY','KEVIN','JASON','MATTHEW','GARY','TIMOTHY','JOSE','LARRY','JEFFREY','FRANK'
,'SCOTT','ERIC','STEPHEN','ANDREW','RAYMOND','GREGORY','JOSHUA','JERRY','DENNIS','WALTER','PATRICK','PETER','HAROLD','DOUGLAS','HENRY','CARL','ARTHUR','RYAN','ROGER','JOE','JUAN','JACK','ALBERT','JONATHAN'
,'JUSTIN','TERRY','GERALD','KEITH','SAMUEL','WILLIE','RALPH','LAWRENCE','NICHOLAS','ROY','BENJAMIN','BRUCE','BRANDON','ADAM','HARRY','FRED','WAYNE','BILLY','STEVE','LOUIS','JEREMY','AARON','RANDY','HOWARD'
,'EUGENE','CARLOS','RUSSELL','BOBBY','VICTOR','MARTIN','ERNEST','PHILLIP','TODD','JESSE','CRAIG','ALAN','SHAWN','CLARENCE','SEAN','PHILIP','CHRIS','JOHNNY','EARL','JIMMY','ANTONIO','DANNY','BRYAN','TONY'
,'LUIS','MIKE','STANLEY','LEONARD','NATHAN','DALE','MANUEL','RODNEY','CURTIS','NORMAN','ALLEN','MARVIN','VINCENT','GLENN','JEFFERY','TRAVIS','JEFF','CHAD','JACOB','LEE','MELVIN','ALFRED','KYLE','FRANCIS'
,'BRADLEY','JESUS','HERBERT','FREDERICK','RAY','JOEL','EDWIN','DON','EDDIE','RICKY','TROY','RANDALL','BARRY','ALEXANDER','BERNARD','MARIO','LEROY','FRANCISCO','MARCUS','MICHEAL','THEODORE','CLIFFORD','MIGUEL'
,'OSCAR','JAY','JIM','TOM','CALVIN','ALEX','JON','RONNIE','BILL','LLOYD','TOMMY','LEON','DEREK','WARREN','DARRELL','JEROME','FLOYD','LEO','ALVIN','TIM','WESLEY','GORDON','DEAN','GREG','JORGE','DUSTIN','PEDRO'
,'DERRICK','DAN','LEWIS','ZACHARY','COREY','HERMAN','MAURICE','VERNON','ROBERTO','CLYDE','GLEN','HECTOR','SHANE','RICARDO','SAM','RICK','LESTER','BRENT','RAMON','CHARLIE','TYLER','GILBERT','GENE','MARC','REGINALD'
,'RUBEN','BRETT','ANGEL','NATHANIEL','RAFAEL','LESLIE','EDGAR','MILTON','RAUL','BEN','CHESTER','CECIL','DUANE','FRANKLIN','ANDRE','ELMER','BRAD','GABRIEL','RON','MITCHELL','ROLAND','ARNOLD','HARVEY','JARED','ADRIAN'
,'KARL','CORY','CLAUDE','ERIK','DARRYL','JAMIE','NEIL','JESSIE','CHRISTIAN','JAVIER','FERNANDO','CLINTON','TED','MATHEW','TYRONE','DARREN','LONNIE','LANCE','CODY','JULIO','KELLY','KURT','ALLAN','NELSON','GUY','CLAYTON'
,'HUGH','MAX','DWAYNE','DWIGHT','ARMANDO','FELIX','JIMMIE','EVERETT','JORDAN','IAN','WALLACE','KEN','BOB','JAIME','CASEY','ALFREDO','ALBERTO','DAVE','IVAN','JOHNNIE','SIDNEY','BYRON','JULIAN','ISAAC','MORRIS','CLIFTON'
,'WILLARD','DARYL','ROSS','VIRGIL','ANDY','MARSHALL','SALVADOR','PERRY','KIRK','SERGIO','MARION','TRACY','SETH','KENT','TERRANCE','RENE','EDUARDO','TERRENCE','ENRIQUE','FREDDIE','WADE','AUSTIN','STUART','FREDRICK'
,'ARTURO','ALEJANDRO','JACKIE','JOEY','NICK','LUTHER','WENDELL','JEREMIAH','EVAN','JULIUS','DANA','DONNIE','OTIS','SHANNON','TREVOR','OLIVER','LUKE','HOMER','GERARD','DOUG','KENNY','HUBERT','ANGELO','SHAUN','LYLE'
,'MATT','LYNN','ALFONSO','ORLANDO','REX','CARLTON','ERNESTO','CAMERON','NEAL','PABLO','LORENZO','OMAR','WILBUR','BLAKE','GRANT','HORACE','RODERICK','KERRY','ABRAHAM','WILLIS','RICKEY','JEAN','IRA','ANDRES','CESAR'
,'JOHNATHAN','MALCOLM','RUDOLPH','DAMON','KELVIN','RUDY','PRESTON','ALTON','ARCHIE','MARCO','WM','PETE','RANDOLPH','GARRY','GEOFFREY','JONATHON','FELIPE','BENNIE','GERARDO','ED','DOMINIC','ROBIN','LOREN','DELBERT'
,'COLIN','GUILLERMO','EARNEST','LUCAS','BENNY','NOEL','SPENCER','RODOLFO','MYRON','EDMUND','GARRETT','SALVATORE','CEDRIC','LOWELL','GREGG','SHERMAN','WILSON','DEVIN','SYLVESTER','KIM','ROOSEVELT','ISRAEL'
,'JERMAINE','FORREST','WILBERT','LELAND','SIMON','GUADALUPE','CLARK','IRVING','CARROLL','BRYANT','OWEN','RUFUS','WOODROW','SAMMY','KRISTOPHER','MACK','LEVI','MARCOS','GUSTAVO','JAKE','LIONEL','MARTY','TAYLOR','ELLIS'
,'DALLAS','GILBERTO','CLINT','NICOLAS','LAURENCE','ISMAEL','ORVILLE','DREW','JODY','ERVIN','DEWEY','AL','WILFRED','JOSH','HUGO','IGNACIO','CALEB','TOMAS','SHELDON','ERICK','FRANKIE','STEWART','DOYLE','DARREL','ROGELIO'
,'TERENCE','SANTIAGO','ALONZO','ELIAS','BERT','ELBERT','RAMIRO','CONRAD','PAT','NOAH','GRADY','PHIL','CORNELIUS','LAMAR','ROLANDO','CLAY','PERCY','DEXTER','BRADFORD','MERLE','DARIN','AMOS','TERRELL','MOSES','IRVIN'
,'SAUL','ROMAN','DARNELL','RANDAL','TOMMIE','TIMMY','DARRIN','WINSTON','BRENDAN','TOBY','VAN','ABEL','DOMINICK','BOYD','COURTNEY','JAN','EMILIO','ELIJAH','CARY','DOMINGO','SANTOS','AUBREY','EMMETT','MARLON','EMANUEL'
,'JERALD','EDMOND'
);

nume varr := varr('SMITH','JOHNSON','WILLIAMS','JONES','BROWN','DAVIS','MILLER','WILSON','MOORE','TAYLOR','ANDERSON','THOMAS','JACKSON','WHITE','HARRIS','MARTIN','THOMPSON','GARCIA','MARTINEZ','ROBINSON','CLARK'
,'RODRIGUEZ','LEWIS','LEE','WALKER','HALL','ALLEN','YOUNG','HERNANDEZ','KING','WRIGHT','LOPEZ','HILL','SCOTT','GREEN','ADAMS','BAKER','GONZALEZ','NELSON','CARTER','MITCHELL','PEREZ','ROBERTS','TURNER','PHILLIPS'
,'CAMPBELL','PARKER','EVANS','EDWARDS','COLLINS','STEWART','SANCHEZ','MORRIS','ROGERS','REED','COOK','MORGAN','BELL','MURPHY','BAILEY','RIVERA','COOPER','RICHARDSON','COX','HOWARD','WARD','TORRES','PETERSON','GRAY'
,'RAMIREZ','JAMES','WATSON','BROOKS','KELLY','SANDERS','PRICE','BENNETT','WOOD','BARNES','ROSS','HENDERSON','COLEMAN','JENKINS','PERRY','POWELL','LONG','PATTERSON','HUGHES','FLORES','WASHINGTON','BUTLER','SIMMONS'
,'FOSTER','GONZALES','BRYANT','ALEXANDER','RUSSELL','GRIFFIN','DIAZ','HAYES','MYERS','FORD','HAMILTON','GRAHAM','SULLIVAN','WALLACE','WOODS','COLE','WEST','JORDAN','OWENS','REYNOLDS','FISHER','ELLIS','HARRISON','GIBSON'
,'MCDONALD','CRUZ','MARSHALL','ORTIZ','GOMEZ','MURRAY','FREEMAN','WELLS','WEBB','SIMPSON','STEVENS','TUCKER','PORTER','HUNTER','HICKS','CRAWFORD','HENRY','BOYD','MASON','MORALES','KENNEDY','WARREN','DIXON','RAMOS'
,'REYES','BURNS','GORDON','SHAW','HOLMES','RICE','ROBERTSON','HUNT','BLACK','DANIELS','PALMER','MILLS','NICHOLS','GRANT','KNIGHT','FERGUSON','ROSE','STONE','HAWKINS','DUNN','PERKINS','HUDSON','SPENCER','GARDNER','STEPHENS'
,'PAYNE','PIERCE','BERRY','MATTHEWS','ARNOLD','WAGNER','WILLIS','RAY','WATKINS','OLSON','CARROLL','DUNCAN','SNYDER','HART','CUNNINGHAM','BRADLEY','LANE','ANDREWS','RUIZ','HARPER','FOX','RILEY','ARMSTRONG','CARPENTER'
,'WEAVER','GREENE','LAWRENCE','ELLIOTT','CHAVEZ','SIMS','AUSTIN','PETERS','KELLEY','FRANKLIN','LAWSON','FIELDS','GUTIERREZ','RYAN','SCHMIDT','CARR','VASQUEZ','CASTILLO','WHEELER','CHAPMAN','OLIVER','MONTGOMERY','RICHARDS'
,'WILLIAMSON','JOHNSTON','BANKS','MEYER','BISHOP','MCCOY','HOWELL','ALVAREZ','MORRISON','HANSEN','FERNANDEZ','GARZA','HARVEY','LITTLE','BURTON','STANLEY','NGUYEN','GEORGE','JACOBS','REID','KIM','FULLER','LYNCH','DEAN'
,'GILBERT','GARRETT','ROMERO','WELCH','LARSON','FRAZIER','BURKE','HANSON','DAY','MENDOZA','MORENO','BOWMAN','MEDINA','FOWLER','BREWER','HOFFMAN','CARLSON','SILVA','PEARSON','HOLLAND','DOUGLAS','FLEMING','JENSEN','VARGAS'
,'BYRD','DAVIDSON','HOPKINS','MAY','TERRY','HERRERA','WADE','SOTO','WALTERS','CURTIS','NEAL','CALDWELL','LOWE','JENNINGS','BARNETT','GRAVES','JIMENEZ','HORTON','SHELTON','BARRETT','OBRIEN','CASTRO','SUTTON','GREGORY'
,'MCKINNEY','LUCAS','MILES','CRAIG','RODRIQUEZ','CHAMBERS','HOLT','LAMBERT','FLETCHER','WATTS','BATES','HALE','RHODES','PENA','BECK','NEWMAN','HAYNES','MCDANIEL','MENDEZ','BUSH','VAUGHN','PARKS','DAWSON','SANTIAGO','NORRIS'
,'HARDY','LOVE','STEELE','CURRY','POWERS','SCHULTZ','BARKER','GUZMAN','PAGE','MUNOZ','BALL','KELLER','CHANDLER','WEBER','LEONARD','WALSH','LYONS','RAMSEY','WOLFE','SCHNEIDER','MULLINS','BENSON','SHARP','BOWEN','DANIEL'
,'BARBER','CUMMINGS','HINES','BALDWIN','GRIFFITH','VALDEZ','HUBBARD','SALAZAR','REEVES','WARNER','STEVENSON','BURGESS','SANTOS','TATE','CROSS','GARNER','MANN','MACK','MOSS','THORNTON','DENNIS','MCGEE','FARMER','DELGADO'
,'AGUILAR','VEGA','GLOVER','MANNING','COHEN','HARMON','RODGERS','ROBBINS','NEWTON','TODD','BLAIR','HIGGINS','INGRAM','REESE','CANNON','STRICKLAND','TOWNSEND','POTTER','GOODWIN','WALTON','ROWE','HAMPTON','ORTEGA','PATTON'
,'SWANSON','JOSEPH','FRANCIS','GOODMAN','MALDONADO','YATES','BECKER','ERICKSON','HODGES','RIOS','CONNER','ADKINS','WEBSTER','NORMAN','MALONE','HAMMOND','FLOWERS','COBB','MOODY','QUINN','BLAKE','MAXWELL','POPE','FLOYD'
,'OSBORNE','PAUL','MCCARTHY','GUERRERO','LINDSEY','ESTRADA','SANDOVAL','GIBBS','TYLER','GROSS','FITZGERALD','STOKES','DOYLE','SHERMAN','SAUNDERS','WISE','COLON','GILL','ALVARADO','GREER','PADILLA','SIMON','WATERS','NUNEZ'
,'BALLARD','SCHWARTZ','MCBRIDE','HOUSTON','CHRISTENSEN','KLEIN','PRATT','BRIGGS','PARSONS','MCLAUGHLIN','ZIMMERMAN','FRENCH','BUCHANAN','MORAN','COPELAND','ROY','PITTMAN','BRADY','MCCORMICK','HOLLOWAY','BROCK','POOLE'
,'FRANK','LOGAN','OWEN','BASS','MARSH','DRAKE','WONG','JEFFERSON','PARK','MORTON','ABBOTT','SPARKS','PATRICK','NORTON','HUFF','CLAYTON','MASSEY','LLOYD','FIGUEROA','CARSON','BOWERS','ROBERSON','BARTON','TRAN','LAMB'
,'HARRINGTON','CASEY','BOONE','CORTEZ','CLARKE','MATHIS','SINGLETON','WILKINS','CAIN','BRYAN','UNDERWOOD','HOGAN','MCKENZIE','COLLIER','LUNA','PHELPS','MCGUIRE','ALLISON','BRIDGES','WILKERSON','NASH','SUMMERS','ATKINS'
,'WILCOX','PITTS','CONLEY','MARQUEZ','BURNETT','RICHARD','COCHRAN','CHASE','DAVENPORT','HOOD','GATES','CLAY','AYALA','SAWYER','ROMAN','VAZQUEZ','DICKERSON','HODGE','ACOSTA','FLYNN','ESPINOZA','NICHOLSON','MONROE'
,'WOLF','MORROW','KIRK','RANDALL','ANTHONY','WHITAKER','OCONNOR','SKINNER','WARE','MOLINA','KIRBY','HUFFMAN','BRADFORD','CHARLES','GILMORE','DOMINGUEZ','ONEAL','BRUCE','LANG','COMBS','KRAMER','HEATH','HANCOCK','GALLAGHER'
,'GAINES','SHAFFER','SHORT','WIGGINS','MATHEWS','MCCLAIN','FISCHER','WALL','SMALL','MELTON','HENSLEY','BOND','DYER','CAMERON','GRIMES','CONTRERAS','CHRISTIAN','WYATT','BAXTER','SNOW','MOSLEY','SHEPHERD','LARSEN','HOOVER'
,'BEASLEY','GLENN','PETERSEN','WHITEHEAD','MEYERS','KEITH','GARRISON','VINCENT','SHIELDS','HORN','SAVAGE','OLSEN','SCHROEDER','HARTMAN','WOODARD','MUELLER','KEMP','DELEON','BOOTH','PATEL','CALHOUN','WILEY','EATON','CLINE'
,'NAVARRO','HARRELL','LESTER','HUMPHREY','PARRISH','DURAN','HUTCHINSON','HESS','DORSEY','BULLOCK','ROBLES','BEARD','DALTON','AVILA','VANCE','RICH','BLACKWELL','YORK','JOHNS','BLANKENSHIP','TREVINO','SALINAS','CAMPOS'
,'PRUITT','MOSES','CALLAHAN','GOLDEN','MONTOYA','HARDIN','GUERRA','MCDOWELL','CAREY','STAFFORD','GALLEGOS','HENSON','WILKINSON','BOOKER','MERRITT','MIRANDA','ATKINSON','ORR','DECKER','HOBBS','PRESTON','TANNER','KNOX'
,'PACHECO','STEPHENSON','GLASS','ROJAS','SERRANO','MARKS','HICKMAN','ENGLISH','SWEENEY','STRONG','PRINCE','MCCLURE','CONWAY','WALTER','ROTH','MAYNARD','FARRELL','LOWERY','HURST','NIXON','WEISS','TRUJILLO','ELLISON','SLOAN'
,'JUAREZ','WINTERS','MCLEAN','RANDOLPH','LEON','BOYER','VILLARREAL','MCCALL','GENTRY','CARRILLO','KENT','AYERS','LARA','SHANNON','SEXTON','PACE','HULL','LEBLANC','BROWNING','VELASQUEZ','LEACH','CHANG','HOUSE','SELLERS'
,'HERRING','NOBLE','FOLEY','BARTLETT','MERCADO','LANDRY','DURHAM','WALLS','BARR','MCKEE','BAUER','RIVERS','EVERETT','BRADSHAW','PUGH','VELEZ','RUSH','ESTES','DODSON','MORSE','SHEPPARD','WEEKS','CAMACHO','BEAN','BARRON'
,'LIVINGSTON','MIDDLETON','SPEARS','BRANCH','BLEVINS','CHEN','KERR','MCCONNELL','HATFIELD','HARDING','ASHLEY','SOLIS','HERMAN','FROST','GILES','BLACKBURN','WILLIAM','PENNINGTON','WOODWARD','FINLEY','MCINTOSH','KOCH','BEST'
,'SOLOMON','MCCULLOUGH','DUDLEY','NOLAN','BLANCHARD','RIVAS','BRENNAN','MEJIA','KANE','BENTON','JOYCE','BUCKLEY','HALEY','VALENTINE','MADDOX','RUSSO','MCKNIGHT','BUCK','MOON','MCMILLAN','CROSBY','BERG','DOTSON','MAYS'
,'ROACH','CHURCH','CHAN','RICHMOND','MEADOWS','FAULKNER','ONEILL','KNAPP','KLINE','BARRY','OCHOA','JACOBSON','GAY','AVERY','HENDRICKS','HORNE','SHEPARD','HEBERT','CHERRY','CARDENAS','MCINTYRE','WHITNEY','WALLER','HOLMAN'
,'DONALDSON','CANTU','TERRELL','MORIN','GILLESPIE','FUENTES','TILLMAN','SANFORD','BENTLEY','PECK','KEY','SALAS','ROLLINS','GAMBLE','DICKSON','BATTLE','SANTANA','CABRERA','CERVANTES','HOWE','HINTON','HURLEY','SPENCE'
,'ZAMORA','YANG','MCNEIL','SUAREZ','CASE','PETTY','GOULD','MCFARLAND','SAMPSON','CARVER','BRAY','ROSARIO','MACDONALD','STOUT','HESTER','MELENDEZ','DILLON','FARLEY','HOPPER','GALLOWAY','POTTS','BERNARD','JOYNER','STEIN'
,'AGUIRRE','OSBORN','MERCER','BENDER','FRANCO','ROWLAND','SYKES','BENJAMIN','TRAVIS','PICKETT','CRANE','SEARS','MAYO','DUNLAP','HAYDEN','WILDER','MCKAY','COFFEY','MCCARTY','EWING','COOLEY','VAUGHAN','BONNER','COTTON'
,'HOLDER','STARK','FERRELL','CANTRELL','FULTON','LYNN','LOTT','CALDERON','ROSA','POLLARD','HOOPER','BURCH','MULLEN','FRY','RIDDLE','LEVY','DAVID','DUKE','ODONNELL','GUY','MICHAEL','BRITT','FREDERICK','DAUGHERTY','BERGER'
,'DILLARD','ALSTON','JARVIS','FRYE','RIGGS','CHANEY','ODOM','DUFFY','FITZPATRICK','VALENZUELA','MERRILL','MAYER','ALFORD','MCPHERSON','ACEVEDO','DONOVAN','BARRERA','ALBERT','COTE','REILLY','COMPTON','RAYMOND','MOONEY'
,'MCGOWAN','CRAFT','CLEVELAND','CLEMONS','WYNN','NIELSEN','BAIRD','STANTON','SNIDER','ROSALES','BRIGHT','WITT','STUART','HAYS','HOLDEN','RUTLEDGE','KINNEY','CLEMENTS','CASTANEDA','SLATER','HAHN','EMERSON','CONRAD','BURKS'
,'DELANEY','PATE','LANCASTER','SWEET','JUSTICE','TYSON','SHARPE','WHITFIELD','TALLEY','MACIAS','IRWIN','BURRIS','RATLIFF','MCCRAY','MADDEN','KAUFMAN','BEACH','GOFF','CASH','BOLTON','MCFADDEN','LEVINE','GOOD','BYERS'
,'KIRKLAND','KIDD','WORKMAN','CARNEY','DALE','MCLEOD','HOLCOMB','ENGLAND','FINCH','HEAD','BURT','HENDRIX','SOSA','HANEY','FRANKS','SARGENT','NIEVES','DOWNS','RASMUSSEN','BIRD','HEWITT','LINDSAY','LE','FOREMAN','VALENCIA'
,'ONEIL','DELACRUZ','VINSON','DEJESUS','HYDE','FORBES','GILLIAM','GUTHRIE','WOOTEN','HUBER','BARLOW','BOYLE','MCMAHON','BUCKNER','ROCHA','PUCKETT','LANGLEY','KNOWLES','COOKE','VELAZQUEZ','WHITLEY','NOEL','VANG'
);


tari varr := varr ('Afghanistan','Albania','Algeria','Andorra','Angola','Antigua ' || chr(38) || ' Deps','Argentina','Armenia','Australia','Austria','Azerbaijan','Bahamas','Bahrain','Bangladesh','Barbados','Belarus','Belgium'
,'Belize','Benin','Bhutan','Bolivia','Bosnia Herzegovina','Botswana','Brazil','Brunei','Bulgaria','Burkina','Burundi','Cambodia','Cameroon','Canada','Cape Verde','Central African Rep','Chad','Chile','China'
,'Colombia','Comoros','Congo','Congo {Democratic Rep}','Costa Rica','Croatia','Cuba','Cyprus','Czech Republic','Denmark','Djibouti','Dominica','Dominican Republic','East Timor','Ecuador','Egypt','El Salvador'
,'Equatorial Guinea','Eritrea','Estonia','Ethiopia','Fiji','Finland','France','Gabon','Gambia','Georgia','Germany','Ghana','Greece','Grenada','Guatemala','Guinea','Guinea-Bissau','Guyana','Haiti','Honduras'
,'Hungary','Iceland','India','Indonesia','Iran','Iraq','Ireland {Republic}','Israel','Italy','Ivory Coast','Jamaica','Japan','Jordan','Kazakhstan','Kenya','Kiribati','Korea North','Korea South','Kosovo','Kuwait'
,'Kyrgyzstan','Laos','Latvia','Lebanon','Lesotho','Liberia','Libya','Liechtenstein','Lithuania','Luxembourg','Macedonia','Madagascar','Malawi','Malaysia','Maldives','Mali','Malta','Marshall Islands','Mauritania'
,'Mauritius','Mexico','Micronesia','Moldova','Monaco','Mongolia','Montenegro','Morocco','Mozambique','Myanmar, {Burma}','Namibia','Nauru','Nepal','Netherlands','New Zealand','Nicaragua','Niger','Nigeria','Norway'
,'Oman','Pakistan','Palau','Panama','Papua New Guinea','Paraguay','Peru','Philippines','Poland','Portugal','Qatar','Romania','Russian Federation','Rwanda','St Kitts ' || chr(38) || ' Nevis','St Lucia'
,'Saint Vincent ' || chr(38) || ' the Grenadines'
,'Samoa','San Marino','Sao Tome ' || chr(38) || ' Principe','Saudi Arabia','Senegal','Serbia','Seychelles','Sierra Leone','Singapore','Slovakia','Slovenia','Solomon Islands','Somalia','South Africa','South Sudan','Spain'
,'Sri Lanka','Sudan','Suriname','Swaziland','Sweden','Switzerland','Syria','Taiwan','Tajikistan','Tanzania','Thailand','Togo','Tonga','Trinidad ' || chr(38) || ' Tobago','Tunisia','Turkey','Turkmenistan','Tuvalu','Uganda'
,'Ukraine','United Arab Emirates','United Kingdom','United States','Uruguay','Uzbekistan','Vanuatu','Vatican City','Venezuela','Vietnam','Yemen','Zambia','Zimbabwe');

v_id number(38,0) := 0;
v_nume1 varchar (70);
v_nume2 varchar (70);
v_duplicat varchar (150) :=' ';
v_tara varchar (70);
v_pos int := 1;
v_pos1 int := 1;
begin
while v_id < 1000000 loop
v_nume1 :=  nume(v_pos1);
v_pos:=1;
while (v_pos<=1000) loop
     v_id:=v_id+1;
      v_nume2 := prenume(v_pos);
      v_tara := tari(floor(DBMS_RANDOM.value(1,tari.count())));
        insert into users (id,username,password,email,adress) values (v_id,v_nume1 || '.' || v_nume2, dbms_random.string('X', 10),v_nume1 || '.' || v_nume2 || '@example.com',v_tara);
        v_pos:=v_pos+1;
end loop;
v_pos1:=v_pos1+1;
if(mod(v_id,100000) = 0 ) then 
DBMS_OUTPUT.PUT_LINE(v_id);
end if;
v_duplicat:=' ';
end loop;
end;




declare
TYPE varr IS VARRAY(1000) OF varchar2(70);
tari varr := varr ('Afghanistan','Albania','Algeria','Andorra','Angola','Antigua ' || chr(38) || ' Deps','Argentina','Armenia','Australia','Austria','Azerbaijan','Bahamas','Bahrain','Bangladesh','Barbados','Belarus','Belgium'
,'Belize','Benin','Bhutan','Bolivia','Bosnia Herzegovina','Botswana','Brazil','Brunei','Bulgaria','Burkina','Burundi','Cambodia','Cameroon','Canada','Cape Verde','Central African Rep','Chad','Chile','China'
,'Colombia','Comoros','Congo','Congo {Democratic Rep}','Costa Rica','Croatia','Cuba','Cyprus','Czech Republic','Denmark','Djibouti','Dominica','Dominican Republic','East Timor','Ecuador','Egypt','El Salvador'
,'Equatorial Guinea','Eritrea','Estonia','Ethiopia','Fiji','Finland','France','Gabon','Gambia','Georgia','Germany','Ghana','Greece','Grenada','Guatemala','Guinea','Guinea-Bissau','Guyana','Haiti','Honduras'
,'Hungary','Iceland','India','Indonesia','Iran','Iraq','Ireland {Republic}','Israel','Italy','Ivory Coast','Jamaica','Japan','Jordan','Kazakhstan','Kenya','Kiribati','Korea North','Korea South','Kosovo','Kuwait'
,'Kyrgyzstan','Laos','Latvia','Lebanon','Lesotho','Liberia','Libya','Liechtenstein','Lithuania','Luxembourg','Macedonia','Madagascar','Malawi','Malaysia','Maldives','Mali','Malta','Marshall Islands','Mauritania'
,'Mauritius','Mexico','Micronesia','Moldova','Monaco','Mongolia','Montenegro','Morocco','Mozambique','Myanmar, {Burma}','Namibia','Nauru','Nepal','Netherlands','New Zealand','Nicaragua','Niger','Nigeria','Norway'
,'Oman','Pakistan','Palau','Panama','Papua New Guinea','Paraguay','Peru','Philippines','Poland','Portugal','Qatar','Romania','Russian Federation','Rwanda','St Kitts ' || chr(38) || ' Nevis','St Lucia'
,'Saint Vincent ' || chr(38) || ' the Grenadines'
,'Samoa','San Marino','Sao Tome ' || chr(38) || ' Principe','Saudi Arabia','Senegal','Serbia','Seychelles','Sierra Leone','Singapore','Slovakia','Slovenia','Solomon Islands','Somalia','South Africa','South Sudan','Spain'
,'Sri Lanka','Sudan','Suriname','Swaziland','Sweden','Switzerland','Syria','Taiwan','Tajikistan','Tanzania','Thailand','Togo','Tonga','Trinidad ' || chr(38) || ' Tobago','Tunisia','Turkey','Turkmenistan','Tuvalu','Uganda'
,'Ukraine','United Arab Emirates','United Kingdom','United States','Uruguay','Uzbekistan','Vanuatu','Vatican City','Venezuela','Vietnam','Yemen','Zambia','Zimbabwe');

v_id number(38,0) := 0;
begin
while v_id < tari.count() loop
v_id:=v_id+1;
insert into country (id,name) values (v_id,tari(v_id));
end loop;
end;



declare
v_id1 number(38,0) := 0;
v_id2 number(38,0) := 0;
begin
while v_id1 <= 196 loop
v_id1:=v_id1+1;
v_id2:=v_id1+1;
while v_id2 <= 196 loop
insert into countryconnections (countryoneid,countrytwoid,cost) values (v_id1,v_id2,dbms_random.value(1,1000));
v_id2:=v_id2+1;
end loop;
end loop;
end;





declare
v_id number(38,0) := 0;
v_nume varchar (40);
v_categorie varchar(40);
v_pret number(36,2);
v_model varchar(7);
v_ite int :=1;
v_duplicat varchar (80) :=' ';
begin
v_nume := 'Samsung';
v_categorie := 'Phone';
while v_id < 150 loop
v_id:=v_id+1;
v_model := dbms_random.string('X', 7);
v_pret := round(dbms_random.value(100,4000),2);
begin
select name into v_duplicat from products where name = v_nume || ' ' || v_model;
exception when NO_DATA_FOUND then 
insert into products (id,sellerid,name,description,type,price) values (v_id,round(dbms_random.value(1,1000000)),v_nume || ' ' || v_model,'Phone from Samsung, model ' || v_model,v_categorie,v_pret);
end;
end loop;


v_nume := 'Iphone';
v_categorie := 'Phone';
while v_id < 300 loop
v_id:=v_id+1;
v_model := dbms_random.string('X', 7);
v_pret := round(dbms_random.value(100,4000),2);
begin
select name into v_duplicat from products where name = v_nume || ' ' || v_model;
exception when NO_DATA_FOUND then 
insert into products (id,sellerid,name,description,type,price) values (v_id,round(dbms_random.value(1,1000000)),v_nume || ' ' || v_model,'Phone from Apple, model ' || v_model,v_categorie,v_pret);
end;
end loop;



v_nume := 'Samsung';
v_categorie := 'Fridge';
while v_id < 300 loop
v_id:=v_id+1;
v_model := dbms_random.string('X', 7);
v_pret := round(dbms_random.value(700,4000),2);
begin
select name into v_duplicat from products where name = v_nume || ' ' || v_model;
exception when NO_DATA_FOUND then 
insert into products (id,sellerid,name,description,type,price) values (v_id,round(dbms_random.value(1,1000000)),v_nume || ' ' || v_model,'Fridge from Samsung, model ' || v_model,v_categorie,v_pret);
end;
end loop;



v_nume := 'Bosch';
v_categorie := 'Blender';
while v_id < 500 loop
v_id:=v_id+1;
v_model := dbms_random.string('X', 7);
v_pret := round(dbms_random.value(50,1000),2);
begin
select name into v_duplicat from products where name = v_nume || ' ' || v_model;
exception when NO_DATA_FOUND then 
insert into products (id,sellerid,name,description,type,price) values (v_id,round(dbms_random.value(1,1000000)),v_nume || ' ' || v_model,'Blender from Bosch, model ' || v_model,v_categorie,v_pret);
end;
end loop;


v_nume := 'HyperX';
v_categorie := 'Headset';
while v_id < 550 loop
v_id:=v_id+1;
v_model := dbms_random.string('X', 7);
v_pret := round(dbms_random.value(100,500),2);
begin
select name into v_duplicat from products where name = v_nume || ' ' || v_model;
exception when NO_DATA_FOUND then 
insert into products (id,sellerid,name,description,type,price) values (v_id,round(dbms_random.value(1,1000000)),v_nume || ' ' || v_model,'Headset from HyperX, model ' || v_model,v_categorie,v_pret);
end;
end loop;


v_nume := 'Nikon';
v_categorie := 'Camera';
while v_id < 650 loop
v_id:=v_id+1;
v_model := dbms_random.string('X', 7);
v_pret := round(dbms_random.value(1000,10000),2);
begin
select name into v_duplicat from products where name = v_nume || ' ' || v_model;
exception when NO_DATA_FOUND then 
insert into products (id,sellerid,name,description,type,price) values (v_id,round(dbms_random.value(1,1000000)),v_nume || ' ' || v_model,'Camera from Nikon, model ' || v_model,v_categorie,v_pret);
end;
end loop;

end;
/




declare
TYPE varr IS VARRAY(6) OF varchar(50);
v_id number(38,0) := 0;
lista varr :=varr('Samsung','Phone','Iphone','Blender','Camera','Fridge');
v_val varchar2(50);
v_userid number(38,0);
begin
while v_id < 10000 loop
v_val :=lista(round(dbms_random.value(1,lista.count())));
    v_id:=v_id+1;
    v_userid :=round(dbms_random.value(1,1000000));
    insert into searches (id,userid,search) values (v_id,
    v_userid,
    v_val);
    insert into activities (id,userid,name,time) values (v_id+500000,v_userid,'search',systimestamp - numtodsinterval(dbms_random.value * 5000, 'DAY'));
end loop;
end;
/




declare
v_id number(38,0) := 0;
v_buyerid number(38,0);
v_countryid number(38,0);
v_date timestamp;
v_date2 timestamp;
begin
while v_id < 500000 loop
 v_id:=v_id+1;
 v_buyerid := round(dbms_random.value(1,1000000));
 select country.id into v_countryid from country, users where v_id = users.id and users.adress = country.name;
 v_date := systimestamp - numtodsinterval(dbms_random.value * 5000, 'DAY');
 v_date2 := v_date + numtodsinterval(dbms_random.value * 30, 'DAY');
 insert into orders (id,buyerid,destcountryid,placed_at,arrived_on) values (v_id,v_buyerid,v_countryid,v_date,v_date2 );
 insert into activities (id,userid,name,time) values (v_id,v_buyerid,'placed order',v_date);
end loop;
end;
/


declare
v_id number(38,0) := 0;
begin
while v_id < 500000 loop
 v_id:=v_id+1;
 insert into orderdetails (id,orderid,productid,quantity) values (v_id,v_id,round(dbms_random.value(1,650)),round(dbms_random.value(1,7)));
end loop;
end;
/


create sequence batch_seq start with 510000;
/

create sequence users_seq start with 1000000;
/

create sequence products_seq start with 650;
/

create sequence orderdets_seq start with 500000;
/

create sequence orders_seq start with 500000;
/


create index i_username on Users(Username);
create index i_prodname on products(name);
create index i_searches on searches(search);
create index i_orderdest on orders(destcountryid);
create index i_orderdate on orders(placed_at);
create index i_activitiestype on activities(name);
create index i_activitiesdate on activities(time);

/* can be totally ignored 
set serveroutput on ;
DECLARE
  l_ran_time TIMESTAMP;
BEGIN
  SELECT sysdate+
         dbms_random.value(0, SYSDATE) 
  INTO l_ran_time
  FROM dual;
  dbms_output.put_line(l_ran_time);
END;
/

declare
da timestamp;
nu timestamp;
begin
da := systimestamp - numtodsinterval(dbms_random.value * 1000, 'DAY');
nu := da + numtodsinterval(dbms_random.value * 10, 'DAY');
dbms_output.put_line(da || ' ' || nu);
end;
*/
