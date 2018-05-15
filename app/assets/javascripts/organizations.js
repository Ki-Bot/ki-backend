$(function(){
  $('.def-txt-input').keypress(function(e){
    // allowed char: 1 , 2 , 3, 4, 5, 6, 7, A, B, C
    let allow_char = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57];
    if(allow_char.indexOf(e.which) !== -1 ){
      //do something
    }
    else{
      return false;
    }
  });
  
  $("input").keypress(function(){ 
    // debugger
    id = parseInt(this.id) + 1; 
    $("input[id="+id+"]").focus();  
  })
  
  // var inputs = document.querySelectorAll("#activate_code input[name='chars[]']");
  // inputs.forEach(function(input){
  // })
  //   $("input[name='chars[1]'").focus();
  //   //$("input[name='chars[1]'").text(i += 1);
  // });
  
  // $("input[name='chars[1]'").keypress(function(){
  //   $("input[name='chars[2]'").focus();
  //   //$("input[name='chars[1]'").text(i += 1);
  // });
});

function submit_form(){
  event.preventDefault();
  var id = $('#active-btn')
  var ar = []
  var inputs = document.querySelectorAll("#activate_code input[name='chars[]']");
  inputs.forEach(function(input){
    if (input.value != ""){
      ar.push(input.value)
      // your code here
    }
  })
  $.ajax({
    datatype: "json",
    type: 'GET',
    url: $('form').attr("action"),
    data: {id: id[0].name, chars: ar},
    success: function(data){
      if (data.bool == false){
        alert("Please enter valid access code");
      }
      else{
        $('#activate_code').submit();
      }
    }
  });

  // $.get( $('form').attr("action"), { id: id[0].name, chars: ar } );
  // $.ajax( "example.php" )
  // .done(function() {
  //   alert( "success" );
  // })
  // .fail(function() {
  //   alert( "error" );
  // })
}



// var $inputs = $(".def-txt-input");
// var intRegex = /^\d+$/;

// // Prevents user from manually entering non-digits.
// $inputs.on("input.fromManual", function(){
//     if(!intRegex.test($(this).val())){
//         $(this).val("");
//     }
// });


// // Prevents pasting non-digits and if value is 6 characters long will parse each character into an individual box.
// $inputs.on("paste", function() {
//     var $this = $(this);
//     var originalValue = $this.val();
    
//     $this.val("");

//     $this.one("input.fromPaste", function(){
//         $currentInputBox = $(this);
        
//         var pastedValue = $currentInputBox.val();
        
//         if (pastedValue.length == 6 && intRegex.test(pastedValue)) {
//             pasteValues(pastedValue);
//         }
//         else {
//             $this.val(originalValue);
//         }

//         $inputs.attr("maxlength", 1);
//     });
    
//     $inputs.attr("maxlength", 6);
// });


// // Parses the individual digits into the individual boxes.
// function pasteValues(element) {
//     var values = element.split("");

//     $(values).each(function(index) {
//         var $inputBox = $('.def-txt-input[name="chars[' + (index + 1) + ']"]');
//         $inputBox.val(values[index])
//     });
// };