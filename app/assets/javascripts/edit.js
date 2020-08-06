$(function () {
  var dataBox = new DataTransfer();
  var file_field = document.getElementById('img-file')
  $('#append-js-edit').on('change', '#img-file', function () {
    var labelWidth = $('#image-box__container').css('width').replace(/[^0-9]/g, '');
    $('.img-label').css('width', labelWidth);
    $.each(this.files, function (i, file) {
      var fileReader = new FileReader();
      dataBox.items.add(file)
      var num = $('.item-image').length + 1 + i
      var aaa = $('.item-image').length + i
      var image_id = Number($('#image-box-1').attr('class'))
      var append_div_count = Number($('div[id=1]').length)
      var noreset_id = image_id + append_div_count

      fileReader.readAsDataURL(file);
      if (num == 10) {
        $('#image-box__container').css('display', 'none')
      }
      fileReader.onloadend = function () {
        var src = fileReader.result
        var html = `<div class='item-image' data-image="${file.name}" data-index="${aaa}" id="${noreset_id - 1}">
                    <div class=' item-image__content'>
                      <div class='item-image__content--icon'>
                        <img src=${src} width="114" height="80" >
                      </div>
                    </div>
                    <div class='item-image__operetion'>
                      <div class='item-image__operetion--edit__delete__file'>削除</div>
                    </div>
                  </div>`
        const buildFileField1 = (num) => {
          const html = `<div  class="js-file_group" data-index="${num}" id=1>
                          <input class="js-file-edit" type="file"
                          name="item[images_attributes][${append_div_count + 9}][image]"
                          id="img-file" data-index="${num}value="${noreset_id}" >
                        </div>`;
          return html;
        }
        $('.js-file-edit').removeAttr('id');
        $('.img-label').before(html);
        $('#append-js-edit').append(buildFileField1(num));
      };
      $('#image-box__container').attr('class', `item-num-${num}`)
    });
    var labelWidth = $('#image-box__container').css('width').replace(/[^0-9]/g, '');
    $('.img-label').css('width', labelWidth);
  });

  $(document).ready(function () {
    var image_num = $('.item-image').length
    if (image_num == 10) {
      $('#image-box__container').css('display', 'none')
    }
  });

  $(document).ready(function () {
    var labelWidth = $('#image-box__container').css('width').replace(/[^0-9]/g, '');
    $('.img-label').css('width', labelWidth);
    $('.js-file-edit').removeAttr('id');
    var num = $('.item-image').length - 1
    var image_id = Number($('#image-box-1').attr('class'))
    var append_div_count = Number($('div[id=1]').length)
    var noreset_id = image_id + append_div_count
    const buildFileField = (num) => {
      const html = `<div  class="js-file_group" data-index="${num}" id=1>
                      <input class="js-file-edit" type="file"
                      name="item[images_attributes][100][image]"
                      id="img-file" data-index="${num}" value="${noreset_id}" >
                    </div>`;
      return html;
    }
    $('#append-js-edit').append(buildFileField(num));
  });

  $(document).on("click", '.item-image__operetion--edit__delete__hidden', function () {
    var target_image = $(this).parent().parent();
    var target_id = $(target_image).attr('id');
    var target_image_file = $('input[value="' + target_id + '"][type=hidden]');
    target_image.remove()
    target_image_file.remove()
    var num = $('.item-image').length
    $('#image-box__container').show()
    $('#image-box__container').attr('class', `item-num-${num}`)
    var labelWidth = $('#image-box__container').css('width').replace(/[^0-9]/g, '');
    $('.img-label').css('width', labelWidth);

  })
  $(document).on("click", '.item-image__operetion--edit__delete__file', function () {
    var target_image = $(this).parent().parent();
    var target_id = Number($(target_image).attr('id'));
    var target_image_file = $('#append-js-edit').children('div').children('input[value="' + target_id + '"][type=file]');
    target_image.remove()
    target_image_file.remove()
    var num = $('.item-image').length
    $('#image-box__container').show()
    $('#image-box__container').attr('class', `item-num-${num}`)
    var labelWidth = $('#image-box__container').css('width').replace(/[^0-9]/g, '');
    $('.img-label').css('width', labelWidth);
  })
});