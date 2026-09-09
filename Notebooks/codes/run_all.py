"""run_all.py -- master runner: py_00 ... py_05."""
import importlib
import time

from py_00_setup import setup_logging, check_environment


def main():
    log = setup_logging("run_all")
    check_environment(log)
    modules = ["py_01_load_data", "py_02_segment_summary",
               "py_03_variance_analysis", "py_04_cci_analysis",
               "py_05_figures"]
    for name in modules:
        t0 = time.time()
        log.info("=== running %s ===", name)
        mod = importlib.import_module(name)
        if hasattr(mod, "__main__"):
            pass
        # call the module entry point directly to avoid subprocess overhead
        if name == "py_01_load_data":
            mod.feats, mod.f0, mod.features1, mod.dfs = mod.load_all()
        elif name == "py_02_segment_summary":
            mod.summary, mod.frames = mod.summarize(mod.feats, mod.f0)
        elif name == "py_03_variance_analysis":
            mod.analyse(mod.summary)
        elif name == "py_04_cci_analysis":
            mod.cc = mod.load_counts()
            mod.analyse(mod.cc)
        elif name == "py_05_figures":
            mod.make_figures(mod.summary, mod.frames, mod.cc)
        log.info("=== %s done in %.1fs ===", name, time.time() - t0)
    log.info("ALL DONE")


if __name__ == "__main__":
    main()
