<cfcomponent output="false" rest="true" restPath="expenses" displayName="ExpensesController">

    // Private helper to authorize JWT token
    private struct function authorize() {
        if (not structKeyExists(cgi,"http_authorization")) {
            throw(type="Unauthorized", message="No Authorization header found");
        }

        var authHeader = cgi.http_authorization;
        if (left(authHeader,7) neq "Bearer ") {
            throw(type="Unauthorized", message="Invalid Authorization header");
        }

        var token = trim(mid(authHeader,8)); // Remove "Bearer "
        var tokenHelper = new helpers.Token();
        return tokenHelper.verifyToken(token);
    }

    // GET all expenses
    <cffunction name="getAll" access="remote" httpMethod="GET" returnFormat="json" output="false">
        <cfset var response = {}>

        <cftry>
            <cfset var user = authorize()>

            <cfquery name="result" datasource="mydsn">
                SELECT *
                FROM expenses
                WHERE user_id = <cfqueryparam value="#user.sub#" cfsqltype="cf_sql_integer">
                ORDER BY expense_date DESC
            </cfquery>

            <cfset response = {status="success", expenses=result}>

            <cfcatch type="any">
                <cfset response = {status="error", message=cfcatch.message}>
            </cfcatch>
        </cftry>

        <cfreturn response>
    </cffunction>

    // ADD an expense
    <cffunction name="add" access="remote" httpMethod="POST" returnFormat="json" output="false">
        <cfargument name="category" type="string" required="true">
        <cfargument name="amount" type="numeric" required="true">
        <cfargument name="expense_date" type="date" required="true">
        <cfargument name="description" type="string" required="false" default="">

        <cfset var response = {}>

        <cftry>
            <cfset var user = authorize()>

            <cfquery datasource="mydsn">
                INSERT INTO expenses (user_id, category, amount, expense_date, description)
                VALUES (
                    <cfqueryparam value="#user.sub#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.category#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.amount#" cfsqltype="cf_sql_decimal">,
                    <cfqueryparam value="#arguments.expense_date#" cfsqltype="cf_sql_date">,
                    <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>

            <cfset response = {status="success", message="Expense added"}>

            <cfcatch type="any">
                <cfset response = {status="error", message=cfcatch.message}>
            </cfcatch>
        </cftry>

        <cfreturn response>
    </cffunction>

</cfcomponent>
