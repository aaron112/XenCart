var input_elements = ["sku", "proname", "catid", "price"];

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
	
	for (var i = 0; i < input_elements.length; i++) {
		var key = input_elements[i]+"_new";
		
	    var value = document.getElementById(key).value;
	    
	    params.push(input_elements[i] + "=" + value);
	}

	params.push("a=" + 'INSERT');

	makeRequest(params, 'INSERT', 0);

}

function buildCategorySelect(selectName, catid)
{
	var select = document.getElementById(selectName);
	for(i in cat_id_list) {
		var newo = new Option(cat_name_list[i], cat_id_list[i]);
		if (cat_id_list[i] == catid)
			newo.setAttribute("selected", true);
		
		select.options[select.options.length] = newo;
	}
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
		
		document.getElementById("response").innerHTML = response.print;
		document.getElementById("response").style.color = (response.success?"green":"red");

    	alert(response.print);
    	
		switch (actionType){
			case 'UPDATE':
			    if (response.success) {
					document.getElementById("sku_"+pid).innerHTML = response.sku;
					document.getElementById("proname_"+pid).innerHTML = response.proname;
					document.getElementById("catid_"+pid).innerHTML.option = response.catid;
					document.getElementById("price_"+pid).innerHTML.value = response.price;
				}
			break;
			
			case 'DELETE':
			    if (response.success && response.deleted) {
					var parent = document.getElementById('tblbdy');
					var child = document.getElementById("row_"+pid);
					parent.removeChild(child);
				}
			break;
			
			case 'INSERT':
				if (response.success) {
					// Clear inputs
					for (var i = 0; i < input_elements.length; i++) {
					    document.getElementById(input_elements[i]+"_new").value = "";
					}
					
					
					var table = document.getElementById("table");

					var row = table.insertRow(2);
		            row.id = "row_"+response.pid;
					
					var html = '<td> <input id="id_'+response.pid+'" type="hidden" value="'+response.pid+'" name="id"/>'+response.pid+'</td>' +
		        			   '<td> <input id = "sku_'+response.pid+'" value="'+response.sku+'" name="sku"/></td>' +
		        			   '<td> <input id = "proname_'+response.pid+'" value="'+response.proname+'" name="proname" size="32"/></td>' +
		        			   '<td> <select id = "catid_'+response.pid+'" name="catid"></select></td>' +
		        			   '<td> $<input id = "price_'+response.pid+'" value="'+response.price+'" name="price" size="8"/></td>' +
		        			   '<td> <input type="button" value="UPDATE" onClick="updateRows('+response.pid+', \'UPDATE\');"> ' +
		        			   '<input type="button" value="DELETE" onClick="updateRows('+response.pid+', \'DELETE\');"></td>';
					
					row.innerHTML = html;
					
					buildCategorySelect("catid_"+response.pid, response.catid);
				}
			break;
		
		}

	};
	
	// Send XHR request
	var url="ajax/ajax_man_product.jsp?" + params.join("&");
	xmlHttp.open("POST",url,true);
	xmlHttp.send(null);
}