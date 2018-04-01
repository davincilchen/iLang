$(document).ready(function(){
	$("#flip-flashcard").on("click", function(event){
		console.log("the button is clicked");
		$(".flashcard-value").css("display", "block");
		$("#flip-flashcard").prop("disabled", true);
		$("#flip-flashcard").css("color", "grey")
	})


});

