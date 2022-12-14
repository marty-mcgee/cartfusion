


<cfif session.CustomerArray[26] EQ ''>
	<cflocation url="CartEdit.cfm" addtoken="no">
</cfif>


<cfoutput>

<cfscript>
	getStates = application.Queries.getStates();
	getCountries = application.Queries.getCountries();
</cfscript>

<script type="text/javascript" language="JavaScript">
	function copyshipping(theForm)
	{
		theForm.shippingFirstName.value = theForm.FirstName.value;
		theForm.shippingLastName.value = theForm.LastName.value;
		theForm.shippingCompanyName.value = theForm.CompanyName.value;
		theForm.shippingAddress1.value = theForm.Address1.value;
		theForm.shippingAddress2.value = theForm.Address2.value;
		theForm.shippingCity.value = theForm.City.value;
		theForm.shippingState.selectedIndex = theForm.State.selectedIndex;
		theForm.shippingZip.value = theForm.Zip.value;
		theForm.shippingCountry.selectedIndex = theForm.Country.selectedIndex;
		theForm.shippingPhone.value = theForm.Phone.value;
		return (true);
	}
</script>

<cfparam name="ErrorBilling" default="0">

<cfmodule template="templates/#application.SiteTemplate#/layout.cfm" currenttab="MyAccount" layoutstyle="Full" pagetitle="Check Out - Step 1 of 4" showcategories="false">

<!--- Start Breadcrumb --->
<cfmodule template="tags/breadCrumbs.cfm" crumblevel='2' showlinkcrumb="<a href=cartedit.cfm>Cart</a> | Check Out - Step 1 of 4" />
<!--- End BreadCrumb --->



<!---<div align="right"><img src="images/image-CheckoutProcess1.gif" border="0" hspace="3" align="absmiddle"></div>--->



<div id="formContainer">
	<cfform method="post" action="CO-Options.cfm" name="OrderForm">
	
	<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="2">
				
<!--- CARTFUSION 4.5 - MULTIPLE SHIPPING ADDRESSES --->	
	<cfif application.EnableMultiShip EQ 1 >
		<!--- INVOKE INSTANCE OF OBJECT - GET CART ITEMS --->
		<!--- CARTFUSION 4.6 - CART CFC --->
		<cfscript>
			if ( TRIM(session.CustomerArray[28]) NEQ '' ) {
				UserID = session.CustomerArray[28] ;
			} else {
				UserID = 1 ;
			}
			getCartItems = application.Cart.getCartItems(UserID=UserID,SiteID=application.SiteID,SessionID=SessionID) ;
		</cfscript>
		<cfif not getCartItems.data.RecordCount >
			<cflocation url="CartEdit.cfm" addtoken="no">
		</cfif>
		<cfquery name="getDistinctAddresses" dbtype="query">
			SELECT 	DISTINCT ShippingID
			FROM	getCartItems.data
		</cfquery>
		
