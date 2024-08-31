from sklearn.utils import all_estimators
import pandas as pd
import numpy as np
import os
from common.utils import util, chartutil
import json
from pandas.core.dtypes.common import is_string_dtype, is_numeric_dtype
from pandas._libs.parsers import is_bool_dtype
import time

from sklearn.linear_model import LogisticRegression
from sklearn.svm import LinearSVC
from sklearn.model_selection import train_test_split
 
from sklearn.ensemble import RandomForestRegressor 
from sklearn import metrics 
import traceback
import sys

from sklearn.model_selection import cross_val_predict

from sklearn import preprocessing
from sklearn.preprocessing._data import MinMaxScaler
from sklearn.model_selection._split import KFold

import joblib


from keras.models import Sequential
from keras.layers import Dense
from keras.wrappers.scikit_learn import KerasRegressor
from sklearn.model_selection import cross_val_score

from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline

from pathlib import Path
from django.conf import settings
from train.models import TrainedModel
# 

"""
dymanically import class, function and var
from django.utils.module_loading import import_string
# 
# Klass = import_string('path.to.module.Klass')
# func = import_string('path.to.module.func')
# var = import_string('path.to.module.var')
"""

 

def logistic_regresssion(path,  test_p, class_label, key_attributes):
    
    lr = LogisticRegression()
    df = pd.read_csv(path,encoding= 'unicode_escape')

    train, test = train_test_split(df, test_size = test_p)
   
    train_features = train[key_attributes]
    train_target = train[class_label]
    
    test_features = test[key_attributes]
    test_target = test[class_label]
     
     
     
     
    #Prediction----- 
    regressor = LogisticRegression()
    regressor.fit(train_features, train_target)
    cl_prediction = regressor.predict(test_features)

    

    res = {}
    primary_info = {}
    secondary_info = {}
    primary_info['Mean Absolute Error'] = round(metrics.mean_absolute_error(test_target, cl_prediction), 3)
    primary_info['Mean Squared Error'] = round(metrics.mean_squared_error(test_target, cl_prediction), 3)
    primary_info['Root Mean Squared Error'] = round(np.sqrt(metrics.mean_squared_error(test_target, cl_prediction)),3)
    
    secondary_info['predicted'] = cl_prediction.tolist()

    res['primary_info'] = primary_info
    res['secondary_info'] = secondary_info 
    
    
    print('Mean Absolute Error:', metrics.mean_absolute_error(test_target, cl_prediction))
    print('Mean Squared Error:', metrics.mean_squared_error(test_target, cl_prediction))
    print('Root Mean Squared Error:', np.sqrt(metrics.mean_squared_error(test_target, cl_prediction)))
    return res


    
    
def linear_svc(path,  test_p, class_label, key_attributes):

    
    df = pd.read_csv(path,encoding= 'unicode_escape')

    train, test = train_test_split(df, test_size = test_p)
   
    train_features = train[key_attributes]
    train_target = train[class_label]
    
    test_features = test[key_attributes]
    test_target = test[class_label]
     
     
     
     
    #Prediction----- 
    regressor = LinearSVC(C=1.0)
    regressor.fit(train_features, train_target)
    cl_prediction = regressor.predict(test_features)

    
    res = {}
    primary_info = {}
    secondary_info = {}
    primary_info['Mean Absolute Error'] = round(metrics.mean_absolute_error(test_target, cl_prediction), 3)
    primary_info['Mean Squared Error'] = round(metrics.mean_squared_error(test_target, cl_prediction), 3)
    primary_info['Root Mean Squared Error'] = round(np.sqrt(metrics.mean_squared_error(test_target, cl_prediction)),3)

    secondary_info['predicted'] = cl_prediction.tolist()

    res['primary_info'] = primary_info
    res['secondary_info'] = secondary_info
     
    print('Mean Absolute Error:', metrics.mean_absolute_error(test_target, cl_prediction))
    print('Mean Squared Error:', metrics.mean_squared_error(test_target, cl_prediction))
    print('Root Mean Squared Error:', np.sqrt(metrics.mean_squared_error(test_target, cl_prediction)))
    return res
    


def get_scikit_classifiers():
    return get_scikit_algo('classifier')

def get_scikit_regressors():
    return get_scikit_algo('regressor')

def get_scikit_cluster():
    return get_scikit_algo('cluster')

def get_scikit_transformer():
    return get_scikit_algo('transformer')

def get_scikit_algo(type):
     
    estimators = all_estimators(type_filter=type)
    list = []
    for name, ClassifierClass in estimators:
        #print(name)
        try:
            list.append(name)
        except Exception as e:
            print('Unable to import', name)
            print(e)
    return list 


def get_scikit_algo_details():
     
    estimators = all_estimators()
    dic = {}
    for name, ClassifierClass in estimators:
        #print(name)
        try:
            dic[name] = ClassifierClass

        except Exception as e:
            #print('Unable to import', name)
            print(e)
    
    return dic 
"""
from django.utils.module_loading import import_string
def get_and_import_class(class_name):
    dic = get_scikit_algo_details('regressor')
    cls = dic[class_name]
    klass = import_string(cls)
    return cls
"""

def get_algos_defaults(algolist):
    
    estimators = all_estimators()
    dic = {}
    for algo_name in algolist:
        for name, ClassifierClass in estimators:
            try:
                if name == algo_name:
                    algo = None
                    try:
                        algo = ClassifierClass()
                    except Exception as ex:
                        print(ex)
                        if str(ex).find("missing 1"):
                            algo = ClassifierClass(None)
                    
                    params = algo.get_params()
                    doc = algo.__doc__
                    
                    algo_details ={}
                        
                    for param in params:
                        details = {}
                        details = get_param_type(param, doc)
                        algo_details[param] = details 
                        
                    dic[algo_name] = algo_details
                    break
                    
            except Exception as e:
                #print('Unable to import', name)
                
                print(e)
    return dic 

def get_param_type(param, doc):
    detail = {}
    detail["param_name"] = param
    param_doc = ""
    param_type_details ={}
    startappending = False
    line_for_type = ""
        
        
    for line in doc.splitlines():
            
        if startappending==False and line.startswith("    "+param):
            line_for_type = line
            startappending = True
            param_doc += line

        elif startappending==True :
                
            if (line.startswith("     ") or len(line)<2):
                if line_for_type.endswith('\\'):
                    line_for_type = line_for_type[:-2]
                    line_for_type += line
                
                param_doc += line
                
            else:
                startappending = False
                param_type_details = identify_param_type(param, line_for_type)
                line_for_type = ""
                break
         
    detail["param_doc"] = param_doc
    detail["param_type"] = param_type_details
    return detail  

