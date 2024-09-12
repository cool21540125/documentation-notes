
/* cluster 內的 documents 數量 */
get /_count
{
    "query": {
        "match_all": {}
    }
}

