DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'organization_category') THEN
        CREATE TYPE organization_category AS ENUM (
            'diagnostic_laboratory',
            'healthcare_provider',
            'research_institute',
            'sequencing_center'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'practitioner_role') THEN
        CREATE TYPE practitioner_role AS ENUM (
            'doctor',
            'geneticist',
            'bioinformatician',
            'genetic_counsellor',
            'administrative_assistant',
            'resident'
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
            'social_history',
            'vital_sign',
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
            'single_germline',
            'familial_germline',
            'tumor'
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
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'event_type') THEN
        CREATE TYPE event_type AS ENUM (
            'unknown',
            'baseline',
            'follow_up',
            'treatment'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'experimental_strategy') THEN
        CREATE TYPE experimental_strategy AS ENUM (
            'wgs',
            'wxs',
            'wts'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'technology_platform') THEN
        CREATE TYPE technology_platform AS ENUM (
            'illumina',
            'pacbio',
            'nanopore'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'family_relationship') THEN
        CREATE TYPE family_relationship AS ENUM (
            'mother',
            'father',
            'brother',
            'sister'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'obs_interpretation') THEN
        CREATE TYPE obs_interpretation AS ENUM (
            'positive',
            'negative'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'sample_category') THEN
        CREATE TYPE sample_category AS ENUM (
            'specimen',
            'sample'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'sample_type') THEN
        CREATE TYPE sample_type AS ENUM (
            'dna',
            'rna',
            'blood',
            'solid_tissue'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'histology_type') THEN
        CREATE TYPE histology_type AS ENUM (
            'tumoral',
            'normal'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'affected_status') THEN
        CREATE TYPE affected_status AS ENUM (
            'affected',
            'non_affected',
            'unknown'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'age_unit') THEN
        CREATE TYPE age_unit AS ENUM (
            'day',
            'month',
            'year'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'io_type') THEN
        CREATE TYPE io_type AS ENUM (
            'input',
            'output'
        );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'data_category') THEN
        CREATE TYPE data_category AS ENUM (
            'clinical',
            'genomic'
        );
    END IF;
END;
$$  LANGUAGE plpgsql;

-- Value Sets ---------------------------------------------------------------

CREATE TABLE IF NOT EXISTS "observation_codes" (
    "code" TEXT PRIMARY KEY,
    "name_en" TEXT NOT NULL,
    "name_fr" TEXT,
    "category" observation_category NOT NULL
);

CREATE TABLE IF NOT EXISTS "onset_codes" (
    "code" TEXT PRIMARY KEY,
    "name_en" TEXT NOT NULL,
    "name_fr" TEXT
);

CREATE TABLE IF NOT EXISTS "data_type_codes" (
    "code" TEXT PRIMARY KEY,
    "name_en" TEXT NOT NULL,
    "name_fr" TEXT
);

CREATE TABLE IF NOT EXISTS "file_format_codes" (
    "code" TEXT PRIMARY KEY,
    "name_en" TEXT NOT NULL,
    "name_fr" TEXT
);
)
--  Catalogs ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "analysis_catalog" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "code" TEXT NOT NULL UNIQUE,
    "name_en" TEXT NOT NULL,
    "name_fr" TEXT,
    "genome" genome_analysis_type,
    "family" family_analysis_type,
    "life_stage" life_stage_type,
    "description" TEXT,
    "panel_id" INTEGER,
    "reflex_panel_id" INTEGER
);

CREATE TABLE IF NOT EXISTS "service_catalog" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "code" TEXT NOT NULL UNIQUE,
    "alias" TEXT UNIQUE,
    "name_en" TEXT NOT NULL,
    "name_fr" TEXT,
    "experimental_strategy" experimental_strategy,
    "platform" technology_platform,
    "description" TEXT
);

CREATE TABLE IF NOT EXISTS "task_catalog" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "code" TEXT NOT NULL UNIQUE,
    "name_en" TEXT NOT NULL,
    "name_fr" TEXT,
    "description" TEXT
);



-- Actors ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "organization" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "code" TEXT NOT NULL UNIQUE,
    "name" TEXT NOT NULL,
    "category" organization_category NOT NULL
);

