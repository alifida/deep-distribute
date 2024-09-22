-- public.auth_group definition

-- Drop table

-- DROP TABLE public.auth_group;

CREATE TABLE public.auth_group (
	id serial4 NOT NULL,
	"name" varchar(150) NOT NULL,
	CONSTRAINT auth_group_name_key UNIQUE (name),
	CONSTRAINT auth_group_pkey PRIMARY KEY (id)
);
CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


-- public.auth_user definition

-- Drop table

-- DROP TABLE public.auth_user;

CREATE TABLE public.auth_user (
	id serial4 NOT NULL,
	"password" varchar(128) NOT NULL,
	last_login timestamptz NULL,
	is_superuser bool NOT NULL,
	username varchar(150) NOT NULL,
	first_name varchar(150) NOT NULL,
	last_name varchar(150) NOT NULL,
	email varchar(254) NOT NULL,
	is_staff bool NOT NULL,
	is_active bool NOT NULL,
	date_joined timestamptz NOT NULL,
	CONSTRAINT auth_user_pkey PRIMARY KEY (id),
	CONSTRAINT auth_user_username_key UNIQUE (username)
);
CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


-- public.django_content_type definition

-- Drop table

-- DROP TABLE public.django_content_type;

CREATE TABLE public.django_content_type (
	id serial4 NOT NULL,
	app_label varchar(100) NOT NULL,
	model varchar(100) NOT NULL,
	CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model),
	CONSTRAINT django_content_type_pkey PRIMARY KEY (id)
);


-- public.django_migrations definition

-- Drop table

-- DROP TABLE public.django_migrations;

CREATE TABLE public.django_migrations (
	id serial4 NOT NULL,
	app varchar(255) NOT NULL,
	"name" varchar(255) NOT NULL,
	applied timestamptz NOT NULL,
	CONSTRAINT django_migrations_pkey PRIMARY KEY (id)
);


-- public.django_q_ormq definition

-- Drop table

-- DROP TABLE public.django_q_ormq;

CREATE TABLE public.django_q_ormq (
	id serial4 NOT NULL,
	"key" varchar(100) NOT NULL,
	payload text NOT NULL,
	"lock" timestamptz NULL,
	CONSTRAINT django_q_ormq_pkey PRIMARY KEY (id)
);


-- public.django_q_schedule definition

-- Drop table

-- DROP TABLE public.django_q_schedule;

CREATE TABLE public.django_q_schedule (
	id serial4 NOT NULL,
	func varchar(256) NOT NULL,
	hook varchar(256) NULL,
	args text NULL,
	kwargs text NULL,
	schedule_type varchar(1) NOT NULL,
	repeats int4 NOT NULL,
	next_run timestamptz NULL,
	task varchar(100) NULL,
	"name" varchar(100) NULL,
	minutes int2 NULL,
	cron varchar(100) NULL,
	"cluster" varchar(100) NULL,
	CONSTRAINT django_q_schedule_minutes_check CHECK ((minutes >= 0)),
	CONSTRAINT django_q_schedule_pkey PRIMARY KEY (id)
);


-- public.django_q_task definition

-- Drop table

-- DROP TABLE public.django_q_task;

CREATE TABLE public.django_q_task (
	"name" varchar(100) NOT NULL,
	func varchar(256) NOT NULL,
	hook varchar(256) NULL,
	args text NULL,
	kwargs text NULL,
	"result" text NULL,
	started timestamptz NOT NULL,
	stopped timestamptz NOT NULL,
	success bool NOT NULL,
	id varchar(32) NOT NULL,
	"group" varchar(100) NULL,
	attempt_count int4 NOT NULL,
	CONSTRAINT django_q_task_pkey PRIMARY KEY (id)
);
CREATE INDEX django_q_task_id_32882367_like ON public.django_q_task USING btree (id varchar_pattern_ops);


-- public.django_session definition

-- Drop table

-- DROP TABLE public.django_session;

CREATE TABLE public.django_session (
	session_key varchar(40) NOT NULL,
	session_data text NOT NULL,
	expire_date timestamptz NOT NULL,
	CONSTRAINT django_session_pkey PRIMARY KEY (session_key)
);
CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);
CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


-- public.django_site definition

-- Drop table

-- DROP TABLE public.django_site;

