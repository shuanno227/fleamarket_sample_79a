//DataTransferオブジェクトで、データを格納する箱を作る
var dataBox = new DataTransfer();
var select_image
var file_field = $(".itemImageArea-sub");

function changeSelect(src) {
  var html = `
                <img src=${src} class="imageSelect">
            `
  $('.itemImageArea-select').append(html);
}


$(document).on("mouseover", '#image', function () {
  $('.imageSelect').remove();
  var select_image = this.src;
  changeSelect(select_image);

  $(this).css({
    opacity: 1
  })
});
$(document).on("mouseout", '#image', function () {
  $('.imageSelect').remove();
  var select_image = this.src;
  changeSelect(select_image);
  $(this).css({
    opacity: 0.4
  })
});





