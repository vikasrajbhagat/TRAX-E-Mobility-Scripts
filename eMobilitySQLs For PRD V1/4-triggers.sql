--triggers
create or replace TRIGGER "TR_DEFECT_REPORT_IOS_SYNC"
AFTER DELETE OR INSERT OR UPDATE ON DEFECT_REPORT
FOR EACH ROW
declare
  d_default_date date;
  messageType varchar2(100);
contentData varchar2(4000) ;
pragma autonomous_transaction;
BEGIN

If Updating Then
  d_default_date := TO_DATE('00010101','YYYYMMDD');


  if (((nvl(:new."DEFECT_TYPE", '') != nvl(:old."DEFECT_TYPE", '')) or
      (nvl(:new."DEFECT", '')!= nvl(:old."DEFECT", '') ) or
      (nvl(:new."DEFECT_ITEM", '') != nvl(:old."DEFECT_ITEM", '')) or
      (nvl(:new."DEFECT_DESCRIPTION", '') != nvl(:old."DEFECT_DESCRIPTION", '')) or
      (nvl(:new."AC", '') != nvl(:old."AC", '')) or
      (nvl(:new."CHAPTER", 0) != nvl(:old."CHAPTER", 0)) or
      (nvl(:new."SECTION", 0) != nvl(:old."SECTION", 0)) or
      (nvl(:new."FLIGHT", '') != nvl(:old."FLIGHT", '')) or
      (nvl(:new."FLIGHT_PHASE", '') != nvl(:old."FLIGHT_PHASE", '')) or
      (nvl(:new."DEFER_TO_DATE", '') != nvl(:old."DEFER_TO_DATE", '')) or
      (nvl(:new."STATION", '') != nvl(:old."STATION", '')) or
      (nvl(:new."DEFER_DATE", d_default_date) != nvl(:old."DEFER_DATE", d_default_date)) or
      (nvl(:new."DEFER_HOUR", 0) != nvl(:old."DEFER_HOUR", 0)) or
      (nvl(:new."DEFER_MINUTE", 0) != nvl(:old."DEFER_MINUTE", 0)) or
      (nvl(:new."MDDR", '') != nvl(:old."MDDR", '')) or
      (nvl(:new."DEFER", '') != nvl(:old."DEFER", '')) or
      (nvl(:new."DEFER_BY", '') != nvl(:old."DEFER_BY", '')) or
      (nvl(:new."MEL_NUMBER", '') != nvl(:old."MEL_NUMBER", '')) or
      (nvl(:new."DEFER_CATEGORY", '') != nvl(:old."DEFER_CATEGORY", '')) or
      (nvl(:new."SCHEDULE_HOURS", 0) != nvl(:old."SCHEDULE_HOURS", 0)) or
      (nvl(:new."SCHEDULE_CYCLES", 0) != nvl(:old."SCHEDULE_CYCLES", 0)) or
      (nvl(:new."SCHEDULE_DAYS", 0) != nvl(:old."SCHEDULE_DAYS", 0)) or
      (nvl(:new."DEFER_TO_NEXT_EC", '') != nvl(:old."DEFER_TO_NEXT_EC", '')) or
      (nvl(:new."SKILL", '') != nvl(:old."SKILL", '')) or
      (nvl(:new."MAN_HOURS", 0) != nvl(:old."MAN_HOURS", 0)) or
      (nvl(:new."MAN_REQUIRED", 0) != nvl(:old."MAN_REQUIRED", 0)) or
      (nvl(:new."CAPABILITY_AREA", '') != nvl(:old."CAPABILITY_AREA", '')) or
      (nvl(:new."REPEAT_NUMBER", 0) != nvl(:old."REPEAT_NUMBER", 0)) or
      (nvl(:new."COMPLETED_NUMBER", 0) != nvl(:old."COMPLETED_NUMBER", 0)) or
      (nvl(:new."DISPATCHER_NOTIFIED", '') != nvl(:old."DISPATCHER_NOTIFIED", '')) or
      (nvl(:new."NOT_DO_ALLOW_CONCESSION", '') != nvl(:old."NOT_DO_ALLOW_CONCESSION", '')) or
      (nvl(:new."MEL_CALENDAR_DAYS_FLAG", '') != nvl(:old."MEL_CALENDAR_DAYS_FLAG", '')) or
      (nvl(:new."DEFER_NOTES", '') != nvl(:old."DEFER_NOTES", '')) or
      (nvl(:new."MEL", '') != nvl(:old."MEL", '')) or
      (nvl(:new."WO", 0) != nvl(:old."WO", 0)) or
      (nvl(:new."RESOLUTION_CATEGORY", '') != nvl(:old."RESOLUTION_CATEGORY", '')) or
      (nvl(:new."RESOLVED_BY", '') != nvl(:old."RESOLVED_BY", '')) or
      (nvl(:new."RESOLVED_DATE", d_default_date) != nvl(:old."RESOLVED_DATE", d_default_date)) or
      (nvl(:new."RESOLUTION_DESCRIPTION", '') != nvl(:old."RESOLUTION_DESCRIPTION", '')) or
      (nvl(:new."DISPATCHER_NOTIFIED_RESOLUTION", '') != nvl(:old."DISPATCHER_NOTIFIED_RESOLUTION", '')) or
      (nvl(:new."RESOLVED_LOCATION", '') != nvl(:old."RESOLVED_LOCATION", '')) or
      (nvl(:new."FAULT_CONFIRM", '') != nvl(:old."FAULT_CONFIRM", '')) or
      (nvl(:new."REPORTED_BY", '') != nvl(:old."REPORTED_BY", '')) or
      (nvl(:new."SDR", '') != nvl(:old."SDR", '')) or
      (nvl(:new."DEFECT_GATE", '') != nvl(:old."DEFECT_GATE", '')) or
      (nvl(:new."INTERNAL_CAPABILITY", '') != nvl(:old."INTERNAL_CAPABILITY", '')) or
      (nvl(:new."REPORTED_DATE", d_default_date) != nvl(:old."REPORTED_DATE", d_default_date)) or
      (nvl(:new."CADOR_DAMAGE", '') != nvl(:old."CADOR_DAMAGE", '')) or
      (nvl(:new."AUTHORIZATION_DATE", '') != nvl(:old."AUTHORIZATION_DATE", '')) or
      (nvl(:new."STATUS", '') != nvl(:old."STATUS", '')) or
      (nvl(:new."MIS", '') != nvl(:old."MIS", '')) or
      (nvl(:new."I_F_S_D", '') != nvl(:old."I_F_S_D", '')) or
      (nvl(:new."MEL_SUB", '') != nvl(:old."MEL_SUB", '')) )
      )
  Then

   plog.debug( 'DEFECT: ' || :NEW.DEFECT  || 'DEFECT TYPE: ' || :NEW.DEFECT_TYPE || ' STATUS: ' || :new.status) ;
     messageType := 'SYNCDEFECT';

   contentData  := '{ "messageType": "' || messageType || '" , "defectKey": { "defect": "'||:new."DEFECT"||'", "defectType": "'||:new."DEFECT_TYPE"||'", "defectItem": "' ||:new."DEFECT_ITEM"|| '" } }';


    PKG_WEB_REST.syncEmobilityQueue(contentData,messageType);

  end if;

