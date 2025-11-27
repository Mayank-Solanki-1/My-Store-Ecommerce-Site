# My Store Ecommerce Site
Online E-Commerce Platform (Java Servlet & JSP)

 The platform will allow sellers to create and manage product listings, buyers to 
browse and purchase products, and administrators to oversee user management, product 
listings, and order processing.


Problem Statement:

The goal is to develop an e-commerce platform where sellers can list products, 
buyers can purchase products, and administrators can manage the overall system. Each user 
type will have a dedicated dashboard to manage their activities and view relevant information. 

Group Members:

• MAYANK SOLANKI

• MONU KUMAR

• BHUPESH DUBEY


🚀 Features

 User Roles & Authentication

Secure Login/Registration: Users can sign up as a Buyer or Seller.

Role-Based Access Control: Validated access to specific dashboards (Admin, Seller, Buyer) via AuthFilter.

Auto-Login: Immediate redirection to the dashboard after registration.

1. Admin Module (Admin register is only allowed when Admin secret key =SuperSecret123)

2. Seller Module

3. Buyer Module


How to Run the Project:

1. Clone the Project

2. Import into IDE

   • Use IntelliJ / Eclipse

   • Select Existing Maven / Java Project

3. Setup Database

   • Import schema.sql into MySQL

   • Update application.properties with your database username/password

4. Configure Tomcat

   • Download and Select Tomcat 9 

   • Deploy the project

5. Run

   • Open browser and go to:



🛠️ Technology Stack

• Backend: Java Servlets (javax.servlet), JDBC

• Frontend: JSP (JavaServer Pages), JSTL, Bootstrap 5

• Database: MySQL 8.0

• Connection Pooling: HikariCP

• Build/Server: Maven (optional), Apache Tomcat 9+




