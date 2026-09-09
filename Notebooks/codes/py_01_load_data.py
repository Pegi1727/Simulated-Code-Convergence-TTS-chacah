"""py_01_load_data.py -- load npz/npy and github_data CSVs into memory."""
import os
import numpy as np
import pandas as pd

from py_00_setup import (FEATS_NPZ, F0_NPY, FEATURES1_NPZ, GITHUB_DIR,
                         setup_logging, check_environment)

CSV_FILES = ["feats_frame_features.csv", "features_master_frame_features.csv",
             "f0_hz.csv", "ac "data_dictionary.csv"]


def load_all():
             "data_dictionary.csv"]


def load_all():
    log = setup_logging("01_load")
    check_environment(log)

    d = np.load(FEATS_NPZ)
    feats = {k: np.asarray(d[k], dtype=float) for k in d.files}
    log.info("feats.npz: %s", {k: v.shape for k, v in feats.items()})

    f0 = np.load(F0_NPY).astype(float)
    log.info("f0.npy: %s frames", f0.size)

    d2 = np.load(FEATURES1_NPZ)
    features1 = {k: d2[k].item() if d2[k].ndim == 0 else np.asarray(d2[k], float)
                 for k in d2.files}
    log.info("features(1).npz keys: %s", list(features1.keys()))

    dataframes = {}
    for name in CSV_FILES:
        p = os.path.join(GITHUB_DIR, name)
        if os.path.exists(p):
            dataframes[name.replace(".csv", "")] = pd.read_csv(p)
            log.info("csv loaded: %s (%d rows)", name, len(dataframes[list(dataframes)[-1]]))
    return feats, f0, features1, dataframes


if __name__ == "__main__":
    feats, f0, features1, dfs = load_all()
    print("Loaded:", list(feats.keys()), f0.shape, list(dfs.keys()))
