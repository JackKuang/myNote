SELECT
     表名       = Case When A.colorder=1 Then D.name Else '' End,
     表说明     = Case When A.colorder=1 Then isnull(F.value,'') Else '' End,
     字段序号   = A.colorder,
     字段名     = A.name,
     字段说明   = isnull(G.[value],''),
     标识       = Case When COLUMNPROPERTY( A.id,A.name,'IsIdentity')=1 Then '√'Else '' End,
     主键       = Case When exists(SELECT 1 FROM sysobjects Where xtype='PK' and parent_obj=A.id and name in (
                      SELECT name FROM sysindexes WHERE indid in( SELECT indid FROM sysindexkeys WHERE id = A.id AND colid=A.colid))) then '√' else '' end,
     类型       = B.name,
     占用字节数 = A.Length,
     长度       = COLUMNPROPERTY(A.id,A.name,'PRECISION'),
     小数位数   = isnull(COLUMNPROPERTY(A.id,A.name,'Scale'),0),
     允许空     = Case When A.isnullable=1 Then '√'Else '' End,
     默认值     = isnull(E.Text,'')
 FROM
     syscolumns A
 Left Join
     systypes B
 On
     A.xusertype=B.xusertype
 Inner Join
     sysobjects D
 On
     A.id=D.id  and D.xtype='U' and  D.name<>'dtproperties'
 Left Join
     syscomments E
 on
     A.cdefault=E.id
 Left Join
 sys.extended_properties  G
 on
     A.id=G.major_id and A.colid=G.minor_id
 Left Join

 sys.extended_properties F
 On
     D.id=F.major_id and F.minor_id=0
     -- 表名
     where d.name like 't_sm%' 
 Order By
     A.id,A.colorder