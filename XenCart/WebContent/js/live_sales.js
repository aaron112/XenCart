var lastupdate = 0;		// Last updated "sales.id"

function test()
{
	document.getElementById("32.4").textContent = "test";
}

function makeRequest(params, actionType, pid){
	var xmlHttp = new XMLHttpRequest();	
	
	xmlHttp.onreadystatechange = function() {
		
		if (xmlHttp.readyState != 4) return;
		
		if (xmlHttp.status != 200) {
			alert("HTTP status is " + xmlHttp.status + " instead of 200");
			return;
		};
		
		var responseDoc = xmlHttp.responseText;
		var responseLines = responseDoc.split("\n");
		
		if (responseLines[1] == "Not updated.")
			return;
		
		for (var i in responseLines) {
			if ( i == 0 )
				lastupdate = parseInt(responseLines[0]);
			else {
				var obj = JSON.parse(responseLines[i]);
				console.log(obj.c);
				document.getElementById(obj.c).textContent = "$"+obj.t;
			}
		  
		}
	};
	
	// Send XHR request
	var url = "ajax/ajax_live_sales.jsp?lastupdate="+lastupdate;
	console.log("Sending request: " + url);
	xmlHttp.open("GET", url, true);
	xmlHttp.send(null);
}