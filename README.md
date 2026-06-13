# CSN Patient Navigator Knowledge Base

## Project Overview
**Cancer Support Netherlands (CSN)** is a community-led organization established in 2025 to assist English-speaking internationals navigating the Dutch healthcare system after a cancer diagnosis. With approximately 10,000 internationals diagnosed annually, many face barriers such as language difficulties, unfamiliar systems, and limited local support networks.

This project acts as a data analytics foundation to build a structured, English-language knowledge base from trusted Dutch sources. The goal is to support a future **Patient Navigator** tool that helps patients identify practical next steps in their journey.

---

## Core Objectives
* **Web Scraping:** Extracting data from approved Dutch healthcare webpages.
* **Translation:** Converting content from Dutch to English while preserving hyperlinks and references.
* **Data Structuring:** Mapping patient questions to trusted answers and tagging them for future AI/chatbot use.
* **Analysis:** Identifying key insights into the patient care pathway in the Netherlands.

---

## Technical Scope
The primary focus is **Understanding Your Care Pathway in the Netherlands**, which includes:
* Referrals and process.
* Waiting times.
* Treatment decisions.
* Second opinions.
* Additional care and support.
* Communication and understanding.

---

## Repository Contents

### 1. Structured Dataset
A reusable dataset containing:
* **Source Info:** Organisation, page title, original URL, and scrape date.
* **Patient Journey Data:** Journey stage, specific questions, and stakeholder tags.
* **Content:** Original Dutch text, English translations, and summarized answers.

### 2. Python Notebook
The technical pipeline including:
* Web scraping and extraction approach.
* Translation and cleaning methodology.
* Categorization, tagging logic, and data visualization.

### 3. Documentation
* **Technical Report:** Detailed breakdown of sourcing methodology, limitations, and recommendations.
* **Project Presentation:** A structured summary of the approach, sources used, and key findings.

---

## Future Implementation
The structured output is designed to be integrated into a future interface or chatbot. This includes proposed wireframes or dashboard concepts to help CSN visualize the "Patient Navigator" in action.


1. **Distributed Scraping & Ingestion:** Programmatic extractors target high-trust Dutch domains using tailored configurations:
   * `kanker.nl`: Parallelized via a thread pool (5 active workers) to traverse deep child-link tree topologies.
   * `iknl.nl`: Custom document-order walks (`<h2>`, `<p>`, `<li>`) to maintain content relationships, backed by local on-disk HTML caching for offline re-processing.
   * `Thuisarts.nl`: Recursive tree-walk engine that formats deeply nested HTML lists into cleanly indented text blocks.
   * `Zorgwijzer.nl` & `Zorginstituut Nederland`: Dynamic sitemap and clinical work-agenda crawling.
2. **Clinical Filter Gate:** Content is automatically screened against case-insensitive oncology parameters (*kanker*, *oncologie*, *tumor*, *palliatief*). Administrative headers, cookies, and boilerplate scripts are fully decomposed.
3. **Linguistic Clean-Up & Translation:** Repairs character encoding corruptions (Mojibake matrix remediation converting Windows-1252/UTF-8 compression artifacts like `‚Ä¢` to `•`). Wide matrix fields are unpivoted and safely translated using automated sentence-aware chunk boundaries (max 4,500 characters per segment).
4. **Semantic Question Bank Linkage:** Evaluates text segments against the approved CSN reference bank using token intersection scoring and conditional keyword weight boosts (e.g., matching explicit "second opinion" or "palliative" concepts) to attach standardized Question IDs.

---

## 🛠️ Tech Stack & Dependencies

The pipeline relies entirely on Python 3.13+ and utilizes the following key libraries:

| Core Domain | Library / Module | Functional Application |
| :--- | :--- | :--- |
| **Data Orchestration** | `pandas`, `numpy` | Matrix unpivoting, text slicing, unified dataset consolidation, and tabular file exports. |
| **Ingestion Engines** | `beautifulsoup4`, `requests`, `lxml` | Multi-source DOM parsing, network sessions, keep-alive connections, and layout noise decomposition. |
| **Concurrency** | `concurrent.futures` | Multi-threaded extraction scaling (5 threads) to reduce directory crawl times. |
| **Language Processing** | `deep-translator`, `re`, `html` | Google Translate API execution, sentence chunk splitting, HTML entity resolution, and regex taxonomy cleaning. |
| **Data Integrity** | `hashlib`, `json` | SHA-256 and MD5 cryptographic content fingerprinting to support automated change-tracking. |
| **Environment & Logging**| `datetime`, `os`, `logging`, `urllib.parse` | Precise timestamp generation, local physical cache creation, system error handling, and absolute URL string resolution. |

---

## 📁 Repository Structure

```hl
├── web_scraper.ipynb                      # Baseline exploratory multi-domain scraper & text utility tester
├── web_scraper_detail_kanker.ipynb         # Parallelized directory extractor for primary cancer type profiles
├── Translation_kanker.nl.ipynb            # Google API translation matrix & boundary chunking handler
├── iknl_scraper.ipynb                     # Polite overview scraper for IKNL with document-order element walks
├── nfk_nl_data_table.ipynb                # NFK patient federation data extractor and tracking hash generator
├── web_scraper_detail_thuisarts.ipynb     # Directory scanner & nested HTML list formatting tool for Thuisarts
├── web_scraper_detail_zorginstituut.ipynb # Zorginstituut work agenda spider & cancer map taxonomy engine
├── csn_data_consolidation_pipeline.ipynb  # Core engine: handles unpivoting, encoding repairs, and CSN Question Bank mapping
└── README.md                              # Project documentation


Set up guide
