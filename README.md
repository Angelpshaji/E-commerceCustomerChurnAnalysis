# 🛍️ E-commerce Customer Churn Analysis (SQL Project)
## 📖 Project Overview

This project focuses on analyzing customer churn patterns in an e-commerce business using SQL.
The goal is to identify the key factors influencing customer attrition — such as complaints, satisfaction scores, payment modes, and order behavior — and provide actionable insights to help improve customer retention.

## 🎯 Objectives

Understand customer churn trends and behavior.

Identify relationships between customer satisfaction, complaints, and churn rate.

Support data-driven decision-making for retention strategies.

## 🧩 Dataset Details

Table: customer_churn
Contains customer demographics, purchasing behavior, complaints, and churn status.

Additional Table: customer_returns
Stores customer return and refund details to analyze refund-related churn.

## 🛠️ SQL Tasks Performed
### 🔹 Data Cleaning

Imputed missing values (mean/mode) and removed outliers.

Standardized categorical values (e.g., COD → Cash on Delivery).

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

Dataset – CSV format (imported into MySQL)

Data Cleaning & Analysis – SQL Queries

## Outcomes

Identified top churn contributors to improve business strategies.

Provided actionable insights for customer retention and loyalty programs.

Demonstrated complete end-to-end SQL data analysis workflow.