CREATE TABLE IF NOT EXISTS "practitioner" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "last_name" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "license" TEXT,
    "prefix" TEXT,
    "suffix" TEXT
);

CREATE INDEX IF NOT EXISTS idx_practitioner_name ON "practitioner" ("last_name", "first_name");

CREATE TABLE IF NOT EXISTS "practitioner_has_roles" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "practitioner_id" INTEGER REFERENCES "practitioner" ("id"),
    "organization_id" INTEGER REFERENCES "organization" ("id"),
    "role" practitioner_role NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    CONSTRAINT unique_role_in_organization UNIQUE ("practitioner_id", "organization_id", "role")
);

CREATE INDEX IF NOT EXISTS idx_practitioner_has_role_organization_id ON "practitioner_has_roles" ("organization_id");

-- Patients ---------------------------------------------------------------

CREATE TABLE IF NOT EXISTS "person" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "last_name" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "sex" sex NOT NULL,
    "dob" DATE,
    "jhn" TEXT UNIQUE
);
CREATE INDEX IF NOT EXISTS idx_person_name ON "person" ("last_name", "first_name");

CREATE TABLE IF NOT EXISTS "patient" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "submitter_id" TEXT,
    "person_id" INTEGER REFERENCES "person"("id") NOT NULL,
    "sex" sex NOT NULL,
    "mrn" TEXT,
    "managing_organization_id" INTEGER REFERENCES "organization"("id"),
    "note" TEXT,
    CONSTRAINT unique_mrn_org UNIQUE ("mrn", "managing_organization_id")
);

CREATE TABLE IF NOT EXISTS "study" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "code" TEXT NOT NULL UNIQUE,
    "name" TEXT NOT NULL,
    "description" TEXT
);

CREATE TABLE IF NOT EXISTS "study_has_patients" (
    "study_id" INTEGER REFERENCES "study" ("id") NOT NULL,
    "patient_id" INTEGER REFERENCES "patient" ("id") NOT NULL,
    PRIMARY KEY ("study_id", "patient_id")
);

CREATE TABLE IF NOT EXISTS "event" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "patient_id" INTEGER REFERENCES "patient" ("id") NOT NULL,
    "type" event_type NOT NULL,
    "age_at_event" NUMERIC(6,1),
    "age_at_event_unit" age_unit,
    "start_date" DATE,
    "end_date" DATE
);

-- Cases ---------------------------------------------------------------

CREATE TABLE IF NOT EXISTS "project" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "code" TEXT NOT NULL UNIQUE,
    "name" TEXT NOT NULL,
    "description" TEXT
);

CREATE TABLE IF NOT EXISTS "case" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "analysis_catalog_id" INTEGER REFERENCES "analysis_catalog" ("id") NOT NULL,
    "project_id" INTEGER REFERENCES "project" ("id") NOT NULL,
    "proband_id" INTEGER REFERENCES "patient" ("id") NOT NULL,
    "event_id" INTEGER REFERENCES "event" ("id") NOT NULL,
    "type" case_type NOT NULL,
    "status" request_status NOT NULL,
    "priority" request_priority NOT NULL,
    "life_stage" life_stage_type NOT NULL,
    "requester_id" INTEGER REFERENCES "practitioner_has_roles" ("id"),
    "performer_id" INTEGER REFERENCES "organization" ("id"),
    "created_on" TIMESTAMP NOT NULL,
    "updated_on" TIMESTAMP NOT NULL,
    "reflex_panel" BOOLEAN,
    "diagnosis_hypothesis" TEXT,
    "note" text
);

CREATE INDEX IF NOT EXISTS idx_case_analysis_catalog_id ON "case" ("analysis_catalog_id");

CREATE INDEX IF NOT EXISTS idx_case_project_id ON "case" ("project_id");

CREATE INDEX IF NOT EXISTS idx_case_proband_id ON "case" ("proband_id");

CREATE INDEX IF NOT EXISTS idx_case_event_id ON "case" ("event_id");

CREATE INDEX IF NOT EXISTS idx_case_requester_id ON "case" ("requester_id");

CREATE INDEX IF NOT EXISTS idx_case_performer_id ON "case" ("performer_id");

