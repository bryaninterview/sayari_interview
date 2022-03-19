curl -XPUT -H "Content-Type: application/json" http://localhost:9200/_index_template/openaq_mapping -d '
{
    "index_patterns": [
        "openaq*"
    ],
    "priority": 1,
    "template": {
        "settings": {
            "index": {
                "number_of_shards": "3",
                "number_of_replicas": "1"
            }
        },
        "mappings": {
            "dynamic": false,
            "properties": {
                "city": {
                    "type": "keyword"
                },
                "@timestamp": {
                    "type": "date"
                },
                "region": {
                    "type": "keyword"
                },
                "mobile": {
                    "type": "boolean"
                },
                "location_name": {
                    "type": "keyword"
                },
                "value": {
                    "type": "float",
                    "ignore_malformed": true
                },
                "country": {
                    "type": "keyword"
                },
                "source_type": {
                    "type": "keyword"
                },
                "parameter": {
                    "type": "keyword"
                },
                "unit": {
                    "type": "keyword"
                },
                "location": {
                    "type": "geo_point",
                    "ignore_malformed": true
                }
            }
        }
    },
    "allow_auto_create": true
}'
echo ""
