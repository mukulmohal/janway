-- public.roles definition

-- Drop table

-- DROP TABLE public.roles;

CREATE TABLE public.roles (
	id uuid NOT NULL,
	"name" varchar(256) NULL,
	normalized_name varchar(256) NULL,
	concurrency_stamp text NULL,
	is_internal bool NOT NULL,
	CONSTRAINT roles_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX roles_normalized_name_key ON roles USING btree (normalized_name);


-- public.states definition

-- Drop table

-- DROP TABLE public.states;

CREATE TABLE public.states (
	id serial NOT NULL,
	"name" varchar(50) NOT NULL,
	country_id int4 NOT NULL,
	creation_date timestamp NOT NULL DEFAULT now(),
	CONSTRAINT states_pkey PRIMARY KEY (id)
);


-- public.users definition

-- Drop table

-- DROP TABLE public.users;

CREATE TABLE public.users (
	id uuid NOT NULL,
	user_name varchar(256) NULL,
	normalized_user_name varchar(256) NULL,
	email varchar(256) NULL,
	normalized_email varchar(256) NULL,
	email_confirmed bool NOT NULL,
	password_hash text NULL,
	security_stamp text NULL,
	concurrency_stamp text NULL,
	phone_number text NULL,
	phone_number_confirmed bool NOT NULL,
	two_factor_enabled bool NOT NULL,
	lockout_end timestamptz NULL,
	lockout_enabled bool NOT NULL,
	access_failed_count int4 NOT NULL,
	creation_date timestamp NOT NULL DEFAULT now(),
	CONSTRAINT users_pkey PRIMARY KEY (id)
);
CREATE INDEX users_normalized_email_key ON users USING btree (normalized_email);
CREATE UNIQUE INDEX users_normalized_user_name_key ON users USING btree (normalized_user_name);


-- public.addresses definition

-- Drop table

-- DROP TABLE public.addresses;

CREATE TABLE public.addresses (
	id int4 NOT NULL,
	street varchar(100) NOT NULL,
	city varchar(50) NOT NULL,
	state_id int4 NOT NULL,
	zip_code varchar(10) NOT NULL,
	latitude float8 NOT NULL,
	longitude float8 NOT NULL,
	creation_date timestamp NOT NULL DEFAULT now(),
	CONSTRAINT adresses_pkey PRIMARY KEY (id),
	CONSTRAINT addresses_states_id_fkey FOREIGN KEY (state_id) REFERENCES states(id)
);


-- public.organizations definition

-- Drop table

-- DROP TABLE public.organizations;

CREATE TABLE public.organizations (
	id serial NOT NULL,
	"name" varchar(50) NOT NULL,
	is_active bool NOT NULL,
	address_id int4 NOT NULL,
	creation_date timestamp NOT NULL DEFAULT now(),
	CONSTRAINT organizations_pkey PRIMARY KEY (id),
	CONSTRAINT organizations_address_id_fkey FOREIGN KEY (address_id) REFERENCES addresses(id)
);


-- public.roleclaims definition

-- Drop table

-- DROP TABLE public.roleclaims;

CREATE TABLE public.roleclaims (
	id serial NOT NULL,
	role_id uuid NOT NULL,
	claim_type text NULL,
	claim_value text NULL,
	CONSTRAINT role_claims_pkey PRIMARY KEY (id),
	CONSTRAINT role_claims_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);
CREATE INDEX role_claims_role_id_key ON roleclaims USING btree (role_id);


-- public.userclaims definition

-- Drop table

-- DROP TABLE public.userclaims;

CREATE TABLE public.userclaims (
	id serial NOT NULL,
	user_id uuid NOT NULL,
	claim_type text NULL,
	claim_value text NULL,
	CONSTRAINT user_claims_pkey PRIMARY KEY (id),
	CONSTRAINT user_claims_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX user_claims_user_id_key ON userclaims USING btree (user_id);


-- public.userlogins definition

-- Drop table

-- DROP TABLE public.userlogins;

CREATE TABLE public.userlogins (
	login_provider text NOT NULL,
	provider_key text NOT NULL,
	provider_display_name text NULL,
	user_id uuid NOT NULL,
	CONSTRAINT user_logins_pkey PRIMARY KEY (login_provider, provider_key),
	CONSTRAINT user_logins_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX user_logins_user_id_key ON userlogins USING btree (user_id);


-- public.userroles definition

-- Drop table

-- DROP TABLE public.userroles;

CREATE TABLE public.userroles (
	user_id uuid NOT NULL,
	role_id uuid NOT NULL,
	CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id),
	CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
	CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX user_roles_role_id_key ON userroles USING btree (role_id);


-- public.usertokens definition

-- Drop table

-- DROP TABLE public.usertokens;

CREATE TABLE public.usertokens (
	user_id uuid NOT NULL,
	login_provider text NOT NULL,
	"name" text NOT NULL,
	value text NULL,
	CONSTRAINT user_tokens_pkey PRIMARY KEY (user_id, login_provider, name),
	CONSTRAINT user_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


-- public.facilities definition

-- Drop table

-- DROP TABLE public.facilities;

CREATE TABLE public.facilities (
	id serial NOT NULL,
	"name" varchar(50) NOT NULL,
	is_active bool NOT NULL,
	organization_id int4 NOT NULL,
	address_id int4 NOT NULL,
	creation_date timestamp NOT NULL DEFAULT now(),
	CONSTRAINT facilities_pkey PRIMARY KEY (id),
	CONSTRAINT facilities_address_id_fkey FOREIGN KEY (address_id) REFERENCES addresses(id),
	CONSTRAINT facilities_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organizations(id)
);


-- public.supervisors definition

-- Drop table

-- DROP TABLE public.supervisors;

CREATE TABLE public.supervisors (
	id serial NOT NULL,
	is_owner bool NOT NULL,
	user_id uuid NOT NULL,
	facility_id int4 NULL,
	organization_id int4 NOT NULL,
	creation_date timestamp NOT NULL DEFAULT now(),
	CONSTRAINT supervisors_pkey PRIMARY KEY (id),
	CONSTRAINT supervisors_facility_id_fkey FOREIGN KEY (facility_id) REFERENCES facilities(id),
	CONSTRAINT supervisors_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organizations(id),
	CONSTRAINT supervisors_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id)
);


-- public.units definition

-- Drop table

-- DROP TABLE public.units;

CREATE TABLE public.units (
	id serial NOT NULL,
	suin int4 NOT NULL,
	uin int4 NOT NULL,
	mac_address varchar(20) NOT NULL,
	ip_address varchar(20) NOT NULL,
	"name" varchar(50) NOT NULL,
	is_active bool NOT NULL,
	facility_id int4 NULL,
	creation_date timestamp NOT NULL DEFAULT now(),
	CONSTRAINT units_ip_address_key UNIQUE (ip_address),
	CONSTRAINT units_mac_address_key UNIQUE (mac_address),
	CONSTRAINT units_pkey PRIMARY KEY (id),
	CONSTRAINT units_suin_key UNIQUE (suin),
	CONSTRAINT units_uin_key UNIQUE (uin),
	CONSTRAINT units_facility_id_fkey FOREIGN KEY (facility_id) REFERENCES facilities(id)
);


-- public.flushes definition

-- Drop table

-- DROP TABLE public.flushes;

CREATE TABLE public.flushes (
	id serial NOT NULL,
	"date" timestamp NOT NULL DEFAULT now(),
	selenoid_temperature float8 NOT NULL,
	filter_1 float8 NOT NULL,
	filter_2 float8 NOT NULL,
	filter_3 float8 NOT NULL,
	filter_4 float8 NOT NULL,
	battery_level int4 NOT NULL,
	health int4 NOT NULL,
	performance int4 NOT NULL,
	unit_id int4 NOT NULL,
	creation_date timestamp NOT NULL DEFAULT now(),
	CONSTRAINT flushes_pkey PRIMARY KEY (id),
	CONSTRAINT flushes_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES units(id)
);


CREATE TABLE public.invites (
	id serial NOT NULL,
	email varchar(100) NOT NULL,
	confirmed bool NOT NULL,
	creation_date timestamp NOT NULL DEFAULT now(),
	CONSTRAINT invites_pkey PRIMARY KEY (id)
);

alter table public.invites add column RoleId int
alter table public.invites add column FacilityID int
alter table public.invites add column OrganizationId int
