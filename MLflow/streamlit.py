cat << EOF > /root/main.py
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import timeit
import warnings
warnings.filterwarnings("ignore")
import streamlit as st
import streamlit.components.v1 as components

#Import classification models and metrics
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.ensemble import RandomForestClassifier,ExtraTreesClassifier
from sklearn.model_selection import cross_val_score

#Import performance metrics, imbalanced rectifiers
from sklearn.metrics import  confusion_matrix,classification_report,matthews_corrcoef
from imblearn.over_sampling import SMOTE
from imblearn.under_sampling import NearMiss
np.random.seed(42) #for reproducibility since SMOTE and Near Miss use randomizations

from pandas_profiling import ProfileReport
from streamlit_pandas_profiling import st_profile_report

st.title('Credit Card Fraud Detection')

df=st.cache(pd.read_excel)('https://github.com/Stijnvhd/Streamlit_Course/blob/main/4.1%20Finance%20Dashboard%20Exercise/small_set.xlsx?raw=true', engine='openpyxl',)
df = df.sample(frac=0.1, random_state = 48)

app_mode = st.sidebar.selectbox('Mode', ['About', 'EDA', 'Analysis'])
EOF