elsif inserting then

	messageType := 'SYNCDEFECT';

	contentData  := '{ "messageType": "' || messageType || '" , "defectKey": { "defect": "'||:new."DEFECT"||'", "defectType": "'||:new."DEFECT_TYPE"||'", "defectItem": "' ||:new."DEFECT_ITEM"|| '" } }';


    PKG_WEB_REST.syncEmobilityQueue(contentData,messageType);



elsif deleting then

      messageType := 'SYNCDEFECT/DELETE';

	   contentData  := '{ "messageType": "' || messageType || '" , "defectKey": { "defect": "'||:old."DEFECT"||'", "defectType": "'||:old."DEFECT_TYPE"||'", "defectItem": "' ||:old."DEFECT_ITEM"|| '" } }';


    PKG_WEB_REST.syncEmobilityQueue(contentData,messageType);

end if;


exception when others then
  null;


END;


 / 
 
 create or replace TRIGGER "TR_FLIGHT_SCHEDULE_IOS" AFTER UPDATE ON FLIGHT_SCHEDULE
FOR EACH ROW
declare
pragma autonomous_transaction;
messageType varchar2(100);
contentData varchar2(4000) ;
message varchar2(300);
oldDeptDate date ;
oldArrivalDate date;
newDeptDate date;
newArrivalDate date ;
fstatus varchar2(100);

BEGIN

