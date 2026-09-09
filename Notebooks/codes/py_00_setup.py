"""py_00_setup.py -- logging, paths, environment checks, constants."""
import logging
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))  # /mnt/data
DATA_DIR = os.environ.get("DATA_DIR", ROOT)
CODES_DIR = os.path.join(ROOT, "codes")
OUT_DIR = os.path.join(ROOT, "outputs_py")
OUT_TAB = os.path.join(OUT_DIR, "tables")
OUT_FIG = os.path.join(OUT_DIR, "figures")
for d in (OUT_DIR, OUT_TAB, OUT_FIG):
    os.makedirs(d, exist_ok=True)

# --- constants -------------------------------------------------------------
SEG_NAMES = ["S1", "S2", "S3", "S4"]
N_SEGMENTS = 4
SEG_BOUNDS = {  # seconds (from acoustic_summary.csv)
    "S1": (0.0, 62.694), "S2": (62.787, 125.388),
    "S3": (125.481, 188.082), "S4": (188.175, 250.776),
}
DURATION = 250.816
EXPECTED_RAW_RATIO = 2.11        # paper: raw F0 variance S1/S4
EXPECTED_CORRECTED_RATIO = 1.62  # paper: pitch-corrected F0 variance S1/S4
RATIO_TOL_REL = 0.15
0_MIN_HZ, F0_MAX_HZ = = 60.0, 800.0  # plausible vocal-pitch range

# --- file paths ------------------------------------------------------------
FEATS_NPZ = os.path.join(DATA_DIR, "feats.npz")
F0_NPY = os.path.join(DATA_DIR, "f0.npy")
FEATURES1_NPZ = os.path.join(DATA_DIR, "features (1).npz")
GITHUB_DIR = os.path.join(DATA_DIR, "github_data")
DEMO_CCI_CSV = os.path.join(CODES_DIR, "data", "demo", "code_counts_demo.csv")


def setup_logging(name="pipeline"):
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s | %(levelname)s | %(name)s | %(message)s",
        handlers=[
            logging.StreamHandler(sys.stdout),
            logging.FileHandler(os.path.join(OUT_DIR, "pipeline.log"), mode="a"),
        ],
        force=True,
    )
    return logging.getLogger(name)


def check_environment(log=None):
    import numpy, pandas, matplotlib, scipy
    log = log or setup_logging()
    log.info("python %s | numpy %s | pandas %s | matplotlib %s | scipy %s",
             sys.version.split()[0], numpy.__version__, pandas.__version__,
             matplotlib.__version__, scipy.__version__)
    missing = [p for p in (FEATS_NPZ, F0_NPY, FEATURES1_NPZ, GITHUB_DIR)
               if not os.path.exists(p)]
    for p in missing:
        log.warning("missing input: %s", p)
    return not missing


if __name__ == "__main__":
    log = setup_logging("00_setup")
    ok = check_environment(log)
    log.info("00_setup done; all inputs present = %s", ok)