def identify_param_type(param, line):
    type_dic ={} 
    d_type = ""
    line = line.replace(param+" : ", '', 1)
    default_index = line.find('default=')
    default_str=line
    if default_index >= 0:
        default_str = line[default_index:]
        default_str=default_str.replace("(","")
        default_str=default_str.replace(")","")
        
        
            
        default_str=default_str.strip()
        default_str = default_str.replace("default=","")
        
        default_str=default_str.strip()
        if default_str.endswith("."):
            default_str=default_str.replace(".","")
            
        if default_str.startswith("'") or default_str.endswith("'"):
            default_str=default_str.replace("'","")
        if default_str.startswith("\"") or default_str.endswith("\""):
            default_str=default_str.replace("\"","")

        default_str=default_str.strip()
            
        line = line[0:default_index]
    else: 
        default_str="None"    
    
     
    
    line = line.strip()
    
    if line.endswith(",") or line.endswith("."):
        line = line[:-1]
    
    
        
    if line =="int" :
        d_type = "int"
         
    elif line =="float" or line=="double":
        d_type = "int-or-float"

    elif line == "int or float":
        d_type = "int-or-float"
         
    elif line =="bool" or line=="boolean":
        d_type = "bool"
    
    elif line.startswith("{") and line.endswith("}"):
        d_type = "dropdown"
        line = line.replace("{","")
        line = line.replace("}","")
        line = line.replace("'", "")
        line = line.replace("\"", "")
        line = line.replace("  ", " ")
        line = line.replace(", ", ",")
        dd_list = line.split(",")
        type_dic["dd_list"] = dd_list 
    
    
    
    elif line.find("dict, list")>=0:
        d_type = "string"
        
    
    elif line.find("list")>=0:
        d_type = "string"
        
    
    elif line.find("dict")>=0:
        d_type = "string"
        
    elif line.find("float")>=0:
        d_type = "float"
    
    elif line.find("int")>=0 or line.find("integer")>=0:
        d_type = "int"
    
    else :
        d_type="string"
    
    
    type_dic["d_type"] = d_type
    type_dic["default_val"] = default_str
    
    
        
         
    return type_dic
    
def transform_column(le, col):
   
    le.fit(col)
    list(le.classes_)
    transformed =  le.transform(col)
    
    return transformed
def inverse_transform_column(le, trans):
    
    col = list(le.inverse_transform(trans))
    return col
    
def remove_special_characters_in_df_cols(cols):
    cols = cols.str.replace(' ', '_')
    cols = cols.str.replace('+', '_')
    cols = cols.str.replace('-', '_')
    cols = cols.str.replace('.', '_')
    return cols
def remove_special_characters_in_list(list):
    modified =[]
    for item in list:
        item = remove_special_characters_in_str(item)
        modified.append(item)
    return modified
        
def remove_special_characters_in_str(str):
    str = str.replace(" ","_")
    str = str.replace("+","_")
    str = str.replace("-","_")
    str = str.replace(".","_")
    return str

def inverse_tranform_label_encode(le_dict, key_attributes, test_features):
    for attribute in key_attributes:
        col= test_features[attribute]
        le = le_dict[attribute]
        inverse_transformed = inverse_transform_column(le, col)
        test_features = test_features.drop(attribute, axis=1)
        #test_features[attribute] = inverse_transformed
        test_features.insert(0, attribute, inverse_transformed)
    return test_features

def tranform_label_encode(df, key_attributes, class_label):
    key_attributes.append(class_label)
    res={}
    le_dict = {}
    trimed_attributes = []
    
    encoded_df = pd.DataFrame()  
    for attribute in key_attributes:
        attribute = remove_special_characters_in_str(attribute)
        trimed_attributes.append(attribute)
        if is_numeric_dtype(df[attribute]):
            df[attribute].fillna(value=0, inplace=True)
        le = preprocessing.LabelEncoder()
        le_dict[attribute] = le
        col = df[attribute]
        transformed = transform_column(le, col)
        
        encoded_df.insert(0, attribute, transformed)
    trimed_attributes.remove(class_label)
    key_attributes = trimed_attributes
    
    res["le_dict"] = le_dict
    res['df']=encoded_df
    return res

def run_scikit_algo(params, algo_params):
    
    
    algo_name = params['algo_name']
    algo_type = params['algo_type']
    path = params['dataset_path']
    test_p = params['test_p']
    class_label = params['class_label']
    key_attributes = params['key_attributes']
     
    
    
    res = {}
    class_label = remove_special_characters_in_str(class_label)
     
    try:
        dic = get_scikit_algo_details()
        cls = dic[algo_name]
        algo = None
        try:
            algo = cls(**algo_params)
        except Exception as ex:
            print(ex)
            if str(ex).find("missing 1"):
                algo = cls(1)
        
        
        df = pd.read_csv(path,encoding= 'unicode_escape')
        df.columns = remove_special_characters_in_df_cols(df.columns)
         
        # Encoder to transform
        '''
        le_dict = {}
        trimed_attributes = []
        for attribute in key_attributes:
            
            attribute = remove_special_characters_in_str(attribute)
             
            trimed_attributes.append(attribute)
            
            
            if is_numeric_dtype(df[attribute]):
                df[attribute].fillna(value=0, inplace=True)
            
            
            le = preprocessing.LabelEncoder()
             
            le_dict[attribute] = le
            col = df[attribute]
            transformed = transform_column(le, col)
            df = df.drop(attribute, axis=1)
            #df[attribute] = transformed
            df.insert(0, attribute, transformed)
        
        key_attributes = trimed_attributes
        '''
        label_trans_res = tranform_label_encode(df, key_attributes, class_label)
        le_dict = label_trans_res['le_dict']
        df = label_trans_res['df']
        train, test = train_test_split(df, test_size = test_p)
       
        train_features = train[key_attributes]
        train_target = train[class_label]
        
        test_features = test[key_attributes]
        test_target = test[class_label]
         
            
        algo.fit(train_features, train_target)
        cl_prediction = algo.predict(test_features)
    
         
     
        primary_info = get_results_from_matrics(test_target, cl_prediction, algo_type)
        res['primary_info'] = primary_info
        
        secondary_info = {}
        test_features['orignal_value'] = test_target.tolist()
        test_features['predicted'] = cl_prediction.tolist()
       
        
        if pd.api.types.is_string_dtype(test[class_label]):
            test_features['error'] = test_features['orignal_value'] == test_features['predicted']
        else:
            test_features['error'] = test_features['orignal_value'] - test_features['predicted']
        ''' 
        for attribute in key_attributes:
            col= test_features[attribute]
            le = le_dict[attribute]
            inverse_transformed = inverse_transform_column(le, col)
            test_features = test_features.drop(attribute, axis=1)
            #test_features[attribute] = inverse_transformed
            test_features.insert(0, attribute, inverse_transformed)
        '''
        
        test_features = inverse_tranform_label_encode(le_dict, key_attributes, test_features)
        
        secondary_info['test_features_html'] = test_features.to_html(index=False)
        
    
        res['secondary_info'] = secondary_info
    
        
        res["status"] = "success"
        res["message"] = 'Request processed successfully'
           
    except ValueError as e:
        res["status"]="error"
        res["message"] = "<b> You might be using wrong Algo or incompatible dataset.</b> <br/>" + str(e)
        print(traceback.format_exception(None,  e, e.__traceback__),file=sys.stderr, flush=True)
        print(e) 
    except Exception as e:
        res["status"]="error"
        res["message"] = str(e)
        print(traceback.format_exception(None,  e, e.__traceback__),file=sys.stderr, flush=True)
        
        print(e)
    finally:
        return res


