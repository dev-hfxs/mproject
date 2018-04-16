/*==============================================================*/
/* Table: t_user                                                */
/*==============================================================*/
create table t_user 
(
   id                   varchar(32)                    not null,
   user_name            varchar(64)                    not null		comment '用户名',
   full_name            varchar(64)                    not null		comment '姓名',
   id_number            varchar(18)                    not null		comment '身份证号',
   org_id               varchar(32)                    null		comment '所在单位',
   contact_number       varchar(32)                    null		comment '联系电话',
   role_id              varchar(32)                    null		comment '用户类型(角色)',
   status               char(1)                        null		comment '状态值:D删除,N新建,R恢复',
   password             varchar(32)                    null		comment '用户密码',
   init_password	char(1)			       null		comment '是否初始化密码',
   sex                  char(1)                        null		comment '性别M:男,F:女',
   birthday             varchar(19)                    null		comment '出生日期',
   creator              Varchar(64)                    null ,
   create_date          varchar(19)                    null ,
   constraint pk_t_user_id primary key (id)
);


/*==============================================================*/
/* Table: t_project_personnel                                */
/*==============================================================*/
create table t_project_personnel
(
   id                   varchar(32)                    not null,
   project_id           varchar(32)                    null	comment '对应项目id',
   user_id              varchar(32)                    null	comment '对应人员id',
   duty                 char(1)                        null	comment '职责',
   allow_box_num        int(4)                         null	comment '施工经理应创建的机箱数',
   constraint pk_t_project_personnel_id primary key (id)
);


/*==============================================================*/
/* Table: t_project                                             */
/*==============================================================*/
create table t_project 
(
   id                   varchar(32)                    not null ,
   project_name         varchar(64)                    not null comment '项目名称',
   project_number       varchar(20)                    not null comment '项目编号',
   contract_number      varchar(60)                    null comment '合同号',
   project_desc         varchar(256)                   null comment '项目描述',
   project_manager      varchar(32)                    null comment '项目经理',
   status               char(1)                        null comment '项目状态值I:进行中,F:完成',
   allow_box_num        int(4)                         null comment '项目应创建的机箱数',
   creator              varchar(64)                    null ,
   create_date          varchar(19)                    null ,
   constraint pk_t_project_id primary key (id)
);

/*==============================================================*/
/* Table: t_org                                                 */
/*==============================================================*/
create table t_org 
(
   id                   varchar(32)                    not null,
   org_name             varchar(128)                   not null comment '单位名称',
   org_code             varchar(20)                    not null comment '单位编码',
   tax_number           varchar(25)                    null comment '单位税号',
   address              varchar(256)                   null comment '单位地址',
   area_code            varchar(4)                     null comment '电话区号',
   telephone            varchar(8)                     null comment '单位电话',
   open_bank            varchar(64)                    null comment '开户行',
   account              varchar(20)                    null comment '账户',
   contacts             varchar(32)                    null comment '联系人',
   contact_position     varchar(64)                    null comment '联系人职务',
   email                varchar(64)                    null comment '联系邮件',
   contact_phone         varchar(11)                   null comment '联系电话',
   status               char(1)                        null comment '状态D：删除,,R:恢复,N:新建',
   creator              varchar(64)                    null ,
   create_date          varchar(19)                    null ,
   constraint pk_t_org_id primary key (id)
);

/*==============================================================*/
/* Table: t_job                                                 */
/*==============================================================*/
create table t_job 
(
   id                   varchar(32)                    not null,
   project_id           varchar(32)                    null  comment '对应项目id' ,
   machine_box_id       varchar(32)                    null  comment '对应机箱id' ,
   process_person       varchar(32)                    null  comment '工单处理工程师' ,
   work_content         varchar(512)                   null  comment '工作内容' ,
   status               char(1)                        null  comment '工单状态值I:未处理,N:未完成,F:正常完成,Q:问题工单' ,
   job_type             char(1)                        null  comment '值A:安装,T:调试,O:其他' ,
   job_desc             varchar(128)                   null  comment '工单描述' ,
   creator              varchar(32)                    null  ,
   create_date          varchar(19)                    null  ,
   config_file          varchar(128)                   null  comment '配置文件路径' ,
   detector_file        varchar(128)                   null  comment '探测器信息文件路径' ,
   constraint pk_t_job_id primary key (id)
);


