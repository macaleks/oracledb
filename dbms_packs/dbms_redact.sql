create table plch_survey_responses (
  survey_id         integer not null,
  email_address     varchar2(320) not null,
  response_datetime date not null,
  response_text     clob,
  primary key ( survey_id, email_address )
);

insert into plch_survey_responses 
values (1, 'dave.badger@oracle.com', sysdate, 'This was great!');

insert into plch_survey_responses 
values (1, 'simon.squirrel@oracle.com', sysdate, 'This was terrible!');

commit;

begin
  dbms_redact.add_policy (
    object_schema         => user, 
    object_name           => 'plch_survey_responses', 
    policy_name           => 'PLCH Hide email addresses', 
    expression             => '1=1',
    column_name           => 'email_address', 
    function_type         => dbms_redact.full
  );
end;
/

exec SYS.DBMS_REDACT.DROP_POLICY(user, 'plch_survey_responses', 'PLCH Hide email addresses');

begin
  dbms_redact.add_policy (
    object_schema          => user, 
    object_name            => 'plch_survey_responses', 
    policy_name            => 'PLCH Hide email addresses', 
    expression             => '1=1',
    column_name            => 'email_address', 
    function_type          => dbms_redact.regexp,
    regexp_pattern         => dbms_redact.re_pattern_email_address,
    regexp_replace_string  => dbms_redact.re_redact_email_entire
  );
end;
/
exec SYS.DBMS_REDACT.DROP_POLICY(user, 'plch_survey_responses', 'PLCH Hide email addresses');

begin
  dbms_redact.add_policy (
    object_schema          => user, 
    object_name            => 'plch_survey_responses', 
    policy_name            => 'PLCH Hide email addresses', 
    expression             => '1=1',
    column_name            => 'email_address', 
    function_type          => dbms_redact.regexp,
    regexp_pattern         => 
      '([A-Za-z0-9._%+-]+)@([A-Za-z0-9.-]+\.[A-Za-z]{2,4})',
    regexp_replace_string  => 'xxxx@xxxxx.com'
  );
end;
/
exec SYS.DBMS_REDACT.DROP_POLICY(user, 'plch_survey_responses', 'PLCH Hide email addresses');

begin
  dbms_redact.add_policy (
    object_schema          => user, 
    object_name            => 'plch_survey_responses', 
    policy_name            => 'PLCH Hide email addresses', 
    expression             => '1=1',
    column_name            => 'email_address', 
    function_type          => dbms_redact.regexp,
    regexp_pattern         => 
      '([A-Za-z0-9._%+-]+)@([A-Za-z0-9.-]+\.[A-Za-z]{2,4})',
    regexp_replace_string  => '\2@\1'
  );
end;
/
exec SYS.DBMS_REDACT.DROP_POLICY(user, 'plch_survey_responses', 'PLCH Hide email addresses');