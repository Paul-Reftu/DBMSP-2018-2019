
create index i_userpass on USERS(username,password);

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
insert into passresettable (id,code,issued) values (passreset_seq.nextval,v_code,systimestamp);
insert into activities (id,userid,name,time) values (batch_seq.nextval,v_id,'pass change request',systimestamp);
  apex_mail_p.mail('Oracleappsnotes', emailaddr, 'Password reset', v_username 
                      || ' you have issued a password reset link, please follow this link '  || v_code || '<br> The link will be avariable for the next 24 hours'  || '<br> If you did not ask for this please ignore the email');
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


