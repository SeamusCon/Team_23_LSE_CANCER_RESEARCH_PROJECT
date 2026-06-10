-- Setting up the the data table achitecture before populating the table with the real datasets.

-- 1. ADDITIONAL CANCER INFORMATION
CREATE TABLE additional_cancer_info (
    global_track VARCHAR(255), page_title TEXT, source_url TEXT, scrape_date DATE, content_hash VARCHAR(64),
    article_content TEXT, page_title_en TEXT, article_content_en TEXT, 
    trustworthiness NUMERIC(2,1)
);

--  ZORGWIJZER
CREATE TABLE zorgwijzer_data (
    source_organisation           VARCHAR(255),
    source_page_title_nl          TEXT,
    scrape_date                   TIMESTAMP,
    content_hash                  VARCHAR(64),
    original_dutch_text           TEXT,
    original_url                  TEXT,
    hyperlinks                    TEXT,
    patient_journey_stage         TEXT,
    care_pathway_topic            TEXT,
    stakeholder                   TEXT,
    action_or_next_step           TEXT,
    source_page_title_nl_en       TEXT,
    original_dutch_text_en        TEXT,
    patient_journey_stage_en      TEXT,
    care_pathway_topic_en         TEXT,
    stakeholder_en                TEXT,
    action_or_next_step_en        TEXT,
    trustworthiness               NUMERIC(2,1)
);

-- ZORGINSTITUUT
CREATE TABLE zorginstituut_data (
    advisory_topic TEXT, standardized_cancer_type VARCHAR(255), source_url TEXT, scrape_date DATE, content_hash VARCHAR(64),
    intro_summary TEXT, full_context_block TEXT, advisory_topic_en TEXT, intro_summary_en TEXT, full_context_block_en TEXT, 
    trustworthiness NUMERIC(2,1)
);

-- IKNL MASTER
CREATE TABLE iknl_data (
    cancer_type VARCHAR(255), source_url TEXT, source_organisation VARCHAR(255), general_description TEXT,
    decision_making TEXT, treatment TEXT, statistics_and_survival TEXT, life_after_cancer TEXT, palliative_phase TEXT,
    research TEXT, scrape_date DATE, content_hash VARCHAR(64), body_length_chars INT, hyperlinks_preserve TEXT,
    notes TEXT, general_description_en TEXT, decision_making_en TEXT, treatment_en TEXT, statistics_and_survival_en TEXT,
    life_after_cancer_en TEXT, palliative_phase_en TEXT, research_en TEXT, hyperlinks_preserved_en TEXT, 
    trustworthiness NUMERIC(2,1)
);

-- KANKER.NL BREAKOUT
CREATE TABLE kanker_nl_data (
    cancer_type VARCHAR(255), source_url TEXT, scrape_date DATE, content_hash VARCHAR(64), general_description TEXT,
    prognosis_nl TEXT, symptoms_nl TEXT, causes_nl TEXT, treatments_nl TEXT, general_description_en TEXT,
    prognosis_en TEXT, symptoms_en TEXT, causes_en TEXT, treatments_en TEXT, 
    trustworthiness NUMERIC(2,1)
);

--  THUISARTS COMPREHENSIVE
CREATE TABLE thuisarts_data (
    topic_category VARCHAR(255), page_title TEXT, url TEXT, scrape_date DATE, content_hash VARCHAR(64),
    in_brief_summary TEXT, content_extract TEXT, topic_category_en VARCHAR(255), page_title_en TEXT,
    in_brief_summary_en TEXT, content_extract_en TEXT, 
    trustworthiness NUMERIC(2,1) -- Updated to numeric score
);

-- 7. NFK NL TABLE
CREATE TABLE nfk_data (
    cancer_type VARCHAR(255), source_url TEXT, topic TEXT, question TEXT, general_description TEXT,
    journey_stage VARCHAR(255), support_type VARCHAR(255), treatment TEXT, next_step TEXT, keywords TEXT,
    date_scraped DATE, content_hash VARCHAR(64), topic_en TEXT, question_en TEXT, general_description_en TEXT,
    next_step_en TEXT, support_type_en TEXT, 
    trustworthiness NUMERIC(2,1) -- Updated to numeric score
);

-- Please note that the data tables were populated using the pgAdmin's import tool because the COPY command threw "PERMISSION DENIED ERROR".

