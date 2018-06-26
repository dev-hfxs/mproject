/* 初始单位信息 */

INSERT INTO t_org(id,org_name,org_code,tax_number,address,area_code,telephone,status) VALUES ('o3f25612335a4d188020d617801ea7bf','天津航峰希萨科技有限公司','tjhfxs','0000000000000000000000000','北京朝阳区阜通东大街6号方恒国际中心B座1808','010','64779901','N');


/* 初始用户类型即角色 */

INSERT INTO t_role(id,role_name,role_type,home_page,role_desc) VALUES('r0dd980638bc43efb2e01d362db32151','超级管理员','S','m.user.mgr#m.add.user','');
INSERT INTO t_role(id,role_name,role_type,home_page,role_desc) VALUES('r0dd980638bc43efb2e01d362db32152','管理员','M','m.user.mgr#m.add.user','');
INSERT INTO t_role(id,role_name,role_type,home_page,role_desc) VALUES('r0dd980638bc43efb2e01d362db32153','系统工程师','E','m.buildproject.mgr#m.project.psn.mgr','可作为安装工程师、调试工程师');
INSERT INTO t_role(id,role_name,role_type,home_page,role_desc) VALUES('r0dd980638bc43efb2e01d362db32154','施工经理','B','m.buildproject.mgr#m.current.project','外部施工单位人员');
INSERT INTO t_role(id,role_name,role_type,home_page,role_desc) VALUES('r0dd980638bc43efb2e01d362db32156','安装工程师','I','m.buildproject.mgr#m.wait.job','');
INSERT INTO t_role(id,role_name,role_type,home_page,role_desc) VALUES('r0dd980638bc43efb2e01d362db32155','调试工程师','D','m.buildproject.mgr#m.wait.job','');

/* 初始用户 */

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a61','grace.wang@sierotech.com','王蓓','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000','r0dd980638bc43efb2e01d362db32151','N','dd4b21e9ef71e1291183a46b913ae6f2','Y','F');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a62','angel.liu@sierotech.com','刘丽静','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000','r0dd980638bc43efb2e01d362db32152','N','dd4b21e9ef71e1291183a46b913ae6f2','Y','F');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a63','emily.yuan@sierotech.com','袁春会','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000','r0dd980638bc43efb2e01d362db32152','N','dd4b21e9ef71e1291183a46b913ae6f2','Y','F');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a64','jianli.yin@sierotech.com','尹建利','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000','r0dd980638bc43efb2e01d362db32153','N','dd4b21e9ef71e1291183a46b913ae6f2','Y','M');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a65','shuai.chang@sierotech.com','常帅','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000','r0dd980638bc43efb2e01d362db32153','N','dd4b21e9ef71e1291183a46b913ae6f2','Y','M');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a66','jianqiang.liu@sierotech.com','刘建强','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000','r0dd980638bc43efb2e01d362db32153','N','dd4b21e9ef71e1291183a46b913ae6f2','Y','M');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a67','zhijie.ren@sierotech.com','任志杰','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000','r0dd980638bc43efb2e01d362db32153','N','dd4b21e9ef71e1291183a46b913ae6f2','Y','M');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a71','chao.sun@sierotech.com','孙超','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000','r0dd980638bc43efb2e01d362db32153','N','dd4b21e9ef71e1291183a46b913ae6f2','Y','M');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a72','wenliang.sun@sierotech.com','孙文亮','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000','r0dd980638bc43efb2e01d362db32153','N','dd4b21e9ef71e1291183a46b913ae6f2','Y','M');

/* 初始菜单 */

INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma900252694f4bd99fa3e16ce9df3cd1','人员管理','m.user.mgr','','','ROOT',1);

INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('m74ddfae86104121883fec9edbbbdc66','用户修改','m.update.user','/user/userList.jsp','','ma900252694f4bd99fa3e16ce9df3cd1',11);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('m74ddfae86104121883fec9edbbbdc88','添加用户','m.add.user','/user/userAdd.jsp','','ma900252694f4bd99fa3e16ce9df3cd1',12);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('m74ddfae86104121883fec9edbbbdc99','恢复用户','m.resume.user','/user/delUserList.jsp','','ma900252694f4bd99fa3e16ce9df3cd1',13);

INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma900252694f4bd99fa3e16ce9df3cd2','单位管理','m.org.mgr','','','ROOT',2);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma900252694f4bd99fa3e16ce9df3c68','单位修改','m.update.org','/org/orgList.jsp','','ma900252694f4bd99fa3e16ce9df3cd2',21);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('m2212adcb9d8458882fb04b1ecfbca7a','添加单位','m.add.org','/org/orgAdd.jsp','','ma900252694f4bd99fa3e16ce9df3cd2',22);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('mcc00252694f4bd99fa3e16ce9df3c69','恢复单位','m.resume.org','/org/delOrgList.jsp','','ma900252694f4bd99fa3e16ce9df3cd2',23);

INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma900252694f4bd99fa3e16ce9df3cd3','项目管理','m.project.mgr','','','ROOT',3);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('md2ce92105364fa3a8a910939b4e2096','修改项目','m.update.project','/project/projectList.jsp','','ma900252694f4bd99fa3e16ce9df3cd3',31);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('md27e92105364fa3a8a940939b4e20a6','新建项目','m.add.project','/project/projectAdd.jsp','','ma900252694f4bd99fa3e16ce9df3cd3',32);


INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma900252694f4bd99fa3e16ce9df3cd4','查询管理','m.query.mgr','','','ROOT',4);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('me93bc69648a4e8eae2a78fd883aea19','生成校验码','m.produce.code','/query/verifyCodeProduce.jsp','','ma900252694f4bd99fa3e16ce9df3cd4',41);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('me93bc69648a4e8eae2a78fd883aca89','修改记录查询','m.query.updatelog','/query/logOperationList.jsp','','ma900252694f4bd99fa3e16ce9df3cd4',42);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('me93bc69648a4e8eae2a78fd883aba36','工单查询','m.query.log','/query/jobList.jsp','','ma900252694f4bd99fa3e16ce9df3cd4',43);


INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma900252694f4bd99fa3e16ce9df3cd5','在建项目管理','m.buildproject.mgr','','','ROOT',5);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma32905855b54f8fb3895sf8b0c08cbg','选择当前项目','m.project.cur.select','/project/selectCurProject.jsp','','ma900252694f4bd99fa3e16ce9df3cd5',51);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma31605555b54f8fb3895bf8b0c08cbe','人员管理','m.project.psn.mgr','/project/projectPsnList.jsp','','ma900252694f4bd99fa3e16ce9df3cd5',52);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma31604565b54f8fb3895bf8b0c08cbf','当前项目管理','m.current.project','/project/currentProjectMgr.jsp','','ma900252694f4bd99fa3e16ce9df3cd5',53);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma31603785b54f8fb3895bf8b0c08cbg','项目工单查询','m.query.project.job','/project/projectJobList.jsp','','ma900252694f4bd99fa3e16ce9df3cd5',54);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma31603665b54f8fb3895bf8b0c08cbh','待处理工单','m.wait.job','/project/waitingJobList.jsp','','ma900252694f4bd99fa3e16ce9df3cd5',55);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma31603885b54f8fb3895bf8b0c08cbj','已处理工单','m.processed.job','/project/processedJobList.jsp','','ma900252694f4bd99fa3e16ce9df3cd5',56);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma31603995b54f8fb3895bf8b0c08cbk','信息查询','m.query.info','/project/infoQuery.jsp','','ma900252694f4bd99fa3e16ce9df3cd5',57);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma31603995b5bf8fb3895bf8b0c08cbs','信息修改','m.update.info','/project/infoUpdate.jsp','','ma900252694f4bd99fa3e16ce9df3cd5',58);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma31603115b54f8fb3895bf8b0c08cbl','创建机箱','m.create.box','/project/addMachineBox.jsp','','ma900252694f4bd99fa3e16ce9df3cd5',59);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma31603225b54f8fb3895bf8b0c08cbn','机箱信息填写及上报','m.write.box','/project/machineBoxWrite.jsp','','ma900252694f4bd99fa3e16ce9df3cd5',595);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('ma31603005b54f8fb3895bf8b0c08cbx','机箱验收进度','m.box.progress','/project/machineBoxProgress.jsp','','ma900252694f4bd99fa3e16ce9df3cd5',596);

INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('mf900252694f4bd99fa3e16ce9df3e5n','字典管理','m.nfc.dict.mgr','','','ROOT',6);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('mf900252694f4bd99fa3e16ce9dm201a','机箱NFC序列号','m.box.nfc.dict','/dict/nfcCode4Box.jsp','','mf900252694f4bd99fa3e16ce9df3e5n',61);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('mf910252694f4bd99fa3e16ce9dm201b','处理器NFC序列号','m.processor.nfc.dict','/dict/nfcCode4Processor.jsp','','mf900252694f4bd99fa3e16ce9df3e5n',62);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('mf9c0252694f4bd99fa3e16ce9dm201c','MOXA-NFC序列号','m.moxa.nfc.dict','/dict/nfcCode4Moxa.jsp','','mf900252694f4bd99fa3e16ce9df3e5n',63);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('mf9f0252694f4bd99fa3e16ce9dm201d','探测器NFC序列号','m.detecotr.nfc.dict','/dict/nfcCode4Detector.jsp','','mf900252694f4bd99fa3e16ce9df3e5n',64);

INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('mf310252694f4bdt9fa3e1xce9df9688','IP管理','m.ip.mgr','','','ROOT',7);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('mf3102526cmf4bdt9fa3e1xce9df7680','IP列表','m.ip.mgr','/ip/ipList.jsp','','mf310252694f4bdt9fa3e1xce9df9688',7);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('m111222005b54f8fb3895356b0c09c70','IP地址使用','m.project.ip.use','/ip/ipUseList.jsp','','ma900252694f4bd99fa3e16ce9df3cd5',597);

INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('mf3102526t2f4bdt9fa3e1xce9df5945','查看日志','m.log.view','','','ROOT',8);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('mf3102526t2f4bdt9fa3e1exe9df5931','用户登录日志','m.session.log.view','/log/logSession.jsp','','mf3102526t2f4bdt9fa3e1xce9df5945',81);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('mf3102526t2f4bdt9fa3e1txt9df5977','管理员操作日志','m.admin.log.view','/log/logAdminOperation.jsp','','mf3102526t2f4bdt9fa3e1xce9df5945',82);
INSERT INTO  t_menu(id,menu_name,menu_code,menu_url,icon_url,parent_id,order_num) VALUES ('mf3102526t2f4bdt9fa3e1prp9df5878','报表打印日志','m.print.log.view','/log/logPrint.jsp','','mf3102526t2f4bdt9fa3e1xce9df5945',83);


/* 初始角色权限 */
/* 超级管理员拥有的菜单 */
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abc','r0dd980638bc43efb2e01d362db32151','M','ma900252694f4bd99fa3e16ce9df3cd1');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abd','r0dd980638bc43efb2e01d362db32151','M','m74ddfae86104121883fec9edbbbdc88');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abe','r0dd980638bc43efb2e01d362db32151','M','m74ddfae86104121883fec9edbbbdc66');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abf','r0dd980638bc43efb2e01d362db32151','M','m74ddfae86104121883fec9edbbbdc99');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abg','r0dd980638bc43efb2e01d362db32151','M','ma900252694f4bd99fa3e16ce9df3cd2');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abh','r0dd980638bc43efb2e01d362db32151','M','m2212adcb9d8458882fb04b1ecfbca7a');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abj','r0dd980638bc43efb2e01d362db32151','M','ma900252694f4bd99fa3e16ce9df3c68');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abk','r0dd980638bc43efb2e01d362db32151','M','mcc00252694f4bd99fa3e16ce9df3c69');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abi','r0dd980638bc43efb2e01d362db32151','M','ma900252694f4bd99fa3e16ce9df3cd3');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abm','r0dd980638bc43efb2e01d362db32151','M','md27e92105364fa3a8a940939b4e20a6');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abn','r0dd980638bc43efb2e01d362db32151','M','md2ce92105364fa3a8a910939b4e2096');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1ab0','r0dd980638bc43efb2e01d362db32151','M','ma900252694f4bd99fa3e16ce9df3cd4');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abp','r0dd980638bc43efb2e01d362db32151','M','me93bc69648a4e8eae2a78fd883aea19');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abr','r0dd980638bc43efb2e01d362db32151','M','me93bc69648a4e8eae2a78fd883aca89');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abs','r0dd980638bc43efb2e01d362db32151','M','me93bc69648a4e8eae2a78fd883aba36');

