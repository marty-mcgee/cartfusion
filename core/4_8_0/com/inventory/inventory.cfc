<cfcomponent displayname="Inventory" output="false">
	<cffunction name="Init">
	
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

	<cffunction name="AddInventory">
	
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


	<cffunction name="EditInventory">
	
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


	<cffunction name="DeleteInventory">
	
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


	<cffunction name="ViewInventory" roles="Admin">
	
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


	<cffunction name="ActivateInventory">
	
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