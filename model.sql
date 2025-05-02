


DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'category') THEN
        CREATE TYPE category AS ENUM (
            'diagnostic_laboratory',
            'healthcare_provider',
            'research_institute',
            'university'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'status') THEN
        CREATE TYPE status AS ENUM (
            'draft',
            'unknown',
            'active',
            'revoke',
            'completed',
            'on-hold',
            'incomplete'
        );
    END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'practionner_role') THEN
        CREATE TYPE status AS ENUM (
            'doctor',
            'geneticist'
        );
    END IF;
END
$$;
CREATE TABLE IF NOT EXISTS  "Organization" (
    "id" integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "code" varchar NOT NULL UNIQUE,
    "name" varchar NOT NULL,
    "category" org_cat NOT NULL
);

CREATE TABLE "Practitioner" (
    "id" integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "last_name" varchar NOT NULL,
    "first_name" varchar NOT NULL,
    "licence" varchar UNIQUE,
    "prefix" varchar,
    "suffix" varchar
);
CREATE INDEX idx_practitioner_last_name ON "Practitioner" ("last_name");
CREATE INDEX idx_practitioner_first_name ON "Practitioner" ("first_name");

CREATE TABLE IF NOT EXISTS "Practitioner_role" (
    "practitioner_id" integer REFERENCES "Practitioner"("id"),
    "organization_id" integer REFERENCES "Organization"("id"),
    "role" practionner_role NOT NULL,           
    "email" varchar,         
    "phone" varchar,                   
    PRIMARY KEY ("practitioner_id", "organization_id")
);
CREATE INDEX IF NOT EXISTS idx_practitioner_role_practitioner_id 
    ON "Practitioner_role" ("practitioner_id");

CREATE INDEX IF NOT EXISTS idx_practitioner_role_organization_id 
    ON "Practitioner_role" ("organization_id");

-- -----


