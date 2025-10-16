<cfif NOT structKeyExists(session, "isLoggedIn") OR session.isLoggedIn EQ false>
    <cflocation url="/views/auth/login.cfm">
</cfif>

<h2>Welcome, <cfoutput>#session.username#</cfoutput>!</h2>
<p>This is your dashboard. You can start adding and tracking expenses.</p>
<a href="/controllers/logout.cfm">Logout</a>
