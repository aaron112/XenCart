// check for updates every 2 seconds
setInterval(function(){update();}, 2000);

//unfinished
//params will have the last time the cells were updated.. checkupdates will return timestamps.. if any timestamps are greater than the ast timestamp, then it should display new cells
function update(params) {
$.ajax({
	type: 'POST',
	url: "checkupdates.jsp"+params,
	success:function(result) {
		var response = $.parseJSON(result);
		console.log(response);
		
// Parse through the json and change the corresponding dom_id(category_state) to updated values 

		
	}
	
})
}
	
