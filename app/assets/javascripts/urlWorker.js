$(document).ready(function () {
	initValueSearchBox();
});

function initValueSearchBox() {
	alert("hello");
	var searchValue = URI(document.URL).search(true)["search"];
	alert(searchValue);
	$('#search-box').val(searchValue);

	/*
	$("#search-link").on('click', function() {
		var link = document.getElementById("search-link");
    link.setAttribute("href", document.URL);
	});

	$("#search-box").on('change', function () {
	      setUrlParam("search", this.value);
	});
*/
}

/*
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
*/
