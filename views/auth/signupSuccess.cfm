<cfinclude template="/views/layout/header.cfm">

<section class="auth-section">
    <div class="auth-container">
        <cfoutput>
            <div class="success-message">#successMessage#</div>
        </cfoutput>
        <script>
            setTimeout(function(){
                window.location.href = "/views/auth/login.cfm";
            }, 3000);
        </script>
    </div>
</section>

<cfinclude template="/views/layout/footer.cfm">
