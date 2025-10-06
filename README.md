# 🛍️ E-commerce Customer Churn Analysis (SQL Project)
## 📖 Project Overview

This project focuses on analyzing customer churn patterns in an e-commerce business using SQL.
The goal is to identify the key factors influencing customer attrition — such as complaints, satisfaction scores, payment modes, and order behavior — and provide actionable insights to help improve customer retention.

# Problem Statement

E-commerce companies often lose customers due to dissatisfaction, poor engagement, or lack of loyalty programs.
This project uses historical transactional data to identify:

Why customers are leaving (churn drivers).

Which customer segments are most at risk.

What strategies can reduce churn and improve loyalty.

## 🎯 Objectives

Understand customer churn trends and behavior.

Identify relationships between customer satisfaction, complaints, and churn rate.

Support data-driven decision-making for retention strategies.

## 🧩 Dataset Details
📂 Dataset

Download the dataset:
📎 Click here to download

The dataset contains customer demographics, purchase behavior, satisfaction scores, payment preferences, and churn indicators.
Table: customer_churn
Contains customer demographics, purchasing behavior, complaints, and churn status.

Additional Table: customer_returns
Stores customer return and refund details to analyze refund-related churn.

## 🛠️ SQL Tasks Performed
### 🔹 Data Cleaning

Imputed missing values (mean/mode) and removed outliers.

Standardized categorical values (e.g., COD → Cash on Delivery).
Handles outliers using Z-score

### 🔹 Data Transformation

Renamed columns for consistency.

Created new columns like ComplaintReceived and ChurnStatus.

Dropped redundant columns after transformation.

### 🔹 Data Analysis

Identified churned vs. active customers.

Calculated average tenure, cashback, and satisfaction for churned users.

Found most preferred payment modes and order categories.

Categorized customers by distance from warehouse and analyzed churn distribution.

Joined with returns data to explore refund patterns of churned customers.

## 📊 Key Insights

Customers with more complaints and lower satisfaction are more likely to churn.

Credit card and mobile app users show higher retention.

City Tier 1 customers exhibit higher churn due to competitive offers.

Effective complaint resolution can significantly improve loyalty.

## 💡 Tools & Technologies

SQL – MySQL Workbench

Dataset – SQL format (imported into MySQL)

Data Cleaning & Analysis – SQL Queries

## Outcomes

Identified top churn contributors to improve business strategies.

Provided actionable insights for customer retention and loyalty programs.

Demonstrated complete end-to-end SQL data analysis workflow.

Author

Angel P Shaji
B.Tech in Information Technology | Aspiring Data Analyst
📍 Kerala, India
