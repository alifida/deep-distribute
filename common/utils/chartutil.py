
import json
from common.utils import util
import random
 

   
def createRandomChart(raw,title, chartTypes):
     
    charttype = random.choice(chartTypes)
    chartTemplate = charttype.template
    data = []
    jsonobj = json.loads(raw)
    
    for key in jsonobj:
        chartdata = {}
        chartdata["name"] = key
        chartdata["y"] = jsonobj[key]
        data.append(chartdata)
    
    seriesjson = util.tojson(data)
    
    seriesjson = chartTemplate.replace("____DATA____", seriesjson)
    seriesjson = seriesjson.replace("____SERIES____", seriesjson)
    seriesjson = seriesjson.replace("____TITLE____", title)
     
    
    return seriesjson
 
    
