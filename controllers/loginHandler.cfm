<cfparam name="form.email" default="">
<cfparam name="form.password" default="">

<cftry>
    <!--- Hash the password --->
    <cfset hashedPassword = hash(trim(form.password) & "yoursalt", "SHA-256")>

    <!--- Check credentials --->
    <cfquery name="result" datasource="mydsn">
        SELECT id, username
        FROM users
        WHERE email = <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar">
        AND password = <cfqueryparam value="#hashedPassword#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif result.recordCount gt 0>
        <!--- Set session --->
        <cfset session.isLoggedIn = true>
        <cfset session.userId = result.id[1]>
        <cfset session.username = result.username[1]>

        <!--- Redirect to dashboard --->
        <cflocation url="/views/dashboard/index.cfm">
    <cfelse>
        <cfoutput>
            <h3>Invalid email or password.</h3>
            <a href="/views/auth/login.cfm">Try again</a>
        </cfoutput>
    </cfif>

<cfcatch type="any">
    <cfoutput>
        <h3>Error: #cfcatch.message#</h3>
        <a href="/views/auth/login.cfm">Try again</a>
    </cfoutput>
</cfcatch>
</cftry>
