<cfparam name="form.username" default="">
<cfparam name="form.email" default="">
<cfparam name="form.password" default="">
<cfparam name="form.confirmPassword" default="">

<!--- Check if password and confirm password match --->
<cfif form.password neq form.confirmPassword>
    <cfset errorMessage = "Passwords do not match. Please try again.">
    <cfinclude template="/views/auth/signup.cfm">
    <cfabort>
</cfif>

<cftry>
    <!--- Hash the password --->
    <cfset hashedPassword = hash(trim(form.password) & "yoursalt", "SHA-256")>

    <!--- Insert into database --->
    <cfquery datasource="mydsn">
        INSERT INTO users (username, email, password)
        VALUES (
            <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#hashedPassword#" cfsqltype="cf_sql_varchar">
        )
    </cfquery>

    <!--- Instead of redirect page, show success message inside signup form --->
    <cfset successMessage = "Signup successful! Redirecting to login page...">
    <cfinclude template="/views/auth/signup.cfm">

<cfcatch type="any">
    <!--- Handle duplicate email or general errors --->
    <cfif findNoCase("Duplicate entry", cfcatch.message) and findNoCase("email", cfcatch.message)>
        <cfset errorMessage = "This email is already registered. Please try another email.">
    <cfelse>
        <cfset errorMessage = "Error: #cfcatch.message#">
    </cfif>

    <cfinclude template="/views/auth/signup.cfm">
</cfcatch>
</cftry>