/*==============================================================*/
/* Table: t_job_option                                          */
/*==============================================================*/
create table t_job_option 
(
   id                   varchar(32)                    not null,
   job_id               varchar(32)                    null comment '对应工单id' ,
   option_name          varchar(40)                    null comment '工单详细项名称' ,
   option_value         varchar(256)                   null comment '工单详细项值' ,
   constraint pk_t_job_option_id primary key (id)
);


/*==============================================================*/
/* Table: t_machine_box                                         */
/*==============================================================*/
create table t_machine_box 
(
   id                   varchar(32)                    not null,
   box_number           varchar(12)                    null comment '机箱编号' ,
   longitude            decimal(9,6)                   null comment '经度' ,
   latitude             decimal(9,6)                   null comment '纬度' ,
   pos_desc             varchar(128)                   null comment '位置描述' ,
   processor_num        int(4)                         null comment '处理器数量' ,
   install_space        decimal(9,6)                   null comment '安装间距' ,
   org_id               varchar(32)                    null comment '施工单位id' ,
   build_manager        varchar(32)                    null comment '施工经理' ,
   install_engineer     varchar(32)                    null comment '安装工程师' ,
   confirm_install_date varchar(19)                    null comment '安装工程师确认时间' ,
   debug_engineer       varchar(32)                    null comment '调试工程师' ,
   confirm_debug_date   varchar(19)                    null comment '调试工程师确认时间' ,
   pm_confirm_date      varchar(19)                    null comment '项目经理确认时间' ,
   project_id           varchar(32)                    null comment '对应项目id' ,
   enable_edit          char(1)                        null comment '提交后是否允许修改' ,

   create_date          varchar(19)                    null ,
   constraint pk_t_machine_box_id primary key (id)
);


/*==============================================================*/
/* Table: t_machine_box_submit                                  */
/*==============================================================*/
create table t_machine_box_submit 
(
   id                   varchar(32)                    not null,
   machine_box_id       varchar(32)                    null comment '对应机箱id' ,
   submit_date          varchar(19)                    null comment '提交时间' ,
   remark               varchar(128)                   null comment '备注' ,
   constraint pk_t_machine_box_submit_id primary key (id)
);


/*==============================================================*/
/* Table: t_processor                                           */
/*==============================================================*/
create table t_processor 
(
   id                   varchar(32)                    not null,
   machine_box_id       varchar(32)                    null comment '对应机箱id' ,
   nfc_number           varchar(20)                    null comment 'NFC序列号' ,
   moxa_number          varchar(20)                    null comment 'moxa序列号' ,
   processor_id         varchar(20)                    null comment '处理器ID' ,
   ip                   varchar(32)                    null comment 'ip地址' ,
   detector_num         int(4)                         null comment '下属探测器数量' ,
   creator              varchar(32)                    null ,
   create_date          varchar(19)                    null ,
   constraint pk_t_processor_id primary key (id)
);


/*==============================================================*/
/* Table: t_detector                                            */
/*==============================================================*/
create table t_detector 
(
   id                   varchar(32)                    not null,
   detector_id          varchar(20)                    null comment '探测器id' ,
   processor_id         varchar(32)                    null comment '对应处理器id' ,
   nfc_number           varchar(20)                    null comment 'NFC序列号' ,
   longitude            decimal(9,6)                   null comment '经度' ,
   latitude             decimal(9,6)                   null comment '纬度' ,
   start_point          varchar(40)                    null comment '起点' ,
   end_point            varchar(40)                    null comment '终点' ,
   pos_desc             varchar(128)                   null comment '位置描述' ,
   constraint pk_t_detector_id primary key clustered (id)
);


/*==============================================================*/
/* Table: t_verification_code                                   */
/*==============================================================*/
create table t_verification_code 
(
   id                   varchar(32)                    not null,
   project_id           varchar(32)                    null comment '对应项目id' ,
   code_type            char(1)                        null comment '验证码类型' ,
   code_value           varchar(8)                     null comment '验证码值' ,
   target_user          varchar(32)                    null comment '验证码使用用户' ,
   valid_time           int(4)                         null comment '有效时长' ,
   used                 char(1)                        null comment '是否已使用,Y使用,N未使用' ,
   creator              varchar(32)                    null,
   create_date          varchar(19)                    null,
   constraint pk_t_verification_code_id primary key (id)
);