oldDeptDate :=  trunc(:old.schedule_date) + 1/24* :old.SCHEDULE_DEPART_HOUR_ZULU + 1/24/60 * :old.SCHEDULE_DEPART_MINUTE_ZULU  ;
newDeptDate :=  trunc(:new.schedule_date) + 1/24* :new.SCHEDULE_DEPART_HOUR_ZULU + 1/24/60 * :new.SCHEDULE_DEPART_MINUTE_ZULU  ;

oldArrivalDate :=  trunc(:old.SCHEDULE_ARRIVAL_DATE_ZULU) + 1/24* :old.SCHEDULE_ARRIVAL_HOUR_ZULU + 1/24/60 * :old.SCHEDULE_ARRIVAL_MINUTE_ZULU  ;
newArrivalDate :=  trunc(:new.SCHEDULE_ARRIVAL_DATE_ZULU) + 1/24* :new.SCHEDULE_ARRIVAL_HOUR_ZULU + 1/24/60 * :new.SCHEDULE_ARRIVAL_MINUTE_ZULU  ;

if  :new.ARRIVAL_GATE != :old.ARRIVAL_GATE   or
      oldDeptDate != newDeptDate or
      oldArrivalDate != newArrivalDate or :new.ac != :old.ac
      then

  if oldDeptDate between (sysdate - 1/24*1 )  and (sysdate + 1/24*1 ) or
  oldArrivalDate between (sysdate - 1/24*1 )  and (sysdate + 1/24*1 )
  then  --Something changed and its was supposed to be landing or departing at some location within an hour.

 fstatus := '' ;

 if (:new.ac != :old.ac ) then
    fstatus := fstatus || ' SWAP ' ;
 end if;

 if (:new.ARRIVAL_GATE != :old.ARRIVAL_GATE ) then
  fstatus :=  fstatus || ' Gate change ' ;
 end if;

  if oldDeptDate != newDeptDate then
    if newDeptDate > oldDeptDate then
      fstatus :=  fstatus ||  ' Delay ' ;
    else
      fstatus :=  fstatus ||  ' Schedule Change ' ;
    end if ;
 end if;



 if oldArrivalDate != newArrivalDate then
  if newArrivalDate > oldArrivalDate then
    fstatus :=  fstatus ||  ' Delay ' ;
  else
    fstatus :=  fstatus ||  ' Schedule Change ' ;
  end if ;

 end if;


  message := :new.FLIGHT || ' ' ||  fstatus ||  '\n' ;
  message := message || ' ' || :new.ac || '\n';
  message := message || ' ' || to_char( newDeptDate , 'YYYY-MM-DD HH24:MI' )  || '\n';
  message := message || ' ' || to_char( newArrivalDate , 'YYYY-MM-DD HH24:MI' )  || '\n';
  message := message || ' ' || :new.ARRIVAL_GATE ;


   messageType := 'FLIGHT/UPDATE';

   contentData  := '{ "messageType": "' || messageType || '" , "message": "'|| message ||'", "ac":"' || :new.ac || '" , "arrivalGate":"' || :new.ARRIVAL_GATE || '" , "toLocation":"' || :new.destination  || '"'
      || ' }';


   PKG_WEB_REST.syncEmobilityQueue(contentData,messageType);

 end if;

end if;

exception when others then
  null;

END;

 / 
 
 
 create or replace TRIGGER "TRG_AC_PN_TRANS_HIST_IOS"
AFTER INSERT  ON AC_PN_TRANSACTION_HISTORY
FOR EACH ROW
DECLARE

s_status varchar2(10 CHAR);
messageType varchar2(100);
contentData varchar2(4000) ;
v_pn_category pn_master.category%type ; 
s_pos varchar2(32000 char);
pragma autonomous_transaction;

BEGIN

--INTERCHG
IF NVL(:NEW.TRANSACTION_TYPE, ' ') = 'INSTALL' or NVL(:NEW.TRANSACTION_TYPE, ' ') = 'REMOVE' then 


  select "SYSTEM_TRAN_CODE"."PN_TRANSACTION" 
  into v_pn_category
  from "SYSTEM_TRAN_CODE"  , "PN_INTERCHANGEABLE",   "PN_MASTER"
  where  ( "PN_INTERCHANGEABLE"."PN_INTERCHANGEABLE" = :NEW.PN )
       and ( "PN_INTERCHANGEABLE"."PN" = "PN_MASTER"."PN" ) AND 
      "SYSTEM_TRAN_CODE"."SYSTEM_TRANSACTION" = 'PNCATEGORY' 
        and "SYSTEM_TRAN_CODE"."SYSTEM_CODE" = "PN_MASTER"."CATEGORY" ;