/* 超级管理员增加的字典管理*/
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ke4f459cf554859d8c1986','r0dd980638bc43efb2e01d362db32151','M','mf900252694f4bd99fa3e16ce9df3e5n');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ke4f459cf554859d8c2011','r0dd980638bc43efb2e01d362db32151','M','mf900252694f4bd99fa3e16ce9dm201a');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ke4f459cf554859d8c2080','r0dd980638bc43efb2e01d362db32151','M','mf910252694f4bd99fa3e16ce9dm201b');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ke4f459cf554859d8c3011','r0dd980638bc43efb2e01d362db32151','M','mf9c0252694f4bd99fa3e16ce9dm201c');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ke4f459cf554859d8cc015','r0dd980638bc43efb2e01d362db32151','M','mf9f0252694f4bd99fa3e16ce9dm201d');

/* 超级管理员增加的IP管理*/
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ke89019cf554859d8c3071','r0dd980638bc43efb2e01d362db32151','M','mf310252694f4bdt9fa3e1xce9df9688');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5a3721bxke79639cf554859d8cc065','r0dd980638bc43efb2e01d362db32151','M','mf3102526cmf4bdt9fa3e1xce9df7680');


/* 超级管理员增加的查看日志*/
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ke89019cf554859d1c3030','r0dd980638bc43efb2e01d362db32151','M','mf3102526t2f4bdt9fa3e1xce9df5945');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5a3721bxke79639cf554859d8c8787','r0dd980638bc43efb2e01d362db32151','M','mf3102526t2f4bdt9fa3e1exe9df5931');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5a3721bxke79639cf554859d9c8386','r0dd980638bc43efb2e01d362db32151','M','mf3102526t2f4bdt9fa3e1txt9df5977');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5a3721bxke79639cf554xy9d9c8188','r0dd980638bc43efb2e01d362db32151','M','mf3102526t2f4bdt9fa3e1prp9df5878');



/* 管理员拥有的菜单 */
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abx','r0dd980638bc43efb2e01d362db32152','M','ma900252694f4bd99fa3e16ce9df3cd1');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1aby','r0dd980638bc43efb2e01d362db32152','M','m74ddfae86104121883fec9edbbbdc88');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abz','r0dd980638bc43efb2e01d362db32152','M','m74ddfae86104121883fec9edbbbdc66');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1aec','r0dd980638bc43efb2e01d362db32152','M','m74ddfae86104121883fec9edbbbdc99');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1adc','r0dd980638bc43efb2e01d362db32152','M','ma900252694f4bd99fa3e16ce9df3cd2');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1aac','r0dd980638bc43efb2e01d362db32152','M','m2212adcb9d8458882fb04b1ecfbca7a');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1afc','r0dd980638bc43efb2e01d362db32152','M','ma900252694f4bd99fa3e16ce9df3c68');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1ajc','r0dd980638bc43efb2e01d362db32152','M','mcc00252694f4bd99fa3e16ce9df3c69');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1ahc','r0dd980638bc43efb2e01d362db32152','M','ma900252694f4bd99fa3e16ce9df3cd3');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1aic','r0dd980638bc43efb2e01d362db32152','M','md27e92105364fa3a8a940939b4e20a6');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1akc','r0dd980638bc43efb2e01d362db32152','M','md2ce92105364fa3a8a910939b4e2096');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1amc','r0dd980638bc43efb2e01d362db32152','M','ma900252694f4bd99fa3e16ce9df3cd4');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1anc','r0dd980638bc43efb2e01d362db32152','M','me93bc69648a4e8eae2a78fd883aea19');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1axc','r0dd980638bc43efb2e01d362db32152','M','me93bc69648a4e8eae2a78fd883aca89');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1ayc','r0dd980638bc43efb2e01d362db32152','M','me93bc69648a4e8eae2a78fd883aba36');

/* 管理员增加的字典管理*/
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ae4f459cf554859d8d1986','r0dd980638bc43efb2e01d362db32152','M','mf900252694f4bd99fa3e16ce9df3e5n');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ae4f459cf554859d8d2011','r0dd980638bc43efb2e01d362db32152','M','mf900252694f4bd99fa3e16ce9dm201a');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ae4f459cf554859d8d2080','r0dd980638bc43efb2e01d362db32152','M','mf910252694f4bd99fa3e16ce9dm201b');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ae4f459cf554859d8d3011','r0dd980638bc43efb2e01d362db32152','M','mf9c0252694f4bd99fa3e16ce9dm201c');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ae4f459cf554859d8dc015','r0dd980638bc43efb2e01d362db32152','M','mf9f0252694f4bd99fa3e16ce9dm201d');

