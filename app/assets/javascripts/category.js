$(function () {
  // カテゴリーセレクトボックスのオプションを作成
  function appendOption(category) {
    var html = `<option value="${category.id}" data-category="${category.id}">${category.name}</option>`;
    return html;
  }
  "ハッシュ名[category_id]"
  // 子カテゴリーの表示作成
  function appendChildrenBox(insertHTML) {
    var childSelectHtml = '';
    childSelectHtml = `
                       <div class='select--wrap' id= 'categoryBox--children'>
                         <select class="input input-default" id="child_form" name="category_id">
                           <option value="---" data-category="---">---</option>
                           ${insertHTML}
                         </select>
                       </div>
                      `;
    $('.categoryField-details').append(childSelectHtml);
  }

  // 孫カテゴリーの表示作成
  function appendGrandchildrenBox(insertHTML) {
    var grandchildSelectHtml = '';
    grandchildSelectHtml = `
                            <div class='select--wrap' id= 'categoryBox--grandchildren'>
                              <select class="input input-default" id="grandchild_form" name="category_id">
                                <option value="---" data-category="---">---</option>
                                ${insertHTML}
                              </select>
                            </div>
                           `;
    $('.categoryField-details').append(grandchildSelectHtml);
  }

  // 子要素のアクション
  $("#parent_form").on("change", function () {
    var parentValue = document.getElementById("parent_form").value;
    if (parentValue != "---") {
      $('#categoryBox--children').remove(); // 選択し直したときに、前回の選択イベント発火で表示したボックスを消去
      $('#categoryBox--grandchildren').remove(); // 選択し直したときに、前回の選択イベント発火で表示したボックスを消去
      $.ajax({
        url: '/items/search_child',
        type: 'GET',
        data: {
          parent_id: parentValue
        },
        dataType: 'json'
      })

        .done(function (children) {
          $('#categoryBox--children').remove();
          $('#categoryBox--grandchildren').remove();
          var insertHTML = '';
          children.forEach(function (child) {
            insertHTML += appendOption(child);
          });
          appendChildrenBox(insertHTML);
        })
        .fail(function () {
          alert('カテゴリーを入力して下さい');
        })
    } else {
      $('#categoryBox--children').remove();
      $('#categoryBox--grandchildren').remove();
    }
  });

  // 孫要素のアクション
  $(".categoryField-details").on("change", "#child_form", function () {
    var childValue = $('#child_form option:selected').data('category');
    if (childValue != "---") {
      $('#categoryBox--grandchildren').remove(); // 選択し直したときに、前回の選択イベント発火で表示したボックスを消去
      $.ajax({
        url: '/items/search_grandchild',
        type: 'GET',
        data: {
          child_id: childValue
        },
        dataType: 'json'
      })

        .done(function (grandchildren) {
          var insertHTML = '';
          grandchildren.forEach(function (grandchild) {
            insertHTML += appendOption(grandchild);
          });
          appendGrandchildrenBox(insertHTML);
        })
        .fail(function () {
          alert('カテゴリーを入力して下さい');
        })
    } else {
      $('#categoryBox--children').remove();
      $('#categoryBox--grandchildren').remove();
    }
  });
});
