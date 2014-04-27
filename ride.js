// This example adds a predefined symbol (an arrow) to a polyline.
// Setting offset to 100% places the arrow at the end of the line.


function initialize() {

/*
var myJSONObject = [

        {
        "Long1": -122.122198,
        "Lat1": 37.448274,
        "Long2": -122.128206,
        "Lat2": 37.453725,
        "Eff": 3,
        },

        {
        "Long1": -122.029673,
        "Lat1": 37.399469,
        "Long2": -122.007872,
        "Lat2": 37.394423,
        "Eff": 5,
        },

        {
        "Long1": -122.129673,
        "Lat1": 37.429469,
        "Long2": -122.107872,
        "Lat2": 37.424423,
        "Eff": 1,
        }
    ];
*/


    var mapOptions = {
        zoom: 12,
        //center: new google.maps.LatLng(37.448274, -122.122198),
        center: new google.maps.LatLng(37.375068,-121.966095),
        mapTypeId: google.maps.MapTypeId.TERRAIN
    };

    var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

    //Loading drive.json from root
    $.getJSON('aggregate.json')
    .done(function (data) {
        myJSONObject = data.nodes;
        $.each(myJSONObject, function(idx, obj) {
            var rgbClr = '#292'; 
            if(obj.Eff < 4) {
                rgbClr = '#F00';
            } 
            // [START region_polyline]
            // Define a symbol using a predefined path (an arrow)
            // supplied by the Google Maps JavaScript API. 
            var lineSymbol = {
                path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
                strokeColor: rgbClr,
                fillColor: rgbClr,
                fillOpacity: 1
            };
           // Create the polyline and add the symbol via the 'icons' property.
            var lineCoordinates = [
                new google.maps.LatLng(obj.Lat1, obj.Long1),
                new google.maps.LatLng(obj.Lat2, obj.Long2)
            ];
            var line = new google.maps.Polyline({
                path: lineCoordinates,
                icons: [
                    {
                        icon: lineSymbol,
                        offset: '100%'
                    }
                ],
                map: map
            });
            // [END region_polyline]
        });//END iteration
    });//END loading
}

google.maps.event.addDomListener(window, 'load', initialize);