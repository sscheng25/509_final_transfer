#####
# Setting environment variable. NOTE: This is not a production-safe practice.
# This is only acceptable because this is a lab.
import os
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = '/Users/tushimin/Desktop/musa-509-final-27b36afe08d2.json'
#####\

from pathlib import Path
from pipeline_tools import run_transform_gbq

sql_root = Path(__file__).parent / 'sql'

def main():
    run_transform_gbq('justtest', 'bus_in_neigh', sql_root)
    run_transform_gbq('justtest', 'cri_in_neigh', sql_root)
    run_transform_gbq('justtest', 'gro_in_neigh', sql_root)
    run_transform_gbq('justtest', 'res_in_neigh', sql_root)
    run_transform_gbq('justtest', 'neighborhood_list', sql_root)
    run_transform_gbq('justtest', 'nhoods_detail', sql_root)
    run_transform_gbq('justtest', 'max_crime', sql_root)
    run_transform_gbq('justtest', 'min_crime', sql_root)
    run_transform_gbq('justtest', 'count_crimes_oct', sql_root)
    run_transform_gbq('justtest', 'count_crimes', sql_root)
    run_transform_gbq('justtest', 'crime_risk', sql_root)
    run_transform_gbq('justtest', 'boundingbox', sql_root)
    run_transform_gbq('justtest', 'centroid', sql_root)
    run_transform_gbq('justtest', 'gro_level', sql_root)
    run_transform_gbq('justtest', 'bus_stop_level', sql_root)
    run_transform_gbq('justtest', 'res_level', sql_root)


if __name__ == '__main__':
    main()