CREATE TABLE public.django_site (
	id serial4 NOT NULL,
	"domain" varchar(100) NOT NULL,
	"name" varchar(50) NOT NULL,
	CONSTRAINT django_site_domain_a2e37b91_uniq UNIQUE (domain),
	CONSTRAINT django_site_pkey PRIMARY KEY (id)
);
CREATE INDEX django_site_domain_a2e37b91_like ON public.django_site USING btree (domain varchar_pattern_ops);


-- public.train_charttype definition

-- Drop table

-- DROP TABLE public.train_charttype;

CREATE TABLE public.train_charttype (
	id serial4 NOT NULL,
	"name" varchar(50) NULL,
	"type" varchar(50) NOT NULL,
	status varchar(20) NULL,
	"template" text NOT NULL,
	CONSTRAINT train_charttype_pkey PRIMARY KEY (id)
);


-- public.train_clusternode definition

-- Drop table

-- DROP TABLE public.train_clusternode;

CREATE TABLE public.train_clusternode (
	id serial4 NOT NULL,
	node_type varchar(10) NOT NULL,
	ip_address varchar(15) NOT NULL,
	port int4 NOT NULL,
	CONSTRAINT train_clusternode_pkey PRIMARY KEY (id)
);


-- public.train_permission definition

-- Drop table

-- DROP TABLE public.train_permission;

CREATE TABLE public.train_permission (
	id serial4 NOT NULL,
	"name" varchar(100) NOT NULL,
	CONSTRAINT train_permission_pkey PRIMARY KEY (id)
);


-- public.auth_permission definition

-- Drop table

-- DROP TABLE public.auth_permission;

CREATE TABLE public.auth_permission (
	id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	content_type_id int4 NOT NULL,
	codename varchar(100) NOT NULL,
	CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename),
	CONSTRAINT auth_permission_pkey PRIMARY KEY (id),
	CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


-- public.auth_user_groups definition

-- Drop table

-- DROP TABLE public.auth_user_groups;

CREATE TABLE public.auth_user_groups (
	id serial4 NOT NULL,
	user_id int4 NOT NULL,
	group_id int4 NOT NULL,
	CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id),
	CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id),
	CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);
CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


-- public.auth_user_user_permissions definition

-- Drop table

-- DROP TABLE public.auth_user_user_permissions;

CREATE TABLE public.auth_user_user_permissions (
	id serial4 NOT NULL,
	user_id int4 NOT NULL,
	permission_id int4 NOT NULL,
	CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id),
	CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id),
	CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);
CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


-- public.django_admin_log definition

-- Drop table

-- DROP TABLE public.django_admin_log;

CREATE TABLE public.django_admin_log (
	id serial4 NOT NULL,
	action_time timestamptz NOT NULL,
	object_id text NULL,
	object_repr varchar(200) NOT NULL,
	action_flag int2 NOT NULL,
	change_message text NOT NULL,
	content_type_id int4 NULL,
	user_id int4 NOT NULL,
	CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0)),
	CONSTRAINT django_admin_log_pkey PRIMARY KEY (id),
	CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);
CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


-- public.registration_registrationprofile definition

-- Drop table

-- DROP TABLE public.registration_registrationprofile;

CREATE TABLE public.registration_registrationprofile (
	id serial4 NOT NULL,
	activation_key varchar(64) NOT NULL,
	user_id int4 NOT NULL,
	activated bool NOT NULL,
	CONSTRAINT registration_registrationprofile_pkey PRIMARY KEY (id),
	CONSTRAINT registration_registrationprofile_user_id_key UNIQUE (user_id),
	CONSTRAINT registration_registr_user_id_5fcbf725_fk_auth_user FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED
);


-- public.registration_supervisedregistrationprofile definition

-- Drop table

-- DROP TABLE public.registration_supervisedregistrationprofile;

CREATE TABLE public.registration_supervisedregistrationprofile (
	registrationprofile_ptr_id int4 NOT NULL,
	CONSTRAINT registration_supervisedregistrationprofile_pkey PRIMARY KEY (registrationprofile_ptr_id),
	CONSTRAINT registration_supervi_registrationprofile__0a59f3b2_fk_registrat FOREIGN KEY (registrationprofile_ptr_id) REFERENCES public.registration_registrationprofile(id) DEFERRABLE INITIALLY DEFERRED
);