def normalize_data(df, min_, max_):
    scaler = MinMaxScaler(feature_range=(min_, max_))
    df =  pd.DataFrame(scaler.fit_transform(df),columns = df.columns)
    
    #df.to_csv('out.csv', index=False) 
    norm_res = {'scaler':scaler, 'df':df}
    return norm_res

def denormalize_data(scaler, df):
    
    df = pd.DataFrame(scaler.inverse_transform(df), columns = df.columns)
    return df

def run_scikit_transformer(params, algo_params):
    
    
    transformer_name = params['transformer_name']
    path = params['dataset_path']
    key_attributes = params['key_attributes']
    
    
    
    
    
    res = {}
    try:
        dic = get_scikit_algo_details()
        cls = dic[transformer_name]
        algo = None
        try:
            algo = cls(**algo_params)
            #algo = cls()
        except Exception as ex:
            print(ex)
            if str(ex).find("missing 1"):
                algo = cls(1)
        
        key_attributes = remove_special_characters_in_list(key_attributes)
            
        df = pd.read_csv(path, encoding= 'unicode_escape')
        df.columns = remove_special_characters_in_df_cols(df.columns)
        df = prepare_df(df, key_attributes, '')
        
        algo.fit(X=df, y=None)
        algo_res = algo.transform(df)
    
        ''' 
        num_rows, num_cols = algo_res.shape
        col_labels=[]
        for col in range(1,num_cols):
            col_labels.append("col_"+str(col))
        '''
        df  = pd.DataFrame(algo_res)
        res["algo_res"] = df
        res["status"] = "success"
        res["message"] = 'Request processed successfully'
        
    except ValueError as e:
        res["status"]="error"
        res["message"] = "<b> You might be using wrong Algo or incompatible dataset.</b> <br/>" + str(e)
        print(traceback.format_exception(None,  e, e.__traceback__),file=sys.stderr, flush=True)
        print(e) 
    except Exception as e:
        res["status"]="error"
        res["message"] = str(e)
        print(traceback.format_exception(None,  e, e.__traceback__),file=sys.stderr, flush=True)
        
        print(e)
    finally:
        return res





def run_scikit_algo_percent_split(params, algo_params):
    print('run_scikit_algo_percent_split------------')
    
    
    algo_name = params['algo_name']
    algo_type = params['algo_type']
    path = params['dataset_path']
    test_path = params['test_dataset_path']
    test_p = params['test_p']
    class_label = params['class_label']
    key_attributes = params['key_attributes']
    test_option = params['test_option']
    splits = params['splits']
    normalize = params['normalize']
    normalize_min = params['normalize_min']
    normalize_max = params['normalize_max']
    
    res = {}
    class_label = remove_special_characters_in_str(class_label)
     
    try:
        
        if 'Keras' == algo_name:
            print ('Keras---------')
            algo = KerasRegressor(build_fn=baseline_model, nb_epoch=100, batch_size=100, verbose=False, input_dim=key_attributes.__len__())
        
        else: 
            dic = get_scikit_algo_details()
            cls = dic[algo_name]
            algo = None
            try:
                algo = cls(**algo_params)
            except Exception as ex:
                print(ex)
                if str(ex).find("missing 1"):
                    algo = cls(1)
        
        
        key_attributes = remove_special_characters_in_list(key_attributes)
        
        
        if Path(path).suffix=='.csv':
            df = pd.read_csv(path,encoding= 'unicode_escape')
        elif Path(path).suffix=='.xls' or  Path(path).suffix=='.xlsx':
            df = pd.read_excel(path,engine='openpyxl')
        
        #df = pd.read_csv(path,encoding= 'unicode_escape')
        df.columns = remove_special_characters_in_df_cols(df.columns)
        df = prepare_df(df, key_attributes, class_label)
        
     
        scaler = None
        scaler_cls = None
        scaler_cls_test = None
        scaler_except_class=None
        if normalize =='on':
            
            if normalize_min =='':
                normalize_min = 0
                 
            if normalize_max =='':
                normalize_max = 1 
            
            n_min = int(normalize_min)
            n_max = int(normalize_max)
            
            #col_class_label = df[class_label]
            #df = df.drop(class_label, axis=1)
             
           
            norm_res = normalize_data(df, n_min, n_max)
            norm_df = norm_res["df"]
            scaler = norm_res["scaler"]
           
            df_without_class = df.drop(class_label, axis=1) 
            norm_excep_class_res = normalize_data(df_without_class, n_min, n_max)
            norm_df_excep_class = norm_excep_class_res["df"]
            scaler_except_class = norm_excep_class_res["scaler"]
           
           
           
            #normalize classlabel column to get scalar object that will be used for denormalization.
            col_class_label = pd.DataFrame(data=df[class_label], columns=[class_label]) 
            norm_cls_label_res =  normalize_data(col_class_label, n_min, n_max)
            
            norm_cls_label = norm_cls_label_res["df"]
            scaler_cls = norm_cls_label_res["scaler"]
            
            
            
            ''' scaler for test is same in all cases other than test_option == 3  '''
            scaler_cls_test = scaler_cls
            #norm_df.insert(0, class_label, col_class_label)
            df = norm_df
            
             
            
        train = None 
        test = None  
         
        train, test = train_test_split(df, test_size = test_p)
        
        train.fillna(0, inplace=True)
        test.fillna(0, inplace=True)
       
        train_features = train[key_attributes]
        train_target = train[class_label]
        
        test_features = test[key_attributes]
        test_target = test[class_label]
         
            
        algo.fit(train_features, train_target)
        primary_info = None
        cl_prediction = None
         
        cl_prediction = algo.predict(test_features)
         
        primary_info = get_results_from_matrics(test_target, cl_prediction, algo_type)
        res['primary_info'] = primary_info
        
        
        
        secondary_info = {}
        test_features.insert(0, 'predicted', cl_prediction.tolist())
        test_features.insert(0, 'orignal_value', test_target.tolist())
        print(cl_prediction)
        if normalize =='on': # dnormalize predicted class
            
            ''' Denormalize the predicted class   '''
            predicted_class_df = pd.DataFrame(data=cl_prediction, columns=[class_label])
            denorm_pre_df = denormalize_data(scaler_cls, predicted_class_df)
            test_features = test_features.drop('predicted', axis=1)
            test_features.insert(0,  'predicted', denorm_pre_df[class_label].tolist())


            ''' Denormalize the orignal provided (splited) values/test values that are going to be predicted   '''
            orignal_class_df = pd.DataFrame(data=test_target, columns=[class_label])
            denorm_orig_df = denormalize_data(scaler_cls_test, orignal_class_df)
            test_features = test_features.drop('orignal_value', axis=1)
            test_features.insert(0, 'orignal_value', denorm_orig_df[class_label].tolist())
            
             
        if pd.api.types.is_string_dtype(test[class_label]):
            test_features.insert(0, 'error',test_features['orignal_value'] == test_features['predicted'])
        else:
            test_features.insert(0, 'error',abs(test_features['orignal_value'] - test_features['predicted']))
        
        
        test_features.drop(key_attributes, axis = 1, inplace=True)
        
        
        secondary_info['test_features_html'] = test_features.to_html(index=True)
        
        secondary_info['errors'] = test_features['error'].tolist()
        
        res['secondary_info'] = secondary_info
        res["status"] = "success"
        res["message"] = 'Request processed successfully'
        
        # Save the trained model
        trained_model_id = save_model(algo, params)  
        res['trained_model_id'] = trained_model_id 
    except ValueError as e:
        res["status"]="error"
        res["message"] = "<b> You might be using wrong Algo or incompatible dataset.</b> <br/>" + str(e)
        print(traceback.format_exception(None,  e, e.__traceback__),file=sys.stderr, flush=True)
        print(e) 
    except Exception as e:
        res["status"]="error"
        res["message"] = str(e)
        print(traceback.format_exception(None,  e, e.__traceback__),file=sys.stderr, flush=True)
        
        print(e)
    finally:
        return res
    
    

