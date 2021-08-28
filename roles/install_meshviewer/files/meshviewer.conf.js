module.exports = function () {
    return {
        // Array of data provider are supported
        'dataPath': [
            'https://map.freifunk-westerwald.de/data/'
        ],
        'siteName': 'Freifunk Westerwald',
        'mapLayers': [
            {
                'name': 'Freifunk Westerwald OSM Map',
                'url': 'https://map.freifunk-westerwald.de/osm/{z}/{x}/{y}.png', // {r} removed :)
                'config': {
                    'maxZoom': 19,
                    'subdomains': '1234',
                    'attribution': '<a href="http://www.openmaptiles.org/" target="_blank">&copy; OpenMapTiles</a> <a href="http://www.openstreetmap.org/about/" target="_blank" rel="noopener">&copy; OpenStreetMap contributors</a>',
                    'start': 6
                }
            }
        ],
        // Set a visible frame
        'fixedCenter': [
            // Northwest
            [
                50.7635,
                7.5347
            ],
            // Southeast
            [
                50.3361,
                8.2333
            ]
        ],
        'domainNames': [
            {
                'domain': 'ffww',
                'name': 'Westerwald(fastd)'
            },
            {
                'domain': 'ffww01',
                'name': 'Westerwald'
            }
        ],
        'linkList': [
            {
                'title': 'Impressum',
                'href': 'https://freifunk-westerwald.de/impressum/'
            },
            {
                'title': 'Datenschutz',
                'href': 'https://freifunk-westerwald.de/datenschutz/'
            }
        ]
    };
};