/**
 * Created by agonq on 6/24/17.
 */

$(function(){
    // if (jQuery.ui) {
    //     alert('UI loaded');
    // }
    $('[data-method="get"]').removeAttr('data-method');
    // $('[data-method="post"]').removeAttr('data-method');

    //For delete links
    $('a[data-method="delete"]').each(function(index, link){
        $(link).on('click', function(){
            if(confirm('Are you sure you want to delete?')){
                $.ajax({
                    url: $(this).attr('href'),
                    method: 'DELETE',
                    success: function(data){
                        if(data.url){
                            window.location = data.url;
                        } else if(data.message){
                            alert(data.message);
                        }
                    },
                    error: function(err1, err2){
                        alert(JSON.stringify(err1) + '\n' + JSON.stringify(err2));
                    }
                });
                return false;
            }
        });
    });
    $('[data-method="delete"]').removeAttr('data-method').removeAttr('data-confirm');

    //For update forms
    $('form:has(input[name="_method"][value="patch"])').on('submit', function(){
        $.ajax({
            url: $(this).attr('action'),
            method: 'PUT',
            data: $(this).serialize(),
            success: function(data){
                if(data.url){
                    window.location = data.url;
                } else if(data.message){
                    alert(data.message);
                }
            },
            error: function(err1, err2){
                alert(JSON.stringify(err1) + '\n' + JSON.stringify(err2));
            }
        });
        return false;
    });
});
