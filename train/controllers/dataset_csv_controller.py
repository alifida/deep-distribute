
from django.shortcuts import redirect
from train.models import Dataset, ChartType
from train.forms.forms import DatasetForm, TestDatasetForm
from common.utils import util, pandautil
from django.http.response import HttpResponse
from django.contrib.auth.decorators import login_required, permission_required
from common.utils.pandautil import    run_scikit_algo_cv 
from pandas.core.dtypes.inference import is_number
from django.shortcuts import get_object_or_404, HttpResponse
from common.utils.pandautil import   get_scikit_classifiers,\
     get_scikit_regressors, get_scikit_cluster,\
     get_scikit_transformer

import json


DEFAULT_TEST_PERCENT =.30
DEFAULT_TRAINING_PERCENT =.70



@login_required
@permission_required('datasource.view_dataset')
def get_algos_defaults(request):
    
    data ={}
    algoscsv= request.POST.get("selected_algos")
    algoslist = algoscsv.split(",")
    data["algos_details"] = pandautil.get_algos_defaults(algoslist)
    data["selected_algos"] = algoscsv
    return util.myrender(request, 'dataset_csv/algos_defaults.html', data)


@login_required
@permission_required('datasource.change_dataset')
def predict_dataset(request):
     
    datasetId = request.POST.get("dataset_id", "")
    dataset = Dataset.objects.get(pk=datasetId)
    
    algos = request.POST.getlist("algo",[])
    algo_type = request.POST.get("algo_type", "")
    
    test_option = request.POST.get("test_option") # 1= test_train_split, 2=CV, 3= Supply test set
    #test_option = '1'
    splits = request.POST.get("splits")
    normalize =request.POST.get("normalize");
    normalize_min = request.POST.get("normalize_min")
    normalize_max = request.POST.get("normalize_max")
    
    if test_option == '3':
        testDatasetForm = TestDatasetForm(request.POST, request.FILES, instance = dataset)
        if (testDatasetForm.is_valid()):
            dataset = testDatasetForm.save(commit=True)
    
    class_label = request.POST.get("class_label", "")
    key_attributes = request.POST.getlist("key_attributes",[])
     
    test_p = request.POST.get("test_percent", "")
   
    chart_data={}
    res={}
    res_status = True
    res_message = ""
    classifiers = []
    
    if(splits.isdigit()):
        splits = int(splits)
    else:
        splits = int(0)

    
    params = {
            
            'algo_type':algo_type,
            'dataset_path':dataset.dataset.path,
            'test_dataset_path':'',
            'test_p':float(test_p),
            'class_label':class_label,
            'key_attributes':key_attributes,
            'test_option':test_option,
            'splits':splits,
            'normalize':normalize,
            'normalize_min':normalize_min,
            'normalize_max':normalize_max,
            'dataset_id': dataset.id,
            'user_id': dataset.user.id,
            'dataset_name': dataset.description
            }
    
    if test_option == '3':
        params['test_dataset_path' ] = dataset.dataset_test.path 
    
    for algo in algos:
        
        try:
            params[ 'algo_name'] = algo
            
            algo_params ={}
            for param_key, param in request.POST.items():
                arrang_request_params(algo_params, algo,param_key, request)      
            
            classifier={}
              
            classifier = run_scikit_algo_cv(params, algo_params)
            
            classifier["classifier"] = algo
            
            if classifier["status"] ==  "success":
                prepare_primary_chart_data(chart_data, classifier)
               
                res_status &= True
                
            else:
                res_status &= False
                res_message += "<br/><b><u>" +algo+"</u></b>:  "+ classifier["message"]
            classifiers.append(classifier)
        except Exception as ex:
            print(ex)
            res_status &= False
            res_message += "<br/><b><u> Error occured for algo : " +algo+ ", Error: " +str(ex)+"</u></b>:  " 
    
    charts = []
    
    colors ='["#ffc107","#17a2b8","#28a745","#dc3545","#c2de24","#32cab4", "#ca329b","#ff93c0", "#dc3545", "#dc6835", "#dcbc35", "#4bb106", "#0666b1", "#5406b1", "#b106a7", "#b10631", "#ad8543", "#43ad44", "#ff0202", "#ffcf02", "#68ff02", "#02beff", "#0203ff", "#ff02fc", "#ff0207"]'
    
    
    
    if "primary_series" in chart_data :
        primary_series_json = util.tojson(chart_data["primary_series"])
        primary_categories_json = util.tojson(chart_data["primary_categories"])
        primary_chart = prepare_chart(primary_series_json, primary_categories_json, 23, "Summary", colors, 'auto')
        charts.append(primary_chart)
        
    if "secondary_series" in chart_data :   
        colors ='[ "#dc6835", "#dcbc35", "#4bb106", "#0666b1","#ffc107","#17a2b8","#28a745","#dc3545","#c2de24","#32cab4", "#ca329b","#ff93c0", "#dc3545", "#5406b1", "#b106a7", "#b10631", "#ad8543", "#43ad44", "#ff0202", "#ffcf02", "#68ff02", "#02beff", "#0203ff", "#ff02fc", "#ff0207"]'
        secondary_series_json = util.tojson(chart_data["secondary_series"])
        secondary_categories_json = util.tojson(chart_data["secondary_categories"])
        secondary_chart = prepare_chart(secondary_series_json, secondary_categories_json, 31,  "Error Comparison" , colors, 'auto')
        
        charts.append(secondary_chart)
        
        
        res["charts"] = charts
    
    if res_status :
        res["status"] = "success"
        res["message"] = 'Request processed successfully'
    else: 
        res["status"]="error"
        res["message"] = res_message
    
    
    res["classifiers"] = classifiers
    
    jsondata = util.tojson(res)  

    return HttpResponse(jsondata);
    
