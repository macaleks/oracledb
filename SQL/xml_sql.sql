SELECT
XMLELEMENT("DBHOSTS",
    XMLAGG(
        XMLELEMENT("DBHOST",
          XMLELEMENT("ID", H.ID),
          XMLELEMENT("IP", H.IP),
          XMLELEMENT("IP6", H.IP),
          XMLELEMENT("NAME", H.NAME),
          XMLELEMENT("DESCRIPTION", H.DESCRIPTION)
          ,
          XMLELEMENT("DATABASES",
              (SELECT XMLAGG(
                XMLELEMENT("DATABASE",
                  XMLELEMENT("ID", D.ID),
                  XMLELEMENT("BLOCKID", D.BLOCKID),
                  XMLELEMENT("HOSTID", D.HOSTID),
                  XMLELEMENT("HOST", D.HOST),
                  XMLELEMENT("PORT", D.PORT),
                  XMLELEMENT("SID", D.SID),
                  XMLELEMENT("DESCRIPTION", D.DESCRIPTION)
                  ,
                  XMLELEMENT("BLOCKS",
                      (SELECT XMLAGG(
                                  XMLELEMENT("BLOCK",
                                      XMLELEMENT("ID", B.ID),
                                      XMLELEMENT("CODE", B.CODE),
                                      XMLELEMENT("DESCRIPTION", B.DESCRIPTION),
                                      XMLELEMENT("DATACENTERNAME", B.DATACENTERNAME),
                                      XMLELEMENT("CLUSTERID", B.CLUSTERID),
                                      XMLELEMENT("CURRENTMODEID", B.CURRENTMODEID),
                                      XMLELEMENT("PREVIOUSMODEID", B.PREVIOUSMODEID),
                                      XMLELEMENT("LASTUPDATED", B.LASTUPDATED),
                                      XMLELEMENT("CREATED", B.CREATED),
                                      XMLELEMENT("BLOCKTYPEID", B.BLOCKTYPEID),
                                      XMLELEMENT("BLOCKSTATUSID", B.BLOCKSTATUSID),
                                      XMLELEMENT("TRANSITIONSTATUSID", B.TRANSITIONSTATUSID),
                                      XMLELEMENT("SEGMENTID", B.SEGMENTID)
                                  )
                              )     
                           FROM SI_TP_BLOCK B
                           WHERE B.ID = D.BLOCKID)),
                  XMLELEMENT("PROCESSES",
                      (SELECT XMLAGG(
                                  XMLELEMENT("PROCESS",
                                      XMLELEMENT("ID", PM.ID),
                                      XMLELEMENT("PROCESSNAME", PM.PROCESSNAME),
                                      XMLELEMENT("PROCESSTYPE", PM.PROCESSTYPE),
                                      XMLELEMENT("DESCRIPTION", PM.DESCRIPTION),
                                      XMLELEMENT("DATABASEID", PM.DATABASEID),
                                      XMLELEMENT("PROJECTID", PM.PROJECTID)
                                      ,
                                      XMLELEMENT("PROJECTS",
                                          (SELECT XMLAGG(
                                                      XMLELEMENT("PROJECT",
                                                          XMLELEMENT("ID", P.ID),
                                                          XMLELEMENT("NAME", P.NAME),
                                                          XMLELEMENT("GGSCHEMA", P.GGSCHEMA),
                                                          XMLELEMENT("DESCRIPTION", P.DESCRIPTION)
                                                      )
                                                  )     
                                               FROM SI_TP_GGPROJECT P
                                               WHERE P.ID = PM.PROJECTID))
                                  )
                              )     
                           FROM SI_TP_GGPROCESSMAP PM
                           WHERE PM.DATABASEID = D.ID))         
                  )
                )      
              FROM SI_TP_GGDATABASE D 
              WHERE D.HOSTID = H.ID)
          )
        )
    )
)
FROM SI_TP_GGDBHOST H;