/*==============================================================*/
/* Table: t_menu                                                */
/*==============================================================*/
create table t_menu 
(
   id                   varchar(32)                    not null,
   menu_name            varchar(64)                    null comment '菜单名称' ,
   menu_code            varchar(20)                    null comment '菜单编码' ,
   menu_url             varchar(128)                   null comment '菜单资源地址' ,
   icon_url             varchar(128)                   null comment '菜单图标地址' ,
   parent_id            varchar(32)                    null comment '上级菜单id' ,
   order_num            int(4)                         null comment '菜单序号' ,
   remark               varchar(128)                   null comment '备注' ,
   creator              varchar(32)                    null ,
   create_date          varchar(19)                    null,
   constraint pk_t_menu_id primary key (id)
);


/*==============================================================*/
/* Table: t_user_role                                           */
/*==============================================================*/
create table t_user_role 
(
   id                   varchar(32)                    not null,
   user_id              varchar(32)                    null  comment '用户id' ,
   role_id              varchar(32)                    null  comment '角色id' ,
   constraint pk_t_user_role_id primary key (id)
);


/*==============================================================*/
/* Table: t_role                                                */
/*==============================================================*/
create table t_role 
(
   id                   varchar(32)                    not null,
   role_name            varchar(64)                    null comment '角色名称' ,
   role_type		varchar(1)		       null comment '值S:超级管理员,M：管理员,G：普通角色' ,
   home_page            varchar(128)                   null comment '角色的首页' ,
   role_desc            varchar(128)                   null comment '角色描述' ,
   creator              varchar(32)                    null,
   create_date          Varchar(19)                    null,
   constraint pk_t_role_id primary key (id)
);


/*==============================================================*/
/* Table: t_role_res                                            */
/*==============================================================*/
create table t_role_res 
(
   id                   varchar(32)                    not null,
   role_id              varchar(32)                    null comment '角色id' ,
   res_type             varchar(32)                    null comment '资源类型' ,
   res_id               varchar(32)                    null comment '对应资源id' ,
   constraint pk_t_role_res_id primary key (id)
);


/*==============================================================*/
/* Table: t_operation_log                                       */
/*==============================================================*/
create table t_operation_log 
(
   id                   varchar(32)                    not null,
   user_name            varchar(64)                    null comment '操作的用户' ,
   operation_date       varchar(19)                    null comment '操作时间' ,
   operation_type       char(1)                        null comment '操作类型Q:查询,U:修改' ,
   operation_desc       varchar(256)                   null comment '操作描述' ,
   old_value            varchar(128)                   null comment '修改前内容' ,
   new_value            varchar(128)                   null comment '修改后内容' ,
   project_id           varchar(32 )                   null comment '对应项目' ,
   operation_part	char(1)			       null comment '1:项目,2:机箱,3:处理器,4:探测器',
   update_field  	varchar(40)		       null comment '修改的字段',
   constraint pk_t_operation_log_id primary key (id)
);


/*==============================================================*/
/* Table: t_session_log                                         */
/*==============================================================*/
create table t_session_log 
(
   id                   varchar(32)                    not null,
   session_id           varchar(64)                    null comment '会话id' ,
   user_name            varchar(64)                    null comment '操作的用户' ,
   login_date           varchar(19)                    null comment '登入时间' ,
   client_ip            varchar(32)                    null comment '客户端ip' ,
   remark               varchar(128)                   null comment '备注' ,
   constraint pk_t_session_log_id primary key (id)
);

/*==============================================================*/
/* Table: t_admin_log                                           */
/*==============================================================*/
create table t_admin_log 
(
   id                   varchar(32)                    not null,
   user_name            varchar(64)                    null comment '操作的用户' ,
   operation_date       varchar(19)                    null comment '操作时间' ,
   operation_module     varchar(20)                    null comment '操作模块' ,
   operation_desc       varchar(256)                   null comment '操作描述' ,
   constraint pk_t_admin_log_id primary key (id)
);