CREATE TABLE IF NOT EXISTS "service_request" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "service_catalog_id" INTEGER REFERENCES "service_catalog" ("id") NOT NULL,
    "case_id" INTEGER REFERENCES "case" ("id") NOT NULL,
    "patient_id" INTEGER REFERENCES "patient" ("id") NOT NULL,
    "status" request_status NOT NULL,
    "priority" request_priority NOT NULL,
    "requester_id" INTEGER REFERENCES "practitioner_has_roles" ("id"),
    "performer_id" INTEGER REFERENCES "organization" ("id"),
    "created_on" TIMESTAMP NOT NULL,
    "updated_on" TIMESTAMP NOT NULL,
    "note" text
);

CREATE INDEX IF NOT EXISTS idx_service_service_id ON "service_request" ("service_catalog_id");

CREATE INDEX IF NOT EXISTS idx_service_case_id ON "service_request" ("case_id");

CREATE INDEX IF NOT EXISTS idx_service_patient_id ON "service_request" ("patient_id");

CREATE INDEX IF NOT EXISTS idx_service_requester_id ON "service_request" ("requester_id");

CREATE INDEX IF NOT EXISTS idx_service_performer_id ON "service_request" ("performer_id");


--Observations ---------------------------------------------------------------

CREATE TABLE IF NOT EXISTS "family" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "submitter_id" TEXT,
    "case_id" INTEGER REFERENCES "case" ("id") NOT NULL,
    "proband_id" INTEGER REFERENCES "patient" ("id") NOT NULL,
    "family_member_id" INTEGER REFERENCES "patient" ("id") NOT NULL,
    "relationship_to_proband" family_relationship NOT NULL,
    "affected_status" affected_status NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_family_case_id ON "family" ("case_id");
CREATE INDEX IF NOT EXISTS idx_family_patient_id ON "family" ("proband_id");



CREATE TABLE IF NOT EXISTS "observation_coding" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "case_id" INTEGER REFERENCES "case" ("id")  NOT NULL,
    "patient_id" INTEGER REFERENCES "patient" ("id") NOT NULL,
    "observation_code" TEXT REFERENCES "observation_codes" ("code") NOT NULL,
    "coding_system" TEXT NOT NULL,
    "code_value" TEXT NOT NULL,
    "onset_code" TEXT REFERENCES "onset_codes" ("code") NOT NULL,
    "interpretation" obs_interpretation,
    "note" TEXT
);
CREATE INDEX IF NOT EXISTS idx_observation_case_id ON "observation_coding" ("case_id");
CREATE INDEX IF NOT EXISTS idx_observation_patient_id ON "observation_coding" ("patient_id");

-- samples & sequencing ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "sample" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "submitter_id" TEXT,
    "category" sample_category NOT NULL,
    "type" sample_type NOT NULL,
    "patient_id" INTEGER REFERENCES "patient" ("id") NOT NULL,
    "parent_specimen_id" INTEGER REFERENCES "sample"("id"),
    "tissue_site" TEXT,
    "histology" histology_type
);
CREATE INDEX IF NOT EXISTS idx_sample_parent_id ON "sample" ("parent_specimen_id");
CREATE INDEX IF NOT EXISTS idx_sample_patient_id ON "sample" ("patient_id");

CREATE TABLE IF NOT EXISTS "sequencing_experiment" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "service_request_id" INTEGER REFERENCES "service_request" ("id") NOT NULL,
    "sample_id" INTEGER REFERENCES "sample" ("id") NOT NULL,
    "aliquot" TEXT NOT NULL,
    "run_name" TEXT,
    "run_alias" TEXT,
    "run_date" date,
    "sequencer" TEXT,
    "capture_kit" TEXT,
    "is_paired_end" BOOLEAN,
    "read_length" INTEGER,
    "protocol" Text
);
CREATE INDEX IF NOT EXISTS idx_sequencing_service_request_id ON "sequencing_experiment" ("service_request_id");
CREATE INDEX IF NOT EXISTS idx_seqencing_sample_id ON "sequencing_experiment" ("sample_id");

