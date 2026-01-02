# 🏗️ Data Warehouse Project (Medallion Architecture)

This project demonstrates the design and implementation of an **enterprise-style Data Warehouse** using the **Medallion Architecture (Bronze, Silver, Gold)** pattern.  
It focuses on clean data layering, traceability, transformation logic, and analytics-ready modeling.

The solution is implemented using **SQL Server**, with structured naming conventions and clear separation of responsibilities across layers.

---

## 📐 Architecture Overview
The data warehouse follows the **Medallion Architecture**, where data flows progressively from raw ingestion to business-ready outputs.

### 🔹 High-Level Architecture
![Data Architecture Diagram](./PROJECT%20FILES/%23%20Project%20Diagrams/Medallion%20Architecture%20in%20Brief.png)

---

## 🔁 Data Flow

Source systems feed raw data into the Bronze layer, which is then transformed and standardized in the Silver layer, and finally exposed through analytical views in the Gold layer.

![Data Flow Diagram](./PROJECT%20FILES/%23%20Project%20Diagrams/Data%20Flow.png)

---

## 🧱 Medallion Layers

### 🥉 Bronze Layer (Raw Data)
- Stores **raw, unprocessed data** from source systems (CRM, ERP)
- Loaded using **Full Load (Truncate & Insert)**
- No transformations applied
- Used for **traceability and debugging**

**Object Type:** Tables  
**Target Audience:** Data Engineers

---

### 🥈 Silver Layer (Clean & Standardized)
- Data cleaning and standardization
- Normalization and enrichment
- Derived columns added
- Prepares data for analytical modeling

**Transformations Include:**
- Data cleaning  
- Data standardization  
- Normalization  
- Enrichment  

**Object Type:** Tables  
**Target Audience:** Data Engineers, Data Analysts

---

### 🥇 Gold Layer (Business-Ready)
- Contains **analytics-ready datasets**
- Implements **business logic and aggregations**
- Designed using **Star Schema**
- **Implemented as SQL Views (not physical tables)**

**Object Type:** Views  
**Target Audience:** Data Analysts, Business Users

![Medallion Architecture Summary](./Medallion%20Architecture%20in%20Brief.png)

---

## 🔗 Integration Model

CRM and ERP data are integrated in the Silver layer before being modeled into dimensions and fact views in the Gold layer.

![Integration Model](./PROJECT%20FILES/%23%20Project%20Diagrams/Integration%20Model.png)

---

## ⭐ Gold Layer – Data Mart (Star Schema)

The Gold layer exposes a **Star Schema** optimized for reporting and analytics.

- `gold.fact_sales`
- `gold.dim_customers`
- `gold.dim_products`

📌 **Note:**  
All Gold layer objects are **VIEWS**, not permanent tables.

![Star Schema Diagram](./Star%20Schema%20Diagram%20%5B%20Gold%20Layer%20Table%20%5D.png)

---

## 🧾 Naming Conventions

A consistent naming standard is followed across all layers:

```text
bronze.<source>_<entity>
silver.<source>_<entity>
gold.dim_<entity>
gold.fact_<entity>
