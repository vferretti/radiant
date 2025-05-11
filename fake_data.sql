-- Active: 1746963621814@@127.0.0.1@5435@radiant
-- Actors
INSERT INTO organization (id, code, name, category) VALUES
  (1, 'CHOP', 'ChilDrn Hospital of Philadelphia', 'healthcare_provider'),
  (2, 'UCSF', 'University of California San-Francisco', 'healthcare_provider'),
  (3, 'CHUSJ', 'Centre hospitalier universitaire Sainte-Justine', 'healthcare_provider'),
  (4, 'LDM-CHUSJ', 'Laboratoire de diagnostic moléculaire, CHU Sainte-Justine', 'diagnostic_laboratory'),
  (5, 'LDM-CHOP', 'Molecular Diagnostic Laboratory, CHOP', 'diagnostic_laboratory'),
  (6, 'CQGC', 'Quebec Clinical Genomic Center', 'sequencing_center')
  ON CONFLICT (code) DO NOTHING;

INSERT INTO practitioner (id, last_name, first_name, license, prefix, suffix) VALUES 
(1, 'Laflamme', 'Felix', '37498', 'Dr', NULL),
(2, 'Lopez', 'Melissa', '37500', 'Dr', NULL),
(3, 'Watson', 'Christopher', '37502', 'Dr', NULL),
(4, 'Breton', 'Victoria', '37504', 'Dr', NULL),
(5, 'Paré', 'Antoine', '37506', 'Dr', NULL),
(6, 'Frye', 'Jonathan', '37508', 'Dr', NULL),
(7, 'Taylor', 'Dawn', '37510', 'Dr', NULL),
(8, 'Maxwell', 'Lauren', '37512', 'Dr', NULL),
(9, 'Duchesne', 'Elliot', '37514', 'Dr', NULL),
(10, 'Williams', 'Alex', '37516', 'Dr', NULL),
(11, 'Séguin', 'Arthur', '37518', 'Dr', NULL),
(12, 'Veilleux', 'Raphaelle', '37520', 'Dr', NULL),
(13, 'Stevens', 'Louis', '37522', 'Dr', NULL),
(14, 'Gervais', 'Sarah', '37524', 'Dr', NULL),
(15, 'Peterson', 'Xavier', '37526', 'Dr', NULL),
(16, 'Laroche', 'Jeanne', '37528', 'Dr', NULL),
(17, 'Morissette', 'Arnaud', '37530', 'Dr', NULL),
(18, 'Charron', 'Sophia', '37532', 'Dr', NULL),
(19, 'Reid', 'Ethan', '37534', 'Dr', NULL),
(20, 'Laplante', 'Leonie', '37536', 'Dr', NULL),
(21, 'Chabot', 'Henri', '37538', 'Dr', NULL),
(22, 'Brunet', 'Alexia', '37540', 'Dr', NULL),
(23, 'Vézina', 'Loic', '37542', 'Dr', NULL),
(24, 'Desrochers', 'Rose', '37544', 'Dr', NULL),
(25, 'Morgan', 'Zachary', '37546', 'Dr', NULL),
(26, 'Hall', 'Julie', NULL, 'PhD', NULL),
(27, 'Hamdan', 'Fadi', NULL, 'PhD', NULL),
(28, 'Anoja', 'Nancy', NULL, 'PhD', NULL),
(29, 'Baret', 'Laurence', NULL, 'PhD', NULL),
(30, 'Canales', 'Karen', NULL, 'PhD', NULL),
(31, 'Sillon', 'Guillaume', NULL, 'PhD', NULL),
(32, 'Chong', 'George', NULL, 'PhD', NULL),
(33, 'Monczak', 'Yury', NULL, 'PhD', NULL),
(34, 'Roy', 'Leonard', '37549', 'Dr', NULL),
(35, 'Leclerc', 'Juliette', '37550', 'Dr', NULL),
(36, 'Roy', 'Leon', '37551', 'Dr', NULL),
(37, 'Gagnon', 'Ella', '37552', 'Dr', NULL),
(38, 'Poirier', 'Eva', '37553', 'Dr', NULL),
(39, 'Leblanc', 'Thomas', '37554', 'Dr', NULL),
(40, 'Jordan', 'Romy', NULL, NULL, NULL),
(41, 'Boucher', 'Alexis', NULL, NULL, NULL),
(42, 'Girard', 'Nathan', NULL, NULL, NULL),
(43, 'Thibault', 'Victoria', NULL, NULL, NULL),
(44, 'Beaulieu', 'Samuel', NULL, NULL, NULL),
(45, 'Poulin', 'Mia', NULL, NULL, NULL)
ON CONFLICT (id) DO NOTHING;


