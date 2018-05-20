with jn as (
    select
        --project
        p.id  as proj_id,
        p.name as proj_name,
        p.ggschema as proj_ggschema,
        p.description as proj_desc,
        --blocks
        b.id blck_id,
        b.code blck_code,
        b.description blck_description,
        b.datacentername blck_datacentername,
        b.clusterid blck_clusterid,
        b.currentmodeid blck_currentmodeid,
        b.previousmodeid blck_previousmodeid,
        b.lastupdated blck_lastupdated,
        b.created blck_created,
        b.blocktypeid blck_blocktypeid,
        b.blockstatusid blck_blockstatusid,
        b.transitionstatusid blck_transitionstatusid,
        b.segmentid blck_segmentid,
        --host
        h.id as host_id,
        h.ip as host_ip,
        h.ip6 as host_ip6,
        h.name as host_name,
        h.description as host_description,
        --databases
        d.id as db_id,
        d.blockid as db_blockid,
        d.hostid as db_hostid,
        d.host as db_host,
        d.port as db_port,
        d.sid as db_sid,
        d.description as db_description,
        --processes
        pm.id as ggp_id,
        pm.processname as ggp_processname,
        pm.processtype as ggp_processtype,
        pm.description as ggp_description,
        pm.databaseid as ggp_databaseid,
        pm.projectid as ggp_projectid
    from si_tp_block b
    join si_tp_ggdatabase d on b.id = d.blockid
    join si_tp_ggdbhost h on d.hostid = h.id
    join si_tp_ggprocessmap pm on pm.databaseid = d.id
    join si_tp_ggproject p on pm.projectid = p.id
    where p.name = 'UFS_STANDIN'),
prjct as (
    select distinct proj_id, proj_name, proj_ggschema, proj_desc
    from jn
),
blck as (
    select distinct blck_id, blck_code, blck_description, blck_datacentername, blck_clusterid, blck_currentmodeid,
                    blck_previousmodeid, blck_lastupdated, blck_created, blck_blocktypeid, blck_blockstatusid, blck_transitionstatusid,
                    blck_segmentid, proj_id
    from jn
),
hst as (
    select distinct host_id, host_ip, host_ip6, host_name, host_description,
                    blck_id
    from jn
),
db as (
    select distinct db_id, db_blockid, db_hostid, db_host, db_port, db_sid, db_description,
                    host_id
    from jn
),
ggp as (select distinct ggp_id, ggp_processname, ggp_processtype, ggp_description, ggp_databaseid, ggp_projectid,
                        db_id
        from jn)
select
    xmlelement("project",
        xmlelement("id", proj_id),
        xmlelement("name", proj_name),
        xmlelement("ggschema", proj_ggschema),
        xmlelement("description", proj_desc)
        ,
        xmlelement("blocks",
            (select xmlagg(
                xmlelement("block",
                    xmlelement("id", blck_id),
                    xmlelement("code", blck_code),
                    xmlelement("description", blck_description),
                    xmlelement("datacentername", blck_datacentername),
                    xmlelement("clusterid", blck_clusterid),
                    xmlelement("currentmodeid", blck_currentmodeid),
                    xmlelement("previousmodeid", blck_previousmodeid),
                    xmlelement("lastupdated", blck_lastupdated),
                    xmlelement("created", blck_created),
                    xmlelement("blocktypeid", blck_blocktypeid),
                    xmlelement("blockstatusid", blck_blockstatusid),
                    xmlelement("transitionstatusid", blck_transitionstatusid),
                    xmlelement("segmentid", blck_segmentid)
                    ,
                    xmlelement("dbhosts",
                        (select xmlagg(
                                    xmlelement("dbhost",
                                        xmlelement("id", host_id),
                                        xmlelement("ip", host_ip),
                                        xmlelement("ip6", host_ip6),
                                        xmlelement("name", host_name),
                                        xmlelement("description", host_description)
                                        ,
                                        xmlelement("databases",
                                            (select xmlagg(
                                                        xmlelement("databases",
                                                            xmlelement("id", db_id),
                                                            xmlelement("blockid", db_blockid),
                                                            xmlelement("hostid", db_hostid),
                                                            xmlelement("host", db_host),
                                                            xmlelement("port", db_port),
                                                            xmlelement("sid", db_sid),
                                                            xmlelement("description", db_description)
                                                            ,
                                                            xmlelement("processes",
                                                                (select xmlagg(
                                                                            xmlelement("process",
                                                                                xmlelement("id", ggp_id),
                                                                                xmlelement("processname", ggp_processname),
                                                                                xmlelement("processtype", ggp_processtype),
                                                                                xmlelement("description", ggp_description),
                                                                                xmlelement("databaseid", ggp_databaseid),
                                                                                xmlelement("projectid", ggp_projectid)
                                                                            )
                                                                        )    
                                                                 from ggp
                                                                 where ggp.db_id = db.db_id)
                                                              )
                                                            )
                                                        )
                                             from db
                                             where hst.host_id = db.host_id)
                                          )
                                        )
                                    )
                         from hst
                         where hst.blck_id = blck.blck_id)
                      )
                    )
                )
                 
            from blck
            where blck.proj_id = prjct.proj_id))
    )
from prjct
/