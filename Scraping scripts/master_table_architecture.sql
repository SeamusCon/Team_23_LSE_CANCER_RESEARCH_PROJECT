
CREATE VIEW dashboard_master_view AS

-- 1. ADDITIONAL CANCER INFORMATION
-- LOGIC: This dataset contains broad, overarching articles. Since it lacks an 
-- explicit 'cancer_type' column, I used keyword matching (ILIKE) on titles/content 
-- to categorize specific cancers, falling back to 'General / All'. Since it is 
-- informational, I insert static text for the journey and stakeholder columns.
SELECT 
    CASE 
        WHEN page_title_en ILIKE '%breast%' OR article_content_en ILIKE '%breast%' THEN 'Breast Cancer'
        WHEN page_title_en ILIKE '%lung%' OR article_content_en ILIKE '%lung%' THEN 'Lung Cancer'
        WHEN page_title_en ILIKE '%prostate%' OR article_content_en ILIKE '%prostate%' THEN 'Prostate Cancer'
        WHEN page_title_en ILIKE '%colon%' OR article_content_en ILIKE '%colon%' THEN 'Colon Cancer'
        WHEN page_title_en ILIKE '%skin%' OR article_content_en ILIKE '%skin%' THEN 'Skin Cancer'
        ELSE 'General / All'
    END AS cancer_type, 
    'Additional Cancer Info' AS source_organisation, source_url, scrape_date,
    trustworthiness, -- Universal column
    page_title AS topic_nl, article_content AS general_description_nl, 'Aanvullende Ondersteuning' AS patient_journey_stage_nl, 'Patiëntengids' AS stakeholder_nl, NULL AS treatment_nl, 'Lees het volledige artikel voor leefstijltips.' AS next_step_nl,
    page_title_en AS topic_en, article_content_en AS general_description_en, 'Additional Support' AS patient_journey_stage_en, 'Patient Care Guidance' AS stakeholder_en, NULL AS treatment_en, 'Read full article for lifestyle tips.' AS next_step_en,
    'Informational Resource / General Guidance' AS target_question
FROM additional_cancer_info

UNION ALL

-- 2. ZORGWIJZER
-- LOGIC: This dataset is strictly administrative (focused on insurance & rights). 
-- It naturally contains actionable next steps, but completely lacks clinical medical 
-- treatments, so treatments are hardcoded to 'Insurance & Rights' or left NULL. 
-- I apply the same keyword fallback matching for maximum filtering accuracy.

SELECT 
    CASE 
        WHEN care_pathway_topic_en ILIKE '%breast%' OR original_dutch_text_en ILIKE '%breast%' THEN 'Breast Cancer'
        WHEN care_pathway_topic_en ILIKE '%lung%' OR original_dutch_text_en ILIKE '%lung%' THEN 'Lung Cancer'
        WHEN care_pathway_topic_en ILIKE '%prostate%' OR original_dutch_text_en ILIKE '%prostate%' THEN 'Prostate Cancer'
        WHEN care_pathway_topic_en ILIKE '%colon%' OR original_dutch_text_en ILIKE '%colon%' THEN 'Colon Cancer'
        WHEN care_pathway_topic_en ILIKE '%skin%' OR original_dutch_text_en ILIKE '%skin%' THEN 'Skin Cancer'
        ELSE COALESCE(care_pathway_topic_en, 'General / All') 
    END AS cancer_type,
    'Zorgwijzer' AS source_organisation, original_url AS source_url, scrape_date,
    trustworthiness, -- Universal column
    source_page_title_nl AS topic_nl, original_dutch_text AS general_description_nl, patient_journey_stage AS patient_journey_stage_nl, stakeholder AS stakeholder_nl, NULL AS treatment_nl, action_or_next_step AS next_step_nl,
    source_page_title_nl_en AS topic_en, original_dutch_text_en AS general_description_en, patient_journey_stage_en AS patient_journey_stage_en, stakeholder_en AS stakeholder_en, 'Insurance & Rights' AS treatment_en, action_or_next_step_en AS next_step_en,
    'What are my insurance or system navigation choices?' AS target_question
FROM zorgwijzer_data

UNION ALL

-- 3. ZORGINSTITUUT
-- LOGIC: Represents official government policy and advisory context. It natively 
-- tracks standardized cancer variants and intro summaries for clinical treatment 
-- metrics. Static placeholders bridge the missing administrative 'next step' metrics.
SELECT 
    standardized_cancer_type AS cancer_type, 'Zorginstituut' AS source_organisation, source_url, scrape_date,
    trustworthiness,
    advisory_topic AS topic_nl, full_context_block AS general_description_nl, 'Behandelingsbeslissingen' AS patient_journey_stage_nl, 'Overheidsadviesraad' AS stakeholder_nl, intro_summary AS treatment_nl, 'Raadpleeg het medisch centrum voor afstemming.' AS next_step_nl,
    advisory_topic_en AS topic_en, full_context_block_en AS general_description_en, 'Treatment Decisions' AS patient_journey_stage_en, 'Official Advisory Policy' AS stakeholder_en, intro_summary_en AS treatment_en, 'Consult medical center for advisory standard alignment.' AS next_step_en,
    'What are the official clinical policy positions?' AS target_question
