component {
    this.name = "ExpenseTrackerAPI";
    this.sessionManagement = true;
    this.sessionTimeout = createTimeSpan(0,2,0,0); // 2 hours
    this.datasource = "mydsn";

    function onApplicationStart() {
        try {
            restInitApplication(
                dirPath = expandPath("/var/www/controllers"),
                serviceMapping = "/api",
                password = "hello"
            );
        } catch(any e) {
            writeOutput("REST initialization error: " & e.message);
        }
        return true;
    }

    function onSessionStart() {
        session.isLoggedIn = false;
        session.userRole = "";
    }

    public void function onRequest(string targetPage) {
        try {
            // Skip REST API requests
            if (structKeyExists(cgi,"path_info") and left(cgi.path_info,5) eq "/api/") return;

            // Public pages
            publicPages = ["index.cfm","login.cfm","signup.cfm"];
            pageName = listLast(arguments.targetPage,"/");

            if (arrayFind(publicPages, pageName)) {
                cfinclude(template=arguments.targetPage);
                return;
            }

            // Protect dashboard pages
            if (findNoCase("dashboard", targetPage) and (not structKeyExists(session,"isLoggedIn") or not session.isLoggedIn)) {
                location("/views/auth/login.cfm");
            }

            // Include requested page
            cfinclude(template=arguments.targetPage);

        } catch(any e) {
            sessionInvalidate();
            cfinclude(template="/views/auth/login.cfm");
        }
    }

    function onError(exception, eventName) {
        if (structKeyExists(cgi,"path_info") and left(cgi.path_info,5) eq "/api/") {
            writeOutput(serializeJSON({status="error", message=exception.message}));
        } else {
            writeOutput("<h3>Oops! Something went wrong.</h3>");
            writeDump(var=exception);
        }
    }
}
