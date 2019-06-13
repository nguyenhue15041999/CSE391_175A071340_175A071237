$(document).ready(function(){
    $('#login').click(function() {
        if ($('#name').val()=='HueLoan' && $('#pass').val()=='123456789') {
            window.location.href='Quantrihethong.html';
        }else{
          $( ".notification" ).show();
      }
});
});