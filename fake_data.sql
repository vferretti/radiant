-- Actors
INSERT INTO organization (id, code, name, category) VALUES
  (1, 'CHOP', 'Children Hospital of Philadelphia', 'healthcare_provider'),
  (2, 'UCSF', 'University of California San-Francisco', 'healthcare_provider'),
  (3, 'CHUSJ', 'Centre hospitalier universitaire Sainte-Justine', 'healthcare_provider'),
  (4, 'LDM-CHUSJ', 'Laboratoire de diagnostic moléculaire, CHU Sainte-Justine', 'diagnostic_laboratory'),
  (5, 'LDM-CHOP', 'Molecular Diagnostic Laboratory, CHOP', 'diagnostic_laboratory'),
  (6, 'CQGC', 'Quebec Clinical Genomic Center', 'sequencing_center')
  ON CONFLICT (code) DO NOTHING;



INSERT INTO practitioner (last_name, first_name, license, prefix, suffix) VALUES ('Smith', 'John', 'LIC123', 'Dr.', 'PhD');
INSERT INTO practitioner_has_roles (practitioner_id, organization_id, role, email, phone) VALUES (1, 1, 'requester', 'john.smith@example.com', '123456789');

-- Patients
INSERT INTO person (last_name, first_name, sex, dob, jhn) VALUES ('Doe', 'Jane', 'female', '2000-01-01', 'JHN123');
INSERT INTO patient (submitter_id, person_id, sex, mrn, managing_organization_id, note) VALUES ('SUB123', 1, 'female', 'MRN123', 1, 'Note');
INSERT INTO study (code, name, description) VALUES ('ST001', 'Study Name', 'Study description');
INSERT INTO study_has_patients (study_id, patient_id) VALUES (1, 1);
INSERT INTO event (patient_id, type, age_at_event, age_at_event_unit, start_date, end_date) VALUES (1, 'diagnosis', 10.0, 'year', '2010-01-01', '2010-01-02');

-- Cases
INSERT INTO project (code, name, description) VALUES ('P001', 'Project Name', 'Project description');
INSERT INTO case (analysis_catalog_id, project_id, proband_id, event_id, type, status, priority, life_stage, requester_id, performer_id, created_on, updated_on, reflex_panel, diagnosis_hypothesis, note) 
VALUES (1, 1, 1, 1, 'tumor-only', 'pending', 'routine', 'pediatric', 1, 1, now(), now(), false, 'Hypothesis', 'Case note');

-- Services
INSERT INTO service_request (service_catalog_id, case_id, patient_id, status, priority, requester_id, performer_id, created_on, updated_on, note) 
VALUES (1, 1, 1, 'pending', 'urgent', 1, 1, now(), now(), 'Request note');

-- Observations
INSERT INTO family (submitter_id, case_id, proband_id, family_member_id, relationship_to_proband, affected_status) 
VALUES ('FAM123', 1, 1, 1, 'mother', 'affected');
INSERT INTO observation_coding (case_id, patient_id, observation_code, coding_system, code_value, onset_code, interpretation, note) 
VALUES (1, 1, 'OBS001', 'HPO', 'HP:0000001', 'ONSET001', 'abnormal', 'Observation note');

-- Samples
INSERT INTO sample (submitter_id, category, type, patient_id, tissue_site, histology) 
VALUES ('SMP001', 'blood', 'DNA', 1, 'arm', 'normal');
INSERT INTO sequencing_experiment (service_request_id, sample_id, aliquot, run_name, run_alias, run_date, sequencer, capture_kit, is_paired_end, read_length, protocol)
VALUES (1, 1, 'A001', 'Run01', 'AliasRun', '2024-01-01', 'NovaSeq', 'KitX', true, 150, 'Standard');

-- Tasks and Documents
INSERT INTO task (task_catalog_id, case_id, patient_id, performer_id, created_on, updated_on, note)
VALUES (1, 1, 1, 1, now(), now(), 'Task note');
INSERT INTO task_has_sequencing_experiments (task_id, sequencing_experiment_id) VALUES (1, 1);
INSERT INTO task_has_parent_tasks (task_id, parent_task_id) VALUES (1, 1);
INSERT INTO task_has_workflows (task_id, workflow_name, version, parameter, rank) VALUES (1, 'wf-variant', '1.0.0', '{}', 1);

INSERT INTO document (file_name, data_category, data_type, format, size, url, hash, custodian_id, created_on)
VALUES ('report.pdf', 'clinical-data', 'VCF', 'GZ', 123456, 'http://example.com/report.pdf', 'abc123', 1, now());
INSERT INTO task_has_documents (task_id, document_id, io_type) VALUES (1, 1, 'output');
INSERT INTO document_has_patients (document_id, patient_id, case_id, sample_id) VALUES (1, 1, 1, 1);
