<!--- 
	init
	AddDistributor
	EditDistributor
	DeleteDistributor
	ViewDistributors
 --->

 <cfcomponent displayname="Distributors" output="false">
	
	<cfscript>
		variables.dsn = "";
	</cfscript>

	<cffunction name="init" returntype="Distributors" output="false">
	<cfargument name="dsn" required="true" hint="Passes and init the component with the required dsn">
	
		<cfscript>
			variables.dsn = arguments.dsn;
		</cfscript>
		

		<cfreturn this />
	</cffunction>

	<cffunction name="AddDistributor" output="false">
	
		<cfscript>
			// initialize a structure to hold the returned information
			var stReturn = StructNew();
			// This structure key is used to indicate if the operation completed successfully
			stReturn.bSuccess = True;
			// This structure key is used to pass messages back to the caller of the
			// function. It should be used for passing developer messages to assist debugging
			stReturn.message = "";
			// This structure key is used to hold any data which the function returns
			stReturn.data = "";
			// This structure key is used to hold any error information generated by the function
			stReturn.stError = structNew();
		</cfscript>

		<cfreturn stReturn>
	</cffunction>


	<cffunction name="EditDistributor" output="false">
	
		<cfscript>
			// initialize a structure to hold the returned information
			var stReturn = StructNew();
			// This structure key is used to indicate if the operation completed successfully
			stReturn.bSuccess = True;
			// This structure key is used to pass messages back to the caller of the
			// function. It should be used for passing developer messages to assist debugging
			stReturn.message = "";
			// This structure key is used to hold any data which the function returns
			stReturn.data = "";
			// This structure key is used to hold any error information generated by the function
			stReturn.stError = structNew();
		</cfscript>

		<cfreturn stReturn>
	</cffunction>


	<cffunction name="DeleteDistributor" output="false">
	
		<cfscript>
			// initialize a structure to hold the returned information
			var stReturn = StructNew();
			// This structure key is used to indicate if the operation completed successfully
			stReturn.bSuccess = True;
			// This structure key is used to pass messages back to the caller of the
			// function. It should be used for passing developer messages to assist debugging
			stReturn.message = "";
			// This structure key is used to hold any data which the function returns
			stReturn.data = "";
			// This structure key is used to hold any error information generated by the function
			stReturn.stError = structNew();
		</cfscript>

		<cfreturn stReturn>
	</cffunction>
	

	<cffunction name="ViewDistributors" output="false">
	
		<cfscript>
			// initialize a structure to hold the returned information
			var stReturn = StructNew();
			// This structure key is used to indicate if the operation completed successfully
			stReturn.bSuccess = True;
			// This structure key is used to pass messages back to the caller of the
			// function. It should be used for passing developer messages to assist debugging
			stReturn.message = "";
			// This structure key is used to hold any data which the function returns
			stReturn.data = "";
			// This structure key is used to hold any error information generated by the function
			stReturn.stError = structNew();
		</cfscript>

		<cfreturn stReturn>
	</cffunction>





</cfcomponent>