def run_scikit_algo_k_fold(params, algo_params):
    print('run_scikit_algo_k_fold------------')
    
    algo_name = params['algo_name']
    algo_type = params['algo_type']
    path = params['dataset_path']
    test_path = params['test_dataset_path']
    test_p = params['test_p']
    class_label = params['class_label']
    key_attributes = params['key_attributes']
    test_option = params['test_option'] # 1= test_train_split, 2=CV
    
    splits = params['splits']
    normalize = params['normalize']
    normalize_min = params['normalize_min']
    normalize_max = params['normalize_max']
    
    res = {}
    class_label = remove_special_characters_in_str(class_label)
     
    try:
        if 'Keras' == algo_name:
            print ('Keras---------')
            algo = KerasRegressor(build_fn=baseline_model, nb_epoch=100, batch_size=100, verbose=False, input_dim=key_attributes.__len__())
        
        else: 
            dic = get_scikit_algo_details()
            cls = dic[algo_name]
            algo = None
            try:
                algo = cls(**algo_params)
            except Exception as ex:
                print(ex)
                if str(ex).find("missing 1"):
                    algo = cls(1)
        
        
        key_attributes = remove_special_characters_in_list(key_attributes)

        if Path(path).suffix=='.csv':
            df = pd.read_csv(path,encoding= 'unicode_escape')
        elif Path(path).suffix=='.xls' or  Path(path).suffix=='.xlsx':
            df = pd.read_excel(path,engine='openpyxl')
        
        #df = pd.read_csv(path,encoding= 'unicode_escape')
        df.columns = remove_special_characters_in_df_cols(df.columns)
        df = prepare_df(df, key_attributes, class_label)
        
         
        ''' Off label_encoding
        label_trans_res = tranform_label_encode(df, key_attributes, class_label)
        le_dict = label_trans_res['le_dict']
        df = label_trans_res['df']
        '''
        scaler = None
        scaler_cls = None
        scaler_cls_test = None
        if normalize =='on':
            
            if normalize_min =='':
                normalize_min = 0
                 
            if normalize_max =='':
                normalize_max = 1 
            
            n_min = int(normalize_min)
            n_max = int(normalize_max)
            
            #col_class_label = df[class_label]
            #df = df.drop(class_label, axis=1)
             
            norm_res = normalize_data(df, n_min, n_max)
            norm_df = norm_res["df"]
            scaler = norm_res["scaler"]
            
            #normalize classlabel column to get scalar object that will be used for denormalization.
            col_class_label = pd.DataFrame(data=df[class_label], columns=[class_label]) 
            norm_cls_label_res =  normalize_data(col_class_label, n_min, n_max)
            
            norm_cls_label = norm_cls_label_res["df"]
            scaler_cls = norm_cls_label_res["scaler"]
            
            
            ''' scaler for test is same in all cases other than test_option == 3  '''
            scaler_cls_test = scaler_cls
            #norm_df.insert(0, class_label, col_class_label)
            df = norm_df
            
            

            
        train = None 
        test = None  
        
        train = df
        test = df
        
        train.fillna(0, inplace=True)
        test.fillna(0, inplace=True)
        
       
        train_features = train[key_attributes]
        train_target = train[class_label]
        
        test_features = test[key_attributes]
        test_target = test[class_label]
         
       

        algo.fit(train_features, train_target)
        primary_info = None
        cl_prediction = None
        if test_option == '2':
            #cv = RepeatedKFold(n_splits=10, n_repeats=3, random_state=1)
            cv = KFold(n_splits=splits,  shuffle=False, random_state=None)
            
            cl_prediction = cross_val_predict(algo, X=test_features, y=test_target, cv=cv)
        else:
            cl_prediction = algo.predict(test_features)
         
    
         
     
        primary_info = get_results_from_matrics(test_target, cl_prediction, algo_type)
        res['primary_info'] = primary_info
        
        
        secondary_info = {}
        test_features.insert(0, 'predicted', cl_prediction.tolist())
        test_features.insert(0, 'orignal_value', test_target.tolist())
        
        if normalize =='on': # dnormalize predicted class
            
            ''' Denormalize the predicted class   '''
            predicted_class_df = pd.DataFrame(data=cl_prediction, columns=[class_label])
            denorm_pre_df = denormalize_data(scaler_cls, predicted_class_df)
            
            test_features = test_features.drop('predicted', axis=1)
            test_features.insert(0,  'predicted', denorm_pre_df[class_label].tolist())
            


            ''' Denormalize the orignal provided (splited) values/test values that are going to be predicted   '''
            orignal_class_df = pd.DataFrame(data=test_target, columns=[class_label])
            denorm_orig_df = denormalize_data(scaler_cls_test, orignal_class_df)
            test_features = test_features.drop('orignal_value', axis=1)
            test_features.insert(0, 'orignal_value', denorm_orig_df[class_label].tolist())
            
         
        if pd.api.types.is_string_dtype(test[class_label]):
            test_features.insert(0, 'error',test_features['orignal_value'] == test_features['predicted'])
        else:
            test_features.insert(0, 'error', abs(test_features['orignal_value'] - test_features['predicted']))
        
        
        test_features.drop(key_attributes, axis = 1, inplace=True)
        
        secondary_info['test_features_html'] = test_features.to_html(index=True)
        
        secondary_info['errors'] = test_features['error'].tolist()
        
        res['secondary_info'] = secondary_info
        
        res["status"] = "success"
        res["message"] = 'Request processed successfully'
         # Save the trained model
        trained_model_id = save_model(algo, params)  
        res['trained_model_id'] = trained_model_id
    except ValueError as e:
        res["status"]="error"
        res["message"] = "<b> You might be using wrong Algo or incompatible dataset.</b> <br/>" + str(e)
        print(traceback.format_exception(None,  e, e.__traceback__),file=sys.stderr, flush=True)
        print(e) 
    except Exception as e:
        res["status"]="error"
        res["message"] = str(e)
        print(traceback.format_exception(None,  e, e.__traceback__),file=sys.stderr, flush=True)
        
        print(e)
    finally:
        return res

