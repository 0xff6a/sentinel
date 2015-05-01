$(document).ready( function() {
  if ( $('#geo_dashboard_map').length ) {
    var styleArray = 
    [
        {
            "featureType": "all",
            "elementType": "labels.text.fill",
            "stylers": [
                {
                    "color": "#ffffff"
                }
            ]
        },
        {
            "featureType": "all",
            "elementType": "labels.text.stroke",
            "stylers": [
                {
                    "color": "#000000"
                },
                {
                    "lightness": 13
                }
            ]
        },
        {
            "featureType": "administrative",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "color": "#000000"
                }
            ]
        },
        {
            "featureType": "administrative",
            "elementType": "geometry.stroke",
            "stylers": [
                {
                    "color": "#144b53"
                },
                {
                    "lightness": 14
                },
                {
                    "weight": 1.4
                }
            ]
        },
        {
            "featureType": "landscape",
            "elementType": "all",
            "stylers": [
                {
                    "color": "#08304b"
                }
            ]
        },
        {
            "featureType": "poi",
            "elementType": "geometry",
            "stylers": [
                {
                    "color": "#0c4152"
                },
                {
                    "lightness": 5
                }
            ]
        },
        {
            "featureType": "road.highway",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "color": "#000000"
                }
            ]
        },
        {
            "featureType": "road.highway",
            "elementType": "geometry.stroke",
            "stylers": [
                {
                    "color": "#0b434f"
                },
                {
                    "lightness": 25
                }
            ]
        },
        {
            "featureType": "road.arterial",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "color": "#000000"
                }
            ]
        },
        {
            "featureType": "road.arterial",
            "elementType": "geometry.stroke",
            "stylers": [
                {
                    "color": "#0b3d51"
                },
                {
                    "lightness": 16
                }
            ]
        },
        {
            "featureType": "road.local",
            "elementType": "geometry",
            "stylers": [
                {
                    "color": "#000000"
                }
            ]
        },
        {
            "featureType": "transit",
            "elementType": "all",
            "stylers": [
                {
                    "color": "#146474"
                }
            ]
        },
        {
            "featureType": "water",
            "elementType": "all",
            "stylers": [
                {
                    "color": "#021019"
                }
            ]
        }
    ];

    var hq_lat      = 51.504435,
        hq_lng      = -0.1291664,
        hq_icon     = '/images/hq.png',
        access_icon = '/images/access.png',
        map         = new GMaps({
                        styles: styleArray,
                        div: "#geo_dashboard_map",
                        lat: hq_lat,
                        lng: hq_lng
                      });

    map.addMarker({
      lat: hq_lat,
      lng: hq_lng,
      infoWindow: {
        content: ('<p>MoJ</p>')
      },
      icon: hq_icon
    });

    $.get( "/api/dashboards/geographical", function(response) {
      response.data.forEach(function(location) {
        map.addMarker({
          lat: location.ip_location.lat,
          lng: location.ip_location.lng,
          infoWindow: {
            content: ('<p>' + location.ip_location.ip + '</p>')
          },
          icon: access_icon
        });

        map.drawPolyline({
          path: [[hq_lat, hq_lng], [location.ip_location.lat, location.ip_location.lng]],
          strokeColor: '#ffff00',
          strokeOpacity: 0.6,
          strokeWeight: 6
        });
      });
      map.fitZoom();
    });
  }
});

