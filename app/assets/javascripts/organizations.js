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
  
  $("input").keyup(function(){ 
    // debugger
    if (Number.isInteger(parseInt(this.value))){
      id = parseInt(this.id) + 1; 
      $("input[id="+id+"]").focus();
      if (id == 7){
        submit_form();
      }  
    }
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
}
function create_faq(){
  event.preventDefault();
  var que = $('#create_faq_question')
  var ans = $('#create_faq_answer')
  if (que.val() && ans.val()){
    $.ajax({
      datatype: "json",
      type: 'POST',
      url: $('#faq_create').attr("action"),
      data: {que: que.val(), ans: ans.val(), broadband_id: $('#faq_create').attr("name") }
    });
  }
  else{
    alert("Please fill the fields");
  }
}
function delete_faq(id, broadband_id){

  $.ajax({
    datatype: "json",
    type: 'DELETE',
    url: '/organizations/faq/'+id,
    data: {id: id, broadband_id: broadband_id},
    success: function(data){
      if (data.bool){
        $('#accordion'+data.bool).remove()
        alert("Faq has been deleted")
      }
    }
  });
}

function update_faq(id, broadband_id){

  que = $('#update_question_'+id).val()
  ans = $('#update_answer_'+id).val()
  $.ajax({
    datatype: "json",
    type: 'PUT',
    url: '/organizations/faq/'+id,
    data: {id: id, broadband_id: broadband_id, que: que, ans: ans},
    success: function(data){
      if (data){
        alert("Faq has been updated")
      }
    }
  });
}
