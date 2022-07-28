<cfif session.CustomerArray[26] EQ ''>
	<cfinclude template="index.cfm">
	<cfabort>
</cfif>

<cfif structKeyExists(form, 'UpdateCustomer') AND structKeyExists(form, 'CustomerID')>
	<cfscript>
		if ( structKeyExists(form, 'EmailOK') )
			form.EmailOK = 1 ;
		else
			form.EmailOK = 0 ;	
		form.DateUpdated = #Now()# ;
		form.UpdatedBy = 'Customer' ;
		if ( form.Password neq '' ) 
			form.Password = encrypt(form.Password, application.siteConfig.data.CryptKey, "CFMX_COMPAT", "Hex") ;
	</cfscript>

	<cftry>
		<cfupdate datasource="#application.dsn#" tablename="Customers" 
            formfields="CustomerID, FirstName, LastName, CompanyName, Address1, Address2, City, State, Zip, Country, 
                        ShipFirstName, ShipLastName, ShipCompanyName, ShipAddress1, ShipAddress2, ShipCity, 
                        ShipState, ShipZip, ShipCountry, Phone, Fax, Email, EmailOK, DateUpdated, UpdatedBy, Password">
			<cfset ErrorMsg = 'Your account was updated successfully.'>
			<cfscript>
                session.CustomerArray[1]  = form.FirstName ;
                session.CustomerArray[2]  = form.LastName ;
                session.CustomerArray[3]  = form.Address1 ;
                session.CustomerArray[4]  = form.Address2 ;
                session.CustomerArray[5]  = form.City ;
                session.CustomerArray[6]  = form.State ;
                session.CustomerArray[7]  = form.Zip ;
                session.CustomerArray[8]  = form.Country ;
                session.CustomerArray[9]  = form.Phone ;
                session.CustomerArray[10] = form.Fax ;
                session.CustomerArray[11] = form.Email ;
                session.CustomerArray[12] = form.CompanyName ;					
                session.CustomerArray[18] = form.ShipFirstName ;
                session.CustomerArray[19] = form.ShipLastName ;
                session.CustomerArray[34] = form.ShipCompanyName ;
                session.CustomerArray[20] = form.ShipAddress1 ;
                session.CustomerArray[21] = form.ShipAddress2 ;
                session.CustomerArray[22] = form.ShipCity ;
                session.CustomerArray[23] = form.ShipState ;
                session.CustomerArray[24] = form.ShipZip ;
                session.CustomerArray[25] = form.ShipCountry ;
                session.CustomerArray[27] = form.Password ; // encrypted
                session.CustomerArray[30] = form.EmailOK ;
            </cfscript>
		<cfcatch>
			<cfset ErrorMsg = 'ERROR: Your account information has NOT been updated.'>
		</cfcatch>
	</cftry>
</cfif>

<cfoutput>

<cfmodule template="tags/layout.cfm" PageTitle="Customer Update" CurrentTab="MyAccount">

<!--- Start Breadcrumb --->
<cfmodule template="tags/breadCrumbs.cfm" CrumbLevel='2' showLinkCrumb="My Account|Customer Update" />
<!--- End BreadCrumb --->

<cfscript>
	getCustomer = application.Queries.getCustomer(CustomerID=session.CustomerArray[17]);
	getStates = application.Queries.getStates();
	getCountries = application.Queries.getCountries();

	if ( getCustomer.Password NEQ '' ) Decrypted_Password = DECRYPT(getCustomer.Password, application.siteConfig.data.CryptKey, "CFMX_COMPAT", "Hex") ;
	else Decrypted_Password = '' ;
</cfscript>

	<cfif isDefined("ErrorMsg")>
		<div class="cfErrorMsg">#ErrorMsg#</div>
		<br />		
	</cfif>

<div class="myaccount">
	<img src="images/icon-down.gif" align="absmiddle" /> &nbsp;My Profile
</div>

<br />

