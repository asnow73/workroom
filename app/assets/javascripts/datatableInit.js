// Установка полей фильтра
/*
function setFilterColumn() {
  $('#post-datatable tfoot th').each(function () {
    var title = $('#post-datatable thead th').eq($(this).index()).text();
    if (title == "Created At") {
      $(this).html('<input id="create-at-filter" type="text" class="clearable"' + title + ' />');
    }
    else if (title == "Title") {
      $(this).html('<input id="title-filter" type="text" class="clearable"' + title + ' />');
    }
    else if (title == "Category") {
      $(this).html('<input id="category-filter" type="text" class="clearable"' + title + ' />');
    }
    else if (title == "Published") {
      $(this).html('<input id="published-filter" type="text" class="clearable"' + title + ' />');
    }
  });
}
*/

//Запись значений фильтров в URl
function setUrlParam(paramName, filterValue) {
  var urlParam = URI(document.URL).removeSearch(paramName);
  history.pushState("", "", urlParam);

  if (filterValue) {
    var search = new Object();
    search[paramName] = filterValue;
    var urlParam = URI(document.URL).addSearch(search);
    history.pushState("", "", urlParam);
  }
}

//формирование строки фильтра для компонента мульти выбора 
function getChosenFilterValue(options) {
  var filterValue = "";
  for (i = 0; i < options.length; ++i) {
    filterValue += options[i].value.toString();
    if (i < options.length - 1) {
      filterValue += ",";
    }
  }
  return filterValue;
}

//установка выбранных вариантов в компоненте мульти выбора
function setChosenValue(filterValue, idChosen) {
  if (filterValue != null) {
    var options = filterValue.split(',');
    for (i = 0; i < options.length; ++i) {
      $(idChosen).val(options);
      $(idChosen).trigger("chosen:updated");
    }
  }
}

function fiterField(idElement, numColumn, table) {
  var value = $(idElement).val();
  if ((value == null) || (value == "")) {
    table.columns(numColumn).search("").draw();
  }
  else {
    value = $('<div/>').text(value).html(); //html encode
    table.columns(numColumn).search(value).draw(); 
  }
}

$(document).ready(function() {
	// Установка полей фильтра
  //setFilterColumn();

  var filterCreateAt = URI(document.URL).search(true)["created_at"];
  var filterTitle = URI(document.URL).search(true)["title"];
  var filterCategory = URI(document.URL).search(true)["category"];
  var filterPublished = URI(document.URL).search(true)["published"];

  var sort = URI(document.URL).search(true)["sort"];
  if (sort == null) {
  	sort = [1, "desc"];
  }

  $('#create-at-filter').val(filterCreateAt);
  $('#title-filter').val(filterTitle);
  setChosenValue(filterCategory, '#category-filter');
  setChosenValue(filterPublished, '#published-filter');

  $('#post-datatable').dataTable({
  	"bProcessing": true,
    "bServerSide": true,
    "sAjaxSource": '/admin/posts.json',//$('#post-datatable').data('source')
    "order": sort,
    "fnDrawCallback": function(oSettings) {
    	if (oSettings.aaSorting.length > 0) {
    		setUrlParam("sort", oSettings.aaSorting[0]);
    	}
    },

    //установка фильтров значениями из URL
    "aoSearchCols": [
      null,
      { "oSearch": filterCreateAt },
      { "oSearch": filterTitle },
      { "oSearch": filterCategory },
      { "oSearch": filterPublished }
    ],

    "aoColumns": [
        {
            "sName": "ID",
            "title": "ID",
            "sWidth": "1%",
            "bSearchable": false,
            "bSortable": false
            //"mRender": function (data, type, full) {
            //    return '<input type="checkbox" value="' + data + '" id="rowId' + data + '" onclick="checkOnRow(this.id);">';
            //}
        },                     
                    
        { "sName": "CreatedAt", "title": "Created At" },
        { "sName": "Title", "title": "Title" },
        { "sName": "Category", "title": "Category" },
        { 
        	"sName": "Published",
        	"title": "Published",
        	"mRender": function (data, type, full) {
            if (data) {
            	return '<div class="public-content">' + data + '</div>'
            }
            else {
            	return '<div class="unpublic-content">' + data + '</div>'	
            }
          }
        },
        {
          "sName": "Update",
          "title": "Upd.",
          "bSearchable": false,
          "bSortable": false,
          "mRender": function (data, type, full) {
              return '<a href="/admin/posts/' + data.toString() + '/edit">Изм...</a>';
          }
        },
        {
          "sName": "Delete",
          "title": "Del.",
          "bSearchable": false,
          "bSortable": false,
          "mRender": function (data, type, full) {
          	return '<a data-confirm="Вы уверены?" data-method="delete" href="/admin/posts/' + data.toString() + '" rel="nofollow">Дел...</a>'
          }
        }
      ]
  });


  $('#category-filter').on('change', function () {
    var filterValue = getChosenFilterValue(this.selectedOptions);
    setUrlParam("category", filterValue);
    fiterField("#category-filter", 3, table);
  });

  $('#published-filter').on('change', function () {
    var filterValue = getChosenFilterValue(this.selectedOptions);
    setUrlParam("published", filterValue);
    fiterField("#published-filter", 4, table);
  });

  $('#title-filter').on('keyup', function () {
    setUrlParam("title", this.value);
    fiterField('#title-filter', 2, table);
  });

});

$(function () {
    //$('#date-range0').dateRangePicker();
    //$('#date-range1').dateRangePicker();
    $('#published-filter').chosen('{ disable_search_threshold: 10 , width: "100%" }');
    $('#category-filter').chosen('{ disable_search_threshold: 10 , width: "100% }');
    //noUiSliderInit();
});