def run_scikit_algo_supply_test(params, algo_params):
    print('run_scikit_algo_supply_test------------')
    
    algo_name = params['algo_name']
    algo_type = params['algo_type']
    path = params['dataset_path']
    test_path = params['test_dataset_path']
    test_p = params['test_p']
    class_label = params['class_label']
    key_attributes = params['key_attributes']
    test_option = params['test_option'] # 1= test_train_split, 2=CV
    
    splits = params['splits']
    normalize = params['normalize']
    normalize_min = params['normalize_min']
    normalize_max = params['normalize_max']
    
    return_column_names =None
    return_columns = None
    if 'return_columns' in params:
        return_column_names = params['return_columns']
    
    res = {}
    class_label = remove_special_characters_in_str(class_label)
     
    try:
        if 'Keras' == algo_name:
            print ('Keras---------')
            algo = KerasRegressor(build_fn=baseline_model, nb_epoch=100, batch_size=100, verbose=False, input_dim=key_attributes.__len__())
        
        else: 
            dic = get_scikit_algo_details()
            cls = dic[algo_name]
            algo = None
            try:
                algo = cls(**algo_params)
            except Exception as ex:
                print(ex)
                if str(ex).find("missing 1"):
                    algo = cls(1)
        
        
        key_attributes = remove_special_characters_in_list(key_attributes)
        
        if Path(path).suffix=='.csv':
            df = pd.read_csv(path,encoding= 'unicode_escape')
        elif Path(path).suffix=='.xls' or  Path(path).suffix=='.xlsx':
            df = pd.read_excel(path,engine='openpyxl')   
                 
        #df = pd.read_csv(path,encoding= 'unicode_escape')
        df.columns = remove_special_characters_in_df_cols(df.columns)
        df = prepare_df(df, key_attributes, class_label)
        
        if Path(path).suffix=='.csv':
            df_test = pd.read_csv(test_path,encoding= 'unicode_escape')
        elif Path(path).suffix=='.xls' or  Path(path).suffix=='.xlsx':
            df_test = pd.read_excel(test_path,engine='openpyxl')
            
                     
        #df_test = pd.read_csv(test_path,encoding= 'unicode_escape')
        df_test.columns = remove_special_characters_in_df_cols(df_test.columns)
        
        if return_column_names is not None:
            return_columns = pd.DataFrame()
            for column_name in return_column_names:
                return_columns.insert(0, column_name, df_test[column_name].to_list())
             
        df_test = prepare_df(df_test, key_attributes, class_label)
         
        ''' Off label_encoding
        label_trans_res = tranform_label_encode(df, key_attributes, class_label)
        le_dict = label_trans_res['le_dict']
        df = label_trans_res['df']
        '''
        scaler = None
        scaler_cls = None
        scaler_cls_test = None
        if normalize =='on':
            
            if normalize_min =='':
                normalize_min = 0
                 
            if normalize_max =='':
                normalize_max = 1 
            
            n_min = int(normalize_min)
            n_max = int(normalize_max)
            
            #col_class_label = df[class_label]
            #df = df.drop(class_label, axis=1)
             
            norm_res = normalize_data(df, n_min, n_max)
            norm_df = norm_res["df"]
            scaler = norm_res["scaler"]
          
            
            #normalize classlabel column to get scalar object that will be used for denormalization.
            col_class_label = pd.DataFrame(data=df[class_label], columns=[class_label]) 
            norm_cls_label_res =  normalize_data(col_class_label, n_min, n_max)
            
            norm_cls_label = norm_cls_label_res["df"]
            scaler_cls = norm_cls_label_res["scaler"]
            
          
             
            df = norm_df
            
          
            norm_res_test = normalize_data(df_test, n_min, n_max)
            norm_df_test = norm_res_test["df"]
            #scaler_cls_test = norm_res_test["scaler"]
            
            
            df_test_cls = pd.DataFrame(data=df_test[class_label], columns=[class_label])
             
            norm_res_test_cls = normalize_data(df_test_cls, n_min, n_max)
            scaler_cls_test = norm_res_test_cls["scaler"] 
            df_test = norm_df_test
            
        train = None 
        test = None 
         
        train = df
        test = df_test
         
        train.fillna(0, inplace=True)
        test.fillna(0, inplace=True)
       
        train_features = train[key_attributes]
        train_target = train[class_label]
        
        test_features = test[key_attributes]
        test_target = test[class_label]
         
            
        algo.fit(train_features, train_target)
        primary_info = None
        cl_prediction = None
       
        cl_prediction = algo.predict(test_features)
        
     
        primary_info = get_results_from_matrics(test_target, cl_prediction, algo_type)
        res['primary_info'] = primary_info
        
        
        secondary_info = {}
        test_features.insert(0, 'predicted', cl_prediction.tolist())
        test_features.insert(0, 'orignal_value', test_target.tolist())
        
        
        
        if normalize =='on': # dnormalize predicted class
             
            
            ''' Denormalize the predicted class   '''
            predicted_class_df = pd.DataFrame(data=cl_prediction, columns=[class_label])
            denorm_pre_df = denormalize_data(scaler_cls_test, predicted_class_df)
            test_features = test_features.drop('predicted', axis=1)
            test_features.insert(0,  'predicted', denorm_pre_df[class_label].tolist())


            ''' Denormalize the orignal provided (splited) values/test values that are going to be predicted   '''
            orignal_class_df = pd.DataFrame(data=test_target, columns=[class_label])
            denorm_orig_df = denormalize_data(scaler_cls_test, orignal_class_df)
            test_features = test_features.drop('orignal_value', axis=1)
            test_features.insert(0, 'orignal_value', denorm_orig_df[class_label].tolist())
            '''
            if pd.api.types.is_string_dtype(test[class_label]):
                test_features.insert(0, 'error',test_features['orignal_denormalized'] == test_features['predicted_denormalized'])
            else:
                test_features.insert(0, 'error',abs(test_features['orignal_denormalized'] - test_features['predicted_denormalized']))
            '''
           
        if pd.api.types.is_string_dtype(test[class_label]):
            test_features.insert(0, 'error',test_features['orignal_value'] == test_features['predicted'])
        else:
            test_features.insert(0, 'error',abs(test_features['orignal_value'] - test_features['predicted']))
        
        test_features.drop(key_attributes, axis = 1, inplace=True)
        
        
        
        if return_column_names is not None:
            for column_name in return_column_names:
                test_features.insert(0, column_name, return_columns[column_name].to_list())
        #add ids
        
        secondary_info['test_features_html'] = test_features.to_html(index=True)
        
        secondary_info['errors'] = test_features['error'].tolist()
        
        res['secondary_info'] = secondary_info
        
        res["status"] = "success"
        res["message"] = 'Request processed successfully'
        params['key_attributes'] = key_attributes 
        # Save the trained model
        trained_model_id = save_model(algo, params)  
        res['trained_model_id'] = trained_model_id
    except ValueError as e:
        res["status"]="error"
        res["message"] = "<b> You might be using wrong Algo or incompatible dataset.</b> <br/>" + str(e)
        print(traceback.format_exception(None,  e, e.__traceback__),file=sys.stderr, flush=True)
        print(e) 
    except Exception as e:
        res["status"]="error"
        res["message"] = str(e)
        print(traceback.format_exception(None,  e, e.__traceback__),file=sys.stderr, flush=True)
        
        print(e)
    finally:
        return res