<cfif getDistinctAddresses.RecordCount >
	<table width="100%">

		<!---<tr>
			<td width="100%" colspan="2" class="cfDefault" style="padding:5px;" align="center">
				<b>Using Multiple Shipping Addresses</b>
				<hr class="snip" />
			</td>
		</tr>--->
		<cfloop query="getDistinctAddresses">
			
			<cfif ShippingID GT 0 >
				<cfquery name="getCustomerSH" datasource="#application.dsn#">
					SELECT	*
					FROM	CustomerSH
					WHERE	CustomerID = '#session.CustomerArray[17]#'
					AND		SHID = #ShippingID#
				</cfquery>
				<cfif getCustomerSH.RecordCount >
				<tr>
					<td width="100%" colspan="2">
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td width="50%" class="cfFormLabel" valign="top" align="right" style="padding-right:3px;">
									<cfquery name="getItemInfo" dbtype="query">
										SELECT 	ItemName, Qty <!---, ItemID, SKU, ImageDir, ImageSmall --->
										FROM	getCartItems.data
										WHERE	ShippingID = #ShippingID#
									</cfquery>
									<h5>Package #getDistinctAddresses.CurrentRow#</h5><br/>
									Shipping these items to #getCustomerSH.ShipNickName#:<br/>
									<cfloop query="getItemInfo">
										(#Qty#) <a href="CartEdit.cfm">#ItemName#</a><br/>
									</cfloop>
								</td>
								<td width="50%" valign="top" style="padding-left:3px;">
									<b>#getCustomerSH.ShipFirstName# #getCustomerSH.ShipLastName#</b><br/>
									<cfif getCustomerSH.ShipPhone NEQ '' >
									#getCustomerSH.ShipPhone#<br/>
									</cfif>
									<cfif getCustomerSH.ShipCompanyName NEQ '' >
									#getCustomerSH.ShipCompanyName#<br/>
									</cfif>
									#getCustomerSH.ShipAddress1#<br/>
									<cfif getCustomerSH.ShipAddress2 NEQ '' >
									#getCustomerSH.ShipAddress2#<br/>
									</cfif>
									#getCustomerSH.ShipCity#, #getCustomerSH.ShipState# #getCustomerSH.ShipZip# #getCustomerSH.ShipCountry#<br/>
									<a href="CartEdit.cfm">[change]</a><br/> 
								</td>
							</tr>
						</table>	
					</td>
				</tr>
				<tr>
					<td width="100%" colspan="2" class="cfDefault" style="padding:5px;">
						<hr class="snip" />
					</td>
				</tr>
				</cfif>
			<cfelse>
				<tr>
					<td width="100%" colspan="2">
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td width="50%" class="cfFormLabel" valign="top" align="right" style="padding-right:3px;">
									<cfquery name="getItemInfoMyself" dbtype="query">
										SELECT 	ItemName, Qty <!---, ItemID, SKU, ImageDir, ImageSmall --->
										FROM	getCartItems.data
										WHERE	ShippingID = #ShippingID#
									</cfquery>
									<h5>Package #getDistinctAddresses.CurrentRow#</h5><br/>
									Shipping these items to myself:<br/>
									<cfloop query="getItemInfoMyself">
										(#Qty#) <a href="CartEdit.cfm">#ItemName#</a><br/>
									</cfloop>
									<br/>
								</td>
								<td width="50%">&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td width="100%" colspan="2" class="cfDefault" style="padding:5px;">
						<hr class="snip" />
					</td>
				</tr>
			</cfif>
		</cfloop>
	</cfif>
	<!--- 
		NO shipping session variables set and NOT shipping anything to "myself",
		so set shipping FORM variables to 1st destination - next page will set
		shipping SESSION variables to these values
	--->
	<cfif  (session.CustomerArray[18] EQ '' OR
			session.CustomerArray[19] EQ '' OR
			session.CustomerArray[20] EQ '' OR
			session.CustomerArray[22] EQ '' OR
			session.CustomerArray[23] EQ '' OR
			session.CustomerArray[24] EQ '' OR
			session.CustomerArray[25] EQ '' ) AND
			NOT isDefined('getItemInfoMyself') AND isDefined('getCustomerSH') >				
		<cfinput type="hidden" name="shippingFirstName" value="#getCustomerSH.ShipFirstName#">
		<cfinput type="hidden" name="shippingLastName" value="#getCustomerSH.ShipLastName#">
		<cfinput type="hidden" name="shippingCompanyName" value="#getCustomerSH.ShipCompanyName#">
		<cfinput type="hidden" name="shippingAddress1" value="#getCustomerSH.ShipAddress1#">
		<cfinput type="hidden" name="shippingAddress2" value="#getCustomerSH.ShipAddress2#">
		<cfinput type="hidden" name="shippingCity" value="#getCustomerSH.ShipCity#">
		<cfinput type="hidden" name="shippingState" value="#getCustomerSH.ShipState#">
		<cfinput type="hidden" name="shippingZip" value="#getCustomerSH.ShipZip#">
		<cfinput type="hidden" name="shippingCountry" value="#getCustomerSH.ShipCountry#">
		<cfinput type="hidden" name="shippingPhone" value="#getCustomerSH.ShipPhone#">
	</cfif>
	</table>

<!--- Multiple Shipping Addresses Not Allowed --->
<cfelse>
	<table width="100%">
		<tr><td width="100%" colspan="2"></td></tr>
	</table>
</cfif>
<!--- CARTFUSION 4.5 - MULTIPLE SHIPPING ADDRESSES --->
				
				
				
			</td>
		</tr>
		<tr>
			<td width="50%">
				<cfif ErrorBilling EQ 1 >
					<div class="cfErrorMsg" align="center">Error</div>
				</cfif>
				
					<div class="formWrap1">
					
					<div class="req"><b>*</b> Indicates required field</div>
					
					<h3>Billing Information</h3>
					
						<!--- SPACE ---><fieldset><br/></fieldset>
							
						<fieldset>
					
							<label for="firstName"><b><span class="req">*</span>First name:</b>
								<cfinput type="text" name="FirstName" value="#session.CustomerArray[1]#" size="35" maxlength="25" required="yes" message="Required: First Name"><br/>
							</label>
							
							<label for="lastName"><b><span class="req">*</span>Last name:</b>
								<cfinput type="text" name="LastName" value="#session.CustomerArray[2]#" size="35" maxlength="35" required="yes" message="Required: Last Name"><br/>
							</label>
							
						</fieldset>
					
						<fieldset>
							
							<label for="companyName"><b>Company Name:</b>
								<cfinput type="text" name="CompanyName" value="#session.CustomerArray[12]#" size="35" maxlength="35"><br/>
							</label>
							
						</fieldset>
						
						<fieldset>
							
							<label for="BillingAddress1"><b><span class="req">*</span>Address 1:</b>
								<cfinput type="text" name="Address1" value="#session.CustomerArray[3]#" size="35" maxlength="35" required="yes" message="Required: Address Line 1"><br/>
							</label>
							
							<label for="BillingAddress2"><b>Address 2:</b>
								<cfinput type="text" name="Address2" value="#session.CustomerArray[4]#" size="35" maxlength="35" required="no"><br/>
							</label>
							
							<label for="BillingCity"><b><span class="req">*</span>City/AFO/FPO:</b>
								<cfinput type="text" name="City" value="#session.CustomerArray[5]#" size="35" maxlength="35" required="yes" message="Required: City"><br/>
							</label>
							
							<label for="billingState"><b><span class="req">*</span>State/Prov:</b>
								<cfselect name="State" size="1" query="GetStates" value="StateCode" display="State" required="yes" message="Required: Shipping State/Province"
									selected="#IIf(session.CustomerArray[6] EQ '', 'application.CompanyState', 'session.CustomerArray[6]')#" />
							</label>
							
							<label for="BillingZipCode"><b><span class="req">*</span>Zip/Post Code:</b>
								<cfinput type="text" name="Zip" value="#session.CustomerArray[7]#" size="10" maxlength="10" required="yes" message="Required: ZIP/Postal Code"><br/>
							</label>
							
							<label for="BillingCountry"><b><span class="req">*</span>Country:</b>
								<cfselect name="Country" query="GetCountries" value="CountryCode" display="Country" required="yes" message="Required: Shipping Country"
									selected="#IIf(session.CustomerArray[8] EQ '', 'application.BaseCountry', 'session.CustomerArray[8]')#" /><br/>
							</label>
							
						</fieldset>
						
						<fieldset>
							
							<label for="BillingPhone"><b><span class="req">*</span>Phone Number:</b>
								<cfinput type="text" name="Phone" value="#session.CustomerArray[9]#" size="35" maxlength="20" required="yes" message="Required: Phone Number">
							</label>
							
							<label for="BillingFax"><b>Fax Number:</b>
								<cfinput type="text" name="Fax" value="#session.CustomerArray[10]#" size="35" maxlength="20" required="no">
							</label>
							
							<label for="billingEmailAddress"><b><span class="req">*</span>E-Mail Address:</b>
								<cfinput type="text" name="Email" value="#session.CustomerArray[11]#" size="35" maxlength="40" required="yes" validate="regular_expression" 
									pattern="^[\w-]+(?:\.[\w-]+)*@(?:[\w-]+\.)+[a-zA-Z]{2,7}$" message="Please enter a valid email address (username@domain.com)"><br/>
							</label>
							
						</fieldset>
						
				</div>
			</td>
			
			<td width="50%" valign="top">
				
				<cfif ErrorBilling EQ 2 >
					<div class="cfErrorMsg" align="center">ERROR: Please enter all required (<b>underlined</b>) fields.</div>
				<cfelseif ErrorBilling EQ 3 >
					<div class="cfErrorMsg" align="center">We're sorry. We are not accepting orders shipping to this ZIP code at this time.</div>
				</cfif>
				
				<!--- CARTFUSION 4.5 - MULTIPLE SHIPPING ADDRESSES --->	
				<!--- <cfif application.EnableMultiShip EQ 1 > --->
					<!--- INVOKE INSTANCE OF OBJECT - GET CART ITEMS --->
					<!--- CARTFUSION 4.6 - CART CFC --->
					<cfscript>
						if ( TRIM(session.CustomerArray[28]) NEQ '' ) {
							UserID = session.CustomerArray[28] ;
						} else {
							UserID = 1 ;
						}
						getCartItems = application.Cart.getCartItems(UserID=UserID,SiteID=application.SiteID,SessionID=SessionID) ;
					</cfscript>
					<cfif not getCartItems.data.RecordCount >
						<cflocation url="CartEdit.cfm" addtoken="no">
					</cfif>
					<cfquery name="getDistinctAddresses" dbtype="query">
						SELECT 	DISTINCT ShippingID
						FROM	getCartItems.data
					</cfquery>
				
				<div class="formWrap1">
				
				<div class="req"><b>*</b> Indicates required field</div>
					
				<h3>Shipping Information</h3>
					
				<div onclick="copyshipping(OrderForm);" style="cursor:pointer; color:##277AE6;">&gt;&gt;&gt; COPY from billing address &gt;&gt;&gt;</div>
						
				<fieldset>
			
					<label for="shippingFirstName"><b><span class="req">*</span>First Name:</b>
						<cfinput type="text" name="shippingFirstName" value="#session.CustomerArray[18]#" size="35" maxlength="50" required="yes" message="Required: Shipping First Name"><br/>
					</label>
					
					<label for="shippingLastName"><b><span class="req">*</span>Last Name:</b>
						<cfinput type="text" name="shippingLastName" value="#session.CustomerArray[19]#" size="35" maxlength="50" required="yes" message="Required: Shipping Last Name"><br/>
					</label>
					
				</fieldset>
				
				<fieldset>
					
					<label for="shippingCompanyName"><b>Company Name:</b>
						<cfinput type="text" name="shippingCompanyName" value="#session.CustomerArray[34]#" size="35" maxlength="50" required="no"><br/>
					</label>
					
				</fieldset>
				
				<fieldset>
				
					<label for="shippingAddress1"><b><span class="req">*</span>Address 1:</b>
						<cfinput type="text" name="shippingAddress1" value="#session.CustomerArray[20]#" size="35" maxlength="50" required="yes" message="Required: Shipping Address Line 1"><br/>
					</label>
					
					<label for="shippingAddress2"><b>Address 2:</b>
						<cfinput type="text" name="shippingAddress2" value="#session.CustomerArray[21]#" size="35" maxlength="50" required="no"><br/>
					</label>
					
					<label for="shippingCity"><b><span class="req">*</span>City/AFO/FPO:</b>
						<cfinput type="text" name="shippingCity" value="#session.CustomerArray[22]#" size="35" maxlength="50" required="yes" message="Required: Shipping City"><br/>
					</label>
					
					<label for="shippingState"><b><span class="req">*</span>State/Prov:</b>
						<cfselect name="shippingState" query="GetStates" value="StateCode" display="State" required="yes" message="Required: Shipping State/Province"
							selected="#IIf(session.CustomerArray[23] EQ '', 'application.CompanyState', 'session.CustomerArray[23]')#" /><br/>
					</label>
					
					<label for="shippingZip"><b><span class="req">*</span>Zip/PostCode:</b>
						<cfinput type="text" name="shippingZip" value="#session.CustomerArray[24]#" size="10" maxlength="10" required="yes" message="Required: Shipping ZIP/Postal Code"><br/>
					</label>
					
					<label for="shippingCountry"><b><span class="req">*</span>Country:</b>		
						<cfselect name="shippingCountry" query="GetCountries" value="CountryCode" display="Country" required="yes" message="Required: Shipping Country"
							selected="#IIf(session.CustomerArray[25] EQ '', 'application.BaseCountry', 'session.CustomerArray[25]')#" /><br/>
					</label>
				
				</fieldset>
				
				<fieldset>
				
					<label for="shippingPhone"><b><span class="req">*</span>Phone Number:</b>
						<cfinput type="text" name="shippingPhone" value="#session.CustomerArray[35]#" size="35" maxlength="20" required="yes" message="Required: Shipping Phone Number"><br/>
					</label>
				
				</fieldset>
				
				<!--- SPACE ---><fieldset><br/></fieldset>
				
				<fieldset><b>Keep me informed with special offers and newsletters:</b><br/>
					<input type="radio" name="Notify" value="1" <cfif session.CustomerArray[30] EQ 1> checked </cfif> > Yes, please
					<input type="radio" name="Notify" value="0" <cfif session.CustomerArray[30] NEQ 1> checked </cfif>> No, thanks
				</fieldset>
					
				</div>
			</td>
		</tr>	
	</table>
	<br/>
		<div align="center"><input type="submit" name="Step2" value=" Proceed to Step 2 >>" class="button"></div>
	
	</cfform>
	
</div>

</cfmodule>

</cfoutput>

