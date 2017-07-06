import sys
import numpy as np

numpy_path=sys.argv[1]
features_path=sys.argv[2]
data_set=sys.argv[3]

#atac
atac=features_path+'atac_'+data_set
#TFs
ctcf=features_path+'CTCF_'+data_set
pol3=features_path+'PolII_'+data_set
TP63=features_path+'TP63_'+data_set
#LSD1=features_path+'LSD1_'+data_set # not avaialable for d6
#histone  
H3K27ac=features_path+'H3K27ac_'+data_set
H3K27me3=features_path+'H3K27me3_'+data_set
H3K4me1=features_path+'H3K4me1_'+data_set
H3K4me3=features_path+'H3K4me3_'+data_set
H3K9ac=features_path+'H3K9ac_'+data_set

#features=[atac, ctcf, pol3, TP63, LSD1, H3K27ac, H3K27me3, H3K4me1, H3K4me3, H3K9ac]
features=[atac, ctcf, pol3, TP63, H3K27ac, H3K27me3, H3K4me1, H3K4me3, H3K9ac]  # LSD1 is not avaialable for d6

def get_1d(feature_file):
    X=np.empty(([0,]))
    for line in open(feature_file,'r'):
       words=line.rstrip().split()
       X1=np.array([words[3]])
       X=np.concatenate((X, X1))
    return X, X.shape[0]

feature_list=[]
for feature_file in features:
    feature, size=get_1d(feature_file)
    l=feature.shape[0]
    feature_shaped=np.reshape(feature, (l, 1))
    feature_list.append(feature_shaped)
    X=np.hstack(feature_list)
       
np.save(numpy_path, X)

