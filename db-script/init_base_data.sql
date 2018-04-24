/* 初始单位信息 */

INSERT INTO t_org(id,org_name,org_code,tax_number,address,area_code,telephone,status) VALUES ('o3f25612335a4d188020d617801ea7bf','天津航峰希萨科技有限公司','tjhfxs','0000000000000000000000000','北京朝阳区阜通东大街6号方恒国际中心B座1808','010','64779901','N');


/* 初始用户类型即角色 */

INSERT INTO t_role(id,role_name,role_type,home_page,role_desc) VALUES('r0dd980638bc43efb2e01d362db32159','超级管理员','S','m.user.mgr#m.add.user','');
INSERT INTO t_role(id,role_name,role_type,home_page,role_desc) VALUES('rc106393c9f649e393d7c5d1a52c6105','管理员','M','m.user.mgr#m.add.user','');
INSERT INTO t_role(id,role_name,role_type,home_page,role_desc) VALUES('r9f16963cd27441594bb8fc6de9738a1','系统工程师','E','m.buildproject.mgr#m.project.psn.mgr','可作为安装工程师、调试工程师');
INSERT INTO t_role(id,role_name,role_type,home_page,role_desc) VALUES('re0957cb47484ae8b0647300c0f7fac7','施工经理','B','m.buildproject.mgr#m.current.project','外部施工单位人员');
INSERT INTO t_role(id,role_name,role_type,home_page,role_desc) VALUES('r88c5aa7352a4c1081675436dc06b991','安装工程师','I','m.buildproject.mgr#m.wait.job','');
INSERT INTO t_role(id,role_name,role_type,home_page,role_desc) VALUES('rbeea068409440528713d361e814c8b3','调试工程师','D','m.buildproject.mgr#m.wait.job','');

/* 初始用户 */

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a61','grace.wang@sierotech.com','王蓓','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000000','r0dd980638bc43efb2e01d362db32159','N','0000000','Y','F');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a62','angel.liu@sierotech.com','刘丽静','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000000','rc106393c9f649e393d7c5d1a52c6105','N','0000000','Y','F');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a63','emily.yuan@sierotech.com','袁春会','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000000','rc106393c9f649e393d7c5d1a52c6105','N','0000000','Y','F');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a64','kerry.kou@sierotech.com','寇宝龙','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000000','r9f16963cd27441594bb8fc6de9738a1','N','0000000','Y','M');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a65','shuai.chang@sierotech.com','常帅','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000000','r9f16963cd27441594bb8fc6de9738a1','N','0000000','Y','M');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a66','jianqiang.liu@sierotech.com','刘建强','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000000','r9f16963cd27441594bb8fc6de9738a1','N','0000000','Y','M');

INSERT INTO t_user(id,user_name,full_name,id_number,org_id,contact_number,role_id,status,password,init_password,sex) VALUES ('u8952c8666964e07a9a285b10d706a67','zhijie.ren@sierotech.com','任志杰','000000000000000000','o3f25612335a4d188020d617801ea7bf','00000000000','r9f16963cd27441594bb8fc6de9738a1','N','0000000','Y','M');


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


/* 初始角色权限 */
/* 超级管理员拥有的菜单 */
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abc','r0dd980638bc43efb2e01d362db32159','M','ma900252694f4bd99fa3e16ce9df3cd1');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abd','r0dd980638bc43efb2e01d362db32159','M','m74ddfae86104121883fec9edbbbdc88');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abe','r0dd980638bc43efb2e01d362db32159','M','m74ddfae86104121883fec9edbbbdc66');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abf','r0dd980638bc43efb2e01d362db32159','M','m74ddfae86104121883fec9edbbbdc99');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abg','r0dd980638bc43efb2e01d362db32159','M','ma900252694f4bd99fa3e16ce9df3cd2');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abh','r0dd980638bc43efb2e01d362db32159','M','m2212adcb9d8458882fb04b1ecfbca7a');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abj','r0dd980638bc43efb2e01d362db32159','M','ma900252694f4bd99fa3e16ce9df3c68');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abk','r0dd980638bc43efb2e01d362db32159','M','mcc00252694f4bd99fa3e16ce9df3c69');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abi','r0dd980638bc43efb2e01d362db32159','M','ma900252694f4bd99fa3e16ce9df3cd3');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abm','r0dd980638bc43efb2e01d362db32159','M','md27e92105364fa3a8a940939b4e20a6');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abn','r0dd980638bc43efb2e01d362db32159','M','md2ce92105364fa3a8a910939b4e2096');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1ab0','r0dd980638bc43efb2e01d362db32159','M','ma900252694f4bd99fa3e16ce9df3cd4');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abp','r0dd980638bc43efb2e01d362db32159','M','me93bc69648a4e8eae2a78fd883aea19');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abr','r0dd980638bc43efb2e01d362db32159','M','me93bc69648a4e8eae2a78fd883aca89');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abs','r0dd980638bc43efb2e01d362db32159','M','me93bc69648a4e8eae2a78fd883aba36');

