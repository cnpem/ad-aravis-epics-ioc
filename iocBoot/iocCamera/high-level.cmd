# Configuration for high level PVs used in the Sirius accelerator.
#
# Paramters:
#
# $(PREFIX)
# Prefix for all PVs.
#
# $(MARK_WIDTH)
# Overlay markers line width.
#
# $(PORT)
# Camera asyn port string.

dbLoadRecords("${TOP}/db/accelerator.db", "P=$(P), R=$(R), MARK_WIDTH=$(MARK_WIDTH), PORT=$(PORT)")
