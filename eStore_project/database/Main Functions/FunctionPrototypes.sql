
create index i_userpass on USERS(username,password);

set serveroutput on;
create or replace procedure LogIn (user in varchar2,passw in varchar2,value out int)is    /*  all variables are automatically 'bind variables' for performance and security  */
v_id number(38,0);
begin
  begin
  select id into v_id from users where users.username = user and users.password = passw group by username,password,id;
  EXCEPTION WHEN no_data_found THEN
          value:=0;
          return;
  end;
  insert into activities (id,userid,name,time) values (batch_seq.nextval,v_id,'Login',to_date(trunc(dbms_random.value(2458573,2454833)),'J'));
  value:=1;
  return;
end;

declare
value int:=-1;
begin
Login('VANG.EDMOND','DSHG5FBYK3',value);
DBMS_OUTPUT.PUT_LINE(value);
end;