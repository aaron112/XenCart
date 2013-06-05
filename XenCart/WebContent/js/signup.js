
	// Disable the age/state if the "owner" role is selected
	//document.forms["signup"].age.style.display
	function disable() {
		
		if (document.getElementById("role").selectedIndex==1) {
			document.getElementById("options").style.display = "block";
			document.getElementById("age").disabled = true;
			document.getElementById("state").disabled = true;
			document.getElementById("age").value = null;
			document.getElementById("state").value = null;
		}
		else if (document.getElementById("role").selectedIndex==2) {
			document.getElementById("options").style.display = "block";
			document.getElementById("age").disabled = false;
			document.getElementById("state").disabled = false;
		}
		
		else {
			document.getElementById("options").style.display = "none";
		}	
	}
	
	function validate(form) {
		var valid_age = document.forms["signup"]["age"].value;
		var valid_role = document.forms["signup"]["role"].value;
		var valid_st = document.forms["signup"]["state"].value;
		var intRegex = /^\d+$/;
		var valid_username = document.forms["signup"]["username"].value;
		var isvalid = false;
		
			// owner
			if (valid_role == 1) {
				document.getElementById("age_error").style.display = "none";

				if (valid_username == null || valid_username == "") {
							document.getElementById("username_error").style.display = "block";

					return false; 
				}
				else 
					{ 
					return true; }

			}
			if (valid_role == 2) {
				if (valid_username == null || valid_username == "") {
					document.getElementById("username_error").style.display = "block";
					return false;
				}
				if ((valid_age == "") || (valid_age == null) || (!intRegex.test(valid_age))) {
					document.getElementById("age_error").style.display = "block";
					return false;
				}
				if (valid_state == null) {
					document.getElementById("state_error").style.display = "block";
					return false; 
				}
				else {
					return true;
				}
			}
				
			

		
			if (valid_role == 0) {
			document.getElementById("role_error").style.display = "block";


		}
		

		
		return false;
	}
	