FROM zorginstituut_data

UNION ALL

-- 4. IKNL MASTER
-- LOGIC: This clinical dataset maps comprehensive oncology timelines. It fills 
-- out the diagnosis, treatment, and structural stakeholder fields natively. 
-- Standard action points are provided to support the clinical journey phase.
SELECT 
    cancer_type, source_organisation, source_url, scrape_date,
    trustworthiness,
    'IKNL Oncologie Trajecten' AS topic_nl, general_description AS general_description_nl, 'Diagnose & Zorgtrajecten' AS patient_journey_stage_nl, source_organisation AS stakeholder_nl, treatment AS treatment_nl, 'Zie klinische behandeltrajecten.' AS next_step_nl,
    'IKNL Oncology Pathways' AS topic_en, general_description_en AS general_description_en, 'Diagnosis & Care Pathways' AS patient_journey_stage_en, source_organisation AS stakeholder_en, treatment_en AS treatment_en, 'Refer to specific clinical treatment timelines.' AS next_step_en,
    'What does the general treatment framework look like?' AS target_question
FROM iknl_data

UNION ALL

-- 5. KANKER.NL BREAKOUT
-- LOGIC: Deep medical profile breakouts mapping diagnostic protocols. It maps 
-- directly to specific cancer variants. Static textual navigation loops back to 
-- primary medical specialists as the primary tactical action point.
SELECT 
    cancer_type, 'Kanker.nl' AS source_organisation, source_url, scrape_date,
    trustworthiness,
    'Klinisch Diagnoseprofiel' AS topic_nl, general_description AS general_description_nl, 'Diagnose / Initiële Fase' AS patient_journey_stage_nl, 'Medisch / Klinisch' AS stakeholder_nl, treatments_nl AS treatment_nl, 'Bespreek de symptomen met uw specialist.' AS next_step_nl,
    'Clinical Diagnosis Profile' AS topic_en, general_description_en AS general_description_en, 'Diagnosis / Initial Phase' AS patient_journey_stage_en, 'Medical / Clinical' AS stakeholder_en, treatments_en AS treatment_en, 'Discuss symptoms with your primary specialist.' AS next_step_en,
    CONCAT('What are the symptoms and treatments for ', cancer_type, '?') AS target_question
FROM kanker_nl_data

UNION ALL

-- 6. THUISARTS COMPREHENSIVE
-- LOGIC: Sourced from General Practitioner (GP) guidelines focusing heavily on the 
-- crucial initial 48 hours post-diagnosis. It populates actionable summaries, 
-- leaving deep oncological treatment matrices blank (NULL) to reflect primary care limits.
SELECT 
    topic_category_en AS cancer_type, 'Thuisarts' AS source_organisation, url AS source_url, scrape_date,
    trustworthiness,
    page_title AS topic_nl, content_extract AS general_description_nl, 'Oriëntatie / Eerste 48 Uur' AS patient_journey_stage_nl, 'Huisarts Richtlijn' AS stakeholder_nl, NULL AS treatment_nl, in_brief_summary AS next_step_nl,
    page_title_en AS topic_en, content_extract_en AS general_description_en, 'Orientation / First 48 Hours' AS patient_journey_stage_en, 'GP / Primary Care Guidance' AS stakeholder_en, NULL AS treatment_en, in_brief_summary_en AS next_step_en,
    'What basic information should I review post-diagnosis?' AS target_question
FROM thuisarts_data

UNION ALL

-- 7. NFK TABLE
-- LOGIC: This represents active patient-submitted logs.
-- It naturally contains real user questions, allowing us to map the 
-- question column explicitly to drive the Tableau % Answered KPI cards.
SELECT 
    cancer_type, 'NFK' AS source_organisation, source_url, date_scraped AS scrape_date,
    trustworthiness,
    topic AS topic_nl, general_description AS general_description_nl, journey_stage AS patient_journey_stage_nl, support_type AS stakeholder_nl, treatment AS treatment_nl, next_step AS next_step_nl,
    topic_en AS topic_en, general_description_en AS general_description_en, journey_stage AS patient_journey_stage_en, support_type_en AS stakeholder_en, treatment AS treatment_en, next_step_en AS next_step_en,
    question_en AS target_question
FROM nfk_data;