def save_model(model, params):
    """
    Save the trained model to a file using joblib and store the metadata in the database.
    
    :param model: The trained model object.
    :param params: Dictionary containing parameters including 'user_id', 'dataset_id', and 'algo_name'.
    """
    # Construct the file path and ensure the directory exists
    user_id = params.get('user_id')
    dataset_id = params.get('dataset_id')
    algo_name = params.get('algo_name')
    
    directory = os.path.join(settings.MEDIA_ROOT, str(user_id), 'trained_models', str(dataset_id))
    if not os.path.exists(directory):
        os.makedirs(directory)

    file_name = f"{algo_name}.pkl"  # File name based on the algorithm name
    file_path = os.path.join(directory, file_name)

    try:
        # Save the model to the file
        joblib.dump(model, file_path)
        print(f"Model saved successfully to {file_path}")

        # Create and save the TrainedModel object
        trained_model = TrainedModel(
            model_file=os.path.relpath(file_path, settings.MEDIA_ROOT),  # Store the relative path
            description=f"{params.get('dataset_name')}",
            status='Temp',
            user_id=user_id,
            dataset_id=dataset_id,
            key_attributes = params['key_attributes'],
            class_label = params['class_label']
        )
        trained_model.save()
        print("TrainedModel saved to the database successfully.")
        return trained_model.id
        
    except Exception as e:
        print(f"Error saving model: {str(e)}")
        return 0
 
    
def baseline_model(input_dim):
    # create model
    model = Sequential()
    model.add(Dense(input_dim, input_dim=input_dim, kernel_initializer='normal', activation='relu'))
    model.add(Dense(1, kernel_initializer='normal'))
    # Compile model
    model.compile(loss='mean_squared_error', optimizer='adam')
    return model



 

def larger_model():
    # create model
    model = Sequential()
    model.add(Dense(27, input_dim=27, kernel_initializer='normal', activation='relu'))
    model.add(Dense(6, kernel_initializer='normal', activation='relu'))
    model.add(Dense(1, kernel_initializer='normal'))
    # Compile model
    model.compile(loss='mean_squared_error', optimizer='adam')
    return model
 


def run_scikit_algo_cv(params, algo_params):
    
    test_option = params['test_option'] # 1= test_train_split, 2=CV
     
    # 1= test_train_split, 2=CV, 3= seprate test source
    if test_option =='3':
        return run_scikit_algo_supply_test(params, algo_params)
    elif test_option =='2':
        return  run_scikit_algo_k_fold(params, algo_params)
    else  :
        return  run_scikit_algo_percent_split(params, algo_params)
    
    
def run_scikit_algo_cv_backup(params, algo_params):
    
    algo_name = params['algo_name']
    algo_type = params['algo_type']
    path = params['dataset_path']
    test_path = params['test_dataset_path']
    test_p = params['test_p']
    class_label = params['class_label']
    key_attributes = params['key_attributes']
    test_option = params['test_option'] # 1= test_train_split, 2=CV
    
    
    
    
    splits = params['splits']
    normalize = params['normalize']
    normalize_min = params['normalize_min']
    normalize_max = params['normalize_max']
    
    res = {}
    class_label = remove_special_characters_in_str(class_label)
     
    try:
        dic = get_scikit_algo_details()
        cls = dic[algo_name]
        algo = None
        try:
            algo = cls(**algo_params)
        except Exception as ex:
            print(ex)
            if str(ex).find("missing 1"):
                algo = cls(1)
        
        
        key_attributes = remove_special_characters_in_list(key_attributes)
        
        df = pd.read_csv(path,encoding= 'unicode_escape')
        df.columns = remove_special_characters_in_df_cols(df.columns)
        df = prepare_df(df, key_attributes, class_label)
        
        if test_option == '3':
            df_test = pd.read_csv(test_path,encoding= 'unicode_escape')
            df_test.columns = remove_special_characters_in_df_cols(df_test.columns)
            df_test = prepare_df(df_test, key_attributes, class_label)
         
        ''' Off label_encoding
        label_trans_res = tranform_label_encode(df, key_attributes, class_label)
        le_dict = label_trans_res['le_dict']
        df = label_trans_res['df']
        '''
        scaler = None
        scaler_cls = None
        scaler_cls_test = None
        if normalize =='on':
            
            if normalize_min =='':
                normalize_min = 0
                 
            if normalize_max =='':
                normalize_max = 1 
            
            n_min = int(normalize_min)
            n_max = int(normalize_max)
            
            #col_class_label = df[class_label]
            #df = df.drop(class_label, axis=1)
             
            norm_res = normalize_data(df, n_min, n_max)
            norm_df = norm_res["df"]
            scaler = norm_res["scaler"]
           
            
            #-----TEST---------------------------

            #tmpdf = denormalize_data(norm_res["scaler"], norm_df)
            
            #tmpdf.to_csv('out.csv', index=True)
            #-----TEST---------------------------
            
            
            #normalize classlabel column to get scalar object that will be used for denormalization.
            col_class_label = pd.DataFrame(data=df[class_label], columns=[class_label]) 
            norm_cls_label_res =  normalize_data(col_class_label, n_min, n_max)
            
            norm_cls_label = norm_cls_label_res["df"]
            scaler_cls = norm_cls_label_res["scaler"]
            
            
            ''' scaler for test is same in all cases other than test_option == 3  '''
            scaler_cls_test = scaler_cls
            #norm_df.insert(0, class_label, col_class_label)
            df = norm_df
            
            if test_option =='3':
                #col_class_label = df_test[class_label]
                #df_test = df_test.drop(class_label, axis=1)
                
                norm_res_test = normalize_data(df_test, n_min, n_max)
                norm_df_test = norm_res_test["df"]
                scaler_cls_test = norm_res_test["scaler"]
                #norm_df.insert(0, class_label, col_class_label)
                df_test = norm_df
            
        train = None 
        test = None  
        if test_option == '3': # 1= test_train_split, 2=CV, 3= seprate test source
            train = df
            test = df_test
        elif test_option =='2':
            train = df
            test = df
        else :
            train, test = train_test_split(df, test_size = test_p)
        
       
        train_features = train[key_attributes]
        train_target = train[class_label]
        
        test_features = test[key_attributes]
        test_target = test[class_label]
         
            
        algo.fit(train_features, train_target)
        primary_info = None
        cl_prediction = None
        if test_option == '2':
            #cv = RepeatedKFold(n_splits=10, n_repeats=3, random_state=1)
            cv = KFold(n_splits=splits,  shuffle=False, random_state=None)
            
            cl_prediction = cross_val_predict(algo, X=test_features, y=test_target, cv=cv)
        else:
            cl_prediction = algo.predict(test_features)
         
    
         
     
        primary_info = get_results_from_matrics(test_target, cl_prediction, algo_type)
        res['primary_info'] = primary_info
        
        if normalize =='on': # dnormalize predicted class
            
            
            #denormalize complete dataset.
            #test_features.insert(0, class_label, test_target.tolist())
            
            #test_features =  denormalize_data(scaler, test_features)
            
            
            ''' Denormalize the predicted class   '''
            predicted_class_df = pd.DataFrame(data=cl_prediction, columns=[class_label])
            denorm_pre_df = denormalize_data(scaler_cls, predicted_class_df)
            test_features.insert(0,  'predicted_denormalized', denorm_pre_df[class_label].tolist())


            ''' Denormalize the orignal provided (splited) values/test values that are going to be predicted   '''
            orignal_class_df = pd.DataFrame(data=test_target, columns=[class_label])
            denorm_orig_df = denormalize_data(scaler_cls_test, orignal_class_df)
            test_features.insert(0, 'orignal_denormalized', denorm_orig_df[class_label].tolist())
            
        secondary_info = {}
        test_features.insert(0, 'predicted', cl_prediction.tolist())
        test_features.insert(0, 'orignal_value', test_target.tolist())
        
        #test_features['orignal_value'] = test_target.tolist()
        #test_features['predicted'] = cl_prediction.tolist()
        
        if pd.api.types.is_string_dtype(test[class_label]):
            #test_features['error'] = test_features['orignal_value'] == test_features['predicted']
            test_features.insert(0, 'error',test_features['orignal_value'] == test_features['predicted'])
        else:
            #test_features['error'] = test_features['orignal_value'] - test_features['predicted']
            test_features.insert(0, 'error',abs(test_features['orignal_value'] - test_features['predicted']))
        
        #test_features = inverse_tranform_label_encode(le_dict, key_attributes, test_features)
        
        secondary_info['test_features_html'] = test_features.to_html(index=True)
        secondary_info['errors'] = test_features['error'].tolist()
        res['secondary_info'] = secondary_info
        
        res["status"] = "success"
        res["message"] = 'Request processed successfully'
           
    except ValueError as e:
        res["status"]="error"
        res["message"] = "<b> You might be using wrong Algo or incompatible dataset.</b> <br/>" + str(e)
        print(traceback.format_exception(None,  e, e.__traceback__),file=sys.stderr, flush=True)
        print(e) 
    except Exception as e:
        res["status"]="error"
        res["message"] = str(e)
        print(traceback.format_exception(None,  e, e.__traceback__),file=sys.stderr, flush=True)
        
        print(e)
    finally:
        return res

