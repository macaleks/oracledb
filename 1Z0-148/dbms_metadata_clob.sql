DECLARE
-- Define local variables.
h       NUMBER;         -- handle returned by OPEN
th      NUMBER;         -- handle returned by ADD_TRANSFORM
doc     clob;           -- metadata is returned in a CLOB
BEGIN
 DBMS_OUTPUT.ENABLE(NULL);
-- Specify the object type.
 h := DBMS_METADATA.OPEN('TABLE');

 -- Use filters to specify the schema.
 DBMS_METADATA.SET_FILTER(h,'SCHEMA','SCOTT');
 DBMS_METADATA.SET_FILTER(h,'NAME','EMP_PART');

  th := dbms_metadata.add_transform(h
                                      ,'MODIFY');
  dbms_metadata.set_remap_param(th
                                  ,'REMAP_SCHEMA'
                                  ,'SCOTT'
                                  ,null);

 -- Request that the metadata be transformed into creation DDL.
 th := DBMS_METADATA.ADD_TRANSFORM(h,'DDL');
 
 dbms_metadata.set_transform_param(Th
                                    ,'SEGMENT_ATTRIBUTES'
                                    ,false);
                                    
   /*dbms_metadata.set_transform_param(th
                                    ,'PARTITIONING'
                                    ,false);*/
 -- Fetch the objects.
 --LOOP
   doc := DBMS_METADATA.fetch_clob(h);

   -- When there are no more objects to be retrieved, FETCH_CLOB returns NULL.
   --EXIT WHEN doc IS NULL;

   -- Store the metadata in the table.
   --INSERT INTO my_metadata(md) VALUES (doc);
   --COMMIT;
   DBMS_OUTPUT.PUT_LINE(doc);
   DBMS_OUTPUT.new_line();
 
 -- Release resources.
 DBMS_METADATA.CLOSE(h);
END;
/
