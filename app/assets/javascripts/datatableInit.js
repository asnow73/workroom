  $(document).ready(function() {
    $('#post-datatable').dataTable({
    	"bProcessing": true,
      "bServerSide": true,
      "sAjaxSource": '/admin/posts.json',//$('#post-datatable').data('source')

      "aoColumns": [
            {
                "sName": "ID",
                "title": "",
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
            { "sName": "Published", "title": "Published" },
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
  } );