<cfset sessionInvalidate()>
<cfoutput>
    <h3>You have been logged out. Redirecting to login page...</h3>
    <script>
        setTimeout(function(){
            window.location.href = "/views/auth/login.cfm";
        }, 2000);
    </script>
</cfoutput>
