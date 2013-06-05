

function updateRows(id, actionType) {
	var params = new Array();
	//var pid = null;
	
	var elements = ["id", "sku", "proname", "catid", "price"];

	for (var i = 0; i < elements.length; i++) {
	    var key = elements[i];
	    var ele = key;

	    if (id !== undefined && id !== null) ele = ele + "_" + id;

	    var element = document.getElementById(ele);
	    var value = element.value;
	    
	    //if (actionType === "insert") element.value = null;

	    //if (key === "pid") pid = value;

	    params.push(key + "=" + value);
	}

	if (id !== undefined && id !== null) params.push("id=" + id);

	params.push("a=" + actionType);

	makeRequest(params, actionType, id);
}

function insertRow()
{
	var params = new Array();
	
	var elements = ["proname", "sku", "catid", "price"];
	for (var i = 0; i < elements.length; i++) {
	    var key = elements[i];
	    var ele = key;

	    ele = "i_" + ele;

	    var element = document.getElementById(ele);
	    var value = element.value;
	    
	    params.push(key + "=" + value);
	}

	params.push("a=" + 'insert');

	makeRequest(params, 'insert', 0);

}

function getCategories(catid)
{
	var xmlHttp=new XMLHttpRequest();
	

	
	xmlHttp.onreadystatechange=function() {
		if (xmlHttp.readyState != 4) return;
		
		if (xmlHttp.status != 200) {
			alert("HTTP status is " + xmlHttp.status + " instead of 200");
			return;
		};

		var responseDoc = xmlHttp.responseText;
		var response = eval('(' + responseDoc + ')');
		var ret = "";
		for(var counter = 0 ; counter < response.len ; counter++)
		{
			ret += '<option value="'+counter+'" '+(counter===catid?"selected":"")+'>'+response[counter]+'</option>';
		}
		return ret;
	};
	
	// Send XHR request
	var url="ajax/ajax_man_product.jsp?a=categories";
	xmlHttp.open("GET",url,true);
	xmlHttp.send(null);
}


function makeRequest(params, actionType, pid){
	var xmlHttp=new XMLHttpRequest();	
	
	xmlHttp.onreadystatechange=function() {
		if (xmlHttp.readyState != 4) return;
		
		if (xmlHttp.status != 200) {
			alert("HTTP status is " + xmlHttp.status + " instead of 200");
			return;
		};

		var responseDoc = xmlHttp.responseText;
		var response = eval('(' + responseDoc + ')');

		switch (actionType){
			
		
			case 'UPDATE':
			    if (response.success) {
			    	alert(responseDoc.trim());
					document.getElementById("response").innerHTML = response.print;
					document.getElementById("sku_"+pid).innerHTML = response.sku;
					document.getElementById("proname_"+pid).innerHTML = response.proname;
					document.getElementById("catid_"+pid).innerHTML.option = response.catid;
					document.getElementById("price_"+pid).innerHTML.value = response.price;
				}
			break;
			
			case 'DELETE':
			    if (response.success) {
			    	alert(responseDoc.trim());
					document.getElementById('response').innerHTML =  response.print;
					if(response.deleted === true)
					{
						var parent = document.getElementById('tblbdy');
						var child = document.getElementById("row_"+pid);
						parent.removeChild(child);
					}
				}
			break;
			
			case 'insert':
				if (response.success) {
					alert(responseDoc.trim());
					var table = document.getElementById("table");

					var row = table.insertRow(table.rows.length);
					var cat = getCategories(response.catid);
					alert(cat);
					var html = '<td> <input id="id_"'+response.pid+'" type="hidden" value="'+response.pid+'" name="id"/>'+response.pid+'</td>' +
		        			   '<td> <input id = "sku_'+response.pid+'" value="'+response.sku+'" name="sku"/></td>' +
		        			   '<td> <input id = "proname_'+response.pid+'" value="'+response.proname+'" name="proname"/></td>' +
		        			   '<td> <select id = "catid_'+response.pid+'" name="catid">'+ret+'</select></td>' +
		        			   '<td> $<input id = "price_'+response.pid+'" value="'+response.price+'" name="price"/></td>' +
		        			   '<td> <input type="button" value="UPDATE" onClick="updateRows('+response.pid+', \'UPDATE\');">' +
		        			   '<input type="button" value="DELETE" onClick="updateRows('+response.pid+', \'DELETE\');"></td>';
					alert(html);
					row.innerHTML = html;
					document.getElementById('response').innerHTML = response.print;
				}
			break;
		
		}

	};
	
	// Send XHR request
	var url="ajax/ajax_man_product.jsp?" + params.join("&");
	xmlHttp.open("POST",url,true);
	xmlHttp.send(null);
}