def prepare_df(df, key_attributes, class_label):
        
    for col in df.columns:
        if col not in key_attributes and col != class_label:
            df = df.drop(col, axis=1)
        
    return df
def append_columns_df(df, df2):
        
    for col in df2.columns:
        if col not in df.columns:
            
            df.insert(0, col, df2[col])
    return df

def append_dataframes(source_df, df, rename_columns):
    post_fix =''
    if rename_columns ==True:
        post_fix ='_'
    for col in df.columns:
        source_df.insert(0, col + post_fix, df[col])
    return source_df
def get_results_from_matrics(test_target, cl_prediction, algo_type):
    primary_info = {}   
    if 'Classifiers' == algo_type:
        try:
            primary_info['Balanced accuracy score'] = round(metrics.balanced_accuracy_score(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Accuracy score'] = round(metrics.accuracy_score(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Cohen kappa score'] = round(metrics.cohen_kappa_score(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Confusion matrix'] = metrics.confusion_matrix(test_target, cl_prediction)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Hamming loss'] = round(metrics.hamming_loss(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Matthews corrcoef'] = metrics.matthews_corrcoef(test_target, cl_prediction)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Zero one loss'] = round(metrics.zero_one_loss(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Multilabel confusion matrix'] = (metrics.multilabel_confusion_matrix(test_target, cl_prediction))
        except Exception as e:
            print(e)
            
        try:
            primary_info['Precision recall fscore support'] = metrics.precision_recall_fscore_support(test_target, cl_prediction)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Classification report'] = metrics.classification_report(test_target, cl_prediction, output_dict=True)
        except Exception as e:
            print(e)

            
    elif 'Clusters' == algo_type:
        try:
            primary_info['Adjusted mutual info score'] = round(metrics.adjusted_mutual_info_score(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
        try:
            primary_info['Adjusted rand score'] = round(metrics.adjusted_rand_score(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
        try:
            primary_info['Homogeneity completeness v measure'] = metrics.homogeneity_completeness_v_measure(test_target, cl_prediction)
        except Exception as e:
            print(e)

        try:
            primary_info['Completeness score'] = round(metrics.completeness_score(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)

        try:
            primary_info['Homogeneity score'] = round(metrics.homogeneity_score(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
        
        try:
            primary_info['Mutual info score'] = round(metrics.mutual_info_score(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
        
        try:
            primary_info['Normalized mutual info score'] = round(metrics.normalized_mutual_info_score(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
        
        try:
            primary_info['Fowlkes mallows score'] = round(metrics.fowlkes_mallows_score(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)

        try:
            primary_info['V measure score'] = round(metrics.v_measure_score(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
        
        
      
    elif 'Regressors' == algo_type:
        try:
            primary_info['Explained variance score'] = round(metrics.explained_variance_score(test_target, cl_prediction), 3)
            
        except Exception as e:
            print(e)

        try:
            primary_info['Max error'] = round(metrics.max_error(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
        try:
            primary_info['Mean absolute error'] = round(metrics.mean_absolute_error(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Mean squared error'] = round(metrics.mean_squared_error(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Mean squared log error'] = round(metrics.mean_squared_log_error(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Median absolute error'] = round(metrics.median_absolute_error(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
            
        try:
            primary_info['R2 score'] = round(metrics.r2_score(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Mean tweedie deviance'] = round(metrics.mean_tweedie_deviance(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Mean poisson deviance'] = round(metrics.mean_poisson_deviance(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
            
        try:
            primary_info['Mean gamma deviance'] = round(metrics.mean_gamma_deviance(test_target, cl_prediction), 3)
        except Exception as e:
            print(e)
            

    return primary_info    
        
def run_algo(algo_name, path,  test_p, class_label, key_attributes, n_estimator=20):
    
    res = {}
    try:
        
        df = pd.read_csv(path,encoding= 'unicode_escape')
    
        train, test = train_test_split(df, test_size = test_p)
       
        train_features = train[key_attributes]
        train_target = train[class_label]
        
        test_features = test[key_attributes]
        test_target = test[class_label]
         

        #Prediction----- 
        regressor = None
        if algo_name =='random_forest':
            regressor = RandomForestRegressor(n_estimators=n_estimator, random_state=0)
            regressor.__doc__
        elif algo_name =='linear_svc':
            regressor = LinearSVC(C=1.0)
        elif algo_name =='logistic_regression':
            regressor = LogisticRegression()
        else:
            raise Exception('You have not selected any Algorithm.') 
            
        regressor.fit(train_features, train_target)
        cl_prediction = regressor.predict(test_features)
    
        #print(type(cl_prediction))
    
        
        primary_info = {}
        secondary_info = {}
        primary_info['Mean Absolute Error'] = round(metrics.mean_absolute_error(test_target, cl_prediction), 3)
        primary_info['Mean Squared Error'] = round(metrics.mean_squared_error(test_target, cl_prediction), 3)
        primary_info['Root Mean Squared Error'] = round(np.sqrt(metrics.mean_squared_error(test_target, cl_prediction)),3)
    
        secondary_info['predicted'] = cl_prediction.tolist()
    
        res['primary_info'] = primary_info
        #res['secondary_info'] = secondary_info
    
         
        print('Mean Absolute Error:', metrics.mean_absolute_error(test_target, cl_prediction))
        print('Mean Squared Error:', metrics.mean_squared_error(test_target, cl_prediction))
        print('Root Mean Squared Error:', np.sqrt(metrics.mean_squared_error(test_target, cl_prediction)))
        
        res["status"]="success"
        res["message"] = 'Request processed successfully'
        
    except ValueError as e:
        res["status"]="error"
        res["message"] = "<b> You might be using wrong algo or wrong data.</b> <br/>" + str(e) 
    except Exception as e:
        res["status"]="error"
        res["message"] = str(e)
    finally:
        return res

def random_forest____tested_ok(path,  test_p, class_label, key_attributes, n_estimator=20):
    res = {}
    
    try:
    
        df = pd.read_csv(path,encoding= 'unicode_escape')
    
        train, test = train_test_split(df, test_size = test_p)
       
        train_features = train[key_attributes]
        train_target = train[class_label]
        
        test_features = test[key_attributes]
        test_target = test[class_label]
         
         
         
         
        #Prediction----- 
        regressor = RandomForestRegressor(n_estimators=n_estimator, random_state=0)
        regressor.fit(train_features, train_target)
        cl_prediction = regressor.predict(test_features)
     
        
        primary_info = {}
        secondary_info = {}
        primary_info['Mean Absolute Error'] = round(metrics.mean_absolute_error(test_target, cl_prediction), 3)
        primary_info['Mean Squared Error'] = round(metrics.mean_squared_error(test_target, cl_prediction), 3)
        primary_info['Root Mean Squared Error'] = round(np.sqrt(metrics.mean_squared_error(test_target, cl_prediction)),3)
    
        secondary_info['predicted'] = cl_prediction.tolist()
    
        res['primary_info'] = primary_info
        #res['secondary_info'] = secondary_info
    
         
        print('Mean Absolute Error:', metrics.mean_absolute_error(test_target, cl_prediction))
        print('Mean Squared Error:', metrics.mean_squared_error(test_target, cl_prediction))
        print('Root Mean Squared Error:', np.sqrt(metrics.mean_squared_error(test_target, cl_prediction)))
        
        res["status"]="success"
        res["message"] = 'Request processed successfully'
        
    except ValueError as e:
        res["status"]="error"
        res["message"] = "<b> You might be using wrong algo.</b> <br/>" + str(e) 
    except Exception as e:
        res["status"]="error"
        res["message"] = str(e)
    finally:
        return res

  


def get_details(path):
    details = {}
    
    if Path(path).suffix=='.csv':
        dataFrame = pd.read_csv(path,encoding= 'unicode_escape')
        
    elif Path(path).suffix=='.xls' or  Path(path).suffix=='.xlsx':
        dataFrame = pd.read_excel(path,engine='openpyxl')
     
    details["total_instances"] = dataFrame.__len__()
    
    details["total_attributes"] = dataFrame.dtypes.__len__()
    details["total_missing"] = int(dataFrame.isnull().sum().sum())
    details["total_weight"] = int(dataFrame.isnull().sum().sum())
    #details["datatypes"] = json.loads(dataFrame.dtypes.to_json())


    #details["attributes"] = dataFrame.dtypes
   
    
    print("********************************************")
    columns = {}
     
    for h in dataFrame.head():
        col_details ={}
        if(is_string_dtype(dataFrame.dtypes[h])):
            col_details["datatype"] = 'str'
        elif(is_numeric_dtype(dataFrame.dtypes[h])):
            col_details["datatype"] = 'numeric'
            col_details["min"] = float(dataFrame[h].min())
            col_details["max"] = float(dataFrame[h].max())
        elif(is_bool_dtype(dataFrame.dtypes[h])):
            col_details["datatype"] = 'bool'
            
        
        col_details["distinct"] = int(dataFrame[h].unique().__len__())
        
        columns[h] = col_details
         
    details["columns"] = json.loads(util.tojson(columns))
    
    details["sample"] = (dataFrame[0:5]).to_html(index=False)
     
    return {"details":details}
  
 

def getChartsRawDataByCol(col,  dataFrame, chartTypes):
    chartsrawdata=[]    
    for head in dataFrame.head():
        if(str(col)!=str(head)):
            charts_json = (dataFrame.groupby(col)[head].nunique()).to_json()
            #print(charts_json )
            #print("--------------------------------")
            #print(col +"  "+ head)
            #chartutil.preparePieJSON(charts_json)
            rawdata={}
            rawdata["name"] = col +"  "+ head
            rawdata["chart"] = chartutil.createRandomChart(charts_json, rawdata["name"], chartTypes)
            chartsrawdata.append(rawdata)
    

    
    '''
    charts_json = (dataFrame.groupby([col])).to_json()
    print(charts_json ) 
    rawdata={}
    rawdata["name"] = col 
    rawdata["chart"] = chartutil.createRandomChart(charts_json, rawdata["name"])
    chartsrawdata.append(rawdata)
    
    '''
    return chartsrawdata
  
def myconverter(obj):
    if isinstance(obj, np.integer):
        return int(obj)
    elif isinstance(obj, np.floating):
        return float(obj)
    elif isinstance(obj, np.ndarray):
        return obj.tolist()
    
    return obj.__str__()


def dropColumns(path, columns, createCopy):
    dataFrame = pd.read_csv(path,encoding= 'unicode_escape')
    dataFrame = dataFrame.drop(columns, axis=1)
    if(createCopy):
        randName = str(round(time.time() * 1000))+".csv"
        path = path.replace(".csv", randName)
    else:
        if os.path.exists(path):
            #os.remove(path)
            print("ss")
    dataFrame.to_csv(path, header=True,index=False)
    return path

def normalize(path, columns, createCopy, min_, max_):
    df2 = pd.read_csv(path,encoding= 'unicode_escape')
    df2.columns = remove_special_characters_in_df_cols(df2.columns)
    df = prepare_df(df2, columns, '')
    min_ = int(min_)
    max_ = int(max_)
    res = normalize_data(df, min_, max_)
    df = res['df']
    df = append_columns_df(df, df2)
    if(createCopy):
        randName = str(round(time.time() * 1000))+"__Normalized.csv"
        path = path.replace(".csv", randName)
    else:
        if os.path.exists(path):
            #os.remove(path)
            print("ss")
    df.to_csv(path, header=True,index=False)
    return path




'''
def read_rows(path, start, end):
    dataFrame = pd.read_csv(path)
    print("*****************************")
    print(dataFrame.info())
    print("*****************************")
    return (dataFrame[start:end])


def read_rows_columns(path, row_start, row_end, col_start, col_end):
    dataFrame = pd.read_csv(path)
    return (dataFrame.iloc[row_start:row_end, col_start:col_end])


def get_columns_list(path):
    dataFrame = read_rows(path, 0, 0)
    return dataFrame.columns.to_list()








<thead>
                    <tr class="no-border">
                        {% for row in metainfo.details.sample %}
                            <th>{{row}}</th> 
                        {% endfor %}
                    </tr>
                    
                        {% for rowkey, rowval in metainfo.details.sample.items %}
                        <tr>
                            {% for cellkey, cellval in rowval.items %}
                            <td>{{cellval}}</td>
                        {% endfor %}
                        </tr>    
                    {% endfor %}
                    
                </thead>
                
                
                
                
                
                
                
                
                
                
                
                    <tr>
                            {% for rowkey, rowval in metainfo.details.sample %}
                                <td>{{rowval.items[0]}}</td>                
                            {% endfor %}
                            </tr>








    '''
