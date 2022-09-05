<!--- 
|| LEGAL ||
$CartFusion - Copyright � 2001-2007 Trade Studios, LLC.$
$This copyright notice MUST stay intact for use (see license.txt).$
$It is against the law to copy, distribute, gift, bundle or give away this code$
$without written consent from Trade Studios, LLC.$

|| VERSION CONTROL ||
$Id: $
$Date: $
$Revision: $

|| DESCRIPTION || 
$Description: $
$TODO: $

|| DEVELOPER ||
$Developer: Trade Studios, LLC (webmaster@tradestudios.com)$

|| SUPPORT ||
$Support Email: support@tradestudios.com$
$Support Website: http://support.tradestudios.com$

|| ATTRIBUTES ||
$in: $
$out:$
--->

<cfcomponent displayname="Common Functions Module" hint="This component handles common function calls from a CartFusion site.">
	
	<cfscript>
		variables.dsn = "";
	</cfscript>
	
	<cffunction name="init" returntype="Common" output="false">
		<cfargument name="dsn" required="true">
	
		<cfscript>
			variables.dsn = arguments.dsn;
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	
	<!--- 
		GET ALL PRODUCTS
		Used in: ProductList.cfm
	--->
	<cffunction name="getAllProducts" displayname="Get All Products" hint="Function to retrieve all products information." access="public" returntype="query">
		<cfargument name="UserID" displayname="UserID" hint="The Price and Hide Columns of the Products to get, depending on User" type="numeric" required="yes">
		<cfargument name="SiteID" displayname="SiteID" hint="The CartFusion Site ID of the Products to get" type="numeric" required="yes">
		<cfargument name="CatDisplay" displayname="CatDisplay" hint="Category chosen by visitor" required="no">
		<cfargument name="SecDisplay" displayname="SecDisplay" hint="Section chosen by visitor" required="no">
		<cfargument name="CatFilter" displayname="CatFilter" hint="Category to filter Section by" required="no">
		<cfargument name="SecFilter" displayname="SecFilter" hint="Section to filter Category by" required="no">
		<cfargument name="SMC" displayname="Show Me These Categories" hint="Shows only the selected categories by visitor" required="no">
		<cfargument name="SMS" displayname="Show Me These Sections" hint="Shows only the selected sections by visitor" required="no">
		<cfargument name="SortOption" displayname="Sort By This Cat/Sec" hint="Sorts query results by selected category/section" type="string" required="no">
		<cfargument name="SortAscending" displayname="Sort Ascending" hint="Sorts query results ascending or descending" type="numeric" required="no">
		
		<cfscript>
			var getProducts = "";
		</cfscript>
		
		<cfquery name="getProducts" datasource="#variables.dsn#">
			SELECT 	ItemID, SKU, ItemName, ItemDescription, Category, SectionID, Attribute1, Attribute2, Attribute3, 
					Price#arguments.UserID#, ItemStatus, ImageSmall, ImageDir, CompareType, SellByStock, StockQuantity
			FROM 	Products
			WHERE	(Hide#arguments.UserID# = 0 OR Hide#arguments.UserID# IS NULL)
			AND		(Deleted = 0 OR Deleted IS NULL)
			AND		SiteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SiteID#" null="no">
			
			<!--- DISPLAY --->
			<cfif isDefined('arguments.CatDisplay') AND arguments.CatDisplay NEQ ''>
				AND 	(Category = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CatDisplay#" null="no">
				OR 		OtherCategories LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#arguments.CatDisplay#,%">)
			<cfelseif isDefined('arguments.SecDisplay') AND arguments.SecDisplay NEQ ''>
				AND 	(SectionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SecDisplay#" null="no">
				OR 		OtherSections LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#arguments.SecDisplay#,%">)
			</cfif>
			
			<!--- FILTER --->
			<cfif isDefined('arguments.CatFilter') AND arguments.CatFilter NEQ ''>
				AND 	(Category = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CatFilter#" null="no">
				OR 		OtherCategories LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#arguments.CatFilter#,%">)
			<cfelseif isDefined('arguments.SecFilter') AND arguments.SecFilter NEQ ''>
				AND 	(SectionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SecFilter#" null="no">
				OR 		OtherSections LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#arguments.SecFilter#,%">)
			</cfif>
				
			<!--- SHOW ME --->
			<cfif isDefined('arguments.SMC') AND arguments.SMC NEQ ''>
				AND ((
					<cfloop index="i" list="#arguments.SMC#" delimiters="," >
						Category = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> <cfif i NEQ ListLast(arguments.SMC)> OR </cfif>
					</cfloop> )
				OR (
					<cfloop index="i" list="#arguments.SMC#" delimiters="," >
						OtherCategories LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#i#,%"> <cfif i NEQ ListLast(arguments.SMC)> OR </cfif>
					</cfloop> ))
			<cfelseif isDefined('arguments.SMS') AND arguments.SMS NEQ ''>
				AND ((
					<cfloop index="i" list="#arguments.SMS#" delimiters="," >
						SectionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> <cfif i NEQ ListLast(arguments.SMS)> OR </cfif>
					</cfloop> )
				OR (
					<cfloop index="i" list="#arguments.SMS#" delimiters="," >
						OtherSections LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#i#,%"> <cfif i NEQ ListLast(arguments.SMS)> OR </cfif>
					</cfloop> ))
			</cfif>
			
			ORDER BY 
			<cfif isDefined('arguments.SortOption')> DisplayOrder, #arguments.SortOption# <cfelse> Category, DisplayOrder, SKU </cfif>
			<cfif isDefined('arguments.SortAscending') AND arguments.SortAscending EQ 1 > ASC <cfelse> DESC </cfif>
		</cfquery>
		
		<cfreturn getProducts>
	</cffunction>
	
	
	<!--- 
		GET PRODUCT DETAIL
		Used in: ProductDetail.cfm
	--->
	<cffunction name="getProductDetail" displayname="Get Product Detail" hint="Function to retrieve specific product information." access="public" returntype="query">
		<cfargument name="ItemID" displayname="Product ID" hint="The ID of the Product to get" type="numeric" required="yes">
		
		<cfscript>
			var getProductDetail = "";
		</cfscript>
		
		<cfquery name="getProductDetail" datasource="#variables.dsn#">
			SELECT	*
			FROM	Products
			WHERE	ItemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ItemID#">
			AND		(Deleted = 0 OR Deleted IS NULL)
		</cfquery>
		
		<cfreturn getProductDetail>
	</cffunction>
	
	
	<!--- 
		GET ALL CATEGORIES
		Used in: CategoryList.cfm
	--->
	<cffunction name="getCategories" displayname="Get All Categories" hint="Function to retrieve all category information." access="public" returntype="query">
		<cfargument name="UserID" displayname="UserID" hint="The Price and Hide Columns of the Categories to get, depending on User" type="numeric" required="yes">
		<cfargument name="SiteID" displayname="SiteID" hint="The CartFusion Site ID of the Categories to get" type="numeric" required="yes">
		<cfargument name="PCID" displayname="Parent Category ID" hint="The Parent Category ID of the Category to get" type="numeric" required="no">
		<cfargument name="CatID" displayname="Category ID" hint="The Category ID of the Category to retrieve sub-categories of" type="string" required="no">
		<cfargument name="OnlyMainCategories" displayname="Get Main Categories" hint="Only retrieve categories with no sub-categories, i.e., Main Categories" type="string" required="no">
		
		<cfscript>
			var getCategories = "";
		</cfscript>
		
		<cfquery name="getCategories" datasource="#variables.dsn#">
			SELECT 		* 
			FROM 		Categories
			WHERE		(Hide#arguments.UserID# = 0 OR Hide#arguments.UserID# IS NULL)
			AND			SiteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SiteID#">
			<cfif StructKeyExists(arguments,'CatID') AND arguments.CatID NEQ ''>
			AND			subCategoryOf = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CatID#" null="no">
			</cfif>
			<cfif StructKeyExists(arguments,'OnlyMainCategories') AND arguments.OnlyMainCategories NEQ ''>
			AND			(subCategoryOf = 0 OR subCategoryOf IS NULL)
			</cfif>
			ORDER BY 	DisplayOrder, CatName
		</cfquery>

		<cfreturn getCategories>
	</cffunction>
	

	<!--- 
		GET CATEGORY DETAIL
		Used in: ProductList.cfm
	--->
	<cffunction name="getCategoryDetail" displayname="Get Category Detail" hint="Function to retrieve specific category information." access="public" returntype="query">
		<cfargument name="CatID" displayname="Category ID" hint="The ID of the Category to get" type="numeric" required="yes">
	
		<cfscript>
			// Added by Carl Vanderpal 13 June 2007
			var getCategory = "";
		</cfscript>
		
		<cfquery name="getCategory" datasource="#variables.dsn#">
			SELECT	*
			FROM	Categories
			WHERE	CatID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CatID#">
		</cfquery>
		
		<cfreturn getCategory>
	</cffunction>
	
	<!--- Added By Carl Vanderpal --->
	<cffunction name="getFeaturedCategories" access="public">
		<cfargument name="SiteID" required="true">
	
	
		<cfscript>
			var getFeaturedCategories = "";
		</cfscript>
	
		<cfquery name="getFeaturedCategories" datasource="#variables.dsn#">
			SELECT	CatID, CatName, CatDescription, CatFeaturedID, CatFeaturedDir
			FROM	Categories
			WHERE	Featured = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			AND		SiteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SiteID#">
			ORDER BY DisplayOrder
		</cfquery>
	
		<cfreturn getFeaturedCategories>
	</cffunction>
	
	
	<!--- 
		GET ALL SECTIONS
		Used in: SectionList.cfm
	--->
	<cffunction name="getSections" displayname="Get All Sections" hint="Function to retrieve all section information." access="public" returntype="query">
		<cfargument name="UserID" displayname="UserID" hint="The Price and Hide Columns of the Sections to get, depending on User" type="numeric" required="yes">
		<cfargument name="SiteID" displayname="SiteID" hint="The CartFusion Site ID of the Sections to get" type="numeric" required="yes">
		<cfargument name="PSID" displayname="Parent Section ID" hint="The Parent Section ID of the Section to get" type="numeric" required="no">
		<cfargument name="SectionID" displayname="Section ID" hint="The Section ID of the Section to retrieve sub-Sections of" type="string" required="no">
		<cfargument name="OnlyMainSections" displayname="Get Main Sections" hint="Only retrieve Sections with no sub-Sections, i.e., Main Sections" type="string" required="no">
		
		<cfscript>
			var getSections = "";
		</cfscript>
		
		<cfquery name="getSections" datasource="#variables.dsn#">
			SELECT 		* 
			FROM 		Sections
			WHERE		(Hide#arguments.UserID# = 0 OR Hide#arguments.UserID# IS NULL)
			AND			SiteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SiteID#">
			<cfif StructKeyExists(arguments,'SectionID') AND arguments.SectionID NEQ ''>
			AND			subSectionOf = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SectionID#" null="no">
			</cfif>
			<cfif StructKeyExists(arguments,'OnlyMainSections') AND arguments.OnlyMainSections NEQ ''>
			AND			(subSectionOf = 0 OR subSectionOf IS NULL)
			</cfif>
			ORDER BY 	DisplayOrder, SecName
		</cfquery>

		<cfreturn getSections>
	</cffunction>
	
	
	<!--- 
		GET SECTION DETAIL
		Used in: ProductList.cfm
	--->
	<cffunction name="getSectionDetail" displayname="Get Section Detail" hint="Function to retrieve specific Section information." access="public" returntype="query">
		<cfargument name="SectionID" displayname="Section ID" hint="The ID of the Section to get" type="numeric" required="yes">
		
		<cfscript>
			var getSection = "";
		</cfscript>
		
		<cfquery name="getSection" datasource="#variables.dsn#">
			SELECT	*
			FROM	Sections
			WHERE	SectionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SectionID#">
		</cfquery>
		
		<cfreturn getSection>
	</cffunction>
	
	<!--- Added by Carl Vanderpal 24 May 2007 --->
	<cffunction name="getFeaturedSections" access="public">
		<cfargument name="SiteID" required="true">
		
		<cfscript>
			var getFeaturedSections = "";
		</cfscript>
		
		<cfquery name="getFeaturedSections" datasource="#variables.dsn#">
			SELECT	SectionID, SecName, SecDescription, SecFeaturedID, SecFeaturedDir
			FROM	Sections
			WHERE	Featured = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			AND		SiteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SiteID#">
			ORDER BY DisplayOrder
		</cfquery>
	
		<cfreturn getFeaturedSections>
	</cffunction>
	
	<!--- 
		GET CATEGORIES SELECTED
		Used in: ProductList.cfm
	--->
	<cffunction name="getTheseCategories" displayname="Get These Categories" hint="Function to retrieve selected list of Categories." access="public" returntype="query">
		<cfargument name="SMC" displayname="Show Me These Categories" hint="The IDs of the Categories to get" type="string" required="yes">
		
		<cfscript>
			var getCategory = "";
		</cfscript>
		
		<cfquery name="getCategory" datasource="#variables.dsn#">
			SELECT	*
			FROM	Categories
			WHERE	
			<cfloop index="i" list="#arguments.SMC#" delimiters="," >
				CatID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> <cfif i NEQ ListLast(arguments.SMC)> OR </cfif>
			</cfloop>
		</cfquery>
		
		<cfreturn getCategory>		
	</cffunction>
	
	
	<!--- 
		GET SECTIONS SELECTED
		Used in: ProductList.cfm
	--->
	<cffunction name="getTheseSections" displayname="Get These Sections" hint="Function to retrieve selected list of Sections." access="public" returntype="query">
		<cfargument name="SMS" displayname="Show Me These Sections" hint="The IDs of the Sections to get" type="string" required="yes">
		
		<cfscript>
			var getSection = "";
		</cfscript>
		
		<cfquery name="getSection" datasource="#variables.dsn#">
			SELECT	*
			FROM	Sections
			WHERE	
			<cfloop index="i" list="#arguments.SMS#" delimiters="," >
				SectionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> <cfif i NEQ ListLast(arguments.SMS)> OR </cfif>
			</cfloop>
		</cfquery>
		
		<cfreturn getSection>		
	</cffunction>
	
	
	<!--- 
		GET RELATED ITEMS
		Used in: Includes/ProductRelated.cfm
	--->
	<cffunction name="getRelatedItems" displayname="Get Product Related Items" hint="Function to retrieve all related items of a product." access="public" returntype="query">
		<cfargument name="UserID" displayname="UserID" hint="The Price and Hide Columns of the Products to get, depending on User" type="numeric" required="yes">
		<cfargument name="ItemID" displayname="Product ID" hint="The ID of the Product the related items refer to" type="numeric" required="yes">
		
		<cfscript>
			var relatedList = "";
		</cfscript>
		
		<cfquery name="relatedList" datasource="#variables.dsn#">
			SELECT 	p.ItemID, p.SKU, p.ItemName, p.ShortDescription, p.Category, p.Attribute1, p.Attribute2, p.Attribute3, 
					p.Price#arguments.UserID#, p.ItemStatus, p.ImageSmall, p.ImageDir, p.SellByStock, p.StockQuantity,
					ri.RelatedItemID 
			FROM 	Products p, RelatedItems ri
			WHERE 	(ri.ItemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ItemID#">
			AND		p.ItemID = ri.RelatedItemID)
			OR		(ri.ItemID = p.ItemID
			AND		ri.RelatedItemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ItemID#">)
			AND		(p.Hide#arguments.UserID# = 0 OR p.Hide#arguments.UserID# IS NULL)
			ORDER BY p.ItemName
		</cfquery>
		
		<cfreturn relatedList>		
	</cffunction>
	
	
	
<!--- CART & WISHLIST FUNCTIONS --->

	<!--- 
		GET CART ITEM(S)
		Used in: WishEdit.cfm, CartUpdate.cfm, WishToCart.cfm, WishUpdate.cfm
	--->
	<cffunction name="getCart" displayname="Get Items in Customer Cart" hint="Function to retrieve all items in customer's Cart." access="public" returntype="query">
		<cfargument name="SessionID" displayname="SessionID" hint="SessionID related to Cart" type="string" required="yes">
		<cfargument name="SiteID" displayname="SiteID" hint="The CartFusion Site ID of the Products to get" type="numeric" required="yes">
		<cfargument name="ItemID" displayname="Product ID" hint="The ID of the Product in the Cart" type="numeric" required="no">
		<cfargument name="OptionName1" displayname="Option Name 1" hint="Product option value 1 in Cart" type="string" required="no">
		<cfargument name="OptionName2" displayname="Option Name 2" hint="Product option value 2 in Cart" type="string" required="no">
		<cfargument name="OptionName3" displayname="Option Name 3" hint="Product option value 3 in Cart" type="string" required="no">
		
		<cfscript>
			var getCart = "";
		</cfscript>
		
		<cfquery name="getCart" datasource="#variables.dsn#">
			SELECT 	c.CartItemID, c.CustomerID, c.SessionID, c.ItemID, c.Qty, c.OptionName1, c.OptionName2, c.OptionName3,
					c.DateEntered, c.AffiliateID, c.BackOrdered, c.SiteID,
					p.SKU, p.ItemName, p.Price#session.CustomerArray[28]#, p.Weight
			FROM 	Cart c, Products p
			WHERE 	c.ItemID = p.ItemID
			AND 	c.SessionID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SessionID#">
			AND		c.SiteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SiteID#">
			<cfif isDefined("arguments.ItemID") AND arguments.ItemID NEQ ''>
			AND		c.ItemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ItemID#">
			</cfif>
			<cfif isDefined("arguments.OptionName1") AND arguments.OptionName1 NEQ ''>
			AND 	c.OptionName1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName1#">
			</cfif>
			<cfif isDefined("arguments.OptionName2") AND arguments.OptionName2 NEQ ''>
			AND 	c.OptionName2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName2#">
			</cfif>
			<cfif isDefined("arguments.OptionName3") AND arguments.OptionName3 NEQ ''>
			AND 	c.OptionName3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName3#">
			</cfif>
			ORDER BY p.SKU
		</cfquery>
		
		<cfreturn getCart>		
	</cffunction>
	
	
	<!--- 
		INSERT INTO CART
		Used in: CartUpdate.cfm, WishUpdate.cfm
	--->
	<cffunction name="insertCart" displayname="Update Items in Cart" hint="Function to update items in customer's Cart." access="public">
		<cfargument name="SessionID" displayname="SessionID" hint="SessionID related to Cart" type="string" required="yes">
		<cfargument name="CustomerID" displayname="Customer ID" hint="Customer ID related to Cart" type="string" required="no">
		<cfargument name="SiteID" displayname="SiteID" hint="The CartFusion Site ID of the Products to update" type="numeric" required="yes">
		<cfargument name="Quantity" displayname="Quantity" hint="The Quantity of Products to update" type="numeric" required="yes">
		<cfargument name="ItemID" displayname="ItemID" hint="The Item ID of the item in the Cart to update" type="numeric" required="no">
		<cfargument name="BackOrdered" displayname="Item is Backordered" hint="Cart keeps track if item is backordered" type="numeric" required="no">
		<cfargument name="OptionName1" displayname="Option Name 1" hint="Product option value 1 in Cart" type="string" required="no">
		<cfargument name="OptionName2" displayname="Option Name 2" hint="Product option value 2 in Cart" type="string" required="no">
		<cfargument name="OptionName3" displayname="Option Name 3" hint="Product option value 3 in Cart" type="string" required="no">
		
		<cfscript>
			var insertCart = "";
		</cfscript>
		
		<cfquery name="insertCart" datasource="#variables.dsn#">
			INSERT INTO Cart 
			(	
				SessionID, 
				Qty, 
				ItemID,
				SiteID
				<cfif isDefined("arguments.CustomerID") AND arguments.CustomerID NEQ ''>, CustomerID</cfif>
				<cfif isDefined("arguments.OptionName1") AND arguments.OptionName1 NEQ ''>, OptionName1</cfif>
				<cfif isDefined("arguments.OptionName2") AND arguments.OptionName2 NEQ ''>, OptionName2</cfif>
				<cfif isDefined("arguments.OptionName3") AND arguments.OptionName3 NEQ ''>, OptionName3</cfif>
				<cfif isDefined("arguments.Backordered") AND arguments.Backordered NEQ ''>, BackOrdered</cfif>
			) 
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SessionID#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Quantity#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ItemID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SiteID#">
				<cfif isDefined("arguments.CustomerID") AND arguments.CustomerID NEQ ''>, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CustomerID#"></cfif>
				<cfif isDefined("arguments.OptionName1") AND arguments.OptionName1 NEQ ''>, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName1#"></cfif>
				<cfif isDefined("arguments.OptionName2") AND arguments.OptionName2 NEQ ''>, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName2#"></cfif>
				<cfif isDefined("arguments.OptionName3") AND arguments.OptionName3 NEQ ''>, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName3#"></cfif>
				<cfif isDefined("arguments.Backordered") AND arguments.Backordered NEQ ''>,  <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.Backordered#"></cfif>
			)
		</cfquery>
	
	</cffunction>
	
	
	<!--- 
		UPDATE CUSTOMER CART
		Used in: CartUpdate.cfm
	--->
	<cffunction name="updateCart" displayname="Update Items in Cart" hint="Function to update items in customer's Cart." access="public">
		<cfargument name="SiteID" displayname="SiteID" hint="The CartFusion Site ID of the Products to update" type="numeric" required="yes">
		<cfargument name="Quantity" displayname="Quantity" hint="The Quantity of Products to update" type="numeric" required="yes">
		<cfargument name="ItemID" displayname="ItemID" hint="The Item ID of the item in the Cart to update" type="numeric" required="no">
		<cfargument name="CartItemID" displayname="Cart Item ID" hint="Unique Cart Item ID in Cart" type="numeric" required="no">
		<cfargument name="CustomerID" displayname="Customer ID" hint="Customer ID related to Cart" type="string" required="no">
		<cfargument name="OptionName1" displayname="Option Name 1" hint="Product option value 1 in Cart" type="string" required="no">
		<cfargument name="OptionName2" displayname="Option Name 2" hint="Product option value 2 in Cart" type="string" required="no">
		<cfargument name="OptionName3" displayname="Option Name 3" hint="Product option value 3 in Cart" type="string" required="no">
		
		<cfscript>
			var updateCart = "";
		</cfscript>
		
		<cfquery name="updateCart" datasource="#variables.dsn#">
			UPDATE 	Cart
			SET		Qty = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Quantity#">
			<cfif isDefined("arguments.CustomerID") AND arguments.CustomerID NEQ ''>
					, CustomerID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CustomerID#">
			</cfif>
			<cfif isDefined("arguments.ItemID") AND arguments.ItemID NEQ ''>		
					, ItemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ItemID#">
			</cfif>
			WHERE 	SessionID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SessionID#">
			<cfif isDefined("arguments.CustomerID") AND arguments.CustomerID NEQ ''>
			AND 	CustomerID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CustomerID#">
			</cfif>
			<cfif isDefined("arguments.ItemID") AND arguments.ItemID NEQ ''>
			AND 	ItemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ItemID#">
			</cfif>
			<cfif isDefined("arguments.CartItemID") AND arguments.CartItemID NEQ ''>
			AND 	CartItemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CartItemID#">
			</cfif>			
			<cfif isDefined("arguments.OptionName1") AND arguments.OptionName1 NEQ ''>
			AND 	OptionName1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName1#">
			</cfif>
			<cfif isDefined("arguments.OptionName2") AND arguments.OptionName2 NEQ ''>
			AND 	OptionName2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName2#">
			</cfif>
			<cfif isDefined("arguments.OptionName3") AND arguments.OptionName3 NEQ ''>
			AND 	OptionName3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName3#">
			</cfif>				
		</cfquery>	
	
	</cffunction>
	
	
	<!--- 
		DELETE CART ITEM
		Used in: CartUpdate.cfm
	--->
	<cffunction name="deleteCart" displayname="Delete Items in Customer Cart" hint="Function to delete all items in customer's cart." access="public">
		<cfargument name="SessionID" displayname="SessionID" hint="SessionID related to Cart" type="string" required="yes">
		<cfargument name="SiteID" displayname="SiteID" hint="The CartFusion Site ID of the Products to delete" type="numeric" required="yes">
		<cfargument name="ItemID" displayname="ItemID" hint="The ItemID of the item in the Cart to delete" type="numeric" required="no">
		<cfargument name="OptionName1" displayname="Option Name 1" hint="Product option value 1 in Cart" type="string" required="no">
		<cfargument name="OptionName2" displayname="Option Name 2" hint="Product option value 2 in Cart" type="string" required="no">
		<cfargument name="OptionName3" displayname="Option Name 3" hint="Product option value 3 in Cart" type="string" required="no">
		
		<cfscript>
			var cleanCart = "";
		</cfscript>
		
		<cfquery name="cleanCart" datasource="#variables.dsn#">
			DELETE 
			FROM 	Cart
			WHERE 	SessionID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SessionID#">
			<cfif isDefined("arguments.ItemID") AND arguments.ItemID NEQ ''>
			AND 	ItemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ItemID#">
			</cfif>
			<cfif isDefined("arguments.OptionName1") AND arguments.OptionName1 NEQ ''>
			AND 	OptionName1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName1#">
			</cfif>
			<cfif isDefined("arguments.OptionName2") AND arguments.OptionName2 NEQ ''>
			AND 	OptionName2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName2#">
			</cfif>
			<cfif isDefined("arguments.OptionName3") AND arguments.OptionName3 NEQ ''>
			AND 	OptionName3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName3#">
			</cfif>		
		</cfquery>
	
	</cffunction>
	
	<!--- 
		GET CUSTOMER WISHLIST
		Used in: WishEdit.cfm, CartUpdate.cfm, WishToCart.cfm, WishUpdate.cfm
	--->
	<cffunction name="getCustomerWishList" displayname="Get Items in Customer Wishlist" hint="Function to retrieve all items in customer's wishlist." access="public" returntype="query">
		<cfargument name="CustomerID" displayname="Customer ID" hint="Customer ID related to wishlist" type="string" required="yes">
		<cfargument name="SiteID" displayname="SiteID" hint="The CartFusion Site ID of the Products to get" type="numeric" required="yes">
		<cfargument name="ItemID" displayname="Product ID" hint="The ID of the Product in the wishlist" type="numeric" required="no">
		<cfargument name="OptionName1" displayname="Option Name 1" hint="Product option value 1 in wishlist" type="string" required="no">
		<cfargument name="OptionName2" displayname="Option Name 2" hint="Product option value 2 in wishlist" type="string" required="no">
		<cfargument name="OptionName3" displayname="Option Name 3" hint="Product option value 3 in wishlist" type="string" required="no">
		
		<cfscript>
			var getWishList = "";
		</cfscript>
		
		<cfquery name="getWishList" datasource="#variables.dsn#">
			SELECT 	w.WishListItemID, w.CustomerID, w.SessionID, w.ItemID, w.Qty, w.OptionName1, w.OptionName2, w.OptionName3,
					w.DateEntered, w.AffiliateID, w.BackOrdered, w.SiteID,
					p.SKU, p.ItemName, p.Price#session.CustomerArray[28]#, p.Weight
			FROM 	Wishlist w, Products p
			WHERE 	w.ItemID = p.ItemID
			AND 	w.CustomerID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CustomerID#">
			AND		w.SiteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SiteID#">
			<cfif isDefined("arguments.ItemID") AND arguments.ItemID NEQ ''>
			AND		w.ItemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ItemID#">
			</cfif>
			<cfif isDefined("arguments.OptionName1") AND arguments.OptionName1 NEQ ''>
			AND 	w.OptionName1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName1#">
			</cfif>
			<cfif isDefined("arguments.OptionName2") AND arguments.OptionName2 NEQ ''>
			AND 	w.OptionName2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName2#">
			</cfif>
			<cfif isDefined("arguments.OptionName3") AND arguments.OptionName3 NEQ ''>
			AND 	w.OptionName3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName3#">
			</cfif>
			ORDER BY p.SKU
		</cfquery>
		
		<cfreturn getWishList>		
	</cffunction>
	
	<!--- 
		INSERT INTO CUSTOMER WISHLIST
		Used in: CartUpdate.cfm, WishUpdate.cfm
	--->
	<cffunction name="insertWishList" displayname="Update Items in Customer Wishlist" hint="Function to update items in customer's wishlist." access="public">
		<cfargument name="CustomerID" displayname="Customer ID" hint="Customer ID related to wishlist" type="string" required="yes">
		<cfargument name="SiteID" displayname="SiteID" hint="The CartFusion Site ID of the Products to update" type="numeric" required="yes">
		<cfargument name="Quantity" displayname="Quantity" hint="The Quantity of Products to update" type="numeric" required="yes">
		<cfargument name="ItemID" displayname="ItemID" hint="The Item ID of the item in the wishlist to update" type="numeric" required="no">
		<cfargument name="BackOrdered" displayname="Item is Backordered" hint="Wishlist keeps track if item is backordered" type="numeric" required="no">
		<cfargument name="OptionName1" displayname="Option Name 1" hint="Product option value 1 in wishlist" type="string" required="no">
		<cfargument name="OptionName2" displayname="Option Name 2" hint="Product option value 2 in wishlist" type="string" required="no">
		<cfargument name="OptionName3" displayname="Option Name 3" hint="Product option value 3 in wishlist" type="string" required="no">
		
		<cfscript>
			var insertWishList = "";
		</cfscript>
		
		<cfquery name="insertWishList" datasource="#variables.dsn#">
			INSERT INTO Wishlist 
			(	
				CustomerID, 
				Qty, 
				ItemID,
				SiteID
				<cfif isDefined("arguments.OptionName1") AND arguments.OptionName1 NEQ ''>, OptionName1</cfif>
				<cfif isDefined("arguments.OptionName2") AND arguments.OptionName2 NEQ ''>, OptionName2</cfif>
				<cfif isDefined("arguments.OptionName3") AND arguments.OptionName3 NEQ ''>, OptionName3</cfif>
				<cfif isDefined("arguments.Backordered") AND arguments.Backordered NEQ ''>, BackOrdered</cfif>
			) 
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CustomerID#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Quantity#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ItemID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SiteID#">
				<cfif isDefined("arguments.OptionName1") AND arguments.OptionName1 NEQ ''>, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName1#"></cfif>
				<cfif isDefined("arguments.OptionName2") AND arguments.OptionName2 NEQ ''>, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName2#"></cfif>
				<cfif isDefined("arguments.OptionName3") AND arguments.OptionName3 NEQ ''>, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName3#"></cfif>
				<cfif isDefined("arguments.Backordered") AND arguments.Backordered NEQ ''>,  <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.Backordered#"></cfif>
			)
		</cfquery>
	
	</cffunction>
	
	
	<!--- 
		UPDATE CUSTOMER WISHLIST
		Used in: WishUpdate.cfm
	--->
	<cffunction name="updateWishList" displayname="Update Items in Customer Wishlist" hint="Function to update items in customer's wishlist." access="public">
		<cfargument name="CustomerID" displayname="Customer ID" hint="Customer ID related to wishlist" type="string" required="yes">
		<cfargument name="SiteID" displayname="SiteID" hint="The CartFusion Site ID of the Products to update" type="numeric" required="yes">
		<cfargument name="Quantity" displayname="Quantity" hint="The Quantity of Products to update" type="numeric" required="yes">
		<cfargument name="ItemID" displayname="ItemID" hint="The Item ID of the item in the wishlist to update" type="numeric" required="no">
		<cfargument name="WishlistItemID" displayname="Wishlist ID" hint="The Wishlist ID of the item in the wishlist to update" type="numeric" required="no">
		<cfargument name="OptionName1" displayname="Option Name 1" hint="Product option value 1 in wishlist" type="string" required="no">
		<cfargument name="OptionName2" displayname="Option Name 2" hint="Product option value 2 in wishlist" type="string" required="no">
		<cfargument name="OptionName3" displayname="Option Name 3" hint="Product option value 3 in wishlist" type="string" required="no">
		
		<cfscript>
			var updateWishlist = "";
		</cfscript>
		
		<cfquery name="updateWishlist" datasource="#variables.dsn#">
			UPDATE 	Wishlist
			SET		Qty = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Quantity#">
			<cfif arguments.CustomerID NEQ ''>
					, CustomerID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CustomerID#">
			</cfif>
			WHERE 	CustomerID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CustomerID#">
			<cfif isDefined("arguments.ItemID") AND arguments.ItemID NEQ ''>
			AND 	ItemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ItemID#">
			</cfif>
			<cfif isDefined("arguments.WishlistItemID") AND arguments.WishlistItemID NEQ ''>
			AND 	WishlistItemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.WishlistItemID#">
			</cfif>			
			<cfif isDefined("arguments.OptionName1") AND arguments.OptionName1 NEQ ''>
			AND 	OptionName1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName1#">
			</cfif>
			<cfif isDefined("arguments.OptionName2") AND arguments.OptionName2 NEQ ''>
			AND 	OptionName2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName2#">
			</cfif>
			<cfif isDefined("arguments.OptionName3") AND arguments.OptionName3 NEQ ''>
			AND 	OptionName3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OptionName3#">
			</cfif>				
		</cfquery>
	
	</cffunction>
	
	
	<!--- 
		DELETE CUSTOMER WISHLIST
		Used in: WishUpdate.cfm
	--->
	<cffunction name="deleteWishList" displayname="Delete Items in Customer Wishlist" hint="Function to delete all items in customer's wishlist." access="public">
		<cfargument name="CustomerID" displayname="Customer ID" hint="Customer ID related to wishlist" type="string" required="yes">
		<cfargument name="SiteID" displayname="SiteID" hint="The CartFusion Site ID of the Products to delete" type="numeric" required="yes">
		<cfargument name="WishlistItemID" displayname="Wishlist ID" hint="The ID of the item in the wishlist to delete" type="numeric" required="no">
		<cfargument name="OptionName1" displayname="Option Name 1" hint="Product option value 1 in wishlist" type="string" required="no">
		<cfargument name="OptionName2" displayname="Option Name 2" hint="Product option value 2 in wishlist" type="string" required="no">
		<cfargument name="OptionName3" displayname="Option Name 3" hint="Product option value 3 in wishlist" type="string" required="no">
		
		<cfscript>
			var cleanWishlist = "";
		</cfscript>
		
		<cfquery name="cleanWishlist" datasource="#variables.dsn#">
			DELETE 
			FROM 	Wishlist
			WHERE 	CustomerID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.CustomerID#">
			<cfif isDefined("arguments.WishlistItemID") AND arguments.WishlistItemID NEQ ''>
			AND 	WishlistItemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.WishlistItemID#">
			</cfif>
		</cfquery>
	
	</cffunction>
	
	<!--- Added by Carl Vanderpal 25 May 2007 --->
	<cffunction name="login" hint="Logs customer into the system">
		<cfargument name="email" required="true">
		
		<cfscript>
			var login = "";
		</cfscript>
	
	
		<cfquery name="login" datasource="#variables.dsn#">
			SELECT 	*
			FROM 	Customers
			WHERE 	Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
			AND 	UserName <> <cfqueryparam cfsqltype="cf_sql_varchar" value="">
			AND 	password <> <cfqueryparam cfsqltype="cf_sql_varchar" value="">
		</cfquery>
	
		<cfreturn login>
	</cffunction>
	

</cfcomponent>

