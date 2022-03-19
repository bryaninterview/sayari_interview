## Instruction to run the entire assignment

### 0) Clone the repo

I will assume you clone the repo to /home/xxx/openaq_assignment

### 1) Run the 3 nodes Elasticsearch cluster stack using docker-compose

Please check the docker-compose.yml to check how I spinned up a 3 nodes Elastic cluster using version 7.17.1. To simplify, I have turned off all security features (node-to-node and https to simplify the task. Adding security will take some extra time to generate certificate, mounting certificates, etc...

Do sudo docker-compose up -d to run the entire stack. It should run no problem after the image 7.17.1 of Elasticsearch was downloaded

### 2) Check to see the Elasticsearch stack up and running

I mapped the port 9200 of the first node to the localhost 9200 port so you should be able to hit http://localhost:9200 to check if the cluster is up and running using command such as curl -XGET http://localhost:9200/_cat/_nodes (you should see 3 nodes)

### 3) Load the mapping for the openaq data

Run the script load_mapping.sh. If the script is not executable after you clone the repo. Please do chmod +x load_mapping.sh

### 4) Load the aq data

I assume you have already downloaded the openaq data to your local disk, it's located at something /home/xxx/openaq_data/
I was using this mapping to inflate the csv data (since the csv is header-less):
https://github.com/openaq/openaq-data-format/tree/master/upload


To load the data, you will need to:
1. Download the logstash 7.17.1 compatible with Elasticsearch 7.17.1 at: 
https://www.elastic.co/downloads/past-releases/logstash-7-17-1

2. Please download the tar.gz version so that you only need to unarchive it using tar -xzvf without installing anything. 
Let's say you unzip logstash to /home/xxx/logstash-7.17.1/

3. Go that logstash folder, then go down 1 level to bin, you should be in /home/xxx/logstash-7.17.1/bin using cd

4. Before running, please modify the aq.conf in the repo "path" under "file" and "input" section  to point to where the data files are. For instance, you have to point path to "/home/xxx/openaq_data/*.csv" or where you have the csv data

5. Once you are in the logstash path (/home/xxx/logstash-7.17.1/bin), type: ./logstash -f /home/xxx/openaq_assignment/aq.conf
(or whatever path where you cloned the assignment to, just make sure to point logstash to that logstash programmed config aq.conf in the repo)

6. You should see logstash starting to load data into your deployed elasticsearch, you can verify with curl http://localhost:9200/_cat/indices you should see the monthly-based openaq_* showing up in the index list returned

### 5) Querying

Run the script query_es.sh to query Elasticsearch

### Explaining the query
1. The pm10 filter is explanatory since data is stored where we store key and value separately so we have to filter by that parameter name
2. Second filter I applied after finding out that some pm10 value are negative (probably sensor error or a bias value being used to mark invalid sensor reading). Please note that negative pm10 value makes no sense
3. I am using top hits with sort so return the document with the smallest pm10 value. I limited to return only 3 documents per the query, you could also customize this value to return more documents