/* 管理员增加的IP管理*/
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ae89019cf554859d8d3071','r0dd980638bc43efb2e01d362db32152','M','mf310252694f4bdt9fa3e1xce9df9688');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5a3721bxae79639cf554859d8dc065','r0dd980638bc43efb2e01d362db32152','M','mf3102526cmf4bdt9fa3e1xce9df7680');


/* 管理员增加的查看日志*/
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ae89019cf554859d1f3030','r0dd980638bc43efb2e01d362db32152','M','mf3102526t2f4bdt9fa3e1xce9df5945');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5a3721bxae79639cf554859d8x8787','r0dd980638bc43efb2e01d362db32152','M','mf3102526t2f4bdt9fa3e1exe9df5931');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5a3721bxae79639cf554859d9y8386','r0dd980638bc43efb2e01d362db32152','M','mf3102526t2f4bdt9fa3e1txt9df5977');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5a3721bxae79639cf554xy9d9y8188','r0dd980638bc43efb2e01d362db32152','M','mf3102526t2f4bdt9fa3e1prp9df5878');



/* 系统工程师拥有的菜单 */
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf504859d9d1az1','r0dd980638bc43efb2e01d362db32153','M','ma32905855b54f8fb3895sf8b0c08cbg');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1azc','r0dd980638bc43efb2e01d362db32153','M','ma900252694f4bd99fa3e16ce9df3cd5');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d11bc','r0dd980638bc43efb2e01d362db32153','M','ma31605555b54f8fb3895bf8b0c08cbe');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d12bc','r0dd980638bc43efb2e01d362db32153','M','ma31604565b54f8fb3895bf8b0c08cbf');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1xbc','r0dd980638bc43efb2e01d362db32153','M','ma31603785b54f8fb3895bf8b0c08cbg');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1yb2','r0dd980638bc43efb2e01d362db32153','M','ma31603665b54f8fb3895bf8b0c08cbh');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1mbc','r0dd980638bc43efb2e01d362db32153','M','ma31603885b54f8fb3895bf8b0c08cbj');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1nbc','r0dd980638bc43efb2e01d362db32153','M','ma31603995b54f8fb3895bf8b0c08cbk');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d16bc','r0dd980638bc43efb2e01d362db32153','M','ma31603995b5bf8fb3895bf8b0c08cbs');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe13b3ae4f432cf664859d9d161d','r0dd980638bc43efb2e01d362db32153','M','m111222005b54f8fb3895356b0c09c70');



/* 施工经理拥有的菜单 */
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr3abe33b3ae4f459cf50485xd0d11z9','r0dd980638bc43efb2e01d362db32154','M','ma32905855b54f8fb3895sf8b0c08cbg');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1ub5','r0dd980638bc43efb2e01d362db32154','M','ma900252694f4bd99fa3e16ce9df3cd5');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cba','r0dd980638bc43efb2e01d362db32154','M','ma31603115b54f8fb3895bf8b0c08cbl');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cbf','r0dd980638bc43efb2e01d362db32154','M','ma31603225b54f8fb3895bf8b0c08cbn');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cbx','r0dd980638bc43efb2e01d362db32154','M','ma31603005b54f8fb3895bf8b0c08cbx');

/* 安装工程师拥有的菜单 */
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cb1','r0dd980638bc43efb2e01d362db32156','M','ma900252694f4bd99fa3e16ce9df3cd5');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cb2','r0dd980638bc43efb2e01d362db32156','M','ma31603665b54f8fb3895bf8b0c08cbh');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cbr','r0dd980638bc43efb2e01d362db32156','M','ma31603885b54f8fb3895bf8b0c08cbj');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cbw','r0dd980638bc43efb2e01d362db32156','M','ma31603995b54f8fb3895bf8b0c08cbk');


/* 调试工程师拥有的菜单 */
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cbq','r0dd980638bc43efb2e01d362db32155','M','ma900252694f4bd99fa3e16ce9df3cd5');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cb9','r0dd980638bc43efb2e01d362db32155','M','ma31603665b54f8fb3895bf8b0c08cbh');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cb8','r0dd980638bc43efb2e01d362db32155','M','ma31603885b54f8fb3895bf8b0c08cbj');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1c8w','r0dd980638bc43efb2e01d362db32155','M','ma31603995b54f8fb3895bf8b0c08cbk');

INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae30009cf554859d011c9b','r0dd980638bc43efb2e01d362db32155','M','m111222005b54f8fb3895356b0c09c70');