-- public.train_dataset definition

-- Drop table

-- DROP TABLE public.train_dataset;

CREATE TABLE public.train_dataset (
	id serial4 NOT NULL,
	description varchar(300) NOT NULL,
	dataset varchar(100) NOT NULL,
	dataset_test varchar(100) NULL,
	process_details text NOT NULL,
	processed_at timestamptz NOT NULL,
	metainfo text NOT NULL,
	source_dataset_id_id int4 NULL,
	user_id int4 NOT NULL,
	CONSTRAINT train_dataset_pkey PRIMARY KEY (id),
	CONSTRAINT train_dataset_source_dataset_id_id_190b04e7_fk_train_dataset_id FOREIGN KEY (source_dataset_id_id) REFERENCES public.train_dataset(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT train_dataset_user_id_793c7b0b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX train_dataset_source_dataset_id_id_190b04e7 ON public.train_dataset USING btree (source_dataset_id_id);
CREATE INDEX train_dataset_user_id_793c7b0b ON public.train_dataset USING btree (user_id);


-- public.train_dataset_img definition

-- Drop table

-- DROP TABLE public.train_dataset_img;

CREATE TABLE public.train_dataset_img (
	id serial4 NOT NULL,
	data_name varchar(300) NOT NULL,
	data_path varchar(300) NOT NULL,
	metainfo text NOT NULL,
	processed_at timestamptz NOT NULL,
	delete_at timestamptz NULL,
	status varchar(300) NOT NULL,
	user_id int4 NOT NULL,
	extracted_path text NOT NULL,
	data_path_test varchar(300) NOT NULL,
	extracted_path_test text NOT NULL,
	CONSTRAINT train_dataset_img_pkey PRIMARY KEY (id),
	CONSTRAINT train_dataset_img_user_id_f0f52aad_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX train_dataset_img_user_id_f0f52aad ON public.train_dataset_img USING btree (user_id);


-- public.train_trainedmodel definition

-- Drop table

-- DROP TABLE public.train_trainedmodel;

CREATE TABLE public.train_trainedmodel (
	id serial4 NOT NULL,
	model_file varchar(100) NULL,
	description varchar(300) NULL,
	status varchar(100) NOT NULL,
	created_at timestamptz NOT NULL,
	updated_at timestamptz NOT NULL,
	key_attributes text NOT NULL,
	class_label text NOT NULL,
	dataset_id int4 NULL,
	user_id int4 NOT NULL,
	dataset_img_id int4 NULL,
	CONSTRAINT train_trainedmodel_pkey PRIMARY KEY (id),
	CONSTRAINT train_trainedmodel_dataset_id_8d4a44ab_fk_train_dataset_id FOREIGN KEY (dataset_id) REFERENCES public.train_dataset(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT train_trainedmodel_dataset_img_id_cbb2b55f_fk_train_dat FOREIGN KEY (dataset_img_id) REFERENCES public.train_dataset_img(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT train_trainedmodel_user_id_b0461349_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX train_trainedmodel_dataset_id_8d4a44ab ON public.train_trainedmodel USING btree (dataset_id);
CREATE INDEX train_trainedmodel_dataset_img_id_cbb2b55f ON public.train_trainedmodel USING btree (dataset_img_id);
CREATE INDEX train_trainedmodel_user_id_b0461349 ON public.train_trainedmodel USING btree (user_id);


-- public.train_training_job definition

-- Drop table

-- DROP TABLE public.train_training_job;

CREATE TABLE public.train_training_job (
	id serial4 NOT NULL,
	job_name varchar(300) NOT NULL,
	status varchar(300) NOT NULL,
	started_at timestamptz NULL,
	ended_at timestamptz NULL,
	algo varchar(300) NOT NULL,
	dataset_img_id int4 NOT NULL,
	user_id int4 NOT NULL,
	"result" text NULL,
	parameter_settings text NULL,
	training_log text NULL,
	training_log_history text NULL,
	CONSTRAINT train_training_job_pkey PRIMARY KEY (id),
	CONSTRAINT train_training_job_dataset_img_id_099728da_fk_train_dat FOREIGN KEY (dataset_img_id) REFERENCES public.train_dataset_img(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT train_training_job_user_id_1526950c_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX train_training_job_dataset_img_id_099728da ON public.train_training_job USING btree (dataset_img_id);
CREATE INDEX train_training_job_user_id_1526950c ON public.train_training_job USING btree (user_id);


-- public.uac_group_config definition

-- Drop table

-- DROP TABLE public.uac_group_config;

CREATE TABLE public.uac_group_config (
	id serial4 NOT NULL,
	welcome_url varchar(150) NULL,
	group_id int4 NULL,
	CONSTRAINT uac_group_config_pkey PRIMARY KEY (id),
	CONSTRAINT uac_group_config_group_id_4eb08854_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX uac_group_config_group_id_4eb08854 ON public.uac_group_config USING btree (group_id);


-- public.auth_group_permissions definition

-- Drop table

-- DROP TABLE public.auth_group_permissions;

CREATE TABLE public.auth_group_permissions (
	id serial4 NOT NULL,
	group_id int4 NOT NULL,
	permission_id int4 NOT NULL,
	CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id),
	CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id),
	CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);
CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


-- public.train_chart definition

-- Drop table

-- DROP TABLE public.train_chart;

CREATE TABLE public.train_chart (
	id serial4 NOT NULL,
	"name" varchar(1000) NOT NULL,
	dataset_attribute varchar(1000) NULL,
	"data" text NOT NULL,
	dataset_id int4 NULL,
	type_id int4 NULL,
	CONSTRAINT train_chart_pkey PRIMARY KEY (id),
	CONSTRAINT train_chart_dataset_id_82e1454f_fk_train_dataset_id FOREIGN KEY (dataset_id) REFERENCES public.train_dataset(id) DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT train_chart_type_id_823bcdfa_fk_train_charttype_id FOREIGN KEY (type_id) REFERENCES public.train_charttype(id) DEFERRABLE INITIALLY DEFERRED
);
CREATE INDEX train_chart_dataset_id_82e1454f ON public.train_chart USING btree (dataset_id);
CREATE INDEX train_chart_type_id_823bcdfa ON public.train_chart USING btree (type_id);


INSERT INTO public.auth_group
(id, "name")
VALUES(1, 'admin');


INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(1, 1, 1);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(2, 1, 2);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(3, 1, 3);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(4, 1, 4);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(5, 1, 5);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(6, 1, 6);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(7, 1, 7);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(8, 1, 8);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(9, 1, 9);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(10, 1, 10);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(11, 1, 11);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(12, 1, 12);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(13, 1, 13);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(14, 1, 14);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(15, 1, 15);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(16, 1, 16);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(17, 1, 17);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(18, 1, 18);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(19, 1, 19);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(20, 1, 20);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(21, 1, 21);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(22, 1, 22);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(23, 1, 23);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(24, 1, 24);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(25, 1, 25);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(26, 1, 26);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(27, 1, 27);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(28, 1, 28);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(29, 1, 29);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(30, 1, 30);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(31, 1, 31);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(32, 1, 32);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(33, 1, 33);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(34, 1, 34);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(35, 1, 35);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(36, 1, 36);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(37, 1, 37);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(38, 1, 38);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(39, 1, 39);
INSERT INTO public.auth_group_permissions
(id, group_id, permission_id)
VALUES(40, 1, 40);


INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(1, 'Can add group_config', 1, 'add_group_config');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(2, 'Can change group_config', 1, 'change_group_config');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(3, 'Can delete group_config', 1, 'delete_group_config');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(4, 'Can view group_config', 1, 'view_group_config');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(5, 'Can add registration profile', 2, 'add_registrationprofile');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(6, 'Can change registration profile', 2, 'change_registrationprofile');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(7, 'Can delete registration profile', 2, 'delete_registrationprofile');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(8, 'Can view registration profile', 2, 'view_registrationprofile');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(9, 'Can add supervised registration profile', 3, 'add_supervisedregistrationprofile');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(10, 'Can change supervised registration profile', 3, 'change_supervisedregistrationprofile');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(11, 'Can delete supervised registration profile', 3, 'delete_supervisedregistrationprofile');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(12, 'Can view supervised registration profile', 3, 'view_supervisedregistrationprofile');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(13, 'Can add site', 4, 'add_site');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(14, 'Can change site', 4, 'change_site');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(15, 'Can delete site', 4, 'delete_site');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(16, 'Can view site', 4, 'view_site');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(17, 'Can add dataset_img', 5, 'add_dataset_img');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(18, 'Can change dataset_img', 5, 'change_dataset_img');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(19, 'Can delete dataset_img', 5, 'delete_dataset_img');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(20, 'Can view dataset_img', 5, 'view_dataset_img');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(21, 'Can add training_job', 6, 'add_training_job');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(22, 'Can change training_job', 6, 'change_training_job');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(23, 'Can delete training_job', 6, 'delete_training_job');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(24, 'Can view training_job', 6, 'view_training_job');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(25, 'Can add cluster node', 7, 'add_clusternode');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(26, 'Can change cluster node', 7, 'change_clusternode');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(27, 'Can delete cluster node', 7, 'delete_clusternode');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(28, 'Can view cluster node', 7, 'view_clusternode');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(29, 'Can add log entry', 8, 'add_logentry');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(30, 'Can change log entry', 8, 'change_logentry');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(31, 'Can delete log entry', 8, 'delete_logentry');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(32, 'Can view log entry', 8, 'view_logentry');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(33, 'Can add permission', 9, 'add_permission');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(34, 'Can change permission', 9, 'change_permission');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(35, 'Can delete permission', 9, 'delete_permission');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(36, 'Can view permission', 9, 'view_permission');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(37, 'Can add group', 10, 'add_group');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(38, 'Can change group', 10, 'change_group');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(39, 'Can delete group', 10, 'delete_group');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(40, 'Can view group', 10, 'view_group');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(41, 'Can add user', 11, 'add_user');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(42, 'Can change user', 11, 'change_user');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(43, 'Can delete user', 11, 'delete_user');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(44, 'Can view user', 11, 'view_user');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(45, 'Can add content type', 12, 'add_contenttype');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(46, 'Can change content type', 12, 'change_contenttype');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(47, 'Can delete content type', 12, 'delete_contenttype');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(48, 'Can view content type', 12, 'view_contenttype');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(49, 'Can add session', 13, 'add_session');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(50, 'Can change session', 13, 'change_session');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(51, 'Can delete session', 13, 'delete_session');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(52, 'Can view session', 13, 'view_session');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(53, 'Can add trained model', 14, 'add_trainedmodel');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(54, 'Can change trained model', 14, 'change_trainedmodel');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(55, 'Can delete trained model', 14, 'delete_trainedmodel');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(56, 'Can view trained model', 14, 'view_trainedmodel');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(57, 'Can add dataset', 15, 'add_dataset');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(58, 'Can change dataset', 15, 'change_dataset');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(59, 'Can delete dataset', 15, 'delete_dataset');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(60, 'Can view dataset', 15, 'view_dataset');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(61, 'Can add chart type', 16, 'add_charttype');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(62, 'Can change chart type', 16, 'change_charttype');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(63, 'Can delete chart type', 16, 'delete_charttype');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(64, 'Can view chart type', 16, 'view_charttype');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(65, 'Can add chart', 17, 'add_chart');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(66, 'Can change chart', 17, 'change_chart');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(67, 'Can delete chart', 17, 'delete_chart');
INSERT INTO public.auth_permission
(id, "name", content_type_id, codename)
VALUES(68, 'Can view chart', 17, 'view_chart');


INSERT INTO public.auth_user
(id, "password", last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined)
VALUES(1, 'pbkdf2_sha256$216000$yqg22fH3HIf7$lItuvLlJYQCVwcddYa1NOj3FNjmK5U4C2n8EoEgJ2Pc=', NULL, true, 'administrator', '', '', 'alifida86@gmail.com', true, true, '2024-02-04 18:19:54.610');
INSERT INTO public.auth_user
(id, "password", last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined)
VALUES(3, 'pbkdf2_sha256$216000$8J1Z4WEml7cf$E1qbBETXTlJTnGsOnacHWgXss8WNgYRQDAA1B5Y93rw=', '2024-02-05 08:41:07.828', false, 'ali', '', '', '', false, true, '2024-02-04 19:13:07.000');
INSERT INTO public.auth_user
(id, "password", last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined)
VALUES(2, 'pbkdf2_sha256$216000$EiESHJ7RKD1i$HBZCS860RwReID+0ItrzoIKuR1FiOgi2aCpDij9Jd4A=', '2024-08-31 19:11:59.670', true, 'admin', '', '', 'alifida.86@gmail.com', true, true, '2024-02-04 18:20:47.870');


INSERT INTO public.auth_user
(id, "password", last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined)
VALUES(3, 'pbkdf2_sha256$216000$8J1Z4WEml7cf$E1qbBETXTlJTnGsOnacHWgXss8WNgYRQDAA1B5Y93rw=', '2024-02-05 08:41:07.828', false, 'ali', '', '', '', false, true, '2024-02-04 19:13:07.000');



INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(1, 3, 1);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(2, 3, 2);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(3, 3, 3);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(4, 3, 4);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(5, 3, 5);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(6, 3, 6);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(7, 3, 7);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(8, 3, 8);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(9, 3, 9);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(10, 3, 10);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(11, 3, 11);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(12, 3, 12);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(13, 3, 13);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(14, 3, 14);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(15, 3, 15);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(16, 3, 16);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(17, 3, 17);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(18, 3, 18);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(19, 3, 19);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(20, 3, 20);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(21, 3, 21);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(22, 3, 22);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(23, 3, 23);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(24, 3, 24);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(25, 3, 25);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(26, 3, 26);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(27, 3, 27);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(28, 3, 28);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(29, 3, 29);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(30, 3, 30);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(31, 3, 31);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(32, 3, 32);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(33, 3, 33);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(34, 3, 34);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(35, 3, 35);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(36, 3, 36);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(37, 3, 37);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(38, 3, 38);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(39, 3, 39);
INSERT INTO public.auth_user_user_permissions
(id, user_id, permission_id)
VALUES(40, 3, 40);




INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(1, '2024-02-04 19:11:55.758', '1', 'admin', 1, '[{"added": {}}]', 7, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(2, '2024-02-04 19:13:08.144', '3', 'ali', 1, '[{"added": {}}]', 8, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(3, '2024-02-04 19:13:23.533', '3', 'ali', 2, '[{"changed": {"fields": ["Groups", "User permissions"]}}]', 8, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(4, '2024-02-04 19:42:15.284', '1', 'Test', 1, '[{"added": {}}]', 11, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(5, '2024-02-04 19:42:22.807', '1', 'Test', 2, '[]', 11, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(6, '2024-06-08 15:48:42.643', '31', 'ffffff', 2, '[{"changed": {"fields": ["Extracted path", "Delete at"]}}]', 11, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(7, '2024-06-08 15:49:14.991', '31', 'ffffff', 2, '[{"changed": {"fields": ["Extracted path"]}}]', 11, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(8, '2024-06-08 15:51:12.592', '31', 'ffffff', 2, '[{"changed": {"fields": ["Extracted path"]}}]', 11, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(9, '2024-06-08 15:54:27.614', '31', 'ffffff', 2, '[{"changed": {"fields": ["Extracted path"]}}]', 11, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(10, '2024-06-27 16:10:10.153', '62', '1  fPa1EBSfvc_20240627210919', 3, '', 12, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(11, '2024-06-27 16:10:15.948', '61', '1  lyzQ0LwRtp_20240627210328', 3, '', 12, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(12, '2024-06-27 19:54:13.174', '86', 'mediumsizeTB  C4qhbErAlN_20240628003706', 2, '[{"changed": {"fields": ["Result"]}}]', 12, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(13, '2024-06-27 20:13:05.214', '88', 'Single GPU batch 20', 2, '[{"changed": {"fields": ["Result"]}}]', 12, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(14, '2024-06-27 20:13:59.115', '89', 'PS batch 2', 2, '[{"changed": {"fields": ["Started at", "Ended at"]}}]', 12, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(15, '2024-06-27 20:14:29.963', '90', 'PS batch 20', 2, '[{"changed": {"fields": ["Started at", "Ended at"]}}]', 12, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(16, '2024-06-27 20:14:43.070', '88', 'Single GPU batch 20', 2, '[{"changed": {"fields": ["Started at", "Ended at"]}}]', 12, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(17, '2024-06-27 20:17:31.623', '92', 'PS batch 20 again', 2, '[{"changed": {"fields": ["Job name"]}}]', 12, 2);
INSERT INTO public.django_admin_log
(id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id)
VALUES(18, '2024-08-07 21:19:09.445', '42', 'TB Tiny Dataset', 3, '', 11, 2);




INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(1, 'uac', 'group_config');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(2, 'registration', 'registrationprofile');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(3, 'registration', 'supervisedregistrationprofile');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(4, 'sites', 'site');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(5, 'train', 'dataset_img');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(6, 'train', 'training_job');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(7, 'train', 'clusternode');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(8, 'admin', 'logentry');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(9, 'auth', 'permission');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(10, 'auth', 'group');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(11, 'auth', 'user');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(12, 'contenttypes', 'contenttype');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(13, 'sessions', 'session');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(14, 'train', 'trainedmodel');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(15, 'train', 'dataset');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(16, 'train', 'charttype');
INSERT INTO public.django_content_type
(id, app_label, model)
VALUES(17, 'train', 'chart');









INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(1, 'contenttypes', '0001_initial', '2024-08-17 16:03:12.684');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(2, 'auth', '0001_initial', '2024-08-17 16:03:12.732');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(3, 'admin', '0001_initial', '2024-08-17 16:03:12.806');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(4, 'admin', '0002_logentry_remove_auto_add', '2024-08-17 16:03:12.822');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(5, 'admin', '0003_logentry_add_action_flag_choices', '2024-08-17 16:03:12.827');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(6, 'contenttypes', '0002_remove_content_type_name', '2024-08-17 16:03:12.840');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(7, 'auth', '0002_alter_permission_name_max_length', '2024-08-17 16:03:12.846');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(8, 'auth', '0003_alter_user_email_max_length', '2024-08-17 16:03:12.852');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(9, 'auth', '0004_alter_user_username_opts', '2024-08-17 16:03:12.858');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(10, 'auth', '0005_alter_user_last_login_null', '2024-08-17 16:03:12.864');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(11, 'auth', '0006_require_contenttypes_0002', '2024-08-17 16:03:12.865');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(12, 'auth', '0007_alter_validators_add_error_messages', '2024-08-17 16:03:12.871');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(13, 'auth', '0008_alter_user_username_max_length', '2024-08-17 16:03:12.883');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(14, 'auth', '0009_alter_user_last_name_max_length', '2024-08-17 16:03:12.901');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(15, 'auth', '0010_alter_group_name_max_length', '2024-08-17 16:03:12.909');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(16, 'auth', '0011_update_proxy_permissions', '2024-08-17 16:03:12.915');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(17, 'auth', '0012_alter_user_first_name_max_length', '2024-08-17 16:03:12.921');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(18, 'registration', '0001_initial', '2024-08-17 16:03:12.935');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(19, 'registration', '0002_registrationprofile_activated', '2024-08-17 16:03:12.944');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(20, 'registration', '0003_migrate_activatedstatus', '2024-08-17 16:03:12.952');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(21, 'registration', '0004_supervisedregistrationprofile', '2024-08-17 16:03:12.962');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(22, 'registration', '0005_activation_key_sha256', '2024-08-17 16:03:12.970');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(23, 'sessions', '0001_initial', '2024-08-17 16:03:12.981');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(24, 'sites', '0001_initial', '2024-08-17 16:03:12.995');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(25, 'sites', '0002_alter_domain_unique', '2024-08-17 16:03:13.005');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(26, 'train', '0001_initial', '2024-08-17 16:03:13.023');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(27, 'train', '0002_auto_20240211_1407', '2024-08-17 16:03:13.105');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(28, 'train', '0003_dataset_img_extracted_path', '2024-08-17 16:03:13.123');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(29, 'train', '0004_clusternode', '2024-08-17 16:03:13.130');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(30, 'train', '0005_training_job_result', '2024-08-17 16:03:13.138');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(31, 'train', '0006_auto_20240808_1525', '2024-08-17 16:03:13.152');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(32, 'uac', '0001_initial', '2024-08-17 16:03:13.166');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(33, 'train', '0007_training_job_parameter_settings', '2024-08-17 20:17:53.535');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(34, 'train', '0008_dataset_trainedmodel', '2024-08-31 19:10:13.425');
INSERT INTO public.django_migrations
(id, app, "name", applied)
VALUES(35, 'train', '0009_chart_charttype', '2024-08-31 20:10:14.518');











INSERT INTO public.django_site
(id, "domain", "name")
VALUES(1, 'example.com', 'example.com');