CREATE TABLE "Obs_string" (
    "id" integer NOT NULL,
    "case_id" integer,
    "patient_id" integer NOT NULL,
    "event_id" integer,
    "obs_code_id" integer NOT NULL,
    "value" varchar NOT NULL,
    -- HPO code
    "onset" enum,
    -- Positive, Negative, unknown
    "interpretation" enum,
    "note" text,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "Obs_string"."onset" IS 'HPO code';
COMMENT ON COLUMN "Obs_string"."interpretation" IS 'Positive, Negative, unknown';


CREATE TABLE "Person" (
    "id" integer NOT NULL,
    "last_name" varchar(30),
    "first_name" varchar(30),
    "sex" enum,
    "dob" date,
    -- Jurisdictional Health Number (eg RAMQ)
    "jhn" varchar(20) UNIQUE,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "Person"."jhn" IS 'Jurisdictional Health Number (eg RAMQ)';


CREATE TABLE "Analysis_dir" (
    "id" integer NOT NULL,
    -- e.g RDGI
    "code" varchar NOT NULL UNIQUE,
    "name_en" varchar NOT NULL,
    "name_fr" varchar,
    -- germline, somatic
    "type" enum,
    -- single, familial, both
    -- 
    "context" enum NOT NULL,
    -- pre-natal, post-natal, both
    "stage" enum,
    "description" varchar,
    "panel_id" integer,
    "reflex_panel_id" integer,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "Analysis_dir"."code" IS 'e.g RDGI';
COMMENT ON COLUMN "Analysis_dir"."type" IS 'germline, somatic';
COMMENT ON COLUMN "Analysis_dir"."context" IS 'single, familial, both
';
COMMENT ON COLUMN "Analysis_dir"."stage" IS 'pre-natal, post-natal, both';





CREATE TABLE "Obs_number" (
    "id" integer NOT NULL,
    "case_id" integer,
    "patient_id" integer NOT NULL,
    "event_id" integer,
    "obs_code_id" integer NOT NULL,
    "value" numeric NOT NULL,
    "unit" varchar,
    -- HPO code
    "onset" enum,
    -- Positive, Negative, unknown
    "interpretation" enum,
    "note" text,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "Obs_number"."onset" IS 'HPO code';
COMMENT ON COLUMN "Obs_number"."interpretation" IS 'Positive, Negative, unknown';


CREATE TABLE "project" (
    "id" integer NOT NULL,
    "code" varchar UNIQUE,
    "name" varchar,
    "description" text,
    PRIMARY KEY ("id")
);



CREATE TABLE "Obs_coding" (
    "id" integer NOT NULL,
    "case_id" integer,
    "patient_id" integer NOT NULL,
    "event_id" integer,
    "obs_code_id" integer NOT NULL,
    "code_system" enum NOT NULL,
    -- HP:393883
    "code_value" varchar NOT NULL,
    "term" varchar NOT NULL,
    -- HPO code
    "onset" enum,
    -- Positive, Negative, unknown
    "interpretation" enum,
    "note" text,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "Obs_coding"."code_value" IS 'HP:393883';
COMMENT ON COLUMN "Obs_coding"."onset" IS 'HPO code';
COMMENT ON COLUMN "Obs_coding"."interpretation" IS 'Positive, Negative, unknown';


CREATE TABLE "Family" (
    "id" integer NOT NULL,
    "submitter_id" integer,
    "case_id" integer,
    "proband_id" integer NOT NULL,
    "family_member_id" integer NOT NULL,
    -- Self 
    -- Mother
    -- Father
    -- Brother
    -- Sister
    -- Half-brother
    -- Half-sister
    -- Identical twin
    -- Fraternal twin brother
    -- Fraternal twin sister
    -- Son
    -- Daughter
    "relationship_to_proband" enum NOT NULL,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "Family"."relationship_to_proband" IS 'Self 
Mother
Father
Brother
Sister
Half-brother
Half-sister
Identical twin
Fraternal twin brother
Fraternal twin sister
Son
Daughter';

CREATE UNIQUE INDEX "Family_index_2"
ON "Family" ("case_id", "family_member_id");


CREATE TABLE "Patient" (
    "id" integer NOT NULL,
    "submitter_id" integer,
    "person_id" integer,
    "sex" enum NOT NULL,
    "mrn" varchar(10),
    "managing_organization_id" integer,
    "note" text,
    PRIMARY KEY ("id")
);



CREATE TABLE "Case_analysis" (
    "id" integer NOT NULL,
    "analysis_id" integer NOT NULL,
    "project_id" integer NOT NULL,
    -- The patient to be analysed
    "proband_id" integer NOT NULL,
    -- Individual Germline Analysis
    -- Familial Germline nalysis,
    -- Somatic Tumor Analysis
    "type" enum,
    "status" enum NOT NULL,
    "priority" enum NOT NULL,
    -- postnatal, prenatal
    "stage" enum NOT NULL,
    "event_id" integer,
    "requester_id" integer,
    "performer_id" integer,
    "created_on" timestamp NOT NULL,
    "updated_on" timestamp NOT NULL,
    "reflex_panel" boolean,
    -- diagnosis hypothesis
    "diagnosis_hypothesis" varchar,
    "note" text,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "Case_analysis"."proband_id" IS 'The patient to be analysed';
COMMENT ON COLUMN "Case_analysis"."type" IS 'Individual Germline Analysis
Familial Germline nalysis,
Somatic Tumor Analysis';
COMMENT ON COLUMN "Case_analysis"."stage" IS 'postnatal, prenatal';
COMMENT ON COLUMN "Case_analysis"."diagnosis_hypothesis" IS 'diagnosis hypothesis';


CREATE TABLE "Obs_dir" (
    "id" integer NOT NULL,
    "code" varchar NOT NULL,
    "name_en" varchar NOT NULL,
    "name_fr" varchar,
    -- exam,, lab, procedure, social-history
    "category" enum,
    "description" varchar NOT NULL,
    PRIMARY KEY ("id", "code")
);

COMMENT ON COLUMN "Obs_dir"."category" IS 'exam,, lab, procedure, social-history';


CREATE TABLE "Study" (
    "id" integer NOT NULL,
    "code" varchar,
    "name" varchar,
    "description" text,
    PRIMARY KEY ("id")
);



CREATE TABLE "doc_has_patients" (
    "id" integer NOT NULL,
    "document_id" integer NOT NULL,
    "case_id" integer,
    "patient_id" integer,
    PRIMARY KEY ("id")
);



CREATE TABLE "Seq_experiment" (
    "id" integer NOT NULL,
    "service_request_id" varchar,
    "case_id" integer,
    "patient_id" integer NOT NULL,
    "aliquot" varchar NOT NULL UNIQUE,
    "sample_id" integer NOT NULL,
    "run_name" varchar,
    "run_alias" varchar,
    "run_date" date,
    "sequencer" varchar,
    "capture_kit" varchar,
    "is_paired_end" enum,
    "read_length" integer,
    "protocol" varchar,
    PRIMARY KEY ("id")
);



CREATE TABLE "Pipeline_dir" (
    "id" integer NOT NULL,
    "code" varchar NOT NULL,
    "name_en" varchar NOT NULL,
    "name_fr" varchar,
    "description" varchar,
    "version" char(10) NOT NULL,
    PRIMARY KEY ("id", "code")
);



CREATE TABLE "event" (
    "id" bigint NOT NULL,
    "case_id" integer,
    "patient_id" integer,
    -- baseline, followup. treatment
    "event_type" enum NOT NULL,
    "age_at_event" integer,
    "age_at_event_unit" enum,
    "start_date" date,
    "end_date" date,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "event"."event_type" IS 'baseline, followup. treatment';


-- WGS, WXS, MRI, WTS
CREATE TABLE "Service_dir" (
    "id" integer NOT NULL,
    -- code officiel (ex du MSSS)
    "code" varchar NOT NULL,
    -- WXS
    "alias" varchar,
    "name_en" varchar NOT NULL,
    "name_fr" varchar,
    -- wgs, wxs, etc.
    "experimental_strategy" enum,
    -- Illumina, PacBio
    "platform" varchar(10),
    "description" varchar NOT NULL,
    PRIMARY KEY ("id", "code")
);

COMMENT ON TABLE "Service_dir" IS 'WGS, WXS, MRI, WTS';

COMMENT ON COLUMN "Service_dir"."code" IS 'code officiel (ex du MSSS)';
COMMENT ON COLUMN "Service_dir"."alias" IS 'WXS';
COMMENT ON COLUMN "Service_dir"."experimental_strategy" IS 'wgs, wxs, etc.';
COMMENT ON COLUMN "Service_dir"."platform" IS 'Illumina, PacBio';


CREATE TABLE "Case_req_has_samples" (
    "id" bigint NOT NULL,
    "case_id" integer,
    "request_id" integer,
    "sample_id" integer NOT NULL,
    PRIMARY KEY ("id")
);





COMMENT ON COLUMN "Organization"."category" IS 'Diagnostic Laboratory, Healthcare Provider
Research Institute
University';


CREATE TABLE "Biorin_task_has_document" (
    "id" bigint NOT NULL,
    "task_id" bigint,
    "document_id" bigint,
    "io" enum,
    PRIMARY KEY ("id")
);



CREATE TABLE "Service_request" (
    "id" integer NOT NULL,
    "service_id" integer,
    "case_id" integer NOT NULL,
    "patient_id" integer,
    "status" enum NOT NULL,
    "requester_id" integer,
    "performer_id" integer,
    "created_on" timestamp NOT NULL,
    "updated_on" timestamp NOT NULL,
    PRIMARY KEY ("id")
);



CREATE TABLE "Family_member_history" (
    "id" integer NOT NULL,
    "case_id" integer,
    "patient_id" integer NOT NULL,
    "relationship_code" bigint,
    "condition" varchar(255) NOT NULL,
    PRIMARY KEY ("id")
);


CREATE UNIQUE INDEX "Family_member_history_index_2"
ON "Family_member_history" ("case_id");


CREATE TABLE "Sample" (
    "id" integer NOT NULL,
    "submitter_id" integer,
    -- specimen, sample
    "category" enum,
    -- DNA, RNA, blood, tissue
    "type" enum NOT NULL,
    "case_id" integer,
    "patient_id" integer NOT NULL,
    "parent_specimen_id" integer,
    -- biopsy site
    "tissue_site" varchar,
    -- Tumoral; Normal
    "histology" enum,
    PRIMARY KEY ("id")
);

COMMENT ON COLUMN "Sample"."category" IS 'specimen, sample';
COMMENT ON COLUMN "Sample"."type" IS 'DNA, RNA, blood, tissue';
COMMENT ON COLUMN "Sample"."tissue_site" IS 'biopsy site';
COMMENT ON COLUMN "Sample"."histology" IS 'Tumoral; Normal';


CREATE TABLE "Practitioner_role" (
    "id" integer NOT NULL,
    "pratictioner_id" integer NOT NULL,
    "organization_id" integer NOT NULL,
    "role" enum NOT NULL,
    "email" varchar,
    "phone" varchar(12),
    PRIMARY KEY ("id")
);



CREATE TABLE "Study_has_patients" (
    "id" integer NOT NULL,
    "study_id" integer,
    "patient_id" integer,
    PRIMARY KEY ("id")
);



CREATE TABLE "Document" (
    "id" integer NOT NULL,
    "task_id" integer,
    "name" varchar NOT NULL,
    "url" varchar,
    "data_category" enum NOT NULL,
    "data_type" enum NOT NULL,
    "format" enum NOT NULL,
    "hash" varchar,
    "size" integer NOT NULL,
    "custodian_id" integer,
    PRIMARY KEY ("id")
);



ALTER TABLE "Case_analysis"
ADD CONSTRAINT "fk_Case_analysis_id_Service_request_case_id" FOREIGN KEY("id") REFERENCES "Service_request"("case_id");

ALTER TABLE "Organization"
ADD CONSTRAINT "fk_Organization_id_Practitioner_role_organization_id" FOREIGN KEY("id") REFERENCES "Practitioner_role"("organization_id");

ALTER TABLE "Patient"
ADD CONSTRAINT "fk_Patient_id_Case_analysis_proband_id" FOREIGN KEY("id") REFERENCES "Case_analysis"("proband_id");

ALTER TABLE "Practitioner"
ADD CONSTRAINT "fk_Practitioner_id_Practitioner_role_pratictioner_id" FOREIGN KEY("id") REFERENCES "Practitioner_role"("pratictioner_id");

ALTER TABLE "project"
ADD CONSTRAINT "fk_project_id_Case_analysis_project_id" FOREIGN KEY("id") REFERENCES "Case_analysis"("project_id");
