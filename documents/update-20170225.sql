ALTER TABLE t_customer MODIFY address VARCHAR(100) COMMENT '地址';

ALTER TABLE t_customer ADD company VARCHAR(50) NULL COMMENT '公司';

ALTER TABLE t_customer MODIFY phone VARCHAR(13) COMMENT '手机号';

ALTER TABLE t_admin MODIFY phone VARCHAR(13) COMMENT '手机号';

ALTER TABLE t_device MODIFY phone VARCHAR(13) COMMENT '手机号';