if v_pn_category = 'R' then 

  
  if  NVL(:NEW.TRANSACTION_TYPE, ' ') = 'INSTALL' then
    s_status:= 'INSTALLED' ; 
  end if ;
  
  IF NVL(:NEW.TRANSACTION_TYPE, ' ') = 'REMOVE'  then
   s_status:= 'ISSUED' ; 
  end if;

begin
  SELECT LISTAGG(POSITION,',') WITHIN GROUP (
  ORDER BY POSITION )
  into s_pos
  FROM
   ( SELECT DISTINCT PN_POSITION_DISTRIBUTION.POSITION
    FROM PN_POSITION_DISTRIBUTION ,
      pn_interchangeable pi
    WHERE PN_POSITION_DISTRIBUTION.pn = pi.pn
    AND pi.pn_interchangeable         = :NEW.PN and ac = :new.ac
    );   
exception when others then 
  s_pos := '';
end ;  

if  NVL(:NEW.TRANSACTION_TYPE, ' ') = 'INSTALL' then

  s_pos := :new.position;

end if ; 
  

messageType := 'AC/INSTALL/REMOVE/UPDATE';
contentData  := '{ "ac": "' ||:NEW.AC || '"  , "position": "' || s_pos || '" , "partStatus": "' || s_status || '",  "messageType": "' || messageType ||'", "batch": "'||:NEW.BATCH||'", "pn": "' 
          ||:NEW.PN||'", "sn": "'||:NEW.SN || '" }';
    
  
  PKG_WEB_REST.syncEmobilityQueue(contentData,messageType); 

end if;
end if;

exception when others then 
  null;
END;
 
 /
 
 
 create or replace TRIGGER TRG_EMP_ASSIGM_SYNC_IOS
AFTER INSERT or UPDATE  ON EMPLOYEE_ASSIGNMENTS FOR EACH ROW
DECLARE

s_ac_list EMPLOYEE_ASSIGNMENTS.AC_LIST%TYPE;
s_gate_list EMPLOYEE_ASSIGNMENTS.GATE_LIST%TYPE;
s_location_list  EMPLOYEE_ASSIGNMENTS.LOCATION_LIST%TYPE;
s_employee VARCHAR2(10);
messageType varchar2(100);
contentData varchar2(4000) ;
pragma autonomous_transaction;
BEGIN




s_ac_list := :new.ac_list;
s_gate_list := :new.GATE_LIST;
s_location_list  := :new.LOCATION_LIST;
s_employee := :new.employee;

messageType := 'ASSIGMENT/CHANGE/QT';

     contentData  := '{ "acList": "'||s_ac_list||'", "messageType": "'||messageType||'", "locationList": "'||s_location_list||'", "gateList": "'
          ||s_gate_list|| '", "userName": "'||s_employee|| '" }';


    PKG_WEB_REST.syncEmobilityQueue(contentData,messageType);


exception when others then
  null;

END;

 / 
 create or replace TRIGGER "TRG_PN_EFFECTIVITY_DIST_IOS" 
AFTER DELETE or INSERT  ON PN_EFFECTIVITY_DISTRIBUTION
FOR EACH ROW
DECLARE

pn varchar2(35 CHAR);
messageType varchar2(100);
contentData varchar2(4000) ;
statusUpdate varchar2(10 char);

pragma autonomous_transaction;

BEGIN

if INSERTING then 
statusUpdate := 'UPDATE';
messageType := 'PN/EFF/UPDATE';
contentData  := '{ "pn": "' || :NEW.PN || '"  , "statusUpdate": "' || statusUpdate || '" , "messageType": "' || messageType ||'" }';
end if;

if DELETING then 
statusUpdate := 'UPDATE';
messageType := 'PN/EFF/UPDATE';
contentData  := '{ "pn": "' || :OLD.PN || '"  , "statusUpdate": "' || statusUpdate || '" , "messageType": "' || messageType ||'" }';
end if;
    
  
PKG_WEB_REST.syncEmobilityQueue(contentData,messageType); 

exception when others then 
  null;
END; 

/

create or replace TRIGGER "TRG_PN_INTERCHANGEABLE_IOS" 
AFTER DELETE or INSERT or UPDATE  ON PN_INTERCHANGEABLE
FOR EACH ROW
DECLARE

