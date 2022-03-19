curl -XPOST -H "Content-Type: application/json" http://localhost:9200/openaq_*/_search -d '{
    "query": {
        "bool": {
            "filter": [
                {
                    "term": {
                        "parameter": "pm10"
                    }
                },
                {
                    "range": {
                        "value": {
                            "gte": 1e-12
                        }
                    }
                }
            ]
        }
    },
    "aggs": {
        "top_hit_agg": {
            "top_hits": {
                "sort": [
                    {
                        "value": {
                            "order": "asc"
                        }
                    }
                ],
                "size": 3
            }
        }

    },
    "size": 0
}'