-- Tasks and Documents -------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS "task" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "task_catalog_id" INTEGER REFERENCES "task_catalog" ("id") NOT NULL,
    "case_id" INTEGER REFERENCES "case" ("id")  NOT NULL,
    "patient_id" INTEGER REFERENCES "patient" ("id") NOT NULL,
    "performer_id" INTEGER REFERENCES "organization" ("id") NOT NULL,
    "created_on" TIMESTAMP NOT NULL,
    "updated_on" TIMESTAMP NOT NULL,
    "note" text
);
CREATE INDEX IF NOT EXISTS idx_task_case_id ON "task" ("case_id");
CREATE INDEX IF NOT EXISTS idx_task_patient_id ON "task" ("patient_id");

CREATE TABLE IF NOT EXISTS "task_has_sequencing_experiments" (
    "task_id" INTEGER REFERENCES "task" ("id") NOT NULL,
    "sequencing_experiment_id" INTEGER REFERENCES "sequencing_experiment" ("id") NOT NULL,
    PRIMARY KEY ("task_id", "sequencing_experiment_id")
);

CREATE TABLE IF NOT EXISTS "task_has_parent_tasks" (
    "task_id" INTEGER REFERENCES "task" ("id") NOT NULL,
    "parent_task_id" INTEGER REFERENCES "task" ("id") NOT NULL,
    PRIMARY KEY ("task_id", "parent_task_id")
);

CREATE TABLE IF NOT EXISTS "task_has_workflows" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "task_id" INTEGER REFERENCES "task" ("id") NOT NULL,
    "workflow_name" TEXT NOT NULL,
    "version" TEXT NOT NULL,
    "parameter" TEXT,
    "rank" SMALLINT
);
CREATE INDEX IF NOT EXISTS idx_task_has_workflows_task_id ON "task_has_workflows" ("task_id");