INSERT INTO practitioner_has_roles (id, practitioner_id, organization_id, role, email, phone) VALUES
(1, 1, 3, 'doctor', 'laflamme.felix@chusj.org', '514-564-3099'),
(2, 2, 3, 'doctor', 'lopez.melissa@chusj.org', '514-564-3100'),
(3, 3, 3, 'doctor', 'watson.christopher@chusj.org', '514-564-3101'),
(4, 4, 3, 'doctor', 'breton.victoria@chusj.org', '514-564-3102'),
(5, 5, 3, 'doctor', 'pare.antoine@chusj.org', '514-564-3103'),
(6, 6, 3, 'doctor', 'frye.jonathan@chusj.org', '514-564-3104'),
(7, 7, 1, 'doctor', 'taylor.dawn@chop.org', '514-564-3105'),
(8, 8, 1, 'doctor', 'maxwell.lauren@chop.org', '514-564-3106'),
(9, 9, 1, 'doctor', 'duchesne.elliot@chop.org', '514-564-3107'),
(10, 10, 1, 'doctor', 'williams.alex@chop.org', '514-564-3108'),
(11, 11, 1, 'doctor', 'seguin.arthur@chop.org', '514-564-3109'),
(12, 12, 1, 'doctor', 'veilleux.raphaelle@chop.org', '514-564-3110'),
(13, 13, 2, 'doctor', 'stevens.louis@ucsf.org', '514-564-3111'),
(14, 14, 2, 'doctor', 'gervais.sarah@ucsf.org', '514-564-3112'),
(15, 15, 2, 'doctor', 'peterson.xavier@ucsf.org', '514-564-3113'),
(16, 16, 2, 'doctor', 'laroche.jeanne@ucsf.org', '514-564-3114'),
(17, 17, 2, 'doctor', 'morissette.arnaud@ucsf.org', '514-564-3115'),
(18, 18, 3, 'geneticist', 'charron.sophia@ucsfj.org', '514-564-3116'),
(19, 19, 3, 'geneticist', 'reid.ethan@chusj.org', '514-564-3117'),
(20, 20, 3, 'geneticist', 'laplante.leonie@chusj.org', '514-564-3118'),
(21, 21, 3, 'geneticist', 'chabot.henri@chusj.org', '514-564-3119'),
(22, 22, 1, 'geneticist', 'brunet.alexia@chop.org', '514-564-3120'),
(23, 23, 2, 'geneticist', 'vezina.loic@chop.org', '514-564-3121'),
(24, 24, 2, 'geneticist', 'desrochers.rose@ucsf.org', '514-564-3122'),
(25, 25, 2, 'geneticist', 'morgan.zachary@ucsf.org', '514-564-3123'),
(26, 26, 4, 'geneticist', 'hall.julie@ldm-chusj.org', '514-564-3124'),
(27, 27, 4, 'geneticist', 'hamdan.fadi@ldm-chusj.org', '514-564-3125'),
(28, 28, 4, 'geneticist', 'anoja.nancy@ldm-chusj.org', '514-564-3126'),
(29, 29, 5, 'geneticist', 'baret.laurence@ldm-chop.org', '514-564-3127'),
(30, 30, 5, 'geneticist', 'canales.karen@ldm-chop.org', '514-564-3128'),
(31, 31, 5, 'geneticist', 'sillon.guillaume@ldm-chop.org', '514-564-3129'),
(32, 32, 5, 'geneticist', 'chong.george@ldm-chop.org', '514-564-3130'),
(33, 33, 5, 'geneticist', 'monczak.yury@ldm-chop.org', '514-564-3131'),
(34, 34, 4, 'geneticist', 'roy.leonard@ldm-chusj.org', '514-564-3132'),
(35, 35, 4, 'geneticist', 'leclerc.juliette@ldm-chusj.org', '514-564-3133'),
(36, 36, 5, 'geneticist', 'roy.leon@ldm-chop.org', '514-564-3134'),
(37, 37, 5, 'geneticist', 'gagnon.ella@ldm-chop.org', '514-564-3135'),
(38, 38, 5, 'geneticist', 'poirier.eva@ldm-chop.org', '514-564-3136'),
(39, 39, 5, 'geneticist', 'leblanc.thomas@ldm-chop.org', '514-564-3137'),
(40, 40, 4, 'geneticist', 'jordan.romy@ldm-chusj.org', '514-564-3138'),
(41, 41, 5, 'geneticist', 'boucher.alexis@ldm-chop.org', '514-564-3139'),
(42, 42, 5, 'geneticist', 'girard.nathan@ldm-chop.org', '514-564-3140'),
(43, 43, 4, 'geneticist', 'thibault.victoria@ldm-chusj.org', '514-564-3141'),
(44, 44, 5, 'geneticist', 'beaulieu.samuel@ldm-chop.org', '514-564-3142'),
(45, 45, 5, 'geneticist', 'poulin.mia@ldm-chop.org', '514-564-3143')
ON CONFLICT (id) DO NOTHING;

-- Patients
INSERT INTO study (id, code, name, description) VALUES
(1, 'CaG', 'CARTaGENE','CARTaGENE est une plateforme publique de recherche du CHU Sainte-Justine'),
(2, 'NeuroDev', 'WGS for the investigation of neuro-developmental disorders', NULL)
ON CONFLICT (id) DO NOTHING;

-- Cases

INSERT INTO project (id, code, name, description) VALUES
(1, 'N1', 'NeuroDev Phase I', 'Phase one NeuroDev cases'),
(2, 'N2', 'NeuroDev Phase II', 'Phase two NeuroDev cases')
ON CONFLICT (id) DO NOTHING;
