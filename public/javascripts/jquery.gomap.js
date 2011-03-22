/**
 * jQuery goMap
 *
 * @url		http://www.pittss.lv/jquery/gomap/
 * @author	Jevgenijs Shtrauss <pittss@gmail.com>
 * @version	1.3.0 2011.02.28
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 */

(function($) {
	var geocoder = new google.maps.Geocoder();

	function MyOverlay(map) { this.setMap(map); };
	MyOverlay.prototype = new google.maps.OverlayView();
	MyOverlay.prototype.onAdd = function() { };
	MyOverlay.prototype.onRemove = function() { };
	MyOverlay.prototype.draw = function() { };

	$.goMap = {};

	$.fn.goMap = function(options) {
		return this.each(function() {
			var goMap = $(this).data('goMap');
			if(!goMap) {
				var goMapBase = $.extend(true, {}, $.goMapBase);
				$(this).data('goMap', goMapBase.init(this, options));
				$.goMap = goMapBase;
			}
			else {
				$.goMap = goMap;
			}
		});
	};

	$.goMapBase = {
		defaults: {
			address:					'', // Street, City, Country
			latitude:					41.3966667,
			longitude:					-73.0763889,
			zoom:						16,
			delay:						200,
			hideByClick:				true,
			oneInfoWindow:				true,
			prefixId:					'gomarker',
			groupId:					'gogroup',
		    navigationControl:			true, // Show or hide navigation control
			navigationControlOptions:	{
				position:	'TOP_LEFT', // TOP, TOP_LEFT, TOP_RIGHT, BOTTOM, BOTTOM_LEFT, BOTTOM_RIGHT, LEFT, RIGHT
				style:		'DEFAULT' // DEFAULT, ANDROID, SMALL, ZOOM_PAN
			},
		    mapTypeControl: 			true, // Show or hide map control
			mapTypeControlOptions:		{
				position: 	'TOP_RIGHT', // TOP, TOP_LEFT, TOP_RIGHT, BOTTOM, BOTTOM_LEFT, BOTTOM_RIGHT, LEFT, RIGHT
				style: 		'DEFAULT' // DEFAULT, DROPDOWN_MENU, HORIZONTAL_BAR
			},
		    scaleControl: 				false, // Show or hide scale
			scrollwheel:				true, // Mouse scroll whell
		    directions: 				false,
		    directionsResult: 			null,
			disableDoubleClickZoom:		false,
			streetViewControl:			false,
			markers:					[],
			maptype:					'HYBRID', // Map type - HYBRID, ROADMAP, SATELLITE, TERRAIN
			html_prepend:				'<div class=gomapMarker>',
			html_append:				'</div>',
			addMarker:					false
		},		
		map:			null,
		count:			0,
		markers:		[],
		tmpMarkers:		[],
		geoMarkers:		[],
		lockGeocode:	false,
		bounds:			null,
		overlay:		null,
		mapId:			null,
		opts:			null,
		centerLatLng:	null,

		init: function(el, options) {
			var opts 	= $.extend({}, $.goMapBase.defaults, options);
			this.mapId	= $(el);
			this.opts	= opts;

			if (opts.address)
				this.geocode({address: opts.address, center: true});
//			else if (opts.latitude != $.goMapBase.defaults.latitude && opts.longitude != $.goMapBase.defaults.longitude)
//				this.centerLatLng = new google.maps.LatLng(opts.latitude, opts.longitude);
			else if ($.isArray(opts.markers) && opts.markers.length > 0) {
				if (opts.markers[0].address)
					this.geocode({address: opts.markers[0].address, center: true});
				else
					this.centerLatLng = new google.maps.LatLng(opts.markers[0].latitude, opts.markers[0].longitude);
			}
			else
				this.centerLatLng = new google.maps.LatLng(opts.latitude, opts.longitude);

			var myOptions = {
				center: 				this.centerLatLng,
				disableDoubleClickZoom:	opts.disableDoubleClickZoom,
		        mapTypeControl:			opts.mapTypeControl,
				streetViewControl:		opts.streetViewControl,
				mapTypeControlOptions:  {
					position:	eval('google.maps.ControlPosition.' + opts.mapTypeControlOptions.position.toUpperCase()),
					style:		eval('google.maps.MapTypeControlStyle.' + opts.mapTypeControlOptions.style.toUpperCase())
				},
				mapTypeId:				eval('google.maps.MapTypeId.' + opts.maptype.toUpperCase()),
        		navigationControl:		opts.navigationControl,
				navigationControlOptions: {
					position:	eval('google.maps.ControlPosition.' + opts.navigationControlOptions.position.toUpperCase()),
					style:		eval('google.maps.NavigationControlStyle.' + opts.navigationControlOptions.style.toUpperCase())
				},
		        scaleControl:			opts.scaleControl,
		        scrollwheel:			opts.scrollwheel,
				zoom:					opts.zoom
			};

			this.map 		= new google.maps.Map(el, myOptions);
			this.overlay	= new MyOverlay(this.map);

			for (var j = 0; j < opts.markers.length; j++)
				this.createMarker(opts.markers[j]);

			var goMap = this;
			if (opts.addMarker == true || opts.addMarker == 'multi') {
				google.maps.event.addListener(goMap.map, 'click', function(event) {
					var options = {
						position:  event.latLng,
						draggable: true
					};

					var marker = goMap.createMarker(options);

					google.maps.event.addListener(marker, 'dblclick', function(event) {
						marker.setMap(null);
						goMap.removeMarker(marker.id);
					});

				});
			}
			else if (opts.addMarker == 'single') {
				google.maps.event.addListener(goMap.map, 'click', function(event) {
					if(!goMap.singleMarker) {
						var options = {
							position:  event.latLng,
							draggable: true
						};

						var marker = goMap.createMarker(options);
						goMap.singleMarker = true;

						google.maps.event.addListener(marker, 'dblclick', function(event) {
							marker.setMap(null);
							goMap.removeMarker(marker.id);
							goMap.singleMarker = false;
						});
					}
				});
			}
			return this;
		},

		ready: function(f) {
			google.maps.event.addListenerOnce(this.map, 'bounds_changed', function() { 
				return f();
		    }); 
		},

		geocode: function(address, options) {
			var goMap = this;
			setTimeout(function() {
				geocoder.geocode({'address': address.address}, function(results, status) {
		        	if (status == google.maps.GeocoderStatus.OK && address.center)
						goMap.map.setCenter(results[0].geometry.location);

					if (status == google.maps.GeocoderStatus.OK && options && options.markerId)
						options.markerId.setPosition(results[0].geometry.location);

					else if (status == google.maps.GeocoderStatus.OK && options) {
						if(goMap.lockGeocode) {
							goMap.lockGeocode = false;
							options.position  = results[0].geometry.location;
							options.geocode   = true;
							goMap.createMarker(options);
						}
					}
					else if(status == google.maps.GeocoderStatus.OVER_QUERY_LIMIT) {
						goMap.geocode(address, options);
					}
   	   			});
			}, this.opts.delay);
		},

		geoMarker: function() {
			if(this.geoMarkers.length > 0 && !this.lockGeocode) {
				this.lockGeocode = true;
				var current = this.geoMarkers.splice(0, 1);
				this.geocode({address:current[0].address}, current[0]);
			}
			else if(this.lockGeocode) {
				var goMap = this;
				setTimeout(function() {
					goMap.geoMarker();
				}, this.opts.delay);
			}
		},

		setMap: function(options) {
			delete options.mapTypeId;

			if (options.address) {
				this.geocode({address: options.address, center: true});
				delete options.address;
			}
			else if (options.latitude && options.longitude) {
				options.center = new google.maps.LatLng(options.latitude, options.longitude);
				delete options.longitude;
				delete options.latitude;
			}

			if(options.mapTypeControlOptions && options.mapTypeControlOptions.position)
				options.mapTypeControlOptions.position = eval('google.maps.ControlPosition.' + options.mapTypeControlOptions.position.toUpperCase());

			if(options.mapTypeControlOptions && options.mapTypeControlOptions.style)
				options.mapTypeControlOptions.style = eval('google.maps.MapTypeControlStyle.' + options.mapTypeControlOptions.style.toUpperCase());

			if(options.navigationControlOptions && options.navigationControlOptions.position)
				options.navigationControlOptions.position = eval('google.maps.ControlPosition.' + options.navigationControlOptions.position.toUpperCase());

			if(options.navigationControlOptions && options.navigationControlOptions.style)
				options.navigationControlOptions.style = eval('google.maps.NavigationControlStyle.' + options.navigationControlOptions.style.toUpperCase());

			this.map.setOptions(options);
		},

		getMap: function() {
		   return this.map;
		},

		createListener: function(type, event, data) {
			var target;

			if(typeof type != 'object')
				type = {type:type};

			if(type.type == 'map')
				target = this.map;
			else if(type.type == 'marker' && type.marker)
				target = $(this.mapId).data(type.marker);
			else if(type.type == 'info' && type.marker)
				target = $(this.mapId).data(type.marker + 'info');

			if(target)
				return google.maps.event.addListener(target, event, data);
			else if((type.type == 'marker' || type.type == 'info') && this.getMarkerCount() != this.getTmpMarkerCount())
				setTimeout(function() {
					this.createListener(type, event, data);
				}, this.opts.delay);
		},

		removeListener: function(listener) {
			google.maps.event.removeListener(listener);
		},

		setInfoWindow: function(marker, html) {
			var goMap = this;
			html.content    = goMap.opts.html_prepend + html.content + goMap.opts.html_append;
			var infowindow  = new google.maps.InfoWindow(html);
			infowindow.show = false;

			$(goMap.mapId).data(marker.id + 'info',infowindow);

			if (html.popup) {
				goMap.openWindow(infowindow, marker, html);
				infowindow.show = true;
			}

			google.maps.event.addListener(marker, 'click', function() {
				if (infowindow.show && goMap.opts.hideByClick) {
					infowindow.close();
					infowindow.show = false;
				}
				else {
					goMap.openWindow(infowindow, marker, html);
					infowindow.show = true;
				}
			});
		},

		openWindow: function(infowindow, marker, html) {
			if(this.opts.oneInfoWindow)
				this.clearInfo();

			if (html.ajax) {
				infowindow.open(this.map, marker);
				$.ajax({
					url: html.ajax,
					success: function(html) {
						infowindow.setContent(html);
					}
				});
			}
			else if (html.id) {
				infowindow.setContent($(html.id).html());
				infowindow.open(this.map, marker);
			}
			else
				infowindow.open(this.map, marker);
		},

		setInfo: function(id, text) {
			var info = $(this.mapId).data(id + 'info');

			if(typeof text == 'object')
				info.setOptions(text);
			else
				info.setContent(text);
		},

		getInfo: function(id, hideDiv) {
			 var info = $(this.mapId).data(id + 'info').getContent();
			if(hideDiv)
				return $(info).html();
			else
				return info;
		},

		clearInfo: function() {
			for (var i in this.markers) {
				var info = $(this.mapId).data(this.markers[i] + 'info');
				if(info) {
					info.close();
					info.show = false;
				}
			}
		},

		fitBounds: function(type, markers) {
			var goMap = this;
			if(this.getMarkerCount() != this.getTmpMarkerCount())
				setTimeout(function() {
					goMap.fitBounds(type, markers);
				}, this.opts.delay);
			else {
				this.bounds = new google.maps.LatLngBounds();

				if(!type || (type && type == 'all')) {
					for (var i in this.markers) {
						this.bounds.extend($(this.mapId).data(this.markers[i]).position);
					}
				}
				else if (type && type == 'visible') {
					for (var i in this.markers) {
						if(this.getVisibleMarker(this.markers[i]))
							this.bounds.extend($(this.mapId).data(this.markers[i]).position);
					}
	
				}
				else if (type && type == 'markers' && $.isArray(markers)) {
					for (var i in markers) {
						this.bounds.extend($(this.mapId).data(markers[i]).position);
					}
				}
				this.map.fitBounds(this.bounds);
			}
		},

		getBounds: function() {
			return this.map.getBounds();
		},

		showHideMarker: function(marker, display) {
			if(typeof display === 'undefined') {
				if(this.getVisibleMarker(marker)) {
					$(this.mapId).data(marker).setVisible(false);
					var info = $(this.mapId).data(marker + 'info');
					if(info && info.show) {
						info.close();
						info.show = false;
					}
				}
				else
					$(this.mapId).data(marker).setVisible(true);
			}
			else
				$(this.mapId).data(marker).setVisible(display);
		},

		showHideMarkerByGroup: function(group, display) {
			for (var i in this.markers) {
				var markerId = this.markers[i];
				var marker	 = $(this.mapId).data(markerId);
				if(marker.group == group) {
					if(typeof display === 'undefined') {
						if(this.getVisibleMarker(markerId)) {
							marker.setVisible(false);
							var info = $(this.mapId).data(markerId + 'info');
							if(info && info.show) {
								info.close();
								info.show = false;
							}
						}
						else
							marker.setVisible(true);
					}
					else
						marker.setVisible(display);
				}
			}
		},

		getVisibleMarker: function(marker) {
			return $(this.mapId).data(marker).getVisible();
		},

		getMarkerCount: function() {
			return this.markers.length;
		},

		getTmpMarkerCount: function() {
			return this.tmpMarkers.length;
		},

		getVisibleMarkerCount: function() {
			return this.getMarkers('visiblesInMap').length;
		},

		getMarkerByGroupCount: function(group) {
			return this.getMarkers('group', group).length;
		},

		getMarkers: function(type, name) {
			var array = [];
			switch(type) {
				case "json":
					for (var i in this.markers) {
						var temp = "'" + i + "': '" + $(this.mapId).data(this.markers[i]).getPosition().toUrlValue() + "'";
						array.push(temp);
					}
					array = "{'markers':{" + array.join(",") + "}}";
					break;
				case "data":
					for (var i in this.markers) {
						var temp = "marker[" + i + "]=" + $(this.mapId).data(this.markers[i]).getPosition().toUrlValue();
						array.push(temp);
					}
					array = array.join("&"); 					
					break;
				case "visiblesInBounds":
					for (var i in this.markers) {
						if (this.isVisible($(this.mapId).data(this.markers[i]).getPosition()))
							array.push(this.markers[i]);
					}
					break;
				case "visiblesInMap":
					for (var i in this.markers) {
						if(this.getVisibleMarker(this.markers[i]))
							array.push(this.markers[i]);
					}
					break;
				case "group":
					if(name)
						for (var i in this.markers) {
							if($(this.mapId).data(this.markers[i]).group == name)
								array.push(this.markers[i]);
						}
					break;
				case "markers":
					for (var i in this.markers) {
						var temp = $(this.mapId).data(this.markers[i]);
						array.push(temp);
					}
					break;
				default:
					for (var i in this.markers) {
						var temp = $(this.mapId).data(this.markers[i]).getPosition().toUrlValue();
						array.push(temp);
					}
					break;
			}
			return array;
		},

		getVisibleMarkers: function() {
			return this.getMarkers('visiblesInBounds');
		},

		createMarker: function(marker) {
			if (!marker.geocode) {
				this.count++;
				if (!marker.id)
					marker.id = this.opts.prefixId + this.count;
				this.tmpMarkers.push(marker.id);
			}
			if (marker.address && !marker.geocode) {
				this.geoMarkers.push(marker);
				this.geoMarker();
			}
			else if (marker.latitude && marker.longitude || marker.position) {
				var options = { map:this.map };
				options.id 			= marker.id;
				options.group		= marker.group ? marker.group : this.opts.groupId; 
				options.zIndex 		= marker.zIndex ? marker.zIndex : 0;
				options.zIndexOrg	= marker.zIndexOrg ? marker.zIndexOrg : 0;

				if (marker.visible == false)
					options.visible = marker.visible;

				if (marker.title)
					options.title = marker.title;

				if (marker.draggable)
					options.draggable = marker.draggable;

				if (marker.icon && marker.icon.image) {
					options.icon = marker.icon.image;
					if (marker.icon.shadow)
						options.shadow = marker.icon.shadow;
				}
				else if (marker.icon)
					options.icon = marker.icon;

				else if (this.opts.icon && this.opts.icon.image) {
					options.icon = this.opts.icon.image;
					if (this.opts.icon.shadow)
						options.shadow = this.opts.icon.shadow;
				}
				else if (this.opts.icon)
					options.icon = this.opts.icon;

				options.position = marker.position ? marker.position : new google.maps.LatLng(marker.latitude, marker.longitude);

				var cmarker = new google.maps.Marker(options);

				if (marker.html) {
					if (!marker.html.content && !marker.html.ajax && !marker.html.id)
						marker.html = { content:marker.html };
					else if (!marker.html.content)
						marker.html.content = null;

					this.setInfoWindow(cmarker, marker.html);
				}
				this.addMarker(cmarker);
				return cmarker;
			}
		},

		addMarker: function(marker) {
			$(this.mapId).data(marker.id, marker);
			this.markers.push(marker.id);
		},

		setMarker: function(marker, options) {
			var tmarker = $(this.mapId).data(marker);

			delete options.id;
			delete options.visible;

			if(options.icon) {
				var toption = options.icon;
				delete options.icon;

				if(toption && toption == 'default') {
					if (this.opts.icon && this.opts.icon.image) {
						options.icon = this.opts.icon.image;
						if (this.opts.icon.shadow)
							options.shadow = this.opts.icon.shadow;
					}
					else if (this.opts.icon)
						options.icon = this.opts.icon;
				}
				else if(toption && toption.image) {
					options.icon = toption.image;
					if (toption.shadow)
						options.shadow = toption.shadow;
				}
				else if (toption)
					options.icon = toption;
			}

			if (options.address) {
				this.geocode({address: options.address}, {markerId:tmarker});
				delete options.address;
				delete options.latitude;
				delete options.longitude;
				delete options.position;
			}
			else if (options.latitude && options.longitude || options.position) {
				if (!options.position)
					options.position = new google.maps.LatLng(options.latitude, options.longitude);
			}
			tmarker.setOptions(options);
		},

		removeMarker: function(marker) {
			var index = $.inArray(marker, this.markers), current;
			if (index > -1) {
				this.tmpMarkers.splice(index,1);
				current = this.markers.splice(index,1);
				var markerId = current[0];
				var marker   = $(this.mapId).data(markerId);
				var info     = $(this.mapId).data(markerId + 'info');

				marker.setVisible(false);
				marker.setMap(null);
				$(this.mapId).removeData(markerId);

				if(info) {
					info.close();
					info.show = false;
					$(this.mapId).removeData(markerId + 'info');
				}
				return true;
			}
			return false;
		},

		clearMarkers: function() {
			for (var i in this.markers) {
				var markerId = this.markers[i];
				var marker   = $(this.mapId).data(markerId);
				var info     = $(this.mapId).data(markerId + 'info');

				marker.setVisible(false);
				marker.setMap(null);
				$(this.mapId).removeData(markerId);

				if(info) {
					info.close();
					info.show = false;
					$(this.mapId).removeData(markerId + 'info');
				}
			}
			this.singleMarker = false;
			this.lockGeocode = false;
			this.markers = [];
			this.tmpMarkers = [];
			this.geoMarkers = [];
		},

		isVisible: function(latlng) {
			return this.map.getBounds().contains(latlng);
		}
	}
})(jQuery);