/* 管理员拥有的菜单 */
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abx','rc106393c9f649e393d7c5d1a52c6105','M','ma900252694f4bd99fa3e16ce9df3cd1');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1aby','rc106393c9f649e393d7c5d1a52c6105','M','m74ddfae86104121883fec9edbbbdc88');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1abz','rc106393c9f649e393d7c5d1a52c6105','M','m74ddfae86104121883fec9edbbbdc66');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1aec','rc106393c9f649e393d7c5d1a52c6105','M','m74ddfae86104121883fec9edbbbdc99');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1adc','rc106393c9f649e393d7c5d1a52c6105','M','ma900252694f4bd99fa3e16ce9df3cd2');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1aac','rc106393c9f649e393d7c5d1a52c6105','M','m2212adcb9d8458882fb04b1ecfbca7a');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1afc','rc106393c9f649e393d7c5d1a52c6105','M','ma900252694f4bd99fa3e16ce9df3c68');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1ajc','rc106393c9f649e393d7c5d1a52c6105','M','mcc00252694f4bd99fa3e16ce9df3c69');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1ahc','rc106393c9f649e393d7c5d1a52c6105','M','ma900252694f4bd99fa3e16ce9df3cd3');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1aic','rc106393c9f649e393d7c5d1a52c6105','M','md27e92105364fa3a8a940939b4e20a6');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1akc','rc106393c9f649e393d7c5d1a52c6105','M','md2ce92105364fa3a8a910939b4e2096');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1amc','rc106393c9f649e393d7c5d1a52c6105','M','ma900252694f4bd99fa3e16ce9df3cd4');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1anc','rc106393c9f649e393d7c5d1a52c6105','M','me93bc69648a4e8eae2a78fd883aea19');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1axc','rc106393c9f649e393d7c5d1a52c6105','M','me93bc69648a4e8eae2a78fd883aca89');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1ayc','rc106393c9f649e393d7c5d1a52c6105','M','me93bc69648a4e8eae2a78fd883aba36');


/* 系统工程师拥有的菜单 */
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf504859d9d1az1','r9f16963cd27441594bb8fc6de9738a1','M','ma32905855b54f8fb3895sf8b0c08cbg');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1azc','r9f16963cd27441594bb8fc6de9738a1','M','ma900252694f4bd99fa3e16ce9df3cd5');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d11bc','r9f16963cd27441594bb8fc6de9738a1','M','ma31605555b54f8fb3895bf8b0c08cbe');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d12bc','r9f16963cd27441594bb8fc6de9738a1','M','ma31604565b54f8fb3895bf8b0c08cbf');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1xbc','r9f16963cd27441594bb8fc6de9738a1','M','ma31603785b54f8fb3895bf8b0c08cbg');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1yb2','r9f16963cd27441594bb8fc6de9738a1','M','ma31603665b54f8fb3895bf8b0c08cbh');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1mbc','r9f16963cd27441594bb8fc6de9738a1','M','ma31603885b54f8fb3895bf8b0c08cbj');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1nbc','r9f16963cd27441594bb8fc6de9738a1','M','ma31603995b54f8fb3895bf8b0c08cbk');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d16bc','r9f16963cd27441594bb8fc6de9738a1','M','ma31603995b5bf8fb3895bf8b0c08cbs');


/* 施工经理拥有的菜单 */
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr3abe33b3ae4f459cf50485xd0d11z9','re0957cb47484ae8b0647300c0f7fac7','M','ma32905855b54f8fb3895sf8b0c08cbg');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1ub5','re0957cb47484ae8b0647300c0f7fac7','M','ma900252694f4bd99fa3e16ce9df3cd5');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cba','re0957cb47484ae8b0647300c0f7fac7','M','ma31603115b54f8fb3895bf8b0c08cbl');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cbf','re0957cb47484ae8b0647300c0f7fac7','M','ma31603225b54f8fb3895bf8b0c08cbn');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cbx','re0957cb47484ae8b0647300c0f7fac7','M','ma31603005b54f8fb3895bf8b0c08cbx');

/* 安装工程师拥有的菜单 */
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cb1','r88c5aa7352a4c1081675436dc06b991','M','ma900252694f4bd99fa3e16ce9df3cd5');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cb2','r88c5aa7352a4c1081675436dc06b991','M','ma31603665b54f8fb3895bf8b0c08cbh');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cbr','r88c5aa7352a4c1081675436dc06b991','M','ma31603885b54f8fb3895bf8b0c08cbj');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cbw','r88c5aa7352a4c1081675436dc06b991','M','ma31603995b54f8fb3895bf8b0c08cbk');


/* 调试工程师拥有的菜单 */
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cbq','rbeea068409440528713d361e814c8b3','M','ma900252694f4bd99fa3e16ce9df3cd5');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cb9','rbeea068409440528713d361e814c8b3','M','ma31603665b54f8fb3895bf8b0c08cbh');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1cb8','rbeea068409440528713d361e814c8b3','M','ma31603885b54f8fb3895bf8b0c08cbj');
INSERT INTO  t_role_res(id,role_id,res_type,res_id) VALUES ('rr5abe33b3ae4f459cf554859d9d1c8w','rbeea068409440528713d361e814c8b3','M','ma31603995b54f8fb3895bf8b0c08cbk');