def prepare_chart(series_json, categories_json, chart_type_id, title, colors, height='auto'):
    
    chartType = ChartType.objects.get(pk=chart_type_id)
    chartTemplate = chartType.template
   
    chartTemplate = chartTemplate.replace("____CATEGORIES____", categories_json)
    chartTemplate = chartTemplate.replace("____HEIGHT____", height)
    chartTemplate = chartTemplate.replace("____COLORS____", colors)
    chartTemplate = chartTemplate.replace("____SERIES____", series_json)
    chartTemplate = chartTemplate.replace("____TITLE____", title)
    return chartTemplate;  
    
def prepare_primary_chart_data(chart_data, classifier):
    
    print (classifier["classifier"])
    if  "categories" not in chart_data.keys() and "primary_info" in  classifier.keys():
        categories = []
        for key, value in classifier['primary_info'].items():
            if is_number( classifier['primary_info'][key]):
                categories.append(key)
    
   
        chart_data["primary_categories"] = categories
        
    primary_series_data = []
    for category in chart_data["primary_categories"]:
        try:
            primary_series_data.append(classifier['primary_info'][category])
        except Exception as ex:
            print(ex)
    
       
    primary_series = {}
    primary_series["name"] =classifier['classifier']
    primary_series["data"] =primary_series_data
    
    if "primary_series" not in  chart_data:
        chart_data["primary_series"]= []
    chart_data["primary_series"].append(primary_series)
    
    
    
    
    chart_data["secondary_categories"] = ["Errors"]
    secondary_series_data = classifier['secondary_info'] ['errors']
    #'Mean squared error'
    #secondary_series_data.append(classifier['secondary_info'])
    
    secondary_series = {}
    secondary_series["name"] =classifier['classifier']
    secondary_series["data"] =secondary_series_data
    
    if "secondary_series" not in  chart_data:
        chart_data["secondary_series"]= []
    chart_data["secondary_series"].append(secondary_series)
     
       
    return chart_data
    
def arrang_request_params(algo_params, algo,param_key, request):
    if param_key.startswith(algo) and not param_key.endswith("___type"):
        param_name = param_key.replace(algo + "_","")
        #string, int, float, bool
        d_type = request.POST.get(param_key + "___type")
        param_val = request.POST.get(param_key)
        if 'warm_start' == param_name:
            print("----------")
            
        print(param_name+"--------------")
        if param_val == 'None':
            algo_params[param_name] = None  
            
        elif d_type =='int':
            if param_val == '':
                param_val = None
                algo_params[param_name] = param_val
            else:
                algo_params[param_name] = int(param_val)
        
        elif d_type =='float':
            if param_val == '':
                param_val = None
                algo_params[param_name] = param_val
            else:
                algo_params[param_name] = float(param_val)
                    
        elif d_type =='float-or-int' or d_type =='int-or-float':
            if param_val == '':
                param_val = None
                algo_params[param_name] = param_val
            else: 
                param_val = float(param_val)
                if param_val.is_integer():
                    param_val = int(param_val)
                else:
                    param_val = float(param_val)
                 

        elif d_type =='bool':
            if param_val == '':
                param_val = None
                algo_params[param_name] = param_val
            else:
                if 'True' == param_val:
                    algo_params[param_name] = True
                else:
                    algo_params[param_name] = False
        
        else: 
            algo_params[param_name] = str(param_val)
        
                
            
    
