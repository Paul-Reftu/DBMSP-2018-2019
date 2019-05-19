
create index i_userpass on USERS(username,password);

create or replace procedure changePass(v_code in varchar2,pass in varchar2, value out int) is
v_id int;
v_email varchar2(70);
v_code1 varchar2(1000);
begin
v_code1 := utl_encode.text_decode(v_code,'AL32UTF8',UTL_ENCODE.BASE64);
v_code1 := substr(v_code1,1,instr(v_code1,' ')-1);
update users set password=trim(pass) where id = to_number(v_code1);
insert into activities (id,userid,name,time) values (batch_seq.nextval,to_number(v_code1),'changed password',systimestamp);
delete from passresettable where v_code = code;
value:=1;
return;
end;

create or replace procedure IsCodeValid(v_code in varchar2,value out int) is
v_id number(38,0);
begin
begin
select id into v_id from passresettable where trim(v_code)=trim(code);
exception when no_data_found then
  value:=0;
  return;
end;
value:=1;
return ;
end;


set serveroutput on;
create or replace procedure LogIn (user in varchar2,passw in varchar2,value out int) is    /*  all variables are automatically 'bind variables' for performance and security  */
  v_id number(38,0);
begin
  begin
  select id into v_id from users where users.username = user and users.password = passw group by username,password,id;
  EXCEPTION WHEN no_data_found THEN
          value:=0;
          return;
  end;
  insert into activities (id,userid,name,time) values (batch_seq.nextval,v_id,'Login',systimestamp);
  value:=1;
  return;
end;


 set serveroutput on;
 begin
 DBMS_OUTPUT.PUT_LINE( users_seq.nextval);
 end;

create or replace procedure ValidAdress(adress in out varchar2, value out int) is
v_id int;
begin
adress:=trim(initcap(lower(adress)));
begin
select id into v_id from country where adress = name;
exception when no_data_found then 
  value:=0;
  return;
end;
value:=1;
return;
end;



