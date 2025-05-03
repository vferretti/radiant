DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'organization_category') THEN
        CREATE TYPE organization_category AS ENUM (
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
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'practitioner_role') THEN
        CREATE TYPE practitioner_role AS ENUM (
            'doctor',
            'geneticist'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'sex') THEN
        CREATE TYPE sex AS ENUM (
            'male',
            'female',
            'unknown'
        );
    END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'observation_category') THEN
        CREATE TYPE observation_category AS ENUM (
            'social-history',
            'vital-sign',
            'imaging',
            'laboratory',
            'procedure',
            'survey',
            'exam',
            'therapy',
            'activity'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'genome_analysis_type') THEN
        CREATE TYPE genome_analysis_type AS ENUM (
            'germline',
            'somatic'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'family_analysis_type') THEN
        CREATE TYPE family_analysis_type AS ENUM (
            'single',
            'familial',
            'both'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'life_stage_type') THEN
        CREATE TYPE life_stage_type AS ENUM (
            'prenatal',
            'postnatal',
            'both'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'case_type') THEN
        CREATE TYPE case_type AS ENUM (
            'single_germline_case',
            'familial_germline_case',
            'tumor_case'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'request_status') THEN
        CREATE TYPE request_status AS ENUM (
            'unknown',
            'draft',
            'active',
            'revoke',
            'completed',
            'on-hold',
            'incomplete'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'request_priority') THEN
        CREATE TYPE request_priority AS ENUM (
            'routine',
            'urgent',
            'asap',
            'stat'
        );
    END IF;
END
$$  LANGUAGE plpgsql;

--  Directory Tables

CREATE TABLE IF NOT EXISTS "Obs_dir" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "code" VARCHAR NOT NULL UNIQUE,
    "name_en" VARCHAR NOT NULL,
    "name_fr" VARCHAR,
    "category" observation_category NOT NULL,
    "description" VARCHAR
);

CREATE TABLE IF NOT EXISTS "Analysis_dir" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "code" VARCHAR NOT NULL UNIQUE,
    "name_en" VARCHAR NOT NULL,
    "name_fr" VARCHAR,
    "genome" genome_analysis_type,
    "family" family_analysis_type,
    "life_stage" life_stage_type,
    "description" VARCHAR,
    "panel_id" INTEGER,
    "reflex_panel_id" INTEGER
);

-- Actor Tables
CREATE TABLE IF NOT EXISTS "Organization" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "code" VARCHAR NOT NULL UNIQUE,
    "name" VARCHAR NOT NULL,
    "category" organization_category NOT NULL
);

CREATE TABLE "Practitioner" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "last_name" VARCHAR NOT NULL,
    "first_name" VARCHAR NOT NULL,
    "licence" VARCHAR UNIQUE,
    "prefix" VARCHAR,
    "suffix" VARCHAR
);

CREATE INDEX idx_practitioner_last_name ON "Practitioner" ("last_name");

CREATE INDEX idx_practitioner_first_name ON "Practitioner" ("first_name");

CREATE TABLE IF NOT EXISTS "Practitioner_role" (
    "practitioner_id" INTEGER REFERENCES "Practitioner" ("id"),
    "organization_id" INTEGER REFERENCES "Organization" ("id"),
    "role" practitioner_role NOT NULL,
    "email" VARCHAR,
    "phone" VARCHAR,
    PRIMARY KEY (
        "practitioner_id",
        "organization_id"
    )
);

CREATE INDEX IF NOT EXISTS idx_practitioner_role_practitioner_id ON "Practitioner_role" ("practitioner_id");

CREATE INDEX IF NOT EXISTS idx_practitioner_role_organization_id ON "Practitioner_role" ("organization_id");

-- Patient Tables
CREATE TABLE IF NOT EXISTS "Person" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "last_name" VARCHAR NOT NULL,
    "first_name" VARCHAR NOT NULL,
    "sex" sex NOT NULL,
    "dob" DATE,
    "jhn" VARCHAR UNIQUE
);

CREATE TABLE IF NOT EXISTS "Patient" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "submitter_id" VARCHAR,
    "person_id" INTEGER REFERENCES "Person"("id") NOT NULL,
    "sex" sex NOT NULL,
    "mrn" VARCHAR,
    "managing_organization_id" INTEGER REFERENCES "Organization"("id)",
    "note" TEXT,
    CONSTRAINT unique_mrn_org UNIQUE ("mrn", "managing_organization_id")
);

CREATE TABLE IF NOT EXISTS "Study" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "code" VARCHAR NOT NULL UNIQUE,
    "name" VARCHAR NOT NULL,
    "description" TEXT
);

CREATE TABLE IF NOT EXISTS "Study_has_patient" (
    "study_id" INTEGER REFERENCES "Study" ("id"),
    "patient_id" INTEGER REFERENCES "Patient" ("id"),
    PRIMARY KEY ("study_id", "patient_id")
);

-- Case Tables, Event Table
CREATE TABLE IF NOT EXISTS "Project" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "code" VARCHAR NOT NULL UNIQUE,
    "name" VARCHAR NOT NULL,
    "description" TEXT
);

CREATE TABLE IF NOT EXISTS "Case" (
    "id" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "analysis_id" INTEGER REFERENCES "Analysis_dir"("id") NOT NULL,
    "project_id" INTEGER REFERENCES "Project"("id") NOT NULL,
    "proband_id" INTEGER REFERENCES "Patient"("id") NOT NULL,
    "type" case_type NOT NULL,
    "status" request_status NOT NULL,
    "priority" request_priority NOT NULL,
    "life_stage" life_stage_type NOT NULL,
    "event_id" INTEGER REFERENCES "Event"("id"),
    "requester_id" INTEGER REFERENCES "Practitioner_role"("id"),
    "performer_id" INTEGER REFERENCES "Organization"("id"),
    "created_on" timestamp NOT NULL,
    "updated_on" timestamp NOT NULL,
    "reflex_panel" boolean,
    "diagnosis_hypothesis" VARCHAR,
    "note" text
);
-- -------------------------------------------------------------