CREATE TABLE IF NOT EXISTS "document" (
    "id" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    "file_name" TEXT NOT NULL,
    "data_category" data_category NOT NULL,
    "data_type" TEXT REFERENCES "data_type_codes" ("code") NOT NULL,
    "format" TEXT REFERENCES "file_format_codes" ("code") NOT NULL,
    "size" INTEGER NOT NULL,
    "url" TEXT NOT NULL,
    "hash" TEXT,
    "custodian_id" INTEGER REFERENCES "organization"("id") NOT NULL,
    "created_on" TIMESTAMP NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_document_data_category ON "document" ("data_category");
CREATE INDEX IF NOT EXISTS idx_document_data_type ON "document" ("data_type");
CREATE INDEX IF NOT EXISTS idx_document_format ON "document" ("format");

CREATE TABLE IF NOT EXISTS "task_has_documents" (
    "task_id" INTEGER REFERENCES "task" ("id") NOT NULL,
    "document_id" INTEGER REFERENCES "document" ("id") NOT NULL,
    "io_type" io_type,
    PRIMARY KEY ("task_id", "document_id", "io_type")
);

CREATE TABLE IF NOT EXISTS "document_has_patients" (
    "document_id" INTEGER REFERENCES "document" ("id") NOT NULL,
    "patient_id" INTEGER REFERENCES "patient" ("id") NOT NULL,
    "case_id" INTEGER REFERENCES "case" ("id")  NOT NULL,
    "sample_id" INTEGER REFERENCES "sample" ("id"),
    PRIMARY KEY ("document_id", "patient_id", "case_id","sample_id")
);
-- Value Sets and Catalogs Initial values -------------------------------------
-- Should probably be in a different init script ------------------------
INSERT INTO "observation_codes" ("code", "name_en", "name_fr", "category") VALUES
('phenotype', 'Clinical sign', 'Signe clinique', 'exam'),
('condition', 'Condition', 'Condition', 'exam'),
('ethnicity', 'Ethnicity', 'Ethnicité', 'social_history')
ON CONFLICT (code) DO NOTHING;

INSERT INTO "onset_codes" ("code", "name_en", "name_fr") VALUES
('unknown', 'Unknown', 'Inconnu'),
('antenatal', 'Antenatal', 'Anténatale'),
('congenital', 'Congenital', 'Congénitale'),
('neonatal', 'Neonatal (< 28 days)', 'Néonatale (< 28 jours)'),
('infantile', 'Infantile (>= 28 days and < 1 year)', 'Enfant en bas âge (>= 28 jours et < 1 an)'),
('childhood', 'Childhood (>= 1 year and < 5 years)', 'Enfance (>= 1 an et < 5 ans)'),
('juvenile', 'Juvenile (>= 5 years and < 16 years)', 'Juvénile (>= 5 ans et < 16 ans)'),
('young_adult', 'Young Adult (>= 16 years and < 40 years)', 'Jeune adulte (>= 16 ans et < 40 ans)'),
('middle_age', 'Middle Age (>= 40 years and < 60 years)', 'Adulte d''âge moyen (>= 40 ans et < 60 ans)'),
('senior', 'Senior (>= 60 years)', 'Adulte sénior (>= 60 ans)')
ON CONFLICT (code) DO NOTHING;

INSERT INTO data_types (code, name_en, name_fr)
VALUES
  ('alir', 'Aligned Reads', 'Fragments alignés'),
  ('snv', 'Germline SNV', 'SNV germinal'),
  ('ssnv', 'Somatic SNV', 'SNV somatic'),
  ('gcnv', 'Germline CNV', 'CNV germinal'),
  ('scnv', 'Somatic CNV', 'CNV somatic'),
  ('gsv', 'Germline SV', 'SV germinal'),
  ('ssv', 'Somatic SV', 'SV somatic'),
  ('somfu', 'Somatic Fusion Dragen VCF', 'VCF Dragen des fusions somatiques'),
  ('ssup', 'Sequencing Data Supplement', 'Données de séquençage supplémentaires'),
  ('igv', 'IGV Track', 'Track IGV'),
  ('cnvvis', 'CNV Visualization', 'Visualization de CNVs'),
  ('exp', 'Expression PNG', 'PNG des expressions'),
  ('covgene', 'Coverage by Gene Report', 'Rapport de couverture par gène'),
  ('qcrun', 'Sequencing Run QC Report', 'Rapport de controle de qualité de la run de séquençage'),
  ('exomiser', 'Exomiser Report', 'Rapport Exomiser')
  ON CONFLICT (code) DO NOTHING;

INSERT INTO file_formats (code, name_en, name_fr)
VALUES
  ('cram', 'CRAM File', 'Fichier CRAM'),
  ('crai', 'CRAI Index File', 'Fichier d''index CRAI'),
  ('vcf', 'VCF File', 'Fichier VCF'),
  ('tbi', 'TBI Index File', 'Fichier d''index TBI'),
  ('tgz', 'TGZ Archive File', 'Fichier d''archive TGZ'),
  ('json', 'JSON File', 'Fichier JSON'),
  ('html', 'HTML File', 'Fichier HTML'),
  ('tsv', 'TSV File', 'Fichier TSV'),
  ('bw', 'BW File', 'Fichier BW'),
  ('bed', 'BED File', 'Fichier BED'),
  ('png', 'PNG File', 'Fichier PNG'),
  ('csv', 'CSV File', 'Fichier CSV'),
  ('pdf', 'PDF File', 'Fichier PDF'),
  ('txt', 'Text File', 'Fichier texte')
 ON CONFLICT (code) DO NOTHING;

 INSERT INTO analysis_catalog (id, code, name_en, name_fr, genome, family, life_stage) VALUES
  (1, 'WGA', 'Whole Genome Analysis', 'Analyse du génome complet', 'germline', 'both', 'postnatal')
ON CONFLICT (id) DO NOTHING;
INSERT INTO service_catalog (id, code, alias, name_en, name_fr, experimental_strategy, platform) VALUES 
  (1, 'WGS', '948004', 'Whole Genome Sequencing', 'Séquençage du génome complet', 'wgs', 'illumina')
ON CONFLICT (id) DO NOTHING;
INSERT INTO task_catalog (id, code, name_en, name_fr) VALUES
  (1, 'NEBA', 'Normal Exome Bioinformatic Analysis', 'Analyse bioinformatique d''exomes normaux'),
  (2, 'TRBA', 'Transcriptome Bioinformatic Analysis', 'Analyse bioinformatique de transcriptomes'),
  (3, 'TEBA', 'Tumoral Exome Bioinformatic Analysis', 'Analyse bioinformatique d''exomes tumoraux'),
  (4, 'TNEBA', 'Tumor-Normal Exomes Bioinformatic Analysis', 'Analyse bioinformatique des exomes tumoraux et normaux')
ON CONFLICT (id) DO NOTHING;


