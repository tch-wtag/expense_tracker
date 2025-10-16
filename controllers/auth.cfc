<cfcomponent output="false" displayname="AuthController">

    <!--- Signup function --->
    <cffunction name="signupFrontend" access="remote" returnformat="html" httpmethod="post" output="true">
        <cfargument name="username" type="string" required="true">
        <cfargument name="email" type="string" required="true">
        <cfargument name="password" type="string" required="true">

        <cfset hashedPassword = hash(trim(form.password) & "yoursalt", "SHA-256")>

        <cftry>
            <!--- Insert user --->
            <cfquery datasource="mydsn">
                INSERT INTO users (username, email, password)
                VALUES (
                    <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#hashedPassword#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>

            <!--- Show friendly message and redirect --->
            <cfoutput>
                <h3>Signup successful! You can now <a href="/views/auth/login.cfm">login</a>.</h3>
                <script>
                    setTimeout(function(){
                        window.location.href = "/views/auth/login.cfm";
                    }, 3000); // redirect after 3 seconds
                </script>
            </cfoutput>

            <cfcatch type="any">
                <cfoutput>
                    <h3>Error: #cfcatch.message#</h3>
                    <a href="/views/auth/signup.cfm">Try again</a>
                </cfoutput>
            </cfcatch>
        </cftry>
    </cffunction>


    <!--- Login function --->
    <cffunction name="login" access="remote" returnformat="json" httpmethod="post" output="false">
        <cfargument name="email" type="string" required="true">
        <cfargument name="password" type="string" required="true">

        <cfset var response = structNew()>
        <cfset hashedPassword = hash(trim(form.password) & "yoursalt", "SHA-256")>


        <cftry>
            <cfquery name="result" datasource="mydsn">
                SELECT id, username
                FROM users
                WHERE email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
                AND password = <cfqueryparam value="#hashedPassword#" cfsqltype="cf_sql_varchar">
            </cfquery>

            <cfif result.recordCount gt 0>
                <cfset session.isLoggedIn = true>
                <cfset session.userId = result.id[1]>
                <cfset session.username = result.username[1]>

                <!--- Generate JWT token --->
                <cfset var tokenHelper = new helpers.Token()>
                <cfset var jwt = tokenHelper.generateToken(result.id[1], result.username[1])>

                <cfset response = {
                    "status"="success",
                    "message"="Login successful",
                    "token"=jwt,
                    "user"={ "id"=result.id[1], "username"=result.username[1] }
                }>
            <cfelse>
                <cfset response = { "status"="error", "message"="Invalid email or password" }>
            </cfif>

            <cfcatch type="any">
                <cfset response = { "status"="error", "message"=cfcatch.message }>
            </cfcatch>
        </cftry>

        <cfreturn response>
    </cffunction>

</cfcomponent>
