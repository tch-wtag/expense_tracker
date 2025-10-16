
<cfscript>
    // Create a Java class reference from the external JAR
    StringUtils = createObject("java", "org.apache.commons.lang3.StringUtils");

    // Test some of its static methods
    isNum = StringUtils.isNumeric("12345");
    isAlpha = StringUtils.isAlpha("CFML");
    reversed = StringUtils.reverse("ColdFusion");
    upper = StringUtils.upperCase("cfml + java");

    // Output results
    writeOutput("<h2>Java Integration Test</h2>");
    writeOutput("<p>Is 12345 numeric? #isNum#</p>");
    writeOutput("<p>Is 'CFML' alphabetic? #isAlpha#</p>");
    writeOutput("<p>Reverse of 'ColdFusion': #reversed#</p>");
    writeOutput("<p>Uppercase: #upper#</p>");
</cfscript>