pn varchar2(35 CHAR);
messageType varchar2(100);
contentData varchar2(4000) ;
statusUpdate varchar2(20 char);

pragma autonomous_transaction;

BEGIN

messageType := 'PN/UPDATE';

if INSERTING then 
statusUpdate := 'INSERT';
contentData  := '{ "pn": "' || :NEW.PN_INTERCHANGEABLE || '"  , "statusUpdate": "' || statusUpdate || '" , "messageType": "' || messageType ||'" }';
end if;
if UPDATING then 
statusUpdate := 'UPDATE';
contentData  := '{ "pn": "' || :NEW.PN_INTERCHANGEABLE || '"  , "statusUpdate": "' || statusUpdate || '" , "messageType": "' || messageType ||'" }';
end if;
if DELETING then 
statusUpdate := 'DELETE';
contentData  := '{ "pn": "' || :OLD.PN_INTERCHANGEABLE || '"  , "statusUpdate": "' || statusUpdate || '" , "messageType": "' || messageType ||'" }';
end if;
  
PKG_WEB_REST.syncEmobilityQueue(contentData,messageType); 

exception when others then 
  null;
END;

/

create or replace TRIGGER "TRG_PN_INVENTORY_HISTORY_IOS"
AFTER INSERT  ON PN_INVENTORY_HISTORY
FOR EACH ROW
DECLARE

s_status varchar2(10 CHAR);
messageType varchar2(100);
contentData varchar2(4000) ;
v_pn_category pn_master.category%type ;
s_pos varchar2(32000 char);
pragma autonomous_transaction;

BEGIN

IF NVL(:NEW.TRANSACTION_TYPE, ' ') = 'ISSUED' or NVL(:NEW.TRANSACTION_TYPE, ' ') = 'A/C INSTALL' or  NVL(:NEW.TRANSACTION_TYPE, ' ') = 'A/C REMOVE' then



  select "SYSTEM_TRAN_CODE"."PN_TRANSACTION"
  into v_pn_category
  from "SYSTEM_TRAN_CODE"  , "PN_INTERCHANGEABLE",   "PN_MASTER"
  where  ( "PN_INTERCHANGEABLE"."PN_INTERCHANGEABLE" = :NEW.PN )
       and ( "PN_INTERCHANGEABLE"."PN" = "PN_MASTER"."PN" ) AND
      "SYSTEM_TRAN_CODE"."SYSTEM_TRANSACTION" = 'PNCATEGORY'
        and "SYSTEM_TRAN_CODE"."SYSTEM_CODE" = "PN_MASTER"."CATEGORY" ;

if v_pn_category = 'R' then

  IF NVL(:NEW.TRANSACTION_TYPE, ' ') = 'ISSUED' then
   s_status:= 'ISSUED' ;
  end if;

  if  NVL(:NEW.TRANSACTION_TYPE, ' ') = 'A/C REMOVE' then
    s_status:= 'REMOVED' ;
  end if ;

  IF NVL(:NEW.TRANSACTION_TYPE, ' ') = 'A/C INSTALL'  then
   s_status:= 'INSTALLED' ;
  end if;

begin
  SELECT LISTAGG(POSITION,',') WITHIN GROUP (
  ORDER BY POSITION )
  into s_pos
  FROM
    ( SELECT DISTINCT PN_POSITION_DISTRIBUTION.POSITION
    FROM PN_POSITION_DISTRIBUTION ,
      pn_interchangeable pi
    WHERE PN_POSITION_DISTRIBUTION.pn = pi.pn
    AND pi.pn_interchangeable         = :NEW.PN
    );
exception when others then
  s_pos := '';
end ;


 contentData  := '{ "ac": "' ||:NEW.AC || '"  , "position": "' || s_pos || '" , "partStatus": "' || s_status || '",  "messageType": "' || messageType ||'", "batch": "'||:NEW.BATCH||'", "pn": "'
          ||:NEW.PN  || '", "issuedTo": "'|| :NEW.ISSUED_TO || '", "picklistNo": "'|| :NEW.ORDER_NO ||  '", "sn": "'||:NEW.SN || '"  }';

  messageType := 'AC/INSTALL/REMOVE/UPDATE';
  PKG_WEB_REST.syncEmobilityQueue(contentData,messageType);

end if;
end if;

exception when others then
  null;
END;

/




 
 
 
 