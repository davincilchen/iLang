$(document).ready(function(){
	$(".flascard-item").each(function(e) {
        if (e != 0)
            $(this).hide();
    });

    $("#next-flashcard").click(function(){
    	EnableFlipButton();
        if ($(".flascard-item:visible").next().length != 0)
            $(".flascard-item:visible").next().show().prev().hide();
        else {
            $(".flascard-item:visible").hide();
            $(".flascard-item:first").show();
        }
        return true;
    });

     $("#previous-flashcard").click(function(){
     	EnableFlipButton();
        if ($(".flascard-item:visible").prev().length != 0)
            $(".flascard-item:visible").prev().show().next().hide();
        else {
            $(".flascard-item:visible").hide();
            $(".flascard-item:first").show();
        }
        return true;
    });

	$("#flip-flashcard").on("click", function(event){
		console.log("the button is clicked");
		$(".flascard-item:visible .flashcard-value p").css("display", "block");
		DisableFlipButton();
	})

});

function EnableFlipButton(){
	$("#flip-flashcard").prop("disabled", false);
    $("#flip-flashcard").css("color", "white")	
}

function DisableFlipButton(){
	$("#flip-flashcard").prop("disabled", true);
	$("#flip-flashcard").css("color", "grey")
}