/* before calling this verify in php if password matches ^(?=.*([[:lower:]])+)(?=.*([[:upper:]])+)(?=.*([[:digit:]])+)(?=.*([[:punct:]])+)[[:lower:][:upper:][:digit:][:punct:]]{8,20}$ cause pl sql is a twat and does not know some symbols from here */
create or replace procedure register(usernm in varchar2, emailus in varchar2, adress in varchar2,value out int) is
v_pass varchar2(10);
v_id number(38,0);
begin
v_pass := dbms_random.string('X', 10);
begin
  select id into v_id from users where users.username = usernm;
  EXCEPTION WHEN no_data_found THEN
          begin
            select id into v_id from users where users.email = emailus ;
            EXCEPTION WHEN no_data_found THEN
                    insert into users (id,username,password,email,adress) values (users_seq.nextval,usernm,v_pass,emailus,adress);
                      apex_mail_p.mail('Oracleappsnotes', emailus, 'Thank you for registering', usernm 
                      || ' thank you for choosing us
                      '  ||'<br> Your password is: ' || v_pass || '<br> Please change it as fast as possible');
                    value:=0;
                    return;
            end;
            value:=1;
            return;
  end;
value:=2;
return;
end;

declare
value int:=-1;
begin
Register('example46.example','kawufih@first-mail.info','Romania',value);
end;

  set serveroutput on;
create or replace procedure issuerestcode(emailaddr in varchar2 , value out int) is
v_code varchar2(1000);
v_id number(38,0);
v_username varchar2(70);
begin
begin
select id into v_id from users where EMAIL = emailaddr;
exception when no_data_found then
  value :=1;
  return;
end;
select username into v_username from users where id = v_id; 
v_code := to_char(v_id) || ' '|| v_username || ' ' || emailaddr || ' ' || TO_CHAR(systimestamp);
v_code := utl_encode.text_encode(v_code,'AL32UTF8',UTL_ENCODE.BASE64);
v_code := replace(replace(v_code,chr(10)),chr(13));
insert into passresettable (id,code,issued) values (passreset_seq.nextval,v_code,systimestamp);
insert into activities (id,userid,name,time) values (batch_seq.nextval,v_id,'pass change request',systimestamp);
  apex_mail_p.mail('Oracleappsnotes', emailaddr, 'Password Reset', v_username 
                      || ' you have issued a password reset link, please follow this link '  || 'http://localhost:8081/eStore_project/web_app/changePass.php' || '?' ||'code=' || v_code || '<br> The link will be avariable for the next 24 hours'  || '<br> If you did not ask for this please ignore the email');
value :=0;
return;
end;

declare
ret int;
begin
resettablemanage;
end;


create or replace procedure resettablemanage is
cursor issuedtime is select issued from passresettable order by ISSUED asc;
var_iss timestamp;
v_diff int;
begin
open issuedtime;
loop
  fetch issuedtime into var_iss;
  exit when issuedtime%notfound;
  select  extract(day from diff) days into v_diff from (select systimestamp - var_iss diff from dual);
  if v_diff >=1 then
    delete from passresettable where issued = var_iss;
  else
    return;
  end if;
end loop;
end;

/* after a fucking eternity it works , taken from here: https://oracleappsnotes.wordpress.com/2011/12/18/e-mail-using-plsql-gmail      */
create or replace package apex_mail_p
is
 g_smtp_host varchar2 (256) := 'localhost';
 g_smtp_port pls_integer := 25;
 g_smtp_domain varchar2 (256) := 'smtp.gmail.com';
 g_mailer_id constant varchar2 (256) := 'Mailer by Oracle UTL_SMTP';
 -- send mail using UTL_SMTP
 procedure mail (
 p_sender in varchar2
 , p_recipient in varchar2
 , p_subject in varchar2
 , p_message in varchar2
 );
end;
/
 
create or replace package body apex_mail_p
is
 -- Write a MIME header
 procedure write_mime_header (
 p_conn in out nocopy utl_smtp.connection
 , p_name in varchar2
 , p_value in varchar2
 )
 is
 begin
 utl_smtp.write_data ( p_conn
 , p_name || ': ' || p_value || utl_tcp.crlf
 );
 end;
 procedure mail (
 p_sender in varchar2
 , p_recipient in varchar2
 , p_subject in varchar2
 , p_message in varchar2
 )
 is
 l_conn utl_smtp.connection;
 nls_charset varchar2(255);
 p_to varchar2(250);
 j number:=null;
 p_recipient_store varchar2(4000);
 begin
 -- get characterset
 select value
 into nls_charset
 from nls_database_parameters
 where parameter = 'NLS_CHARACTERSET';
 -- establish connection and autheticate
 l_conn := utl_smtp.open_connection (g_smtp_host, g_smtp_port);
 utl_smtp.ehlo(l_conn, g_smtp_domain);
 utl_smtp.command(l_conn, 'auth login');
 utl_smtp.command(l_conn, UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW('dbmsp030@gmail.com'))));
 utl_smtp.command(l_conn, UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW('Project_13'))));
 -- set from/recipient
 utl_smtp.command(l_conn, 'MAIL FROM: <'||p_sender||'>');
 --loop through all reciepients and issue the RCPT TO command for each one
 p_recipient_store:=p_recipient;
 while nvl(length(p_recipient_store),0)>0
 loop
 select decode(instr(p_recipient_store, ','),
 0,
 length(p_recipient_store) + 1,
 instr(p_recipient_store, ','))
 into j
 from dual;
 p_to:=substr(p_recipient_store,1,j-1);
 utl_smtp.command(l_conn, 'RCPT TO: <'||p_to||'>');
 p_recipient_store:=substr(p_recipient_store,j+1);
 end loop;
 -- write mime headers
 utl_smtp.open_data (l_conn);
 write_mime_header (l_conn, 'From', p_sender);
 write_mime_header (l_conn, 'To', p_recipient);
 write_mime_header (l_conn, 'Subject', p_subject);
 write_mime_header (l_conn, 'Content-Type', 'text/plain');
 write_mime_header (l_conn, 'X-Mailer', g_mailer_id);
 utl_smtp.write_data (l_conn, utl_tcp.crlf);
 -- write message body
 utl_smtp.write_data (l_conn, p_message);
 utl_smtp.close_data (l_conn);
 -- end connection
 utl_smtp.quit (l_conn);
 exception
 when others
 then
 begin
 utl_smtp.quit(l_conn);
 exception
 when others then
 null;
 end;
 raise_application_error(-20000,'Failed to send mail due to the following error: ' || sqlerrm);
 end;
end;
/

set serveroutput on;
create or replace procedure CreateMatrix(matrice out array_2d) is
cursor parcurgere is select countryoneid,countrytwoid,cost from countryconnections order by countryoneid;
v_id1 number(38,0);
v_id2 number(38,0);
v_cost float;
begin
  matrice := array_2d();
  matrice.extend(197);
  for i in matrice.first .. matrice.last loop
    matrice(i) := array_1d();
    matrice(i).extend(197);
  end loop;
  
  open parcurgere;
  loop
    exit when parcurgere%notfound;
    fetch parcurgere into v_id1,v_id2,v_cost;
    matrice(v_id1)(v_id2):=v_cost;
  end loop;
  close parcurgere;
  
  
  /*  print the matrix
  
  for i in matrice.first .. matrice.last loop
      for j in matrice(i).first .. matrice(i).last loop
        dbms_output.put(matrice(i)(j) || '|');
    end loop;
    dbms_output.put_line('');
  end loop;
  */
end;

CREATE OR REPLACE TYPE vector IS table of int
CREATE OR REPLACE TYPE matrice IS table of vector

create or replace procedure bfs (rgraph in out array_2d,s in out int ,t in out int,path in out vector,result out int) is
visited vector;
queue vector;
u int;
v int;
v_index int:=1;
begin
visited :=vector();
visited.extend(197);
queue:=vector();
queue.extend(197);
queue(v_index) := s;
for i in visited.first .. visited.last loop
  visited(i):=0;
