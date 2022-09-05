
<cfswitch expression="#thisTag.executionMode#">
<cfcase value="start">
  <cfsilent>
	<cfif not thisTag.hasEndTag>
	  <cfthrow message="jTree requires an end tag.">
	</cfif>

	<!--- Skin --->
	<cfparam name="attributes.skin" default="default">
	<cfif structKeyExists(request, "jComponent") AND structKeyExists(request.jComponent, "skins") AND structKeyExists (request.jComponent.skins, attributes.skin)>
	  <cfloop collection="#request.jComponent.skins[attributes.skin]#" item="i">
  	  <cfif not structKeyExists(attributes, i)>
  		<cfset attributes[i] = request.jComponent.skins[attributes.skin][i]>
  	  </cfif>
	  </cfloop>
	</cfif>
	
	<!--- Attribs --->
	<cfparam name="attributes.name" default="#createUuid()#">
	<cfparam name="attributes.width" default="150">
	<cfparam name="attributes.height" default="400">
	<cfparam name="attributes.border" default="0">
	<cfparam name="attributes.borderColor" default="000000">
	<cfparam name="attributes.bgColor" default="000000">
	<cfparam name="attributes.onChange" default="">
  </cfsilent>
  <cfoutput>
  <cfset msg="<!-- Control generated by jComponents 1.0, copyright #datePart("yyyy", now())# joe rinehart, joe.rinehart@gmail.com, http://clearsoftware.net/jComponents -->">
  <cfoutput>#msg#</cfoutput>
  <script>
	<cfif not isDefined("request.jComponent.init")>
	  <cfset request.jComponent.init = true>
	  jComponents = new Object;
	  jComponents.go = function() {};
	  jComponents.getComponent = function(id) {
		return jComponents[id];
	  }

	  jComponents.setBarColor = function (bgIdArray, fgIdArray, bgColor, fgColor) { //(bgIdArray, fgIdArray, bgColor, fgColor)
		var i=0
		for (i=0;i<bgIdArray.length;i++) try { (document.getElementById(bgIdArray[i]).style.background = bgColor) } catch(e) {};
		for (i=0;i<fgIdArray.length;i++) try { (document.getElementById(fgIdArray[i]).style.color = fgColor) } catch(e) {};
	  }
	</cfif>
	<cfif not isDefined("request.jTree.init")>
	  <cfset request.jTree.init = true>
	  jComponents.setTree = function (treename, nodeData, isOpen) {
		var id = jComponents[treename].items[nodeData].id;
		var currentNode = jComponents[treename].items[nodeData];
		document.getElementById(id).style.display = (isOpen ? '' : 'none');
		try {document.getElementById("i" + id).style.display = document.getElementById(id).style.display = (isOpen ? '' : 'none')} catch(e){};
		try {document.getElementById("ic" + id).style.display = (isOpen ? 'none' : '')} catch(e){};
		if (isOpen) {
		  jComponents[treename].openNodes[jComponents[treename].openNodes.length] = nodeData;
		  currentNode.isOpen = true;
		} else {
		  currentNode.isOpen = false;
		  var newopenNodes = [];
		  for (var i=0;i<jComponents[treename].openNodes.length;i++) {
			if (jComponents[treename].openNodes[i] != nodeData) newopenNodes[newopenNodes.length] = jComponents[treename].openNodes[i];
		  }
		  jComponents[treename].openNodes = newopenNodes;
		}
	  }
	</cfif>
	jComponents["#attributes.name#"] = {name:"#attributes.name#",data:"",items:new Object,openNodes:new Array}
  </script>
  <table cellpadding="0" cellspacing="0" border="0"> <!--- style="background-image:url(../images/leftnav-BG.jpg); background-repeat:repeat-y;"--->
  <tr>
	<td valign="top"><!--- style="border:#attributes.border#px ###attributes.borderColor# Solid;width:#attributes.width#;height:#attributes.height#;padding-left:10px;padding-right:5px;" --->
  </cfoutput>
</cfcase>
<cfcase value="end">
	</td>
	</tr>
  </table>
  <cfif len(attributes.onChange)>
	<cfoutput><script>#attributes.onChange#();</script></cfoutput>
  </cfif>
</cfcase>
</cfswitch>