<cfloop query="getCustomer">
<div id="formContainer">
	<cfform action="#cgi.SCRIPT_NAME#" method="post">
	
	<table width="98%" align="center" border="0" cellpadding="3" cellspacing="0">
		<tr>
			<td width="50%" valign="top">
					<div class="f-wrap-1">
					
					<div class="req"><b>*</b> Indicates required field</div>
					
						<fieldset>
							<h3>Billing Information</h3>
					
							<label for="firstName"><b><span class="req">*</span>First name:</b>
								<cfinput type="text" name="FirstName" value="#FirstName#" size="35" maxlength="25" required="yes" message="Please enter your First Name"><br />
							</label>
							
							<label for="lastName"><b><span class="req">*</span>Last name:</b>
								<cfinput type="text" name="LastName" value="#LastName#" size="35" maxlength="35" required="yes" message="Please enter your Last Name"><br />
							</label>
							
							<label for="billingEmailAddress"><b><span class="req">*</span>E-Mail Address:</b>
								<cfinput type="text" name="Email" value="#Email#" size="35" maxlength="40" required="yes" validate="regular_expression" 
							pattern="^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,7}$" message="Please enter a valid email address (username@domain.com)"><br />
							</label>
							
						</fieldset>
						
						<fieldset>
							
							<label for="BillingAddress1"><b><span class="req">*</span>Address 1:</b>
								<cfinput type="text" name="Address1" value="#Address1#" size="35" maxlength="35" required="yes" message="Please enter your Address (line 1)"><br />
							</label>
							
							<label for="BillingAddress2"><b>Address 2:</b>
								<cfinput type="text" name="Address2" value="#Address2#" size="35" maxlength="35" required="no"><br />
							</label>
							
							<label for="BillingCity"><b><span class="req">*</span>City/AFO/FPO:</b>
								<cfinput type="text" name="City" value="#City#" size="35" maxlength="35" required="yes" message="Please enter your City"><br />
							</label>
							
							<label for="billingState"><b><span class="req">*</span>State/Prov:</b>
								<cfselect name="State" size="1" query="GetStates" value="StateCode" selected="#State#" display="State" required="Yes" /><br />
							</label>
							
							<label for="BillingZipCode"><b><span class="req">*</span>Zip/Post Code:</b>
								<cfinput type="text" name="Zip" value="#Zip#" size="10" maxlength="10" required="yes" message="Please enter your Zip or Postal Code"><br />
							</label>
							
							<label for="BillingCountry"><b><span class="req">*</span>Country:</b>
								<cfselect name="Country" size="1" query="GetCountries" value="CountryCode" display="Country" selected="#Country#" /><br />
							</label>
							
						</fieldset>
					
						<fieldset>
							
							<label for="conpanyName"><b>Company name:</b>
								<cfinput type="text" name="CompanyName" value="#CompanyName#" size="35" maxlength="35"><br />
							</label>
							
						</fieldset>
						
						<fieldset>
							
							<label for="BillingPhone"><b><span class="req">*</span>Phone Number:</b>
								<cfinput type="text" name="Phone" value="#Phone#" size="35" maxlength="20" required="yes" message="Please enter a valid phone number">
							</label>
							
							<label for="BillingFax"><b>Fax Number:</b>
								<cfinput type="text" name="Fax" value="#Fax#" size="35" maxlength="20" required="no">
							</label>
							
						</fieldset>
				</div>
			</td>
			
			<td width="50%" valign="top">
				
				<div class="f-wrap-1">
					<div class="req"><b>*</b> Indicates required field</div>
				
				<fieldset>
					<h3>Shipping Information</h3>
			
					<label for="shippingFirstName"><b><span class="req">*</span>First name:</b>
						<cfinput type="text" name="ShipFirstName" value="#ShipFirstName#" size="35" maxlength="50" required="yes" message="First Name is a required field"><br />
					</label>
					
					<label for="shippingLastName"><b><span class="req">*</span>Last name:</b>
						<cfinput type="text" name="ShipLastName" value="#ShipLastName#" size="35" maxlength="50" required="yes" message="Last Name is a required field"><br />
					</label>
					
				</fieldset>
				
				<fieldset>
				
					<label for="shippingAddress1"><b><span class="req">*</span>Address 1:</b>
						<cfinput type="text" name="ShipAddress1" value="#ShipAddress1#" size="35" maxlength="50" required="yes" message="Address (line 1) is a required field"><br />
					</label>
					
					<label for="shippingAddress2"><b>Address 1:</b>
						<cfinput type="text" name="ShipAddress2" value="#ShipAddress2#" size="35" maxlength="50" required="no"><br />
					</label>
					
					<label for="shippingCity"><b><span class="req">*</span>City/AFO/FPO:</b>
						<cfinput type="text" name="ShipCity" value="#ShipCity#" size="35" maxlength="50" required="yes" message="City is a required field"><br />
					</label>
					
					<label for="shippingState"><b><span class="req">*</span>State/Prov:</b>
						<cfselect name="ShipState" size="1" query="GetStates" value="StateCode" selected="#ShipState#" display="State" required="Yes" >
						</cfselect><br />
					</label>
					
					<label for="shippingZip"><b><span class="req">*</span>Zip/PostCode:</b>
						<cfinput type="text" name="ShipZip" value="#ShipZip#" size="10" maxlength="10" required="yes" message="Zip or Postal Code is a required field"><br />
					</label>
					
					<label for="shippingCountry"><b><span class="req">*</span>Country:</b>
						<cfselect name="ShipCountry" size="1" query="GetCountries" value="CountryCode" display="Country" selected="#ShipCountry#" required="Yes" /><br />
					</label>
				
				</fieldset>
				
				<fieldset>
					
					<label for="shippingCompanyName"><b>Company Name:</b>
						<cfinput type="text" name="ShipCompanyName" value="#ShipCompanyName#" size="35" maxlength="50" required="no"><br />
					</label>
					
				</fieldset>
				
				<fieldset>
				
					<label for="UserName"><b>Username:</b>
						#Username#<br />
					</label>
					
					<label for="password"><b><span class="req">*</span>Password:</b>
						<cfinput type="password" name="Password" value="#decrypted_Password#" size="25" class="cfFormField">
					</label>
					
					<label for="notify"><b>Notify Me:</b>
						<input type="checkbox" name="EmailOK" <cfif EmailOK EQ 1> checked </cfif> ><br />
					</label>
				
				</fieldset>
				
				</div>
			</td>
		</tr>	
	</table>
	<br />
		<div align="center"><input type="submit" name="UpdateCustomer" value="Update" class="button" style="width:200px;"></div>
		<input type="hidden" name="CustomerID" value="#CustomerID#">
	
	</cfform>
	
</div>

	<br class="clear" />

</cfloop>

<div align="center">
	<hr class="snip" />
	<br />
	<a href="CA-CustomerArea.cfm?show3=1"><img src="images/button-Back.gif"></a>&nbsp;&nbsp;
	<a href="CA-CustomerArea.cfm?show3=1"><img src="images/button-Home.gif"></a>	
</div>

</cfmodule>

</cfoutput>