end loop;
visited(s):=1;
path(s) := -1;
while v_index > 0 loop
  u := queue(v_index);
  queue(v_index):=0;
  v_index:=v_index-1;
  for v in 1 .. 197 loop
    if (visited(v) = 0 and rgraph(u)(v)  <>0) then 
      v_index:=v_index+1;
      queue(v_index):=v;
      path(v) :=u;
      visited(v):=1;
    end if;
  end loop;
end loop;
if visited(t) = 1 then
  result :=1;
else
  result :=0;
end if;

end;

create or replace procedure FordF(graph in out array_2d,s in out int,t in out int) is
u int:=1;
v int :=1;
rgraph array_2d;
path vector:=vector();
max_flow int:=0;
path_flow int :=9999999;
result int :=0;
begin
rgraph :=array_2d();
rgraph.extend(197);
for i in rgraph.first .. rgraph.last loop
  rgraph(i):=array_1d();
  rgraph(i).extend(197);
end loop;
for i in rgraph.first .. rgraph.last loop
  for j in rgraph(i).first .. rgraph(i).last loop
    rgraph(i)(j):= graph(i)(j);
  end loop;
end loop;
path.extend(197);
for i in path.first .. path.last loop
  path(i) := 0;
end loop;
max_flow:=0;
bfs(rgraph,s,t,path,result);
while(result = 1) loop
  path_flow:=9999999;
  v:=t;
  loop
    exit when v = s;
    u := path(v);
    if(path_flow > rgraph(u)(v)) then 
      path_flow:=rgraph(u)(v);
    end if;
    v:=path(v);
    bfs(rgraph,s,t,path,result);
  end loop;
  
  
  v:=t;
  loop
    exit when v = s;
    u := path(v);
    rgraph(u)(v) :=rgraph(u)(v) - path_flow;
    rgraph(v)(u) :=rgraph(v)(u) + path_flow;
    v:=path(v);
  end loop;
  
  max_flow:=max_flow + path_flow;
end loop;
dbms_output.put_line(max_flow);
end;


set SERVEROUTPUT ON;
declare
graph array_2d;
s int:=1;
t int:=6;
begin
graph:=array_2d();
graph.extend(197);
for i in graph.first .. graph.last loop
  graph(i):=array_1d();
  graph(i).extend(197);
end loop;
graph(1)(1) := 0;
graph(1)(2):= 16;
graph(1)(3):= 13;
graph(1)(4):= 0;
graph(1)(5):= 0;
graph(1)(6):= 0;
graph(2)(1) := 0;
graph(2)(2) := 0;
graph(2)(3) := 10;
graph(2)(4) := 12;
graph(2)(5) := 0;
graph(2)(6) :=0;
graph(3)(1) :=0;
graph(3)(2) :=4;
graph(3)(3) := 0;
graph(3)(4) :=0;
graph(3)(5) :=14;
graph(3)(6) :=0;
graph(4)(1) :=0;
graph(4)(2) := 0;
graph(4)(3) :=9;
graph(4)(4) :=0;
graph(4)(5) :=0;
graph(4)(6) := 20;
graph(5)(1) := 0;
graph(5)(2) :=0;
graph(5)(3) :=0;
graph(5)(4) := 7;
graph(5)(5) := 0;
graph(5)(6) :=4;
graph(6)(1) := 0;
graph(6)(2) :=0;
graph(6)(3) := 0;
graph(6)(4) :=0;
graph(6)(5) :=0;
graph(6)(6) := 0;
FordF(graph,s,t);
end;


create or replace procedure GetSinks(v_source in out int,v_date in timestamp,v_list in out vector) is 
cursor v_id is select destcountryid from orders where extract (day from v_date)||extract (month from v_date)||extract (year from v_date)  = extract (day from placed_at)||extract (month from placed_at)||extract (year from placed_at) ;
id int:=0;
data varchar2(10);
begin
open v_id;
loop
  fetch v_id into id ;
  exit when v_id%notfound;
  v_list.extend(1);
  v_list(v_list.count()):=id;
end loop;
close v_id;
end;

declare
matrix array_2d;
s int :=143;
t int:= 197;
v_list vector;
begin
CreateMatrix(matrix);
v_list:=vector();
GetSinks(s,systimestamp,v_list);
for i in matrix(197).first .. matrix(197).last loop
  matrix(197)(i):=0;
end loop;
if (v_list.count()>0) then
    for i in v_list.first .. v_list.last loop
      matrix(v_list(i))(197):=99999;
    end loop;
end if;
/*
for i in matrix.first .. matrix.last loop
      for j in matrix(i).first .. matrix(i).last loop
        dbms_output.put(matrix(i)(j) || '|');
    end loop;
    dbms_output.put_line('');
  end loop;*/
  
  
  
  
/* Prints max flow for multiple sinks */

FordF(matrix,s,t);
end;