@login_required
@permission_required('datasource.add_dataset')
@permission_required('datasource.change_dataset')
def save_dataset(request):
    data = {}
    if request.method == 'POST':
        datasetForm = DatasetForm(request.POST, request.FILES)
        if (datasetForm.is_valid()):
            
       
            res = datasetForm.save(commit=False)
            res.user = request.user
            res.save()
            print(res.pk)
             
            details = pandautil.get_details(res.dataset.path)
            
            
            dataset = Dataset.objects.get(pk=res.pk)
            #print(util.tojson(headers))
            dataset.metainfo = util.tojson(details)
            Dataset.save(dataset)
            #createColumnWiseCharts(columnsChartData, dataset)
            datasetForm = DatasetForm()
        
    else:
        datasetForm = DatasetForm()
        
    data["datasetForm"] = datasetForm
    return util.myrender(request, 'dataset_csv/form.html', data)



@login_required
@permission_required('datasource.view_dataset')
def getDatasets(request):
    #datasets = Dataset.objects.all()
    
    if request.user.is_authenticated:
        username = request.user
        datasets = Dataset.objects.filter(user_id=username.id)
    return datasets


@permission_required('datasource.view_dataset')
def preview_dataset(request, pk):
    data = {}
    #details = {"test":"data"}
    dataset = Dataset.objects.get(pk=pk)
    
    data["classifiers"] = get_scikit_classifiers()
    data["clusters"] = get_scikit_cluster()
    data["regressors"] = get_scikit_regressors()
    data["regressors"].append('Keras')
    
    data["transformers"] = get_scikit_transformer()
    
    data["default_test_percent"] = DEFAULT_TEST_PERCENT
    data["default_training_percent"] = DEFAULT_TRAINING_PERCENT


    data["dataset"] = dataset
    data["metainfo"] = json.loads(dataset.metainfo)
    totalInstances = data["metainfo"]["details"]["total_instances"]
    data["loop_range"] = range(0, totalInstances)
    
    testDatasetForm = TestDatasetForm()
    #testDatasetForm.pk=pk
    
    data["testDatasetForm"] = testDatasetForm
    
    data['dataset_list'] = getDatasets(request)
    
    #data["details"] = details
    
   
#     test = pandautil.get_details(dataset.dataset.path)
#     testjson = util.tojson(test)
    return util.myrender(request, 'dataset_csv/preview.html', data)


@login_required
@permission_required('datasource.delete_dataset')
def delete_dataset(request, pk):
    
    if request.method == 'POST':
        dataset = Dataset.objects.get(pk=pk)
        res = dataset.delete()
        print(res)
    return redirect('model_welcome')

@login_required 
@permission_required('datasource.view_dataset')
def list_dataset(request):
    data = {}
    data ["section_heading"]=''
    data['dataset_list'] = getDatasets(request)
    
    data['dataset_count']=0
    
    if data['dataset_list'].exists():
        data['dataset_count']=data['dataset_list'].count()
    

    return util.myrender(request, 'dataset_csv/list.html', data)

 
    
    
@login_required
@permission_required('datasource.view_dataset')
def getDatasets(request):
    #datasets = Dataset.objects.all()
    if request.user.is_authenticated:
        username = request.user
        datasets = Dataset.objects.filter(user_id=username.id)
    return datasets


@login_required
@permission_required('datasource.delete_dataset')
def deleteDataset(request, pk):
    
    if request.method == 'POST':
        dataset = Dataset.objects.get(pk=pk)
        res = dataset.delete()
        print(res)
    return redirect('datasetIndex')
 

 

 

